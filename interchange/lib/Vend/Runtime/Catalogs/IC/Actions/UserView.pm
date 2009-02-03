package Vend::Runtime::Catalogs::IC::Actions::UserView;
use Moose;

has 'user_id' => (is  => 'rw', 
                  isa => 'Int');

has 'view_all' => (is  => 'rw', 
                   isa => 'Int');

1;

sub get_user {
    my ($self, $user_id) = @_;
    
    $::CGI->{mv_nextpage} = 'contact.html'; 
    return 1;
}

sub login{
    my ($self, $user_id) = @_;
    
    $::CGI->{mv_nextpage} = 'login.html'; 
    return 1;
}

=pod

=head1 NAME 

Vend::Runtime::Catalogs::IC::Actions::Userview  

=head1 SYSOPSIS

=head1 DESCRIPTION 

=head1 PARAMETERS 

=head1 METHODS

=back
