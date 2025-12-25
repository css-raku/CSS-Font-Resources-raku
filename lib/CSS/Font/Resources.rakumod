#| Lightweight CSS Font Resource Manager
unit class CSS::Font::Resources:ver<0.0.11>;

use CSS::Properties::Calculator :FontWeight;
use CSS::Font;
use CSS::Font::Descriptor;
use CSS::Font::Resources::Source :FontFormat, :&guess-format;
use CSS::Font::Resources::Source::Local;
use CSS::Font::Resources::Source::Url;

use URI;
has CSS::Font:D() $.font is required;
has Str $.font-family = 'times-roman';
has $.formats = FontFormat;
has CSS::Font::Descriptor @.font-face;
has URI() $.base-url = './';

=begin pod

=head2 Description

This is lightweight font resource manager, driven by CSS `@font-face` font descriptors.

=head2 Methods

=end pod

#| Return only matching font-descriptors
method match(@font-face = @!font-face) {
    $!font.match(@font-face);
}
=para These are matched and ordered by preference, using the
    L<W3C Font Matching Algorithm|https://www.w3.org/TR/2018/REC-css-fonts-3-20180920/#font-matching-algorithm>.

#| Return sources for matching fonts
multi method sources(CSS::Font::Resources:U: Bool :$fallback = True, |c) {
    self.new(|c).sources: :$fallback;
}
multi method sources(
    CSS::Font::Resources:D:
    Bool :$fallback = True,
) {
    my CSS::Font::Resources::Source @sources;
    my @descriptors = $!font.match(@!font-face);

    for @descriptors -> CSS::Font::Descriptor $font-descriptor {

        with $font-descriptor.font-family -> $family {
            if $font-descriptor.src -> @srcs {
                for @srcs -> $src {
                    my $ref = $src[0];
                    my FontFormat $format = .[0] with $src[1];
                    given $ref.type {
                        when 'local' {
                            @sources.push: CSS::Font::Resources::Source::Local.new: :$family, :$font-descriptor, :$format;
                        }
                        when 'url' {
                            my URI() $url = $ref;
                            $format ||= guess-format($url);
                            @sources.push: CSS::Font::Resources::Source::Url.new: :$family, :$font-descriptor, :$format, :$url, :$!base-url;
                        }
                        default {
                            warn 'unknown @font-face src: ' ~ $_;
                        }
                    }
                }
            }
        }
    }

    if $fallback {
        # if none of the @font-face rules match, match the font itself
        given $!font.family.head // $!font-family -> $family {
            my CSS::Font::Descriptor $font-descriptor .= new;
            $font-descriptor.css.copy($!font.css);
            $font-descriptor.css.font-family = $family;
            $font-descriptor.setup;
            @sources.push: CSS::Font::Resources::Source::Local.new: :$family, :$font-descriptor;
        }
    }

    @sources.grep: {.format ~~ $!formats};
}
=begin pod

=item Fonts are first matched using the `match()` method [above]

=item This list is then flattened to L<CSS::Font::Resources::Source::Local> and L<CSS::Font::Resources::Source::Url>
  for `local` and `url` font references in the font descriptor's list of `src` references.

=item Fallback local references are also appended for the font's font-family list.

These matches are ordered by user preference. The fonts themselves can be fetched using the `.IO` or `.Str` or Blob methods
on the first matching font.
=end pod

method source(|c --> CSS::Font::Resources::Source) handles<IO> {
    @.sources(|c).head // CSS::Font::Resources::Source;
}
