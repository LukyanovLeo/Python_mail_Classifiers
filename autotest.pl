#!/usr/bin/perl
#
use strict;
use warnings;
use utf8;
use POSIX qw(strftime);
 
my $prod_bin = "/usr/bin/gedit";
my $user = `whoami`; #get current username
my $timeout = 2;

# exec product
system("$prod_bin 2> /dev/null &");
sleep 1;
my $pid_str = `ps waux|grep "$prod_bin"|egrep -v "grep|bash"`;

# get pid
my @pids = split(' ', $pid_str);
#my $pid = ($pid_str =~ /$user\s+(\d+)/);t
 
# get wid
my $prod_wids = `xdotool search --all --pid $pids[1]`; # shoud return two windows id
my $prod_wid;

foreach my $wid (split (/\n/, $prod_wids)) {
    next if (not defined $wid or $wid !~ /^\d+$/);
 
    # Get position
    my $prod_pos = ` xdotool getwindowgeometry $wid'`;
    if ($prod_pos =~ /Geometry:\s+(\d+).(\d+)/) { # this is wrong window
        next if ($1 < 100 and $2 < 100);
    }
    $prod_wid = $wid;
}
 
# Move to 0x0 position
system ("xdotool windowmove $prod_wid 0 0");
# Set active
system ("xdotool windowactivate --sync $prod_wid");
 
# Type text

my $typed_text = <<endt;
 
########  
##     ## 
##     ## 
########  
##     ## 
##     ## 
########  
 
endt
 
foreach my $line (split /\n/, $typed_text) {
    system ("xdotool key Return type \"$line\"");
}
 
 
# little delay
sleep 2;

# get current date and time
my $datestring = strftime("%G-%m-%d_%H:%M:%S", localtime);

my $buffer;

# save product using following format: HW1_YYYY-MM-DD_hh:mm:ss.txt
LOOP:
while (1){
unless ($buffer){
    system ("xdotool key --delay 500 alt+F4 Return");
    system ("xdotool key type \"HW1_$datestring.txt\"");
    system ("xdotool key Return");
    
    sleep 1;
    #check if file saved correctly
    $buffer = `find ~ -maxdepth 1 -type f -name \"HW1_$datestring.txt\" -print`; #find 
}else{
    # if it saved correclty save status to log.txt
    system ("touch log.txt");	# if log.txt not exists
    open (LOGS,">> log.txt") 	
	or die "Can't open log.txt: $!";
    $datestring = strftime("%H:%M:%S %d.%m.%G  ", localtime);
    print (LOGS "$datestring Created new test file\n");
    close LOGS;
    last LOOP;
}
}
# kill gedit process
system ("kill $pids[1]");

#call next perl script to check for old tests
system ("perl autotest2.pl");

exit 0;