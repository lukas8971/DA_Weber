BASENAME=thesis
DISTNAME=thesis_latex
DISTFOLDER?=$(shell pwd)
CLASS=vutinfth
VIEWER=xdg-open

.PHONY: default all
default: clean compile
all: clean compile doc

doc:
	pdflatex ${CLASS}.dtx
	pdflatex ${CLASS}.dtx
	makeindex -s gglo.ist -o ${CLASS}.gls ${CLASS}.glo
	makeindex -s gind.ist -o ${CLASS}.ind ${CLASS}.idx
	pdflatex ${CLASS}.dtx
	pdflatex ${CLASS}.dtx

document-class: ${CLASS}.cls
${CLASS}.cls:
	pdflatex ${CLASS}.ins

compile: document-class
	pdflatex $(BASENAME)
#	makeglossaries $(BASENAME)
	pdflatex $(BASENAME)
#	makeglossaries $(BASENAME)
	bibtex $(BASENAME)
	pdflatex $(BASENAME)
	pdflatex $(BASENAME)

view:
	$(VIEWER) $(VIEWER_OPTIONS) $(BASENAME).pdf

zip: clean compile doc
	zip -9 -r --exclude=*.git* $(BASENAME).zip \
		build-all.bat \
		build-all.sh \
		build-thesis.bat \
		build-thesis.sh \
		graphics \
		intro.bib \
		intro.tex \
		lppl.txt \
		Makefile \
		README.txt \
		README-vutinfth.txt \
		thesis.tex \
		thesis.pdf \
		vutinfth.dtx \
		vutinfth.ins

dist: zip
	cp $(BASENAME).zip $(DISTFOLDER)/$(DISTNAME).zip

.PHONY: clean
clean:
	find . -type f  -not \( -name "${BASENAME}.tex" -o -name "*.backup" \) -name "${BASENAME}*" -delete -print
	rm -f vutinfth.cls vutinfth.pdf
	rm -f vutinfth.hd vutinfth.ind
	find . -type f -name '*.aux' -delete -print
	find . -type f -name '*.log' -delete -print
	rm -f vutinfth.glo vutinfth.gls vutinfth.idx vutinfth.ilg vutinfth.out vutinfth.toc
