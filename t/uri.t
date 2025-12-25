use Test;
plan 3;
use CSS::URI;

class Uri does CSS::URI { }

my Uri $uri .= new: :url<uri.t>, :base-url<t/>;

is $uri.Str, 't/uri.t';
is $uri.get.substr(0, 9), 'use Test;';
is $uri.Blob.subbuf(0, 9).decode, 'use Test;';
