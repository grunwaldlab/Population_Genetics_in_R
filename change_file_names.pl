#!/usr/bin/perl
# Author: Zhian N. Kamvar
# license: gpl v3
# purpose: To reorder the names of files that have common naming schemes.
# 	   The utility of this was initially for renaming chapters that
#	   began with "C#_". 
# input: a directory
# output: renames files in that directory
# arguments:
#	-v verbose
#	-r run. This will rename all the files in the given directory
#		according to the pattern.
#	-dir directory where the files are found
#	-pre the prefix of the pattern
# 	-sep the separator used to separate important parts of the files.
# 	-outfile a file where an index of all the new prefixes will be written  


use strict;
use warnings;

use Getopt::Long;

my $run;
my $dir = ".";
my $pre = "C";
my $sep = "_";
my $outfile = "newfiles.txt";
my $verbose;
sub collect_files;
sub reorder_array;
sub verb;
sub addzeroes;

GetOptions("run" => \$run,
		   "dir=s" => \$dir,
		   "pre=s" => \$pre,
		   "sep=s" => \$sep,
		   "outfile=s" => \$outfile,
		   "verbose" => \$verbose
		  );

verb("\nDirectory: $dir");
opendir my $wd, $dir or die "Can't open directory!";
my @files = readdir $wd;
my $file;
my %name_hash;
# This part sorts through all the files and grabs the one with the specific
# pattern.

my ($prefix, $file_list, $count) = collect_files(\@files);
my @prefix_list = @$prefix;
my @file_list = @$file_list;


my $number_of_files = $#file_list;
verb("Found $number_of_files matching $pre#$sep with $count unique prefixes.\n");

# Here we are resorting the prefix list as it has the largest number appear
# first. 
# Update July 16, 2014: The addition of leading zeroes gets around this problem.

($prefix) = reorder_array(\@prefix_list, \%name_hash);
@prefix_list = @$prefix;

# Here we are going through the prefix list and reassigning chapter numbers
# into a newlist.

$outfile = $outfile;
open (OUT, ">$outfile");
my %replacement;
$count = 0;
my $zeroes = addzeroes($#prefix_list);
foreach my $key (@prefix_list){
	my $num = ++$count;
	if ($num < 10){
		$num = join "", $zeroes, $count;
	}
	$replacement{$key} = join "", $pre, $num, $sep, $key;
	print OUT "$replacement{$key}\n";
}

for (my $i = 0; $i < (@file_list); $i++){
	my $file = $file_list[$i];
	my $success = 0;
	foreach my $key (@prefix_list){
		my $oldfile = $file;
		if ($file =~ s/$pre\d+?$sep$key(.+?$)/$replacement{$key}$1/){
			verb("$oldfile\t->\t$file");
			if ($run){
				rename "$dir/$oldfile", "$dir/$file";
			}
			$success = 1;
		} elsif ($success > 0) {
			last;
		} else {
			next;
		}
	}
}
close(OUT);
closedir $wd;

sub collect_files (\@){
	# Globals:
	# $pre
	# $sep
	my ($file_ref) = @_;
	my @files = @$file_ref;
	my @prefix_list;
	my @file_list;
	my $count = 0;
	foreach $file (@files){
		my $base;
		my $ext;
		my $num;
		my $sep_location;
		my $name;
		if ($file =~ /$pre\d+?$sep.+?/){
			push @file_list, $file;
			if ($file =~ /\.Rmd/){
				$count++;
				($base, $ext) = split /\./, $file;
				$sep_location = index($base, $sep);
				$num = substr($base, 1, $sep_location - 1);
				$name = substr($base, $sep_location + 1);
				$name_hash{$name} = $num;
				push @prefix_list, $name;
			}
		}
	}
	return(\@prefix_list, \@file_list, $count);
}

sub reorder_array (\@\%)
{
	# Global: $count
	my ($prefix_ref, $name_hash) = @_;
	my @prefix_list = @$prefix_ref;
	my %name_hash = %$name_hash;
	$count = 0;
	verb("COUNT\tVALUE\tINDEX\n-----\t-----\t-----");
	for (my $i = 0; $i < (@prefix_list); $i++){
		my $key = $prefix_list[$i];
		my $value = $name_hash{$key};
		verb("$count\t$value\t$i");
		if ($count < $value - 1){
			push(@prefix_list, splice(@prefix_list, $i, 1));
			#$count++;
			$i = $i - 1;
			next;
		}
		$count++;
	}
	return(\@prefix_list)
}

sub verb {
	return unless $verbose; print "@_\n";
}

sub addzeroes {
	my $num = $_[0];
	if ($num < 10){
		return "";
	} elsif ($num < 100){
		return "0";
	} elsif ($num < 1000){
		return "00";
	} else {
		return;
	}
}
