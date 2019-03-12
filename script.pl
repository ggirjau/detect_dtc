#!/usr/bin/perl

use strict;
use warnings;


sub find_dtc {
	print "Detect DTC script started : \n\n";
	
	my $find = 0;		# flag to check if any DTC was detected;
	my $key;		# var to store detected raw or appeared DTC;
	my $dtc_status = 0;	# var to store DTC status like : Active/Inactive

	# open input .txt file with given .dlt traces;
	open(IN_FILE, "<in.txt") or die "Couldn't open file in.txt, $!";
	my @dlt_line = <IN_FILE>;
	
	# open DTC file;
	open(DTC_FILE, "<dtc.txt") or die "Couldn't open file dtc.txt, $!";
	my @lines = <DTC_FILE>;
	
	# open output file to store detected DTC info ;
	open(OUT_FILE,">out.txt") or die "Couldn't open file out.txt, $!";

	
	for (@dlt_line) {
		if ($_ =~/(DTC..0x)(......)(.Status..)(0x.)/) {
			$key = $2;
			$dtc_status = $4;
			
			for (@lines) {
				if ($_ =~/$key/) {
					
					if ($dtc_status =~/0x9/) {
						print "Active or Raised :  -  $_\n";
						print OUT_FILE "Active or Raised :  -  $_\n";
					}
					else {
						print "Inactive or Cleared : -  $_\n";
						print OUT_FILE "Inactive or Cleared :  -  $_\n";
					}
					
					$find = 1;
				}
			}
		} 
		elsif ($_ =~/(................)(.DTC.:.)(........)/) {
			$key = $3;
			$dtc_status = $1;
			for (@lines) {
				if ($_ =~/$key/) {
					print "$dtc_status :  - $_\n";
					print OUT_FILE "$dtc_status :  - $_\n";
					$find = 1;
				}
			}
		}
	}
	
	unless ($find) {
		print "No DTC detected \n";
	}
	
	close(IN_FILE);
	close(DTC_FILE);
	close(OUT_FILE);
}

find_dtc ();


