#!/usr/bin/perl
#
use strict;
use warnings;
use utf8;
use POSIX qw(strftime);
 
my $prod_bin = "/usr/bin/gedit";
my $user = "schulmann"; #username
my $timeout = 2;
 
# exec product

system("$prod_bin 2> /dev/null &");
sleep 1;
my $pid_str = `ps waux|grep "$prod_bin"|egrep -v "grep|bash"`;

# get pid
my @pids = split(' ', $pid_str);
#my $pid = ($pid_str =~ /$user\s+(\d+)/);t
print "PID: $pids[1]\n";
 
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
print "WID: $prod_wid\n";

 
# Move to 0x0 position
system ("xdotool windowmove $prod_wid 0 0");
# Set active
system ("xdotool windowactivate --sync $prod_wid");
 
# Type text

my $typed_text = <<endt;
 
########  #### ######## ########    ##     ## ##    ##     ######  ##     ## #### ##    ## ##    ##    
##     ##  ##     ##    ##          ###   ###  ##  ##     ##    ## ##     ##  ##  ###   ##  ##  ##     
##     ##  ##     ##    ##          #### ####   ####      ##       ##     ##  ##  ####  ##   ####      
########   ##     ##    ######      ## ### ##    ##        ######  #########  ##  ## ## ##    ##       
##     ##  ##     ##    ##          ##     ##    ##             ## ##     ##  ##  ##  ####    ##       
##     ##  ##     ##    ##          ##     ##    ##       ##    ## ##     ##  ##  ##   ###    ##       
########  ####    ##    ########    ##     ##    ##        ######  ##     ## #### ##    ##    ##       
 
endt
 
foreach my $line (split /\n/, $typed_text) {
    system ("xdotool key Return type \"$line\"");
}
 
 
# kill product
sleep 3;
#kill 2, $pid;
 
# save current date and time
my $datestring = strftime("%G-%m-%d %H:%M:%S", localtime);

# save product using following format: HW1 YYYY-MM-DD hh:mm:ss
system ("xdotool key --delay 250 alt+F4 Return");
system ("xdotool key type \"HW1 $datestring.txt\"");
system ("xdotool key Return");

sleep 1;
system ("kill $pids[1]");
 
exit 0;