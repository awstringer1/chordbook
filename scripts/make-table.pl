#!/usr/bin/perl
use strict;
use warnings;

my $input_file = $ARGV[0] or die "Usage: $0 input.md\n";
my $output_file = $input_file;
$output_file =~ s/\.md$/.tex/;
$output_file =~ s/songs/songs\/tex/;

open my $in, '<', $input_file or die "Could not open '$input_file': $!\n";
open my $out, '>', $output_file or die "Could not open '$output_file': $!\n";

# print $out "\\documentclass{article}\n";
# print $out "\\usepackage{underscore}\n";
# print $out "\\usepackage{ulem}\n";  # Package for underlining text
# print $out "\\begin{document}\n\n";


my $mode = '';
my $in_table = 0;
my $last_was_blank = 0;
my $first_lyric_line = 1;

while (<$in>) {
    chomp;
    s/<u>(.*?)<\/u>/\\underline{$1}/g;  # Convert <u> tags to LaTeX underline
    if (/^# (.+)/) {
        if ($in_table) {
            print $out "\\end{tabular}\n\n";
            $in_table = 0;
        }
        print $out "\\section{$1}\n\n";
        $mode = '';
        $last_was_blank = 0;
        $first_lyric_line = 1;
    } elsif (/^## (.+)/) {
        if ($in_table) {
            print $out "\\end{tabular}\n\n";
            $in_table = 0;
        }
        print $out "\\subsection*{$1}\n\n";
        $mode = lc($1);
        $last_was_blank = 0;
        $first_lyric_line = 1;
    } elsif (/^$/) {
        if ($in_table) {
            print $out "\\end{tabular}\n\n";
            $in_table = 0;
        }
        if (!$last_was_blank) {
            print $out "\n";
            $last_was_blank = 1;
        }
    } elsif ($mode eq 'intro' || $mode eq 'chorus') {
        if (!$in_table) {
            print $out "\\begin{tabular}{l l l l l l l l}\n";
            $in_table = 1;
        }
        s/%/\\\%/g;  # Properly escape % symbols
        my @columns = split /\s+/;
        print $out join(" & ", @columns) . " \\\\ \n";  # Ensure rows end correctly
        $last_was_blank = 0;
    } else {
        if ($in_table) {
            print $out "\\end{tabular}\n\n";
            $in_table = 0;
        }
        s/%/\\\%/g;  # Properly escape % symbols in lyrics
        s/<u>(.*?)<\/u>/\\uline{$1}/g;  # Convert <u> tags to LaTeX underline
        if ($first_lyric_line) {
            print $out "$_ \\\\ \n";
            $first_lyric_line = 0;
        } else {
            print $out "$_ \\\\ \n";
        }
        $last_was_blank = 0;
    }
}

if ($in_table) {
    print $out "\\end{tabular}\n\n";
}

# print $out "\\end{document}\n";

close $in;
close $out;

# print "LaTeX file created: $output_file\n";
