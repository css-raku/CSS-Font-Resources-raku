use CSS::Font::Selector::Source;

unit class CSS::Font::Selector::Source::URI
    is CSS::Font::Selector::Source;

use URI;
use LWP::Simple;
use Temp::Path;

has URI:D $.url is required;
has IO::Path $!path;

method IO {
    given $!url.scheme {
        when 'file'|'' {
            if $!url.host -> $host {
                die "unable to fetch {$!url.Str} from host: $host"
            }
            $!url.path.Str.IO;
        }
        when 'http'|'https' {
            $!path //= do {
                my $content = LWP::Simple.get: $!url.Str;
                my $suffix = $!url.path.segments.tail;
                make-temp-path :$content, :$suffix;
            }
        }
        default {
            die "unsupported URI scheme: $_";
        }
    }
}

method Blob {
    given $!url.scheme {
        when 'file'|'' {
            if $!url.host -> $host {
                die "unable to fetch {$!url.Str} from host: $host"
            }
            $!url.path.Str.IO.slurp: :bin;
        }
        when 'http'|'https' {
            LWP::Simple.get: $!url.Str;
        }
        default {
            die "unsupported URI scheme: $_";
        }
    }
}
