package Constant::FromGlobal;

use strict;
use warnings;

use Carp;
use Data::OptList;

use constant ();

our $VERSION = "0.02";

sub import {
    my ( $class, @args ) = @_;

    my $opt = ref($args[0]) eq 'HASH' ? shift @args : {};

    @_ = (
		"constant",
		$class->process_constants(
			package => scalar(caller),
			%$opt,
			constants => \@args
		)
	);

    goto &constant::import;
}

sub process_constants {
    my ( $class, %args ) = @_;

    my $options = Data::OptList::mkopt(delete $args{constants}, "constant", 1, [qw(HASH ARRAY)]);

    my %constants;

    my $caller = $args{package};

    foreach my $constant ( @$options ) {
        my ( $name, $opt ) = @$constant;

        $constants{$name} = $class->get_value(
            %args,
            name => $name,
            %$opt,
        );
    }

    return %constants;
}

sub get_value {
    my ( $class, %args ) = @_;

    my $value = $class->get_var(%args);

    if ( not defined $value and $args{env} ) {
        $value = $class->get_env_var(%args);
    }

	if ( not defined $value and defined $args{default} ) {
		$value = $args{default};
	}

    if ( $args{bool} ) {
        return not not $value;
    } elsif ( defined $value ) {
        if ( $args{num} ) {
            require Scalar::Util;
            croak "'$value' does not look like a number" unless Scalar::Util::looks_like_number($value);
            return 0+$value;
        } elsif ( $args{int} ) {
            croak "'$value' does not look like an integer" unless $value =~ /^\s* -? \d+ \s*$/x;
            return int 0+$value;
        }
	}

	return $value;
}

sub var_name {
    my ( $class, %args ) = @_;

    join "::", @args{qw(package name)};
}

sub get_var {
    my ( $class, %args ) = @_;

    no strict 'refs';
    return ${ $class->var_name(%args) }
}

sub get_env_var {
    my ( $class, %args ) = @_;

    my $name = uc $class->var_name(%args);
    $name =~ s/^MAIN:://;
    $name =~ s/::/_/g;

    $ENV{$name};
}

# ex: set sw=4 et:

__PACKAGE__

__END__

=pod

=head1 NAME

Constant::FromGlobal - Adam Kennedy's "Constant Global" pattern

=head1 SYNOPSIS

    package Foo;
    
    use Constant::FromGlobal qw(DEBUG);

    sub foo {
        # to enable debug, set $Foo::DEBUG=1 before loading Foo
        warn "lalala" if DEBUG:
    }

=head1 DESCRIPTION

This module lets you easily define constants whose value is initialized from a
global or an environment variable.

=head1 METHODS

=over 4

=item import

This routine takes an optional hash of options for all constants, followed by
an option list (see L<Data::OptList>) of constant names.

For example:

	use Constant::FromGlobal { env => 1 }, "DSN", MAX_FOO => { int => 1, default => 3 };

is the same as

	use Constant::FromGlobal DSN => { env => 1 }, MAX_FOO => { int => 1, default => 3, env => 1 };

which will define two constants, C<DSN> and C<MAX_FOO>. C<DSN> is a string and
C<MAX_FOO> is an integer. Both will take their values from C<$Foo::DSN> if
defined or C<$ENV{FOO_DSN}> as a fallback.

Note: if you define constants in the B<main> namespace, the first release of this module
looked for environment variables prefixed with C<MAIN_>. From version 0.02 onwards,
you don't need the C<MAIN_> prefix.

=head1 SEE ALSO

L<constant>, L<constant::def>, L<http://use.perl.org/~Alias/journal/39845>

