#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;
use Roman;
use Scalar::Util qw(looks_like_number);

my $run;
my $verbose;
my $toc = "";
my $html = "";
my $ext = "";
my $prefix = "";
my $junk;
my $count = 0;
my $rom = 0;
sub verb;

GetOptions("run" => \$run,
		   "verbose" => \$verbose,
		   "toc=s" => \$toc,
		   "html=s" => \$html,
		   "ext=s" => \$ext
		  );

open(TOC, "<", "$toc")
	or die "Cannot open $toc: $!\n";

while (my $line = <TOC>)
{
	chomp $line;
	# Check for starting number
	if ($line =~ m/start:/)
	{
		($junk, $line) = split /:/, $line;
		$count = looks_like_number($line) ? $line : arabic($line);
		$rom = isroman($line) ? 1 : undef;
	}
	# Check for a prefix before the number
	elsif ($line =~ m/prefix:/)
	{
		($junk, $prefix) = split /:/, $line;
	} 
	# Check for full lines. These will be filenames.
	elsif (length($line) > 1)
	{
		my $outcount = $rom ? roman($count) : $count;
		verb("$prefix$outcount.\t$line");
		system("sh update_title.sh $line.Rmd $html $outcount $prefix");
		$count++;
	}
	else
	{
		verb("");
	}
	

}

close(TOC);
sub verb {
	return unless $verbose; print "@_\n";
}