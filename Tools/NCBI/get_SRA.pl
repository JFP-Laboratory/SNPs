#!/usr/bin/perl
## Pombert JF, Illinois Tech - 2019
my $version = '0.5';
my $name = 'get_SRA.pl';
my $updated = '15/03/2021';

use strict; use warnings; use Getopt::Long qw(GetOptions);

## Usage definition
my $usage = <<"OPTIONS";
NAME		${name}
VERSION		${version}
UPDATED		${updated}
SYNOPSIS	Downloads data from NCBI SRA files from the NCBI FTP site and converts to FASTQ format using fasterq-dump
		from the NCBI SRA toolkit
REQUIREMENTS	NCBI SRA toolkit:
		https://trace.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?view=software

EXAMPLE		${name} \\
		  -t 10 \\
		  -o FASTQ \\
		  -l accession_list(s) \\
		  -v

OPTIONS:
-t (--threads)	Number of CPU threads to use [Default: 10]
-o (--outdir)	Output directory [Default: ./]
-l (--list)	List(s) of SRA accesssion numbers, one accession number per line
-v (--verbose)	Adds verbosity
OPTIONS
die "\n$usage\n" unless @ARGV;

## Defining options
my $threads = 8;
my $outdir = './';
my @list;
my $verbose;
GetOptions(
	't|threads=i' => \$threads,
	'o|outdir=s' => \$outdir,
	'l|list=s' => \@list,
	'v|verbose' => \$verbose,
);

while (my $list = shift@list){ 
	open IN, "<", "$list" or die "Can't read file $list: $!\n";
	while (my $line = <IN>){
		chomp $line;
		if ($line =~ /^#/){next;}
		unless ($line eq ''){
			my $sra = $line;
			my $verbosity = '';
			if ($verbose){ $verbosity = '--verbose'; }
			print "Downloading/converting $sra to FASTQ format with fasterq-dump ...\n";
			system "fasterq-dump \\
			  --threads $threads \\
			  $verbosity \\
			  --outdir $outdir \\
			  -3 $sra";
		}
	}
}