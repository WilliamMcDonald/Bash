#!/bin/bash
# Compile Script
# Problem: Lack of automation to compile common scripting files
# Solution: Command to find, compile, and run for me.

filein=$(readlink -f "$1") # File input
cwd=$(dirname "$filein") # Current Working Directory
shebang=$(sed -n 1p "$filein") # First line of file

cd "$cwd" || exit # Change to the directory of the file.

searchshebang() { # Check to see if first line in file is the shebang
  case "$shebang" in
    \#\!*) "$filein" ;;
    *) sent "$filein" 2>/dev/null & ;;
  esac
}

case "$filein" in
  *config.h) make && sudo make install ;; # Config header file
  *\.cpp) g++ "$filein" -o "$filein" && "$filein".bin ;; # C++ file
  *\.py) python3 "$filein" ;; # Python file
  *\.java) javac "$filein" -o "$filein".class && java "$filein".class ;; # Java File
  *\.html) firefox "$filein" ;; # Run HTML files in Firefox
  *\.rb) ruby "$filein" ;; # Ruby files
  *\.md) pandoc "$filein" --pdf-engine=xelatex -o "$filein".pdf && zathura "$filein".pdf ;; # Use pandoc to convert markdown files to PDF
  *) searchshebang ;;
esac
