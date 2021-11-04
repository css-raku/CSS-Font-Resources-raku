use Test;

use CSS::Font;
use CSS::Font::Resources;
use CSS::Font::Resources::Source;
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
my CSS::Font::Resources $font-loader .= new: :$font, :@font-face, :base-url<t/>;

my CSS::Font::Resources::Source @sources;
@sources = $font-loader.sources: :!fallback;
is +@sources, 1, 'sources without fallback';

if %*ENV<TEST_FONT_CONFIG> {
        # site dependant
    @sources = $font-loader.sources;
    is +@sources, 2, 'sources with fallback';
}

given @sources.head {
    .&isa-ok: 'CSS::Font::Resources::Source::Url';
    .url.Str.&is: 't/fonts/DejaVuSans.ttf';
    .family.&is: 'DejaVu Sans';
    .format.&is: 'truetype';
    is-deeply .Blob, 't/fonts/DejaVuSans.ttf'.IO.slurp(:bin);
}

if %*ENV<TEST_FONT_CONFIG> {
    $font = "bold 12pt times roman, serif";
    $font-loader .= new: :$font, :@font-face, :base-url<t/>;
    @sources = $font-loader.sources;
    is +@sources, 2;
    given @sources.head {
        .&isa-ok: 'CSS::Font::Resources::Source::Local';
        .family.&is: 'serif';
        .fontconfig-pattern.&is: 'serif:weight=bold';
        # site dependant
        lives-ok {.format};
        .IO.&isa-ok: IO::Path;
        .Blob.&isa-ok: Blob;
    }
}

if %*ENV<TEST_FONT_CONFIG> {
    my CSS::Properties $css .= new: :style("font-weight:bold");
    my CSS::Font $generic-bold .= new: :$css;
    @sources = CSS::Font::Resources.sources: :font($generic-bold), :@font-face;

    is +@sources, 1;
    is @sources.head.fontconfig-pattern, 'times-roman:weight=bold', 'generic bold';
}

@decls = (
  %( :font-family("DejaVu Sans"), :src<url("fonts/DejaVuSans.ttf")> ),
  %( :font-family("DejaVu Sans"), :src<url("fonts/DejaVuSans.otf")> ),
);

@font-face = @decls.map: -> %opts {CSS::Font::Descriptor.new: |%opts};
$font = "12pt dejavu sans";
@sources = CSS::Font::Resources.sources: :$font, :@font-face, :!fallback, :formats('opentype'|'svg');
is @sources.head.format, 'opentype', 'class-level source() invocation';

if %*ENV<TEST_FONT_CONFIG> {
    $font = '12pt monospace';
    @sources = CSS::Font::Resources.sources: :$font, :@font-face;

    is +@sources, 1;
    is @sources.head.fontconfig-pattern, 'monospace';
}

done-testing;
