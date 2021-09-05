[[Raku CSS Project]](https://css-raku.github.io)
 / [[CSS-Font-Resources]](https://css-raku.github.io/CSS-Font-Resources-raku)
 / [CSS::Font](https://css-raku.github.io/CSS-Font-Resources-raku/CSS/Font)
 :: [Resources](https://css-raku.github.io/CSS-Font-Resources-raku/CSS/Font/Resources)
 :: [Source](https://css-raku.github.io/CSS-Font-Resources-raku/CSS/Font/Resources/Source)
 :: [Url](https://css-raku.github.io/CSS-Font-Resources-raku/CSS/Font/Resources/Source/Url)

class CSS::Font::Resources::Source::Url
---------------------------------------

URL source references

Description This class is used to represent `url` source references.
--------------------------------------------------------------------

The IO and Blob methods resolve the font using:

  * The LWP::Simple module for `http` and `https` URI schemes

  * Local file system for `file` and default URI schemes.

Methods This class inherits from [CSS::Font::Resources::Source](https://css-raku.github.io/CSS-Font-Resources-raku/CSS/Font/Resources/Source) and has its method available, including `font-descriptor`, `format`, `IO` and `Blob`.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

head3 url

```raku
use URL
method url returns URI
```

The source URI. If the `src` url is relative (doesn't have a scheme), an absolute URI is computed, by calling 'rel2abs()', on the font resource `base-url`. For example:

```raku
use CSS::Font::Descriptor;
use CSS::Font::Resources;
use CSS::Font::Resources::Source;
my CSS::Font::Descriptor @font-face;
@font-face.push: CSS::Font::Descriptor.new: :font-family("Times"), :src<url("fonts/TimesRoman.ttf")>;
my $font = "12pt times";
my CSS::Font::Resources $fonts .= new: :$font, :@font-face, :base-url</myfonts>;
my CSS::Font::Resources::Source @sources = $fonts.sources;
say @sources.head.url; # /myfonts/fonts/TimesRoman.ttf
```

