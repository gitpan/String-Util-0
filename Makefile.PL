use ExtUtils::MakeMaker;

WriteMakefile(
	'NAME'	            => 'String::Util',
	'VERSION_FROM'      => 'Util.pm',
	
	'dist'              => {
		COMPRESS => 'gzip -9f',
		SUFFIX   => 'gz',
	},
);
