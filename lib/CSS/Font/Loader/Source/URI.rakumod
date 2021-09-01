use CSS::Font::Loader::Source;

unit class CSS::Font::Loader::Source::URI
    is CSS::Font::Loader::Source;
use URI;
has URI $.url;
method Blob { ... }
