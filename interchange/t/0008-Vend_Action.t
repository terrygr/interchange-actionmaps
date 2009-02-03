use strict;
use warnings;

use Test::More tests => 10;
use FindBin;
use lib "$FindBin::Bin/../lib";

use Vend::Action;

# Test do_action() method
my $action_name="product_detail";
my $routine = sub { 
	my ($product_id, $view) = @_;

	return $product_id;
};

my @parameters = ('SKU0101', 'large');

my $result = Vend::Action::do_action($action_name, $routine, \@parameters);

is($result, 'SKU0101', 'do_action(): executed properly');

# Test do_page() method
