use CSS::Font::Resources::Source;

unit class CSS::Font::Resources::Source::Local
    is  CSS::Font::Resources::Source;

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

