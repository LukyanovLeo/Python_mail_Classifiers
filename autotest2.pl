#!/usr/bin/perl
#
use strict;
use warnings;
use utf8;
use POSIX qw(strftime);

my $buffer = `find ~ -maxdepth 1 -type f -name \"HW1_*.txt\" -print`;	#find all test files
my @arr = split("\n", $buffer);
my $datestring = strftime("%G-%m-%d", localtime);
my $counter = 0;	#how much outdated files

system ("mkdir -p Archive");	#create archive dir

# search for outdated files 
foreach my $str(@arr){
    unless ($str =~ m/$datestring/){
	$counter++;
	system ("mv $str ~/Archive");
    }
}
#if outdated files were found write info to log.txt
if ($counter > 0){
    
    system ("touch log.txt");
    open (LOGS,">> log.txt")
    or die "Can't open log.txt: $!";
    $datestring = strftime("%H:%M:%S %d.%m.%G  ", localtime);
    if ($counter == 1) {
	print (LOGS "$datestring $counter outdated file was found. It moved to Archive\n");	
    }
    else {
	print (LOGS "$datestring $counter outdated files were found. They moved to Archive\n");	
    }
    close LOGS;
}
exit 0;