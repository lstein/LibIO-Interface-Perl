use ExtUtils::MakeMaker;
use Config;

my @libs = ();
push @libs,'-lresolv' unless $Config{d_inetaton};

my $guess_cfg = {
    'freebsd' => {
        'defs' => '-D__USE_BSD',
    },
    'netbsd' => {
        'defs' => '-D__USE_BSD',
    },
    'openbsd' => {
        'defs' => '-D__USE_BSD',
    }
};

my $guess = $guess_cfg->{$^O};
unless (ref $guess eq 'HASH') {
    $guess = {'defs' => ''};
}

WriteMakefile(
    'NAME'	=> 'IO::Interface',
    'VERSION_FROM' => 'Interface.pm', # finds $VERSION
    'LIBS'	=> ["@libs"],   # e.g., '-lm' 
    'INC'	=> '',     # e.g., '-I/usr/include/other' 
    PMLIBDIRS   => ['Interface'],
    CONFIGURE	=> sub {
        my %attrs;
        $attrs{DEFINE} = $guess->{'defs'};
	
        print "Checking for getifaddrs()...";
        eval { require 'ifaddrs.ph' };
        if ($@ && !-r "/usr/include/ifaddrs.h") {
            print " Nope, will not use it.\n";
        } else {
            $attrs{DEFINE} .= ' -DUSE_GETIFADDRS';
            print " Okay, I will use it.\n";
        }
        \%attrs;
    },
);
