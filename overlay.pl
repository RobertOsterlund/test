#!/usr/bin/perl

# http://perldoc.perl.org/Term/ANSIColor.html

# http://perl.active-venture.com/lib/Term/ANSIColor.html

use Term::ANSIColor qw(:constants);

###############################################################################

$ROOT = $ENV{'ROOT'};

# defaults
$DEBUG = 0;
$CLEAR = 0;
$DIE   = 0;
$BEEP  = 0;
$PAUSE = 3; # in seconds

###############################################################################

# process command-line args

while ($#ARGV >= 0) {
    if ($ARGV[0] eq "-c") {
	$CLEAR = 1;
	shift;
    } elsif ($ARGV[0] eq "-d") {
	$DIE = 1;
	shift;
    } elsif ($ARGV[0] =~ /-p(\d+)/) {
	$PAUSE = $1;
	shift;
    } elsif ($ARGV[0] =~ /-j(\d+)/) {
	if ($1 == 1) {
	    $BGS = 1;
	} elsif ($1 == 2) {
	    $HPS = 1;
	}
	shift;
    } elsif ($ARGV[0] eq "-b") {
	$BEEP = 1;
	shift;
    }
}

###############################################################################

# 10% chance overall of not "fire"
$pFriendlyFire = 2;
$pNoFire = 8;
$fDisruptedFire = 2; # multiple of above for disrupted fire
$fLowAmmoFire = 3; # multiple of above for low ammo fire

###############################################################################

$pFixedPassForm = 1;
$pFixedFailForm = 10;

$pInactivePassForm = 2;
$pInactiveFailForm = 20;

$pSemiactivePassForm = 3;
$pSemiactiveFailForm = 30;

###############################################################################

$pPenaltyMove = 100;

###############################################################################

$pPenaltyRout = 100;

###############################################################################

# main program loop

while (1) {

###############################################################################

    if ($CLEAR) {
	&clearscreen();
    }

    print color 'reset';

###############################################################################

    $die = &dieroll(100);

    $r = "\n";
    if ($DIE) {
	$r .= "ROLL\n";
	$r .= "==================\n";
	$r .= sprintf "%d\n", $die;
	#$r .= sprintf "%3d\n", $die;
	$r .= "\n\n";
    }
    print $r;

###############################################################################

    $r  = "FIRE\n";
    $r .= "==================\n";
    $r .= "normal:    ";
    print $r;
    if ($die <= $pFriendlyFire) {
        printrd("fr fire"); print "\n";
    } elsif ($die <= $pFriendlyFire+$pNoFire) {
	printmg("no fire"); print "\n";
    } else {
	print "   fire\n";
    }
    $r  = "disrupt:   ";
    print $r;
    if ($die <= $fDisruptedFire*$pFriendlyFire) {
	printrd("fr fire"); print "\n";
    } elsif ($die <= $fDisruptedFire*($pFriendlyFire+$pNoFire)) {
	printmg("no fire"); print "\n";
    } else {
	print "   fire\n";
    }
    $r  = "lowammo:   ";
    print $r;
    if ($die <= $fLowAmmoFire*($pFriendlyFire+$pNoFire)) {
	printmg("no fire"); print "\n";
    } else {
	print "   fire\n";
    }
    $r  = "------------------\n";
    $r .= sprintf "%d of 1      %d of 4\n", &dieroll(1), &dieroll(4);
    $r .= sprintf "%d of 2      %d of 5\n", &dieroll(2), &dieroll(5);
    $r .= sprintf "%d of 3      %d of 6\n", &dieroll(3), &dieroll(6);
    $r .= "\n\n";
    print $r;

###############################################################################

    $r  = "FORM\n";
    $r .= "==================\n";
    $r .= "pass:   ";
    print $r;
    if ($die <= $pFixedPassForm) {
	printrd("     fixed"); print "\n";
    } elsif ($die <= $pFixedPassForm+$pInactivePassForm) {
	printmg("  inactive"); print "\n";
    } elsif ($die <= $pFixedPassForm+$pInactivePassForm+$pSemiactivePassForm) {
	printbl("semiactive"); print "\n";
    } else {
	print("    active\n");
    }
    $r  = "fail:   ";
    print $r;
    if ($die <= $pFixedFailForm) {
	printrd("     fixed"); print "\n";
    } elsif ($die <= $pFixedFailForm+$pInactiveFailForm) {
	printmg("  inactive"); print "\n";
    } elsif ($die <= $pFixedFailForm+$pInactiveFailForm+$pSemiactiveFailForm) {
	printbl("semiactive"); print "\n";
    } else {
	print("    active\n");
    }
    $r  = "\n\n";
    print $r;

###############################################################################

    $r  = "MOVE\n";
    $r .= "==================\n";
    print $r;
    if ($BGS) {
	print("789low:  n/a"); print "\n"; print("456low:  n/a"); print "\n"; print("123low:  n/a"); print "\n";
 	print("------------------"); print "\n";
 	print("789med:  n/a"); print "\n"; printgr("456med:  no melee"); print "\n"; printbl("123med:  no attack"); print "\n";
	print("------------------"); print "\n";
 	printgr("789high: no melee"); print "\n"; printbl("456high: no attack"); print "\n"; printmg("123high: no engage"); print "\n";
	print("------------------"); print "\n";
 	printbl("789max: no attack"); print "\n"; printmg("456max: no engage"); print "\n"; printrd("123max: no advance"); print "\n";
    } elsif ($HPS) {
	print("ABlow:  n/a"); print "\n"; print("CDlow:  n/a"); print "\n"; print("EFlow:  n/a"); print "\n";
 	print("------------------"); print "\n";
 	print("ABmed:  n/a"); print "\n"; printgr("CDmed:  no melee"); print "" ; print "\n"; printbl("EFmed:  no attack"); print "\n";
	print("------------------"); print "\n";
 	printgr("ABhigh: no melee"); print "\n"; printbl("CDhigh: no attack"); print "\n"; printmg("EFhigh: no engage"); print "\n";
	print("------------------"); print "\n";
 	printbl("ABmax: no attack"); print "\n"; printmg("CDmax: no engage"); print "\n"; printrd("EFmax: no advance"); print "\n";
    }
    $r  = "\n\n";
    print $r;

###############################################################################

    $r  = "ROUT\n";
    $r .= "==================\n";
    print $r;
    if ($BGS) {
	print("789low:  n/a"); print "\n"; print("456low:  n/a"); print "\n"; printmg("123low:  withdraw"); print "\n";
	print("------------------"); print "\n";
 	print("789med:  n/a"); print "\n"; printbl("456med:  withdraw"); print "\n"; printmg("123med:  retreat"); print "\n";
	print("------------------"); print "\n";
 	printbl("789high: withdraw"); print "\n"; printmg("456high: retreat"); print "\n"; printrd("123high: disband"); print "\n";
	print("------------------"); print "\n";
 	printmg("789max:  retreat"); print "\n"; printrd("456max:  disband"); print "\n"; printrd("123max:  disband"); print "\n";
    } elsif ($HPS) {
	print("ABlow:  n/a"); print "\n"; print("CDlow:  n/a"); print "\n"; printmg("EFlow:  withdraw"); print "\n";
	print("------------------"); print "\n";
 	print("ABmed:  n/a"); print "\n"; printbl("CDmed:  withdraw"); print "\n"; printmg("EFmed:  retreat"); print "\n";
	print("------------------"); print "\n";
 	printbl("ABhigh: withdraw"); print "\n"; printmg("CDhigh: retreat"); print "\n"; printrd("EFhigh: disband"); print "\n";
	print("------------------"); print "\n";
 	printmg("ABmax:  retreat"); print "\n"; printrd("CDmax:  disband"); print "\n"; printrd("EFmax:  disband"); print "\n";
    }
    $r  = "\n";
    print $r;

###############################################################################

    sleep $PAUSE;

}   # end of main while loop

###############################################################################

print color 'reset';

exit 0;

###############################################################################

sub dieroll {
    my $sides = $_[0];
    my $roll;

    $roll = int((rand $sides) + 1);
    return $roll;
}

# not used
#sub target {
#    my $targets = $_[0];
#
#    printf "%d\n", &dieroll($targets);
#    return;
#}

sub beep {
    my $a = $_[0];

    if ($a ne "n/a") {
	print "\a" if $BEEP;
    }
}

sub printbp {
    my $r = $_[0];

    printf "%s\n", $r;
    &beep($r);
}

sub printgr {
    my $r = $_[0];

    print GREEN $r, RESET;
}

sub printbgr {
    my $r = $_[0];

    print BOLD GREEN $r, RESET;
}

sub printmg {
    my $r = $_[0];

    print MAGENTA $r, RESET;
}

sub printbmg {
    my $r = $_[0];

    print BOLD MAGENTA $r, RESET;
}

sub printbl {
    my $r = $_[0];

    print BLUE $r, RESET;
}

sub printbbl {
    my $r = $_[0];

    print BOLD BLUE $r, RESET;
}

sub printrd {
    my $r = $_[0];

    print RED $r, RESET;
}

sub printbrd {
    my $r = $_[0];

    print BOLD RED $r, RESET;
}

sub clearscreen {

    print "\033[2J";    #clear the screen
    print "\033[0;0H";  #jump to 0,0
}

sub showinstructions {
    my $m = $_[0];

    &beep();
    if ($m eq "c") {
	print <<EOF;
COMMANDING

EOF
    } elsif ($m eq "x") {
	print <<EOF;
FIXING

EOF
    } elsif ($m eq "r") {
	print <<EOF;
ROUTING

EOF
    } elsif ($m eq "t") {
	print <<EOF;
TARGETING

EOF
    }
}
