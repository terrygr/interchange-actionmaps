package Vend::URLPattern;

use strict;
use warnings;

use Regexp::Parser;
use Moose;

has pattern => (
	is  => 'rw', 
	isa => 'Str',
);

has package => (
	is  => 'rw', 
	isa => 'Str',
);

has method => (
	is  => 'rw',
	isa => 'Str',
);

has action => (
	is  => 'rw',
	isa => 'Object',
);

has named_parameters => (
	is  => 'rw',
	isa => 'ArrayRef',
);

has 'parameters' => (
	is  => 'rw',
	isa => 'ArrayRef',
);

no Moose;

sub parse_path {

	my ($self, $path) = @_;
	my @url_params;
	my $pattern = $self->pattern();

	@url_params = $path =~ /($pattern)/g;
	return unless @url_params;

#::logDebug("URLPattern ------------------->$path:$pattern");
	shift @url_params;
	return {
		pattern	   => $self,
		parameters => \@url_params,
	};
}

sub generate_path {
    my ($self, $parameters) = @_;

    my $pattern = $self->pattern();
    my @params= @{$parameters->{parameters}};
    my $path; 
 
    if( $self->package() ne $parameters->{package} ||
		$self->method() ne $parameters->{method} ) {
		return;
	}

	my $matched_pattern = $self->_find_pattern_match(\@params);
	if($matched_pattern) {
		# Plug in captured parameters if any exist 
		my $final_str = $pattern;
		$final_str =~ /\((.*?)\)/;

		foreach my $param (@params) {
			$final_str =~ s//$param/;
		}   
       
		# Remove anchor tags should they exist
		$final_str =~ s/(^\^)|((?:\$|\)$))//g;

		return $final_str;
	}

    return;
}

sub _find_pattern_match {
	my ($self, $params) = @_;

	my $r = Regexp::Parser->new;
	my @capture_params;

	my $rx = $self->pattern();
	$r->regex($rx);

	my $num_groups = $r->nparen();
	my $captures = $r->captures();
	my $visual = $r->visual();

	if($num_groups == ($#$params+1)) {
		my $i=0;
		foreach my $capture (@$captures) {
			my $capture_visual = '^' . $capture->visual() . '$';

			if($$params[$i] !~ /$capture_visual/) { 
				return;
			}
			push(@capture_params, $capture_visual);
			$i++;
		}
		return $r; 
	}
	return;
}

1;

=pod

=head1 NAME 

Vend::URLPattern - responsible for representing a url path pattern and parameters

=head1 SYSOPSIS

use IC::UserView;
my $url_obj = Vend::URLPattern->new( { pattern => '^userview/(\d+{2})/$',
                                       object  => 'IC::UserVIew' });

my $path = "userview/20/";
$self->parse_path($path);

=head1 DESCRIPTION 

A class used to describe a full url path pattern and its parameters.

Rules for Regexp

=over

=item *

No regular expression syntax that is not being used to capture parameters except for anchor tags.

=item *

No pattern matching that isn't being used as a parameter.

=item *

No nested groups/matches.

=back 

=head1 PARAMETERS 

=over

=item pattern 

This is the regexp pattern that is used to parse against the URL.

=back

=over 

=item named_parameters 

This attribute is a list of named parameters that relate to the pattern supplied.  These parameters
must be in the order they are identified in the pattern.  Each identifier in the pattern must also have a 
name.  Any unamed parameters will throw an error upon object instantiation.

=back

=over 


=item package 

This is the package name that is associated with the pattern provided.  This will be used to instantiate an object.

=back

=head1 METHODS

=over 

=item parse_path()

This method is used to parse the path handed to it and set the objects respective command and parameters attributes.

=back

=cut
