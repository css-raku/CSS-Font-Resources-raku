use CSS::Font::Resources::Source;
use CSS::URI;

#| URL source references
unit class CSS::Font::Resources::Source::Url
    is CSS::Font::Resources::Source
    does CSS::URI::X;

method type {'url'}

=begin pod
=head2 Description
This class is used to represent `url` source references.

The `Str` method returns the serialized url.

The `IO` and `Blob` methods resolve the font using:

=item The LWP::Simple module for `http` and `https` URI schemes
=item Local file system for `file` and default URI schemes.

=head2 Methods
This class inherits from L<CSS::Font::Resources::Source> and has its method available, including `font-descriptor`, `format`, `IO` and `Blob`.

head3 url
=begin code :lang<raku>
use URL
method url returns URI
=end code
The source URI. If the `src` url is relative (doesn't have a scheme), an absolute URI is computed,
by calling 'rel2abs()', on the font resource `base-url`. For example:
=begin code :lang<raku>
use CSS::Font::Descriptor;
use CSS::Font::Resources;
use CSS::Font::Resources::Source;
my CSS::Font::Descriptor @font-face;
@font-face.push: CSS::Font::Descriptor.new: :font-family("Times"), :src<url("fonts/TimesRoman.ttf")>;
my $font = "12pt times";
my CSS::Font::Resources $fonts .= new: :$font, :@font-face, :base-url</myfonts>;
my CSS::Font::Resources::Source @sources = $fonts.sources;
say @sources.head.url; # /myfonts/fonts/TimesRoman.ttf
=end code

=end pod
