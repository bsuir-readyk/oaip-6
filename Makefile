default: bnr;


build:
	fpc solve.dpr -osolve

run:
	./solve
	
bnr:
	@echo "\n\n---===---\nbuilding... \n---===---\n\n"
	make build
	@echo "\n\n---===---\nbuild done \ntrying to run:\n---===---\n\n"
	make run

