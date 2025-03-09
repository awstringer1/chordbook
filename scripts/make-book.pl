#!/usr/bin/perl
use strict;
use warnings;

my $output_file = "chordbook.tex";
my $directory = "songs";
chomp($directory);

# Open the directory and read file names
opendir(my $dh, $directory) or die "Cannot open directory: $!";
my @all_files = readdir($dh);
closedir($dh);
# Filter for .tex files and ensure they are regular files
my @tex_files = sort grep { /\.tex$/} @all_files;
# Open the output file
open my $out, '>', $output_file or die "Could not open '$output_file': $!\n";

print $out "\\documentclass{article}\n";
print $out "\\setcounter{secnumdepth}{0}\n";
print $out "\\usepackage{ulem}\n";
print $out "\\author{Alex Stringer}\n\n";
print $out "\\title{Chord Book}\n\n";
print $out "\\begin{document}\n\n";
print $out "\\maketitle\n\n";
print $out "\\tableofcontents\n\n";
print $out "\\newpage\n\n";


# Write the LaTeX commands to the file
foreach my $file (@tex_files) {
    print $out "\\input{songs/$file}\n";
    print $out "\\newpage\n";
}

print $out "\\end{document}\n";

close $out;
