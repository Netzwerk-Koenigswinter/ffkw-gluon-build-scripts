#!/usr/bin/perl

#This script was developed for Netzwerk Königswinter
#to remove unsopported devices from the gluon config
#files.

use File::Basename;

$BLACKLISTFILE = dirname(__FILE__)."/blacklist";


my $confPath = $ARGV[0];

#Reading in the Blacklist File to get banned devices
open(my $fh, '<:encoding(UTF-8)', $BLACKLISTFILE);
my @devices = <$fh>;
chomp @devices;

#Closing the Blacklist
close($fh);

#Open the Config Dir and Read in the Files
opendir my $dir, $confPath or die "Cannot read Directory: $!";
my @files = readdir $dir;
closedir $dir;



#Scan Files for device Definitions
foreach my $file (@files){
	
	my @lines2Remove;

	open(my $fh2, '<:encoding(UTF-8)', $confPath.$file) or die "Cannot read file: $!";
	my @lines = <$fh2>;
	close($fh2);

	foreach my $i (0..$#lines){
		#print $lines[$i], "Hallo";
		if($lines[$i] =~ /^device/){
			foreach my $dev (@devices){
				if($lines[$i] =~ $dev){
					#print  $file, ": ", $lines[$i];
					push @lines2Remove, $i;
				}
			}
			
		}
	}



	foreach my $i (reverse(@lines2Remove)){
		removeBlock($i, \@lines);
		#print join("\n",@lines);
	}

	if($#lines2Remove + 1){
		open(my $fh3, '>', $confPath.$file) or die "Cannot write File: $!";
		print $fh3 join("\n", @lines)
	}

}


sub removeBlock {
	my ($lineIndex, $lineRef) = (@_);

	my $bracketCount = 0;
	my $curlBracketCount = 0;

	do{
		$bracketCount += (${$lineRef}[$lineIndex] =~ tr/\(//) - (${$lineRef}[$lineIndex] =~ tr/\)//);
		$curlBracketCount += (${$lineRef}[$lineIndex] =~ tr/\{//) - (${$lineRef}[$lineIndex] =~ tr/\}//);

		#print "(): ", $bracketCount, "{}:", $curlBracketCount,"\n";
		#print ${$lineRef}[$lineIndex];
		splice(@{$lineRef}, $lineIndex, 1);

	}while($bracketCount != 0 or $curlBracketCount != 0);

}

# ^device(.*'device'
