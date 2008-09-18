use warnings;
use strict;

use Test::More tests => 6;
use FindBin;
use lib "$FindBin::Bin/../lib";

use Vend::Action::Factory;

my $global_module = "ProductView";
my $catalog_module = "UserView";
my $catalog_id = 'IC';
my %parameters = ( user_id  => '12',
                   view_all => '1' );


# TODO - test global runtime namespace and package name creation

# Unit test for action_class_for() for Catalog specific package
my $package_name = Vend::Action::Factory->action_class_for($catalog_module, $catalog_id);
is($package_name->{'class'}, 'Vend::Runtime::Catalogs::IC::Actions::UserView', ' returned correct class name');
is($package_name->{'location'}, 'Vend/Runtime/Catalogs/IC/Actions/UserView.pm', ' returned correct location name');

# Unit test for action_class_for() for global paackage
$package_name = Vend::Action::Factory->action_class_for($global_module);
is($package_name->{'class'}, 'Vend::Runtime::Global::Actions::ProductView', ' returned correct class name');
is($package_name->{'location'}, 'Vend/Runtime/Global/Actions/ProductView.pm', ' returned correct location name');


# Test complete use of instantiate() with a Global package
my %global_module_parameters = ( product_id => '2');

my $global_module_name = "ProductView";

my %global_parameters = ( module_name       => $global_module_name,
                          module_parameters => \%global_module_parameters);

my $product_view = Vend::Action::Factory->instantiate(\%global_parameters);

ok(defined $product_view,  'new() returned something');
ok($product_view->isa('Vend::Runtime::Global::Actions::ProductView'), 'returned a ProductView Object');
is($product_view->product_id(), 2, 'Product ID');

# Test complete use of instantiate() which calls action_class_for()
my %module_parameters = ( user_id  => '12',
                          view_all => '1' );

my $module_name = "UserView";

my %catalog_parameters = ( module_name       => $module_name,
                   catalog_id        => $catalog_id,
                   module_parameters => \%module_parameters);

my $user_view = Vend::Action::Factory->instantiate(\%catalog_parameters);

ok(defined $user_view,  'new() returned something');
ok($user_view->isa('Vend::Runtime::Catalogs::IC::Actions::UserView'), 'returned a UserView Object');
is($user_view->user_id(), 12, 'User ID');
is($user_view->view_all(), 1, 'View All');
