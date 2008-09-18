use warnings;
use strict;

use Test::More tests => 3;
use FindBin;
use lib "$FindBin::Bin/../lib";

use Vend::Runtime::Catalogs::IC::Actions::UserView;

my $user_view = Vend::Runtime::Catalogs::IC::Actions::UserView->new( { user_id  => '12',
                                                                       view_all => '1'});

ok(defined $user_view,  'new() returned something');
ok($user_view->isa('Vend::Runtime::Catalogs::IC::Actions::UserView'), 'returned a UserView Object');
is($user_view->user_id, '12');
is($user_view->view_all, '1');
