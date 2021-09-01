unit class CSS::Font::Loader::Source;

use URI;
use CSS::Font::Descriptor;

my constant %Extensions = %( :woff<woff>, :woff2<woff2>, :ttf<truetype>, :otf<opentype>, :eot<embedded-opentype>, :svg<svg>, :svg2<svg> );
subset FontFormat is export(:FontFormat) of Str where 'woff'|'woff2'|'truetype'|'opentype'|'embedded-opentype'|'svg'|'other';

has CSS::Font::Descriptor $.font handles<font-family src>;
has Str:D $.family is required;


