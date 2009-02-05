package Vend::Action;

use strict;
use warnings;

use Vend::Page; #TODO: IS THIS NEEDED ?

sub do_action { 
	my ($action_name, $routine, $parameters) = @_;

    return $routine->(@$parameters);
}

sub do_action_page {
	my ($page) = @_;
	display_page($page);
}

sub do_mv {

	my $parameters = shift;

#
# NOTE: Sets mv_action/Vend::Action/mv_nextpage
#
#	if (defined $CGI::values{mv_action}) {
#		$CGI::values{mv_todo} = $CGI::values{mv_action} # SET mv_todo
#			if ! defined $CGI::values{mv_todo}
#			and ! defined $CGI::values{mv_doit};
#		$Vend::Action = $CGI->{mv_ui} ? 'ui' : 'process'; # SET Vend::Action
#		$CGI::values{mv_nextpage} = $Vend::FinalPath # SET mv_nextpage
#			if ! defined $CGI::values{mv_nextpage};
#	}
#

}

1;

=pod

=head1 NAME 

Vend::Action - a class that represents the ActionMap construct

=head1 SYSOPSIS

use Vend::Action;

$status = Vend::Action::do_action('product_detail', ['SKU0002', 'large_view']);

# Handle any exceptions based on the $status

$status = Vend::Action::do_page('index.html');

# Handle any exceptions based on the $status

=head1 DESCRIPTION 

=head1 METHODS

=over

=item do_action(ACTION_NAME, PARAMETER_SET) 

A method used to invoke a method when given an ACTION_NAME and a PARAMETER_SET.

=over

=item ACTION_NAME

The name of the action whose method is to be invoked.

=item PARMETER_SET 

An array ref containing the parameters that will be used to execute the respective method.

=back 

=item do_page(PAGE_NAME) 

A method used to wrap and execute Vend::Dispatch::do_page() when given a PAGE_NAME.

=over

=item PAGE_NAME

The name of the page you would like to have interpolated by Interchange.

=back

=cut
