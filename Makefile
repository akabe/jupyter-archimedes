NON_CPPO_SOURCES = $(shell find src \( -name '*.ml' -or -name '*.mli' \) -not -name '*.cppo.*')
KERNEL_NAME = ocaml-jupyter-$(shell opam var switch)
OCAML_JUPYTER_LOG = debug

.PHONY: format check-format test

format:
	opam exec -- ocp-indent -i $(NON_CPPO_SOURCES)

check-format:
	@res=0; for f in $(NON_CPPO_SOURCES); do \
	  echo ">>> $$f" ; \
	  ( opam exec -- ocp-indent "$$f" | diff "$$f" - ) || res=1 ; \
	done ; \
	exit $$res

test:
	sed 's/__KERNEL_NAME__/$(KERNEL_NAME)/g' tests/notebook.ipynb | OCAML_JUPYTER_LOG=$(OCAML_JUPYTER_LOG) jupyter nbconvert --to notebook --execute --stdin --output tests/notebook.nbconvert.ipynb
