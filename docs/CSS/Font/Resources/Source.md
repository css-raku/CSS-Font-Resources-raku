[[Raku CSS Project]](https://css-raku.github.io)
 / [[CSS-Font-Resources]](https://css-raku.github.io/CSS-Font-Resources-raku)
 / [CSS::Font](https://css-raku.github.io/CSS-Font-Resources-raku/CSS/Font)
 :: [Resources](https://css-raku.github.io/CSS-Font-Resources-raku/CSS/Font/Resources)
 :: [Source](https://css-raku.github.io/CSS-Font-Resources-raku/CSS/Font/Resources/Source)

class CSS::Font::Resources::Source
----------------------------------

Abstract base class for font source references

Description
-----------

This is an abstract base class for font descriptor source references. See also instance classes:

  * [CSS::Font::Resources::Source::Local](https://css-raku.github.io/CSS-Font-Resources-raku/CSS/Font/Resources/Source/Local) for `local(...)` references.

  * [CSS::Font::Resources::Source::Url](https://css-raku.github.io/CSS-Font-Resources-raku/CSS/Font/Resources/Source/Url) for `url(...)` references.

Example
-------

```raku
use CSS::Font::Descriptor;
use CSS::Font::Resources;
use CSS::Font::Resources::Source;
my CSS::Font::Descriptor @font-face;
@font-face.push: CSS::Font::Descriptor.new: :font-family("DejaVu Sans"), :src<url("fonts/DejaVuSans.ttf")>;
@font-face.push: CSS::Font::Descriptor.new: :font-family<serif>, :font-weight<bold>, :src<local(DejaVuSans-Bold)>;
my $font = "bold 12pt times roman, serif";
my CSS::Font::Resources $fonts .= new: :$font, :@font-face;
my CSS::Font::Resources::Source @sources = $fonts.sources;
with @sources.head -> $src {
    say ($src.type, $src.format, $src.IO.path).join: ', ';
    # has matched the second descriptor.
    # results may be system dependant, e.g.:
    # local, truetype, /usr/share/fonts/truetype/dejavu/DejaVuSerif-Bold.ttf
}
```

Methods
-------

### font-descriptor

```raku
use CSS::Font::Descriptor;
method font-descriptor returns CSS::Font::Descriptor;
```

Returns the [CSS::Font::Descriptor](https://css-raku.github.io/CSS-Properties-raku/CSS/Font/Descriptor) associated with the source.

### format

```raku
use CSS::Font::Resource::Source :FontFormat;
method format returns FontFormat;
```

Returns the font-format, one of: 'woff', 'woff2', 'truetype', 'opentype', 'embedded-opentype', 'svg'.

The format may be set by a `format(...)` declaration in the CSS `src` property. If this is absent, the format is guessed from the extension on the url (url sources), or matching file (local sources).

### type Returns the source type 'local' ([CSS::Font::Resources::Source::Local](https://css-raku.github.io/CSS-Font-Resources-raku/CSS/Font/Resources/Source/Local)), or 'url' ([CSS::Font::Resources::Source::Url](https://css-raku.github.io/CSS-Font-Resources-raku/CSS/Font/Resources/Source/Url))

### IO

```raku
method IO returns IO::Path;
```

Returns an IO::Path to a font file

### Blob

```raku
method format returns FontFormat;
```

Returns an Blob of the font file's

