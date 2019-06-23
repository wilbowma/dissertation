all: test

head.ml: head-eg.v
	coqtop -l $< -batch

main.ml: head.ml caller.ml
	./link.sh head.ml caller.ml main.ml

test: main.ml
	@-ocaml main.ml 

clean:
	/bin/rm main.ml head.ml *.mli
