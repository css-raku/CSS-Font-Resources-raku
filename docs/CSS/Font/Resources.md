[[Raku CSS Project]](https://css-raku.github.io)
 / [[CSS-Font-Resources]](https://css-raku.github.io/CSS-Font-Resources-raku)
 / [CSS::Font](https://css-raku.github.io/CSS-Font-Resources-raku/CSS/Font)
 :: [Resources](https://css-raku.github.io/CSS-Font-Resources-raku/CSS/Font/Resources)

class CSS::Font::Resources
--------------------------

Lightweight CSS Font Resource Manager

Description
-----------

This is lightweight font resource manager, driven by CSS `@font-face` font descriptors.

Methods
-------

### method pattern

```raku
method pattern() returns Hash
```

compute a pattern hash for the font

### method fontconfig-pattern

```raku
method fontconfig-pattern() returns Str
```

compute a font-config pattern string for the font

### method match

```raku
method match(
    @font-face = Code.new
) returns Mu
```

Return only matching font-descriptors

These are matched and ordered by preference, using the [W3C Font Matching Algorithm](https://www.w3.org/TR/2018/REC-css-fonts-3-20180920/#font-matching-algorithm).

### multi method sources

```raku
multi method sources(
    Bool :$fallback = Bool::True,
    |c
) returns Mu
```

Return sources for matching fonts

  * Fonts are first matched using the `match()` method [above]

  * This list is then flattened to [CSS::Font::Resources::Source::Local](https://css-raku.github.io/CSS-Font-Resources-raku/CSS/Font/Resources/Source/Local) and [CSS::Font::Resources::Source::Url](https://css-raku.github.io/CSS-Font-Resources-raku/CSS/Font/Resources/Source/Url) for `local` and `url` font references in the font descriptor's list of `src` references.

  * Fallback local references are also appended for the font's font-family list.

These matches are ordered by user preference. The fonts themselves can be fetched using the `.IO` or `.Str` or Blob methods on the first matching font.

