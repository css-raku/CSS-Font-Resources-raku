[[Raku CSS Project]](https://css-raku.github.io)
 / [[CSS-Font-Resources]](https://css-raku.github.io/CSS-Font-Resources-raku)

role CSS::URI;
--------------

Punnable role for lightweight fetchable URI's

Description
-----------

[CSS::URI](https://css-raku.github.io/CSS-Font-Resources-raku) is a fetchable URI class. It currently handles schemes `file:` (default), `https:` and `http:`.

Methods
-------

### get

fetch with automatic binary/text detection. Can return `Str` or `Blob` objects.

### IO

returns an IO::Path for the resource. Either a local file or a temporary file for a fetched remote URL.

### Blob

binary fetch.

