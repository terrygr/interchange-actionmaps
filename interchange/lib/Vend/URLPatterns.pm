package Vend::URLPatterns;

use strict;
use warnings;

use Vend::URLPattern;
use Moose;

has 'url_patterns' => (
	is  => 'rw',
	isa => 'ArrayRef'
);

no Moose;

sub register {
    my ($self, $parameter) = @_;

    if(ref($parameter) eq 'ARRAY') {
		foreach my $pattern(@$parameter){
			$self->_add_pattern($pattern);
		}
	}
	elsif(ref($parameter) eq 'HASH') {
		# send it through Vend::URLpattern for instantiation
 		my $url_pattern = Vend::URLPattern->new($parameter);
		$self->_add_pattern($url_pattern);
	}
	elsif($parameter->isa('Vend::URLPattern')) {
		# add it to the url_patterns attribute
		$self->_add_pattern($parameter);
	}
	else {
		return; # invalid argument type
	}

    return 1; 
}

sub generate_path {
    my ($self, $parameters) = @_;

    for my $url_pattern (@{ $self->url_patterns() }) {
		my $result = $url_pattern->generate_path($parameters);
		return $result if $result;
	}

    return;
}


sub parse_path {
    my ($self, $path) = @_;

    for my $url_pattern (@{ $self->url_patterns() }) {
		my $result = $url_pattern->parse_path($path);
		return $result if $result;
	}
    return;
}

sub _add_pattern {
	my ($self, $pattern) = @_;

	my $array = $self->url_patterns();
	push(@$array, $pattern);
	$self->url_patterns($array);
}
 
1;

sub _is_valid_regexp {
    my ($self, $url_pattern_obj) = @_;
    return 1;
}

=pod

=head1 NAME 

Vend::URLPatterns -acts as a registery for URL path patterns for indivudual catalogs and across Interchange entirely

=head1 SYSOPSIS

use IC::UserView;

my $url_obj = Vend::URLPattern->new({ pattern => '^userview/\d+{2}/$',
                                      object  => 'IC::UserView' });

my $patterns = Vend::URLPatterns->new({ object  =>  $url_obj,
                                        catalog => 'IC'});

my $path = $patterns->generate_path( package    => 'IC::UserView',
                                     method     => 'get_user()',
                                     parameters => [ '12' ] );

my $new_path = "userview/32/";

$matched_url_obj = $patterns->pattern_for_path($new_path);

=head1 DESCRIPTION 

A collection class used as a registery for all Vend::URLPattern objects.  This class is filled with patterns and can later be used to check URL
patterns against the path patterns in each object.  Should one match that object's package can be used to instantiate said package.thus matching
the URL to an object with the proper parameters.

=head1 PARAMETERS 

None 

=head1 METHODS

=over 

=item register()

This method is used to register a Vend::URLPattern object with an associated catalog ID.  

=over 12

=item object 

This is an Vend::URLPattern object that you want to associate with a catalog.

=item catalog 

The name of the catalog you would like ot associate with the Vend::URLPatterns object

=back 

=item generate_path()

A method that will loop through the collection of Vend::URLPattern objects and attempt to find a result
using the encapsulated Vend::URLPattern::generate_path() method.  Undef is returned if no matches are found

The parameters for this method are as follows:

=over 12

=item package

The package name you would like to build a URL for.  This will be used to instantiate an object after a path is matched and routed.

=item method 

A method name that belongs to the package that is to be built into the URL. 

=item parameters 

An ARRAY that holds the parameters that are to be built into the URL.  These are the parameters that will be passed into said method after a path is matched and routed.

=back 

=item pattern_for_path()

A method that will return an object of type Vend::URLPattern when given a path by looping through the collection of Vend::URLPattern objects and using the encapsulated Vend::URLPattern::parse_path(). Undef is returned if no matches are found.

The parameters for this method are as follows:

=over 12

=item path

The path from the URL that allows the connection of this external URL to the internals of the application.

=back 

=item _is_valid_regexp()

A private method used to validate the regular expression within the object Vend::URLPattern.  

The following rules apply to regular expressions registered in Vend::URLPattern
* No nested groups/matches
* No pattern matching that isn't being used as a parameter

=back

=cut
