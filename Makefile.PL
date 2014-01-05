use strict;

use ExtUtils::MakeMaker;

require 5.006;

my $mm_ver = $ExtUtils::MakeMaker::VERSION;
if ($mm_ver =~ /_/) { # dev version
    $mm_ver = eval $mm_ver;
    die $@ if $@;
}

WriteMakefile(
	NAME         => 'Constant::FromGlobal',
	VERSION_FROM => 'lib/Constant/FromGlobal.pm',
	INSTALLDIRS  => 'site',
	PL_FILES     => { },
	PREREQ_PM    => {
		'Test::More' => 0.88,
		'Data::OptList' => 0,
		'constant'      => 0,
        'Carp'          => 0,
        'constant'      => 0,
        'warnings'      => 0,
	},
    META_MERGE => {
        resources => {
            repository => 'https://github.com/neilbowers/constant-fromglobal',
        },
    },
    LICENSE      => 'perl',

    ($mm_ver >= 6.48
        ? (MIN_PERL_VERSION => 5.008)
        : ()
    ),

);
