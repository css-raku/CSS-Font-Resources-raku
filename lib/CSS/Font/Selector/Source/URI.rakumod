use CSS::Font::Selector::Source;

unit class CSS::Font::Selector::Source::URI
    is CSS::Font::Selector::Source;

use URI;
use LWP::Simple;
use Temp::Path;

has URI:D $.url is required;

method path {
    given $!url.scheme {
        when 'file'|'' {
            if $!url.host -> $host {
                die "unable to fetch {$!url.Str} from host: $host"
            }
            $!url.path.Str.IO;
        }
        when 'http'|'https' {
            my $content = LWP::Simple.get: $!url.Str;
            make-temp-path :$content;
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
