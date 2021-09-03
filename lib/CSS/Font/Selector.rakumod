unit class CSS::Font::Selector;

use CSS::Properties::Calculator :FontWeight;
use CSS::Font::Descriptor;
use CSS::Font::Selector::Source :FontFormat;
use CSS::Font::Selector::Source::Local;
use CSS::Font::Selector::Source::URI;
use CSS::Module::CSS3;

use JSON::Fast;
use URI;
has CSS::Font:D() $.font is required;
has CSS::Font::Descriptor @.font-face;
has URI() $.base-url is rw;

method !fc-stretch {
    my constant %Stretch = %(
        :normal(100),
        :semi-expanded(113), :expanded(125), :extra-expanded(150), :ultra-expanded(200),
        :semi-condensed(87), :condensed(75), :extra-condensed(63), :ultra-condensed(50),
    );

    %Stretch{$.stretch};
}

#| compute a fontconfig pattern for the font
method pattern {
    $!font.pattern(self!local-fonts());
}

method fontconfig-pattern {
    $!font.fontconfig-pattern(self!local-fonts());
}

method !local-fonts() {
    @.match(@!font-face)>>.src>>.[0]>>.grep({.type eq 'local'}).Slip;
}

method match(@faces = @!font-face) {
    $!font.match(@faces);
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
    my CSS::Font::Selector::Source @sources;

    for @descriptors -> CSS::Font::Descriptor $font-descriptor {

        with $font-descriptor.font-family -> $family {
            if $font-descriptor.src -> $src {
                for 0 ..^ $src.elems {
                    my $ref = $src[$_][0];
                    my FontFormat $format = $_ with $src[$_][1];
                    given $ref.type {
                        when 'local' {
                            $format ||= 'other';
                            @sources.push: CSS::Font::Selector::Source::Local.new: :$family, :$font-descriptor, :$format;
                        }
                        when 'url' {
                            my URI() $url = $ref;
                            $url .= rel2abs($!base-url);
                            $format ||= guess-format($url);
                            @sources.push: CSS::Font::Selector::Source::URI.new: :$family, :$font-descriptor, :$url, :$format;
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
##        @sources.push: CSS::Font::Selector::Source.::Local.new: :$family, :$.css;
##    }

    @sources;
}
