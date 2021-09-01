use CSS::Font;

unit class CSS::Font::Loader
    is CSS::Font;

use CSS::Properties::Calculator :FontWeight;
use CSS::Font::Descriptor;
use CSS::Font::Loader::Source :FontFormat;
use CSS::Font::Loader::Source::Local;
use CSS::Font::Loader::Source::URI;
use CSS::Module::CSS3;

use JSON::Fast;
use URI;

has CSS::Font::Descriptor @.font-faces is built;
has URI() $.base-url is rw;

method new(
    :@font-faces, :$base-url = '.', |c,
) {
    my $obj = callwith(|c);
    $obj.font-faces = @font-faces;
    $obj.base-url = $base-url;
    $obj;
}

method !fc-stretch {
    my constant %Stretch = %(
        :normal(100),
        :semi-expanded(113), :expanded(125), :extra-expanded(150), :ultra-expanded(200),
        :semi-condensed(87), :condensed(75), :extra-condensed(63), :ultra-condensed(50),
    );

    %Stretch{$.stretch};
}

#| compute a fontconfig pattern for the font
method fontconfig-pattern {
    nextwith(self!local-fonts());
}

method !local-fonts() {
    @.match(@!font-faces)>>.src>>.grep({.type eq 'local'}).Slip;
}

method match(@faces = @!font-faces) {
    nextwith(@faces);
}

sub guess-format(Str() $_ --> FontFormat) {
    when .ends-with: '.ttf'   {'truetype'}
    when .ends-with: '.otf'   {'opentype'}
    when .ends-with: '.woff'  {'woff'}
    when .ends-with: '.woff2' {'woff2'}
    when .ends-with: '.svg'   {'svg'}
    default {'other'}
}

method sources(@descriptors = @.match) {
    my CSS::Font::Loader::Source @sources;

    for @descriptors -> CSS::Font::Descriptor $font-descriptor {

        with $font-descriptor.font-family -> $family {
            if $font-descriptor.src -> @srcs {
                for @srcs -> $src {
                    my FontFormat $format = $_ with $src[1];
                    given $src.type {
                        when 'local' {
                            $format ||= 'other';
                            @sources.push: CSS::Font::Loader::Source::Local.new: :$family, :$font-descriptor, :$format;
                        }
                        when 'url' {
                            my URI() $url = $src[0];
                            $url .= rel2abs($!base-url);
                            $format ||= guess-format($url);
                            @sources.push: CSS::Font::Loader::Source::URI.new: :$family, :$font-descriptor, :$url, :$format;
                        }
                        default {
                            warn 'unknown @font-face src: ' ~ $_;
                        }
                    }
                }
            }
        }
    }

##    for @.family -> $family {
##        @sources.push: CSS::Font::Loader::Source.::Local.new: :$family, :$.css;
##    }

    @sources;
}
