use CSS::Font::Selector::Source;

unit class CSS::Font::Selector::Source::Local
    is  CSS::Font::Selector::Source;

method IO {
    with $.find-font {
        .IO;
    }
    else {
        die "unable to find font";
    }
}

method Blob {
    $.IO.slurp: :bin;
}

