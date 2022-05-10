export OUTPUT_DIR ?= $(abspath ./)
DRAFT ?= false
DEBUG ?= true

ifeq ($(DEBUG), false)
FASTER_FLAG = -latexoption="-interaction=batchmode" -interaction=batchmode
else
endif

.PHONY: all clean distclean dissertation push final

all: dissertation abstract.txt

final: dissertation
	pdfopt.sh $(OUTPUT_DIR)/dissertation.pdf

abstract.txt: abstract.tex
	detex $< > $@

push:
#	rsync -vz $(OUTPUT_DIR)/dissertation.pdf user@server:path/dissertation.pdf

dissertation: $(OUTPUT_DIR)/dissertation.pdf

mttex/%.sty:
	git submodule update --init mttex

#ifeq (,$(wildcard ~/workspace/org/bib.bib))
#else
#bib.bib: ~/workspace/org/bib.bib
#	if [[ ! -f bib.bib ]]; then touch bib.bib; fi
#	chmod +w bib.bib
#	cp -f ~/workspace/org/bib.bib .
#	chmod -w bib.bib
#endif

$(OUTPUT_DIR)/chapters $(OUTPUT_DIR)/frontbackmatters:
	mkdir -p $@

outputdir.tex:
	echo "\PassOptionsToPackage{outputdir=/tmp}{minted}" > $@

chapters/intro/head.ml:
	make -C chapters/intro/

$(OUTPUT_DIR)/%.pdf: %.tex outputdir.tex *.tex chapters/*.tex chapters/cps/cont-shuffle.v chapters/intro/head-eg.v chapters/intro/head.ml chapters/*/*.tex frontbackmatters/*.tex bib.bib mttex/mttex.sty $(OUTPUT_DIR)/chapters $(OUTPUT_DIR)/frontbackmatters
ifeq ($(DRAFT), false)
	latexmk $(FASTER_FLAG) -latexoption="-halt-on-error -shell-escape" -auxdir=$(OUTPUT_DIR) -outdir=$(OUTPUT_DIR) -pdf $<
else
	pdflatex -shell-escape -halt-on-error $(FASTER_FLAG) -output-directory=$(OUTPUT_DIR) $<
endif

clean:
	latexmk -auxdir=$(OUTPUT_DIR) -outdir=$(OUTPUT_DIR) -pdf -c
	rm -f $(OUTPUT_DIR)/*.{pyg,bbl}

distclean: clean
	make -C chapters/intro clean
	latexmk -auxdir=$(OUTPUT_DIR) -outdir=$(OUTPUT_DIR) -pdf -C
	rm -rf $(OUTPUT_DIR)/_minted-dissertation
