use strict;
use warnings;
use ExtUtils::MakeMaker;

my %conf = (
    NAME          => 'Digest::GOST',
    AUTHOR        => [ 'gray <gray@cpan.org>', 'Gabriele Gristina a.k.a. matrix' ],
    LICENSE       => 'perl',
    VERSION_FROM  => 'lib/Digest/GOST.pm',
    ABSTRACT_FROM => 'lib/Digest/GOST.pm',
    PREREQ_PM     => {
        Digest   => 0,
        XSLoader => 0,
        parent   => 0,
    },
    BUILD_REQUIRES => { 'Test::More' => 0.82, },
    META_MERGE     => {
        resources => { repository => 'http://github.com/matrix/digest-gost' },
    },

    INC => '-Isrc/win32' x !!($^O eq 'MSWin32'),

    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES    => 'Digest-GOST-*' },
);

my $eumm_version =  do {
    no warnings 'numeric';
    eval $ExtUtils::MakeMaker::VERSION;
};
delete $conf{META_MERGE} if $eumm_version < 6.46;
$conf{PREREQ_PM} = {
    %{ $conf{PREREQ_PM} || {} }, %{ delete $conf{BUILD_REQUIRES} },
} if ($conf{BUILD_REQUIRES} and $eumm_version < 6.5503);

WriteMakefile(%conf);


sub MY::postamble {
    return <<"    MAKE_FRAG";
authortest:
\t\$(MAKE) -e \$(TEST_TYPE) TEST_FILES="xt/*.t"
    MAKE_FRAG
}

sub MY::dist_test {
    my $self = shift;
    return $self->MM::dist_test . <<"    MAKE_FRAG";
\tcd \$(DISTVNAME) && \$(MAKE) authortest \$(PASTHRU)
    MAKE_FRAG
}
