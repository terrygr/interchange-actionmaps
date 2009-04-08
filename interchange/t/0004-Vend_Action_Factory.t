use warnings;
use strict;

use Test::More tests => 6;
use FindBin;
use lib "$FindBin::Bin/../lib";

use Vend::Action::Factory;
use Class::MOP::Class;

my $global_module = "ProductView";
my $catalog_module = "MyAccount";
my $catalog_id = 'IC';


# TODO - test global runtime namespace and package name creation

# Unit test for action_class_for() for Catalog specific package
my $package_name = Vend::Action::Factory->_action_class_for({
	package_name => $catalog_module,
	catalog_id   => $catalog_id 
});

is($package_name, 'Vend::Runtime::Catalogs::IC::Actions::MyAccount', ' returned correct class name');

# Unit test for action_class_for() for global package (catalog_id is undef)
$package_name = Vend::Action::Factory->_action_class_for({
	package_name    => $global_module,
});

is($package_name, 'Vend::Runtime::Global::Actions::ProductView', ' returned correct class name');


# Test complete use of instantiate() with a Global package
my %global_module_parameters = ( product_id => '2');

my $method = sub {
	my $params= shift;
	return $$params[0];
};

my %global_parameters = (
	package_name   => $global_module,
	actionmap_name => 'action_sub',
	actionmap_sub  => $method
);

my $product_view = Vend::Action::Factory->instantiate(\%global_parameters);

ok(defined $product_view,  'new() returned something');
ok($product_view->isa('Vend::Runtime::Global::Actions::ProductView'), 'returned a ProductView Object');

# Test complete use of instantiate() which calls action_class_for()

my %module_parameters = ( user_id  => '12',
                          view_all => '1' );

my $user_view = Vend::Action::Factory->instantiate({
	package_name   => $catalog_module,
	catalog_id     => $catalog_id,
	actionmap_sub  => $method
}); 

my $final_path = 'MyAccount/23/';
my $url_patterns = Vend::URLPatterns::Registry::patterns_for($catalog_id);
my $catalog_url_pattern = $url_patterns->parse_path($final_path);
my $url_pattern_obj = $catalog_url_pattern->{'pattern'}; 

my $package = $url_pattern_obj->package();                                                                
$method = $url_pattern_obj->method();                                                                  
my $action_obj = $package->new( request_path => $final_path );  

# Test our object returned from instantiate()
my $status = $action_obj->$method(['23']);
is($status->{status}, '23', 'Executed routine properly');

# Test use of instantiate() when given a pattern
$method = sub {
	my $params= shift;
	return ++$$params[0];
};


my $product_detail = Vend::Action::Factory->instantiate({
	package_name   => 'product_detail',
	catalog_id     => $catalog_id,
	actionmap_sub  => $method,
	pattern        => '^product_detail/(\d{2})/$',
}); 

$final_path = 'product_detail/23/';
$url_patterns = Vend::URLPatterns::Registry::patterns_for($catalog_id);
$catalog_url_pattern = $url_patterns->parse_path($final_path);
$url_pattern_obj = $catalog_url_pattern->{'pattern'}; 

$package = $url_pattern_obj->package();                                                                
$method = $url_pattern_obj->method();                                                                  
$action_obj = $package->new( request_path => $final_path );  

# Test our object returned from instantiate()
$status = $action_obj->$method(['23']);
is($status->{status}, '24', 'Executed routine properly');
