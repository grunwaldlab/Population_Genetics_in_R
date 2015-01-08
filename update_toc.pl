#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;

my $run;
my $verbose;
my $toc = "";
my $html = "";
sub verb;

GetOptions("run" => \$run,
		   "verbose" => \$verbose,
		   "toc=s" => \$toc,
		   "html=s" => \$html
		  );

print "Options\n\nrun\t$run\nverbose\t$verbose\ntoc\t$toc\nhtml\t$html\n\n";
open(TOC, "<", "$toc")
	or die "Cannot open $toc: $!\n";

while (my $line = <TOC>)
{
	chomp $line;
	print $line."\n";
}

close(TOC);

sub verb {
	return unless $verbose; print "@_\n";
}