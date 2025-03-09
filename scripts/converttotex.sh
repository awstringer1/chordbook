#!/bin/bash

# Directory containing .md files
dir="./songs/"  # Change this if needed

# Perl script to use
perl_script="scripts/make-table.pl"  # Change this to the actual script name

# Check if the Perl script exists
if [[ ! -f "$perl_script" ]]; then
    echo "Error: Perl script '$perl_script' not found."
    exit 1
fi

# Iterate over all .md files in the directory
for file in "$dir"/*.md; do
    # Ensure it's a file and not an empty glob
    [[ -f "$file" ]] || continue
    
    # Run the Perl script on the file
    perl "$perl_script" "$file"

done
