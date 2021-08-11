use CSS::Font;
use JSON::Fast;

unit class CSS::Font::Loader
    is CSS::Font;

has @.font-faces;

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
    my Str $pat = @.family.join: ',';

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

#| Return a path to a matching system font
method find-font(Str $patt = $.fontconfig-pattern --> Str) {
    my $cmd =  run('fc-match',  '-f', '%{file}', $patt, :out, :err);
    given $cmd.err.slurp {
        note chomp($_) if $_;
    }
    my $file = $cmd.out.slurp;
    $file
      || die "unable to resolve font-pattern: $patt"
}
=para Actually calls `fc-match` on `$.font-config-patterm()`

method match(@font-faces = @!font-faces) {
    nextwith(@font-faces);
}
