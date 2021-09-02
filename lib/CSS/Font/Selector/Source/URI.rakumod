use CSS::Font::Selector::Source;

unit class CSS::Font::Selector::Source::URI
    is CSS::Font::Selector::Source;
use URI;
has URI $.url;
method Blob { ... }
