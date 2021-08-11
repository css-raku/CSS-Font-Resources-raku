use Test;
plan 3;
use JSON::Fast;
use CSS::Font::Loader;

my $font-props = 'italic bold condensed 10pt/12pt times-roman';
my CSS::Font::Loader $font .= new: :$font-props;

is $font.fontconfig-pattern, 'times-roman:slant=italic:weight=bold:width=75', 'fontconfig-pattern';
is to-json($font.pattern, :!pretty, :sorted-keys), '{"family":["times-roman"],"stretch":75,"style":"italic","weight":700}';
$font .= new: :font-props("500 condensed 12px/30px Georgia, serif, Times");
is $font.fontconfig-pattern, 'Georgia,serif,Times:weight=medium:width=75', 'fontconfig-pattern';

