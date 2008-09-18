package Vend::Action::Factory;

use Moose;

# TODO - add error handling for modules that it doesn't find, gracefully die
sub instantiate {

    my $self       = shift;
    my $parameters = shift;
    my $catalog_id = $parameters->{'catalog_id'};
    my $module_name = $parameters->{'module_name'};
    my $module_parameters = $parameters->{'module_parameters'};

    my $package = $self->action_class_for($module_name, $catalog_id);

    require $package->{'location'};

    return $package->{'class'}->new($module_parameters);
}

sub action_class_for {

    my ($self, $module, $catalog_id) = @_;
    my %package;

    if($catalog_id){
        %package =  ( class    => "Vend::Runtime::Catalogs::" . $catalog_id . "::Actions::$module",
                      location => "Vend/Runtime/Catalogs/$catalog_id/Actions/$module.pm");
    }
    else {
        %package =  ( class    => "Vend::Runtime::Global::Actions::$module",
                      location => "Vend/Runtime/Global/Actions/$module.pm");
    }

    return \%package;
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
