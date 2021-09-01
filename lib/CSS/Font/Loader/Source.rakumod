unit class CSS::Font::Loader::Source;

use CSS::Font::Descriptor;

my constant %Extensions = %( :woff<woff>, :woff2<woff2>, :ttf<truetype>, :otf<opentype>, :eot<embedded-opentype>, :svg<svg>, :svg2<svg> );
subset FontFormat is export(:FontFormat) of Str where 'woff'|'woff2'|'truetype'|'opentype'|'embedded-opentype'|'svg'|'other';

has CSS::Font::Descriptor:D $.font-descriptor is required handles<font-family fontconfig-pattern src>;
has FontFormat:D $.format is required;
has Str:D $.family is required;


