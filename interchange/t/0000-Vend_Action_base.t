use warnings;
use strict;

use Test::More;
use FindBin;
use lib "$FindBin::Bin/../lib";
use Test::More qw(no_plan);

BEGIN { use_ok( 'Vend::Action' ); }

require_ok( 'Vend::Action' );
