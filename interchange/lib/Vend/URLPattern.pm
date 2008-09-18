package Vend::URLPattern;
use Moose;

has 'catalog_id' => (is  => 'rw', 
                     isa => 'Str');

has 'url' => (is  => 'rw', 
              isa => 'Str');

has 'command' => (is  => 'rw', 
                  isa => 'Str');

has 'parameters' => (is  => 'rw', 
                     isa => 'ArrayRef');

sub parse_path {

    my $self = shift;
    my @path = split(/\//, $self->url);

    $self->command($path[0]);
    $self->parameters(\@path);

    return 1;
}

1;

=pod

=head1 NAME 

Vend::URLPattern - responsible for representing a url path pattern and parameters

=head1 SYSOPSIS

my $url_obj = Vend::URLPattern->new({  catalog_id => $catalog_id,
                                       url        => 'user_view/12', );

=head1 DESCRIPTION 

A class used to describe a full url path pattern and is parameters.

=head1 PARAMETERS 

=over

=item CATALOG ID

This is the id that represents the catalog that the url is requesting action for.  If undef a global action is assumed.

=back

=over 

=item URL

This is the entire URL that describes the function and parameters to be called up or the actionmap.  

=back

=head1 METHODS

=over 

=item parse_path()

This method is responsible for parsing the path into a function call and its associated parameters.  This data is then put into a data structure.

=back

=over 

=item generate_path()

This method is responsible for generating a path given a data set

=back

=cut
