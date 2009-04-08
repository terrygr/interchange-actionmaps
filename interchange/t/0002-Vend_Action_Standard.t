use strict;
use warnings;

use Test::More tests => 10;
use FindBin;
use lib "$FindBin::Bin/../lib";

use Vend::Action::Standard;

my $action_name = 'product_detail';
my $routine = sub {
	my ($product_id) = @_;
	return $product_id;
};

my $action = Vend::Action::Standard->new(
	name    => $action_name,
	routine => $routine
);

# Make sure its a Vend::Action::Standard instance 
ok(defined $action,  'new() returned something');
ok($action->isa('Vend::Action::Standard'), 'returned a Vend::Action::Standard object');

is($action->name(), 'product_detail', 'returned the proper name attribute');
is(ref($action->routine()), 'CODE', 'returned the proper sub attribute');

# Test inheritance from Vend::Action
$action_name="product_detail";

my @action_parameters = ('SKU0101', 'large');
$routine = sub {
	my ($product_id) = @_;
	return $product_id;
};

my %parameters = ( 
	routine           => $routine,
	action_parameters => \@action_parameters,
);
	
my $result = $action->do_action(\%parameters);

is($result, 'SKU0101', 'do_action(): executed properly');
