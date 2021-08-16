use CSS::Font;

unit class CSS::Font::Loader
    is CSS::Font;

use CSS::Properties::Calculator :FontWeight;
use JSON::Fast;
use URI;
use URI::FetchFile;

has @.font-faces;
has URI() $.base-uri = '.';
has Bool  $.network;
has Bool  $.local = True;
has Str   $.fallback;
subset FontFormat of Str where 'woff'|'woff2'|'truetype'|'opentype'|'embedded-opentype'|'svg';
my constant %Extensions = %( :woff<woff>, :woff2<woff2>, :ttf<truetype>, :otf<opentype>, :eot<embedded-opentype>, :svg<svg>, :svg2<svg> );
#has Set[FontFormat] $.format; # accepted font formats;

method !fc-stretch {
    my constant %Stretch = %(
        :normal(100),
        :semi-expanded(113), :expanded(125), :extra-expanded(150), :ultra-expanded(200),
        :semi-condensed(87), :condensed(75), :extra-condensed(63), :ultra-condensed(50),
    );

    %Stretch{$.stretch};
}

#| compute a fontconfig pattern for the font
method fontconfig-pattern {
    my Str @names = self!local-fonts();
    @names.append: @.family;
    my Str $pat = @names.join: ',';

    $pat ~= ':slant=' ~ $.style
        unless $.style eq 'normal';

    $pat ~= ':weight='
    #    000  100        200   300  400     500    600      700  800       900
      ~ <thin extralight light book regular medium semibold bold extrabold black>[$.weight.substr(0,1)]
        unless $.weight == 400;

    # [ultra|extra][condensed|expanded]
    $pat ~= ':width=' ~ self!fc-stretch()
        unless $.stretch eq 'normal';
    $pat;
}

method !local-fonts() {
    @.match(@!font-faces)>>.src.grep(*.type eq 'local')>>.Slip
}

#| Return a path to a matching system font
method find-font(Str $patt = $.fontconfig-pattern --> URI) {
    my $cmd =  run('fc-match',  '-f', '%{file}', $patt, :out, :err);
    given $cmd.err.slurp {
        note chomp($_) if $_;
    }
    if $cmd.out.slurp -> $path {
        URI.new: "file:/$path";
    }
    else {
        die "unable to resolve font-pattern: $patt"
    }
}
=para Actually calls `fc-match` on `$.font-config-patterm()`

method match(@font-faces = @!font-faces) {
    nextwith(@font-faces);
}
