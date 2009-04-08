package Vend::Action::Factory;

use Vend::URLPatterns::Registry;
use Vend::Action::Standard;
use Moose ();
no Moose;

sub instantiate {

    my ($self, $parameters) = @_;

	my $catalog_id = $parameters->{'catalog_id'} || '';

    my $package = $self->_action_class_for({ 
		package_name => $parameters->{package_name},
		catalog_id   => $catalog_id,
	});

 	my $action_class = Moose::Meta::Class->create(
		$package => (
			superclasses => ['Vend::Action::Standard'],
  			attributes => [
  				Moose::Meta::Attribute->new(
  					'routine' => (
  					default => sub { $parameters->{actionmap_sub} },
  				),)
  			],
		)
	);

	# Create a URLPattern object to register with the colleciton
	my $pattern;
#::logDebug("Passed ActionMap pattern------------------->" . $parameters->{pattern});
	if(defined($parameters->{pattern})){
		$pattern = $parameters->{pattern};
	}
	else {
		$pattern = '^' . $parameters->{package_name} . '((?:/|$|.+))';
	}
#::logDebug("Registered ActionMap pattern------------------->" . $pattern);
	my $url_pattern = Vend::URLPattern->new({
		pattern => $pattern,
		package => $package, 
		method  => 'action'
	});

	my @patterns;
	push(@patterns, $url_pattern);
    Vend::URLPatterns::Registry::register_patterns($catalog_id, \@patterns);

	return $action_class->new_object();
}

sub _action_class_for {

    my ($self, $parameters) = @_;
    my $package;

    if($parameters->{catalog_id}){
        $package = "Vend::Runtime::Catalogs::" . $parameters->{catalog_id} . "::Actions::" . $parameters->{package_name} ;
    }
    else {
        $package = "Vend::Runtime::Global::Actions::" . $parameters->{package_name};
    }

    return $package;
}

1;

=pod

=head1 NAME 

Vend::Action::Factory

=head1 SYSOPSIS

# Parameters for the actual module that Factory will create the object for
my %module_parameters = ( user_id  => '12',
                          view_all => '1' );

my $module_name = "UserView";
my $catalog_id = "IC";

my %parameters = ( module_name       => $module_name,
                   catalog_id        => $catalog_id,
                   module_parameters => \%module_parameters);

my $user_view = Vend::Action::Factory->instantiate(\%parameters);
my $user_id = $user_view->user_id();

=head1 DESCRIPTION 

This module is a factory class used to create objects during runtime that live in the Vend::Runtime namespace.  This module 
generally takes a catalog_id for catalog specific classes in Vend::Runtime::Catalogs:: otherwise it assumes  you want a 
global and attempts to instantiate a global runtime object from Vend::Runtime::Global::Actions

=head1 PARAMETERS 

NONE 

=head1 METHODS

=head2 instantiate(%parameters)

This method takes a hashref of parameters: module_name, catalog_id, and module_parameters. An attempt is then made to create
an object of the given module_name and catalog_id

=head3 %parameters

=over 

=item B<module_name> - The name of the module for the object you want created

=item B<catalog_id> - The catalog id for the catalog that owns the module.  If not supplied global action is assumed

=item B<module_parameters> - A hash ref to a list of parameters to be passed to the module for the object created.  These will vary depending
on the module you are having Factory create

=back

=head2 action_class_for($module, $catalog_id)

A method used to return the proper package name given a module name and a catalog_id.  If catalog_id is not given
it assumes global and returns a global package name.

=over

=item B<module> - name of the module used to create a package name

=item B<catalog_id> - The id of the catalog used to look in an appropiate namespace 

=back
