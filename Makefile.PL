use ExtUtils::MakeMaker;
use Config;

my @libs = ();
push @libs,'-lresolv' unless $Config{d_inetaton};

WriteMakefile(
    'NAME'	=> 'IO::Interface',
    'VERSION_FROM' => 'Interface.pm', # finds $VERSION
    'LIBS'	=> ["@libs"],   # e.g., '-lm' 
    'INC'	=> '',     # e.g., '-I/usr/include/other' 
    CONFIGURE	=> sub {
        my %attrs;
        print "Checking for getifaddrs()...";
        eval { require 'ifaddrs.ph' };
        if ($@ && !-r "/usr/include/ifaddrs.h") {
            print " Nope, will not use it.\n";
        } else {
            $attrs{DEFINE} = '-DUSE_GETIFADDRS';
            print " Okay, I will use it.\n";
        }
        \%attrs;
    },
);
