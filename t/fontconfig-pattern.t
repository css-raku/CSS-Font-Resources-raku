use Test;
plan 5;
use JSON::Fast;
use CSS::Font;
use CSS::Font::Selector;
use CSS::Font::Descriptor;

my CSS::Module:D $module = CSS::Module::CSS3.module.sub-module<@font-face>;
my CSS::Font::Selector $font-selector .= new: :font("italic bold condensed 10pt/12pt times-roman");

is $font-selector.fontconfig-pattern, 'times-roman:slant=italic:weight=bold:width=75', 'fontconfig-pattern';
is to-json($font-selector.pattern, :!pretty, :sorted-keys), '{"family":["times-roman"],"stretch":75,"style":"italic","weight":700}';
$font-selector .= new: :font("500 condensed 12px/30px Georgia, serif, Times");
is $font-selector.fontconfig-pattern, 'Georgia,serif,Times:weight=medium:width=75', 'fontconfig-pattern';

my CSS::Font::Descriptor $font-face .= new: :style("font-family:serif; src:local(MySerif)");

is-deeply $font-selector.match([$font-face]), [$font-face];

$font-selector.font-faces.push: $font-face;
is $font-selector.fontconfig-pattern, 'MySerif,Georgia,serif,Times:weight=medium:width=75', 'fontconfig-pattern';


