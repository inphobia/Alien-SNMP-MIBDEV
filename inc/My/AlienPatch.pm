package My::AlienPatch;

use strict;
use warnings;
use Tie::File;

sub main::alien_patch {
  my $newuse = qq{\nuse Alien::SNMP::MAXTC;\n};
  tie my @perlmod, 'Tie::File', 'perl/SNMP/SNMP.pm'
    or die "can't open SNMP.pm: $!";
  for (@perlmod) {
    if (m/use warnings;/) {
      $_ .= $newuse;
      last;
    }
  }

  my $maxtc = q{#define MAX_IMPORTS 512};
  tie my @parse, 'Tie::File', 'snmplib/parse.c'
    or die "can't open parse.c: $!";
  for (@parse) {
    if (m/#define\s+MAX_IMPORTS\s+/) {
      $_ = $maxtc;
      last;
    }
  }
}

1;
