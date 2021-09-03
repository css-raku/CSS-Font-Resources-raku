unit class CSS::Font::Selector::Source;

use CSS::Font::Descriptor;

my constant %Extensions = %( :woff<woff>, :woff2<woff2>, :ttf<truetype>, :otf<opentype>, :eot<embedded-opentype>, :svg<svg>, :svg2<svg> );
subset FontFormat is export(:FontFormat) of Str where 'woff'|'woff2'|'truetype'|'opentype'|'embedded-opentype'|'svg'|Str:U;

has CSS::Font::Descriptor:D $.font-descriptor is required handles<font-family fontconfig-pattern src find-font>;
has FontFormat $.format;
has Str:D $.family is required;

sub guess-format(Str() $_ --> FontFormat) is export(:guess-format) {
    when .ends-with: '.ttf'   {'truetype'}
    when .ends-with: '.otf'   {'opentype'}
    when .ends-with: '.woff'  {'woff'}
    when .ends-with: '.woff2' {'woff2'}
    when .ends-with: '.svg'   {'svg'}
    default {'other'}
}

method format {
    $!format //= guess-format(self.IO.path);
}
