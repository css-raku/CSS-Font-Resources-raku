# CSS-Font-Resources-raku

## Description

This is a light-weight font selector driven by CSS `@font-face` rules.

It is integrated into the L<CSS> and L<CSS::Stylesheet> modules, but
can also be used as a stand-alone font selector.

## Examples

## from CSS::Stylesheet

```raku
use CSS::Stylesheet;
use CSS::Font::Resources;

my CSS::Stylesheet $css .= parse: q:to<END>, :base-url<my/path>;

    h1 {color:red}
    h2 {color:blue}

    @font-face {
      font-family: "DejaVu Sans";
      src: url("fonts/DejaVuSans.ttf");
    }
    @font-face {
      font-family: "DejaVu Sans";
      src: url("fonts/DejaVuSans-Bold.ttf");
      font-weight: bold;
    }
    @font-face {
      font-family: "DejaVu Sans";
      src: url("fonts/DejaVuSans-Oblique.ttf");
      font-style: oblique;
    }
    @font-face {
      font-family: "DejaVu Sans";
      src: url("fonts/DejaVuSans-BoldOblique.ttf");
      font-weight: bold;
      font-style: oblique;
    }
    END

my CSS::Font::Resources $font-selector = $css.font-selector: "bold 12pt times roman, serif";
# accept first true-type or open-type font
my CSS::Font::Resources::Source @sources = $font-selector.sources;
my Blob $font-buf = .IO with @sources.first: {.format ~~ 'opentype'|'truetype'};
```

## stand-alone

```raku
use CSS::Font::Resources;
use CSS::Font::Descriptor;

my @decls = q:to<END>.split: /^^'---'$$/;
font-family: "DejaVu Sans";
src: url("fonts/DejaVuSans.ttf");
---
font-family: "serif";
font-weight: bold;
src: local(DejaVuSans-Bold);
END

my $font = "bold 12pt times roman, serif";
my CSS::Font::Descriptor @font-face = @decls.map: -> $style {CSS::Font::Descriptor.new: :$font};
my CSS::Font::Resources $font-selector .= new: :$font, :@font-face, :base-url</my/path>;
# accept first true-type or open-type font
my CSS::Font::Resources::Source @sources = $font-selector.sources;
my Blob $font-buf = .IO with @sources.first: {.format ~~ 'opentype'|'truetype'};

```

The most important method is `sources` returns a list of matching fonts of type CSS::Font::Resources::Source.
