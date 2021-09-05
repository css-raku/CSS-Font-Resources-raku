#| Abstract base class for font source references
unit class CSS::Font::Resources::Source;

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

method IO returns IO::Path {...}
method Blob returns Buf {...}
method type returns Str {...}

=begin pod

=head2 Description

This is an abstract base class for font descriptor source references. See also instance classes:

=item L<CSS::Font::Resources::Source::Local> for `local(...)` references.
=item L<CSS::Font::Resources::Source::Url> for `url(...)` references.

=head2 Example

=begin code :lang<raku>
use CSS::Font::Descriptor;
use CSS::Font::Resources;
use CSS::Font::Resources::Source;
my CSS::Font::Descriptor @font-face;
@font-face.push: CSS::Font::Descriptor.new: :font-family("DejaVu Sans"), :src<url("fonts/DejaVuSans.ttf")>;
@font-face.push: CSS::Font::Descriptor.new: :font-family<serif>, :font-weight<bold>, :src<local(DejaVuSans-Bold)>;
my $font = "bold 12pt times roman, serif";
my CSS::Font::Resources $fonts .= new: :$font, :@font-face;
my CSS::Font::Resources::Source @sources = $fonts.sources;
with @sources.head -> $src {
    say ($src.type, $src.format, $src.IO.path).join: ', ';
    # has matched the second descriptor.
    # results may be system dependant, e.g.:
    # local, truetype, /usr/share/fonts/truetype/dejavu/DejaVuSerif-Bold.ttf
}
=end code


=head2 Methods

=head3 font-descriptor
=begin code :lang<raku>
use CSS::Font::Descriptor;
method font-descriptor returns CSS::Font::Descriptor;
=end code
Returns the L<CSS::Font::Descriptor> associated with the source.

=head3 format
=begin code :lang<raku>
use CSS::Font::Resource::Source :FontFormat;
method format returns FontFormat;
=end code
Returns the font-format, one of: 'woff', 'woff2', 'truetype', 'opentype', 'embedded-opentype', 'svg'.

The format may be set by a `format(...)` declaration in the CSS `src` property. If this is absent, the
format is guessed from the extension on the url (url sources), or matching file (local sources).

=head3 type
Returns the source type 'local' (L<CSS::Font::Resources::Source::Local>), or 'url' (L<CSS::Font::Resources::Source::Url>)

=head3 IO
=begin code :lang<raku>
method IO returns IO::Path;
=end code
Returns an IO::Path to a font file

=head3 Blob
=begin code :lang<raku>
method format returns FontFormat;
=end code
Returns an Blob of the font file's

=end pod
