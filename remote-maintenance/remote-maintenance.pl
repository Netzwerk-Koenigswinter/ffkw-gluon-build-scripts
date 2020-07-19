#!/usr/bin/perl

#This script was developed for Netzwerk Königswinter
#to add remote maintenance keys to  gluon config
#files.

$KEYFILE = "authorised-keys";


my $confPath = $ARGV[0];

my $fh;

#Reading in Key File
open($fh, '<:encoding(UTF-8)', $KEYFILE);
my @keyLines = <$fh>;
my $keyText = join("", @keyLines);

#Closing the Key File
close($fh);

open($fh, '<:encoding(UTF-8)' , $confPath);
my @confLines = <$fh>;
close($fh);

open($fh, '>' , $confPath);

foreach my $line (@confLines){
	print $fh $line;
	if($line =~ /-- REMOTE KEY MARKER --/){
		print $fh $keyText;
	}
}

close($fh);


