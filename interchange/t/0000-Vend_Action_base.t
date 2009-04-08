use strict;
use warnings;

use Test::More tests => 10;
use FindBin;
use lib "$FindBin::Bin/../lib";

use Vend::Action;

# Test do_action() method
my $action = Vend::Action->new();

ok($action->isa('Vend::Action'), 'returned object instance of type Vend::Action');


my $action_name="product_detail";
my $routine = sub { 
	my ($product_id, $view) = @_;

	return $product_id;
};

my @action_parameters = ('SKU0101', 'large');
my %parameters = ( 
	routine           => $routine,
	action_parameters => \@action_parameters,
);
	
my $result = $action->do_action(\%parameters);
$action->do_mv();
is($result, 'SKU0101', 'do_action(): executed properly');

# Test do_page() method
