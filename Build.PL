#!/usr/bin/perl

use strict;
use Module::Build;
use Config;

sub compiler_flags() {
    my @flags = ();
    my %cfg = (
        'freebsd' => '-D__USE_BSD',
        'netbsd'  => '-D__USE_BSD',
        'openbsd' => '-D__USE_BSD',
    );

    print "Checking for BSD-like operating system...";
    if (exists $cfg{$^O}) {
        push @flags, $cfg{$^O};
        print " Okay, present.\n";
    } else {
       print " Nope, not present.\n";
    }

    print "Checking for SIOCGIFCONF...";
    if (!-r "/usr/include/sys/sockio.h") {
        print " Nope, will not use it.\n";
    } else {
        push @flags, '-DSIOCGIFCONF';
        print " Okay, I will use it.\n";
    }

    print "Checking for getifaddrs()...";
    eval { require 'ifaddrs.ph' };
    if ($@ && !-r "/usr/include/ifaddrs.h") {
        print " Nope, will not use it.\n";
    } else {
        push @flags, '-DUSE_GETIFADDRS';
        print " Okay, I will use it.\n";
    }

    print "Checking for sockaddr_dl...";
    if (!-r "/usr/include/net/if_dl.h") {
        print " Nope, will not use it.\n";
    } else {
        push @flags, '-DHAVE_SOCKADDR_DL_STRUCT';
        print " Okay, I will use it.\n";
    }

    return \@flags;
}

my $build = Module::Build->new(
    module_name        => 'IO::Interface',
    dist_version_from  => 'lib/IO/Interface.pm',
    dist_author        => 'Lincoln Stein <lincoln.stein@gmail.com>',
    dist_abstract      => 'Access and modify network interface card configuration',
    license            => 'perl',
    dynamic_config     => 1,
    extra_compiler_flags => compiler_flags(),
    build_requires     => {
	'Config'              => 0,
        'ExtUtils::CBuilder'  => 0,
    },
    requires           => {
        'perl'                => '5.005',
    },
    'resources'        => {
        'homepage'            => 'http://search.cpan.org/dist/IO-Interface/',
        'repository'          => 'https://github.com/lstein/LibIO-Interface-Perl/',
    },
);

$build->create_build_script();

# get rid of annoying warning from ExtUtils::ParseXS
my $sub = 's/\$\^W\s*=\s*1/\$^W = 0/';
system "perl -pi -e '$sub' Build";

exit 0;
