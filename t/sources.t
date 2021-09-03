use Test;

use CSS::Font::Selector;
use CSS::Font::Selector::Source;
use CSS::Font::Descriptor;

my @decls = q:to<END>.split: /^^'---'$$/;
font-family: "DejaVu Sans";
src: url("fonts/DejaVuSans.ttf");
---
font-family: "serif";
font-weight: bold;
src: local(DejaVuSans-Bold);
END

my CSS::Font::Descriptor @font-face = @decls.map: -> $style {CSS::Font::Descriptor.new: :$style};

my $font = "12pt DejaVu Sans";
my CSS::Font::Selector $font-loader .= new: :$font, :@font-face, :base-url<t>;

my CSS::Font::Selector::Source @sources = $font-loader.sources;
is +@sources, 1;
given @sources.head {
    .&isa-ok: 'CSS::Font::Selector::Source::URI';
    .url.Str.&is: 't/fonts/DejaVuSans.ttf';
    .family.&is: 'DejaVu Sans';
    .format.&is: 'truetype';
    is-deeply .Blob, 't/fonts/DejaVuSans.ttf'.IO.slurp(:bin);
}

$font = "bold 12pt times roman, serif";
$font-loader .= new: :$font, :@font-face, :base-url<t>;
@sources = $font-loader.sources;
is +@sources, 1;
given @sources.head {
    .&isa-ok: 'CSS::Font::Selector::Source::Local';
    .family.&is: 'serif';
    .format.&is: 'other';
    .fontconfig-pattern.&is: 'serif:weight=bold';
}

done-testing;
