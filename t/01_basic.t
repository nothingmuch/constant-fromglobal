#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

BEGIN {
    $Bar::DEBUG = "tinny";
    $ENV{ZOT_DEBUG} = "peanuts";
    $Doof::NUMBER = " 448 ";
}

{
    package Foo;

    use Constant::FromGlobal { bool => 1 }, qw(DEBUG);

    sub foo { DEBUG }

    package Bar;

    use Constant::FromGlobal qw(DEBUG);

    sub foo { DEBUG }

    package Zot;

    use Constant::FromGlobal { bool => 1, env => 1 }, qw(DEBUG);

    package Doof;

    use Constant::FromGlobal NUMBER => { int => 1 };

    package Quxx;

    use Constant::FromGlobal DEBUG => { default => 1 };
}

ok( !Foo::foo(), "DEBUG not enabled" );
ok( Bar::foo(),  "DEBUG enabled from global" );
is( Bar::foo(), "tinny", "value not processed" );
ok( Zot::DEBUG(),  "DEBUG enabled from env" );
is( Zot::DEBUG(), 1, "converted to bool" );
is( Doof::NUMBER(), 448, "converted to int" );
is( Quxx::DEBUG(), 1, "default" );

done_testing;

# ex: set sw=4 et:

