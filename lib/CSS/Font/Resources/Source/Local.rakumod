use CSS::Font::Resources::Source;

#| local source references
unit class CSS::Font::Resources::Source::Local
    is  CSS::Font::Resources::Source;

method type {'local'}
has $!key;
has $!blob;
method key { $!key //= $.find-font }

method IO {
    with $.key {
        .IO;
    }
    else {
        die "unable to find font";
    }
}

method Blob {
    $.IO.slurp: :bin;
}

=begin pod
=head2 Description
This class is used to represent `local` source references.

The IO and Blob methods resolve the font using `fc-match` from the fontconfig package.

=head2 Methods
This class inherits from L<CSS::Font::Resources::Source> and has its method available, including `font-descriptor`, `format`, `IO` and `Blob`.

=end pod

