use strict;
use warnings;

use Test::More tests => 17;
use FindBin;
use lib "$FindBin::Bin/../lib";

use Vend::URLPattern;

my @named_parameters = ("user_id", "group_id");

my $url_pattern = Vend::URLPattern->new({ 
	pattern          => '^userview/(\d{2})/(\d{4})/$',
	named_parameters => \@named_parameters,
	package          => 'IC::UserView',
	method           => 'get_user()' });

# Test object instantiation 
ok(defined $url_pattern,  'new() returned something');
ok($url_pattern->isa('Vend::URLPattern'), 'returned a URLPattern Object');

is($url_pattern->pattern(), '^userview/(\d{2})/(\d{4})/$', 'URL');
is($url_pattern->named_parameters()->[0], 'user_id', 'Named Parameter 1');
is($url_pattern->named_parameters()->[1], 'group_id', 'Named Parameter 2');
is($url_pattern->package(), 'IC::UserView', 'Catalog ID');
is($url_pattern->method(), 'get_user()', 'Method is correct');

# Test parse_path() functionality
my $path = "userview/foo/2004";
my $result = $url_pattern->parse_path($path);
is($result, undef, 'parse_path: Undef returned as expected.');

$path = "userview/203/2004";
$result = $url_pattern->parse_path($path);
is($result, undef, 'parse_path(): Undef returned as expected.');

$path = "userview/32/2004";
$result = $url_pattern->parse_path($path);
is($result, undef, 'parse_path(): Undef returned as expected.');

$path = "userview/32/2004/";
$result = $url_pattern->parse_path($path);

is($result->{parameters}[0], '32', 'parse_path(): First parameter parsed successfully');
is($result->{parameters}[1], '2004', 'parse_path(): Second parameter parsed successfully');

# Test generate_path() functionality
my %params = ( 
	package    => 'IC::ProductDetail',
	method     => 'get_user()',
	parameters => [ '32', '2004']
);

$result = $url_pattern->generate_path(\%params);

is($result, undef, 'generate_path(): Undef returned as expected.');

%params = ( 
	package    => 'IC::UserView',
	method     => 'update_user()',
	parameters => [ '32', '2004']
);

$result = $url_pattern->generate_path(\%params);

is($result, undef, 'generate_path(): Undef returned as expected.');

%params = ( 
	package    => 'IC::UserView',
	method     => 'get_user()',
	parameters => [ ] 
);

$result = $url_pattern->generate_path(\%params);

is($result, undef, 'generate_path(): Undef returned as expected.');

%params = ( 
	package    => 'IC::UserView',
	method     => 'get_user()',
	parameters => [ 'foo', 'bar' ] 
);

$result = $url_pattern->generate_path(\%params);

is($result, undef, 'generate_path(): Undef returned as expected.');

%params = ( 
	package    => 'IC::UserView',
	method     => 'get_user()',
	parameters => [ '32', '2000' ] 
);

$result = $url_pattern->generate_path(\%params);

is($result, 'userview/32/2000/', 'generate_path(): Undef returned as expected.');
