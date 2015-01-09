#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;
use Roman;
use Scalar::Util qw(looks_like_number);

my $verbose;
my $toc = "";
my $html = "";
my $prefix = "";
my $junk;
my $count = 0;
my $rom = 0;
sub verb;
sub usage;

GetOptions("verbose" => \$verbose,
		   "toc=s" => \$toc,
		   "html=s" => \$html
		  );

if ($html eq "" || $toc eq "")
{
	&usage();
	exit -1;
}

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
		system("sh update_title.sh $line $html $outcount $prefix");
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

sub usage {
	print STDERR "\n$0 Version 0.0.1, Copyright (C) Zhian N. Kamvar \n";
	print STDERR "$0 software comes with no warranty\n";
	print STDERR "LICENSE: GPLv3\n\n";
	print STDERR <<EOF;
	NAME $0 
		This script will assign numbers to displayed table of contents for html
		web pages. This allows for easily adding or removing pages from a
		multi-chapter website.

	USAGE
		$0 -t <toc.txt> -h <html_toc.html> -v
	
	OPTIONS
	-t	text file containing table of contents. Enumeration can be with arabic 
		or roman numerals (lower case). Each section can also have a prefix.
		These are denoted by specifying prefix: and start:1 at the beginning of
		each section.
		EXAMPLE:

		<toc.txt>
		prefix:
		start:i
		Preface
		Forward

		prefix:
		start:1
		Introduction
		Middle
		Conclusion

		prefix:A
		start:1
		Afterward
		Appendix
		</toc.txt>

	-h html file that ends up displayed as table of contents
	-v verbose. Prints files as they are processed
EOF
}


