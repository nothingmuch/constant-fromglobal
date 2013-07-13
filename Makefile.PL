use strict;

use ExtUtils::MakeMaker;

require 5.006;

WriteMakefile(
	NAME         => 'Constant::FromGlobal',
	VERSION_FROM => 'lib/Constant/FromGlobal.pm',
	INSTALLDIRS  => 'site',
	PL_FILES     => { },
	PREREQ_PM    => {
		'Test::More' => 0.88,
		'Data::OptList' => 0,
		'constant' => 0,
	},
);
