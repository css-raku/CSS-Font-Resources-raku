use Test;
plan 6;
use CSS::Font::Loader;
use CSS::Properties;
use CSS::Font::Descriptor;

my @decls = q:to<END>.split(/^^'---'$$/);
font-family: "DejaVu Sans";
src: url("fonts/DejaVuSans.ttf");
---
font-family: "DejaVu Sans";
src: url("fonts/DejaVuSans-Bold.ttf");
font-weight: bold;
---
font-family: "DejaVu Sans";
src: url("fonts/DejaVuSans-Oblique.ttf");
font-style: oblique;
---
font-family: "DejaVu Sans";
src: url("fonts/DejaVuSans-BoldOblique.ttf");
font-weight: bold;
font-style: oblique;
END

my CSS::Font::Descriptor @font-faces = @decls.map: -> $style {CSS::Font::Descriptor.new: :$style};

my $font-props = 'italic bold condensed 10pt/12pt times-roman';

for (
    "" => "Sans.ttf",
    "bold" => "-Bold.ttf",
    "italic" => "-Oblique.ttf",
    "oblique" => "-Oblique.ttf",
    "bold oblique" => "-BoldOblique.ttf",
    "bold italic" => "-BoldOblique.ttf",
) {
    my $font-props = "{.key} 12pt DejaVu Sans";
    my CSS::Font::Loader $font-loader .= new: :$font-props, :@font-faces;
    my CSS::Font::Descriptor $match = $font-loader.match.first;
    ok $match.src.ends-with(.value);
}
