# CSS-Font-Selector-raku

## Description

This is a light-weight CSS font selector driven `@font-face` rules.

It is integrated into the L<CSS> and L<CSS::Stylesheet> modules, but
can also be used stand-alone for CSS driven font selection.

## Examples

## from CSS::Stylesheet

```raku
use CSS::Stylesheet;
use CSS::Font::Selector;

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

my CSS::Font::Selector $font-selector = $css.font-selector: "bold 12pt times roman, serif";
# accept first true-type or open-type font
my CSS::Font::Selector::Source @sources = $font-selector.sources;
my Blob $font-buf = .IO with @sources.first: {.format ~~ 'opentype'|'truetype'};
```

## stand-alone

```raku
use CSS::Font::Selector;
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
my CSS::Font::Selector $font-selector .= new: :$font, :@font-face, :base-url</my/path>;
# accept first true-type or open-type font
my CSS::Font::Selector::Source @sources = $font-selector.sources;
my Blob $font-buf = .IO with @sources.first: {.format ~~ 'opentype'|'truetype'};

```