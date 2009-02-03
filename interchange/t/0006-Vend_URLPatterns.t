use strict;
use warnings;

use Test::More tests => 18;
use FindBin;
use lib "$FindBin::Bin/../lib";

use Vend::URLPattern;
use Vend::URLPatterns;

# Instantiate registration object URLPatterns
my $patterns_reg = Vend::URLPatterns->new();

# Make sure its a URLPatterns Object
ok(defined $patterns_reg,  'new() returned something');
ok($patterns_reg->isa('Vend::URLPatterns'), 'returned a URLPatterns Object');

# Test urlpattern registration process
my $first_url_pattern = Vend::URLPattern->new({ 
	pattern => '^userview/(\d{2})/$',
	package => 'IC::UserView',
	method  => 'get_user()'
});

my $second_url_pattern = Vend::URLPattern->new({
	pattern => '^userview/(\d{2})/(\d{4})/$',
	package => 'IC::UserView',
	method  => 'save_user()'
});

my $third_url_pattern = Vend::URLPattern->new({
	pattern => '^userview/(\d{2})/(\d{4})/$',
	package => 'IC::UserView',
	method  => 'update_user()',
});

my $fourth_url_pattern = Vend::URLPattern->new({
	pattern => '^userview/(\d{2})/(\d{4})/$',
	package => 'IC::ProductDetail',
	method  => 'save_user()',
});

my $fifth_url_pattern = { 
	pattern => '^userview/(\d{2})/(\d{4})/$',
	package => 'IC::UserView',
	method  => 'get_user()',
};

my $sixth_url_pattern = {
	pattern => '^userview/(\d{2})/(\d{4})/$',
	package => 'IC::UserView',
	method  => 'update_user()',
};


# Register the patterns
$patterns_reg->register($first_url_pattern, 'IC');
$patterns_reg->register($second_url_pattern, 'IC');

# Test registering of array of objects
my @obj_array;
push(@obj_array, $third_url_pattern);
push(@obj_array, $fourth_url_pattern);
$patterns_reg->register(\@obj_array, 'IC');

# Test registration of unblessed hash 
$patterns_reg->register($fifth_url_pattern, 'IC');
$patterns_reg->register($sixth_url_pattern, 'IC');

# Test url_patterns() method
my $patterns = $patterns_reg->url_patterns();
#is($patterns->[0]->{'catalog_id'}, 'IC', 'returned URLPattern catalog_id from URLPatterns array');
ok($patterns->[0]->isa('Vend::URLPattern'), 'returned URLPattern object from URLPatterns array');
is($patterns->[0]->pattern(), '^userview/(\d{2})/$', 'returned URLPattern URL from URLPatterns array');
is($patterns->[0]->package(), 'IC::UserView', 'returned URLPattern Module from URLPatterns array');
is($patterns->[0]->method(), 'get_user()', 'returned URLPattern Method from URLPatterns array');

# Test generate_path()
my %params = (
	'package'    => 'IC::UserView',
	'method'     => 'save_user()',
    'parameters' => ['32', '2004']
);

my $generated_path = $patterns_reg->generate_path(\%params);

is($generated_path, 'userview/32/2004/', 'Path generated properly:' . $generated_path);

%params = (
	'package'    => 'IC::UserView',
	'method'     => 'save_user()',
    'parameters' => ['foo', 'bar']
);

$generated_path = $patterns_reg->generate_path(\%params);
is($generated_path, undef, 'generate_path() returned undef given non-matching params');

# OLD TESTS #
# Test parse_path() method
my $path = "userview/32/";
my $result = $patterns->[0]->parse_path($path);
my $param = $result->{parameters}[0];
is($param, '32', 'First registered patterns parameter parsed successfully');

# Test generate_path() and test the matched patterns attributes
$path = "userview/32/2003/";
my $found_url_pattern_obj = $patterns_reg->parse_path($path)->{'pattern'};
ok($found_url_pattern_obj->isa('Vend::URLPattern'), 'pattern_for_path() - returned a URLPattern Object');
is($found_url_pattern_obj->pattern(), '^userview/(\d{2})/(\d{4})/$', 'pattern_for_path() - returned URLPattern URL from URLPatterns array');
is($found_url_pattern_obj->package(), 'IC::UserView', 'pattern_for_path() - returned URLPattern Module from URLPatterns array');
is($found_url_pattern_obj->method(), 'save_user()', 'returned URLPattern Method from URLPatterns array');

$path = "userview/32/";
$found_url_pattern_obj = $patterns_reg->parse_path($path)->{'pattern'};
ok($found_url_pattern_obj->isa('Vend::URLPattern'), 'pattern_for_path() - returned a URLPattern Object');
is($found_url_pattern_obj->pattern(), '^userview/(\d{2})/$', 'pattern_for_path() - returned URLPattern URL from URLPatterns array');
is($found_url_pattern_obj->package(), 'IC::UserView', 'pattern_for_path() - returned URLPattern Module from URLPatterns array');
is($found_url_pattern_obj->method(), 'get_user()', 'returned URLPattern Method from URLPatterns array');

# Make sure a non match returns 0
$path = "userview/word/";
$found_url_pattern_obj = $patterns_reg->parse_path($path);
is($found_url_pattern_obj, undef, 'pattern_for_path() returned 0 properly for an unmatched path');

# Test path generation

# For Vend::URLPattern tests, you should be similarly persnickety, and do
# things like:
# * register two separate Vend::URLPattern instances that have an
# identical pattern but different class/methods.  Verify that parse_path
# for a matching path always returns the first of the two registered,
# indicating that the order of registration determines the order of priority.
# * register multiple Vend::URLPattern instances for a given class/method
# combination, but with different parameter possibilities (maybe one has
# no parameters, one has one param, and a third has two params).  Verify
# that parse_path and generate_path always behave as you would expect in
# each case (i.e. if generate_path() is given with two params, you get a
# path that matches the one supporting two params).
# * again, do some parse_path and generate_path calls that shouldn't find
# any matches at all, and verify that they give false/undef results
# appropriately.
