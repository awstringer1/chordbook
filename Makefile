chordbook: 
	scripts/converttotex.sh 
	scripts/make-book.pl 
	pdflatex -output-directory book book/chordbook.tex
	pdflatex -output-directory book book/chordbook.tex