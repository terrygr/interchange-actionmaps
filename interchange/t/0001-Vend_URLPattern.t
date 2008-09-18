use strict;
use warnings;

use Test::More tests => 7;
use FindBin;
use lib "$FindBin::Bin/../lib";

use Vend::URLPattern;

my $url_pattern = Vend::URLPattern->new( { url        => 'user_view/12', 
                                           catalog_id => 'ic' });

ok(defined $url_pattern,  'new() returned something');
ok($url_pattern->isa('Vend::URLPattern'), 'returned a URLPattern Object');
is($url_pattern->url(), 'user_view/12', 'URL');
is($url_pattern->catalog_id(), 'ic', 'Catalog ID');

ok($url_pattern->parse_path(), 'Parsing path...');
is($url_pattern->command(), 'user_view', 'Command');
is($url_pattern->parameters()->[1], '12', 'Parameters');
