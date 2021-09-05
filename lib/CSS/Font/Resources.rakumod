unit class CSS::Font::Resources;

use CSS::Properties::Calculator :FontWeight;
use CSS::Font::Descriptor;
use CSS::Font::Resources::Source :FontFormat, :&guess-format;
use CSS::Font::Resources::Source::Local;
use CSS::Font::Resources::Source::URI;
use CSS::Module::CSS3;

use JSON::Fast;
use URI;
has CSS::Font:D() $.font is required handles<family>;
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

method sources(@descriptors = @.match) {
    my CSS::Font::Resources::Source @sources;

    for @descriptors -> CSS::Font::Descriptor $font-descriptor {

        with $font-descriptor.font-family -> $family {
            if $font-descriptor.src -> $src {
                for 0 ..^ $src.elems {
                    my $ref = $src[$_][0];
                    my FontFormat $format = $_ with $src[$_][1];
                    given $ref.type {
                        when 'local' {
                            @sources.push: CSS::Font::Resources::Source::Local.new: :$family, :$font-descriptor, :$format;
                        }
                        when 'url' {
                            my URI() $url = $ref;
                            $url .= rel2abs($!base-url);
                            $format ||= guess-format($url);
                            @sources.push: CSS::Font::Resources::Source::URI.new: :$family, :$font-descriptor, :$url, :$format;
                        }
                        default {
                            warn 'unknown @font-face src: ' ~ $_;
                        }
                    }
                }
            }
        }
    }

    for @.family -> $family {
        my CSS::Font::Descriptor $font-descriptor .= new;
        $font-descriptor.css.copy($!font.css);
        $font-descriptor.css.font-family = $family;
        @sources.push: CSS::Font::Resources::Source::Local.new: :$family, :$font-descriptor;
    }

    @sources;
}
