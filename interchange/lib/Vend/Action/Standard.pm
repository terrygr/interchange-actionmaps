package Vend::Action::Standard;

use strict;
use warnings;

use Moose;
extends 'Vend::Action';

has name => (
	is  => 'rw',
	isa => 'Str',
);

has routine => (
	is  => 'rw',
	isa => 'CodeRef',
);

no Moose;

sub action {
 	my ($self, $params) = @_;

	my $status = $self->routine->($params);

  	unless($::Vend::RedoAction) {
		return { 
			status      => $status,
			redo_action => 0,
		};
	}
	else {
		undef $::Vend::RedoAction;
		return { 
			status      => $status,
			redo_action => 1
		};
	
	}
}

1;

=pod

=head1 NAME 

Vend::Action::Standard - a class that represents an ActionMap directive 

=head1 SYSOPSIS

use Vend::Action;
use Vend::Action::Standard;

# These values will usually come from the ActionMap namespace
my $name = 'product_detail';

my $sub = sub { 
	$CGI->{mv_nextpage} = 'product_detail.html'; 
	return 1; 
};

my $action = Vend::Action::Standard->new($name, $sub);

my $name = $action->name();
my $sub = $action->sub();

# Have Vend::Action::do_action() execute the sub 
$status = Vend::Action::do_action(
	$action->name(), 
	$action->sub(), 
	\@path
);

# NOTE: maybe do_action should be in this class as it is executing these subs
$status = $action->do_action();  # this would simply use the instances attributes to execute itself...not in a lethal way as suicide is frowned upon

=head1 DESCRIPTION 

=head1 PARAMETERS 

=head1 METHODS

=back
