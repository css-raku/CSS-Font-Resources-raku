use Test;
plan 7;
use CSS::Font::Resources;
use CSS::Font::Descriptor;

my @decls = q:to<END>.split(/^^'---'$$/);
font-family: "DejaVu Sans";
src: url("fonts/DejaVuSans.ttf");
---
font-family: "DejaVu Sans";
src: url("fonts/DejaVuSans-Bold.ttf") format(truetype);
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

my CSS::Font::Descriptor @font-face = @decls.map: -> $style {CSS::Font::Descriptor.new: :$style};

is @font-face[1].src[0][1][0], "truetype";

for (
    "" => "Sans.ttf",
    "bold" => "-Bold.ttf",
    "italic" => "-Oblique.ttf",
    "oblique" => "-Oblique.ttf",
    "bold oblique" => "-BoldOblique.ttf",
    "bold italic" => "-BoldOblique.ttf",
) {
    my $font = "{.key} 12pt DejaVu Sans";
    my CSS::Font::Resources $font-loader .= new: :$font, :@font-face;
    my CSS::Font::Descriptor $match = $font-loader.match.first;
    ok $match.src[0][0].ends-with(.value), "match $font"
        or note "actual match: " ~ $match.src[0][0];
}
