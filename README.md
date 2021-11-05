[[Raku CSS Project]](https://css-raku.github.io)
 / [[CSS-Font-Resources]](https://css-raku.github.io/CSS-Font-Resources-raku)

# CSS-Font-Resources-raku

## Description

This is a light-weight font selector driven by CSS `@font-face` rules.

It is integrated into the [CSS](https://css-raku.github.io) and [CSS::Stylesheet](https://css-raku.github.io/CSS-Stylesheet-raku) modules, but
can also be used for stand-alone font resource loading.

## Classes in this distribution:

- [CSS::Font::Resources](https://css-raku.github.io/CSS-Font-Resources-raku/CSS/Font/Resources) - CSS Font Resources Manager

- [CSS::Font::Resources::Source](https://css-raku.github.io/CSS-Font-Resources-raku/CSS/Font/Resources/Source) - CSS Font Resources abstract source

  - [CSS::Font::Resources::Source::Local](https://css-raku.github.io/CSS-Font-Resources-raku/CSS/Font/Resources/Source/Local) - CSS Font Resources `local` source

  - [CSS::Font::Resources::Source::Url](https://css-raku.github.io/CSS-Font-Resources-raku/CSS/Font/Resources/Source/Url) - CSS Font Resources `url` source
- [CSS::URI](https://css-raku.github.io/CSS-Font-Resources-raku/CSS/URI) - Lightweight object for fetchable URIs.

## Examples

## from CSS::Stylesheet

```raku
use CSS::Stylesheet;
use CSS::Font::Resources;

my CSS::Stylesheet $css .= parse: q:to<END>, :base-url<my/path/>;

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


my $formats = 'opentype'|'truetype'; # accept first true-type or open-type font
my $font = "bold 12pt times roman, serif";
my CSS::Font::Resources::Source @sources = $css.font-sources($font, :$formats);
my Blob $font-buf = .IO with @sources.first;
```

## stand-alone

```raku
use CSS::Font::Resources;
use CSS::Font::Descriptor;

my @decls = q:to<END>.split: /^^'---'$$/;
font-family: "DejaVu Sans";
src: url("fonts/DejaVuSans.ttf");
---
font-family: serif;
font-weight: bold;
src: local(DejaVuSans-Bold);
END

my CSS::Font::Descriptor @font-face = @decls.map: -> $style {CSS::Font::Descriptor.new: :$font};
my $font = "bold 12pt times roman, serif";
my $formats = 'opentype'|'truetype'; # accept first true-type or open-type font
my CSS::Font::Resources $font-selector .= new: :$font, :@font-face, :base-url</my/path/>, :$formats;
# accept first true-type or open-type font
my CSS::Font::Resources::Source @sources = $font-selector.sources;
my Blob $font-buf = .Blob with @sources.first;

```

## Methods

### new

    method new(
        CSS::Font:D() :$font!,
        CSS::Font::Descriptor :@font-face,
        URI() $.base-url = './',
        :$formats = 'woff'|'woff2'|'truetype'|'opentype'|'embedded-opentype'|'postscript'|'svg'|'cff',
        --> CSS::Font::Resources
    )

Returns a new font selector object for the given font and font-descriptor list.

- `$base-url` is used to compute absolute URI's for relative font `src` urls.

- `$formats` is used to filter fonts to a specific format,

### sources

    multi method sources(
        CSS::Font::Resources:D:
        Bool :$fallback = True
    )

    multi method sources(
        CSS::Font::Resources:U:
        :$font, :@font-face, :$base-url, :$formats,
        Bool :$fallback = True,
    )

Returns a list of matching fonts of type CSS::Font::Resources::Source, ordered by preference.

- `$fallback` return a system font source, if there are no matching font-descriptors.


## source

    method source(|c --> CSS::Font::Resources::Source);

Returns the first matching source.

