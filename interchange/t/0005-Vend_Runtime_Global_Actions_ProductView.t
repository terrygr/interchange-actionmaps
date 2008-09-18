use warnings;
use strict;

use Test::More tests => 3;
use FindBin;
use lib "$FindBin::Bin/../lib";

use Vend::Runtime::Global::Actions::ProductView;

my $product_view = Vend::Runtime::Global::Actions::ProductView->new( { product_id => '23' } );

ok(defined $product_view,  'new() returned something');
ok($product_view->isa('Vend::Runtime::Global::Actions::ProductView'), 'returned a ProductView Object');
is($product_view->product_id, '23', 'Product ID');
