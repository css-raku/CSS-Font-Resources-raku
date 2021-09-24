#| lightweight fetchable URI's
unit class CSS::URI;

role X {...}
also does X;

role X {

    use URI;
    use LWP::Simple;
    use Temp::Path;

    has URI:D() $.url is required handles<Str>;
    has IO::Path $!path;

    submethod TWEAK(URI() :$base-url) {
        $!url .= rel2abs($_) with $base-url;
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
                temp LWP::Simple.force_no_encoding = True;
                LWP::Simple.get: $!url;
            }
            default {
                die "unsupported URI scheme: $_";
            }
        }
    }

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
                    my $content = self.Blob;
                    my $suffix = $!url.path.segments.tail;
                    make-temp-path :$content, :$suffix;
                }
            }
            default {
                die "unsupported URI scheme: $_";
            }
        }
    }

    method get {
        given $!url.scheme {
            when 'file'|'' {
                if $!url.host -> $host {
                    die "file fetch from host is nyi: {$!url.Str}";
                }
                self.IO.slurp;
            }
            when 'http'|'https' {
                LWP::Simple.get: $!url;
            }
            default {
                die "unsupported URI scheme: $_";
            }
        }
    }

}

=begin pod

=head2 Description

L<CSS::URI> is a fetchable URI class. It currently handles schemes `file:` (default), `https:` and `http:`.

=head2 Methods

=head3 get

fetch with automatic binary/text detection. Can return `Str` or `Blob` objects.

=head3 IO

returns an IO::Path for the resource. Either a local file or a temporary file for
a fetched remote URL.

=head3 Blob

binary fetch.


=end pod
