# Builds every variant in variants/ into dist/<variant>.pdf.
# Needs XeLaTeX and latexmk (MacTeX, TeX Live or MiKTeX).

LATEXMK    := latexmk
LATEXFLAGS := -xelatex -interaction=nonstopmode -halt-on-error -file-line-error
VARIANTS   := $(basename $(notdir $(wildcard variants/*.tex)))

.DEFAULT_GOAL := all
.PHONY: all check previews watch clean $(VARIANTS)

all: $(VARIANTS)

$(VARIANTS):
	@mkdir -p dist
	$(LATEXMK) $(LATEXFLAGS) -outdir=dist variants/$@.tex

# Fails if a variant runs past one page; also reports overfull lines and
# characters missing from the fonts. Set MAX_PAGES=2 for a two-page CV.
check: all
	@scripts/check.sh $(VARIANTS)

# Renders page one of each PDF to docs/<variant>.png for the README.
previews: all
	@scripts/previews.sh $(VARIANTS)

# Rebuilds a variant on every save: make watch VARIANT=industry
watch:
	@mkdir -p dist
	$(LATEXMK) $(LATEXFLAGS) -pvc -outdir=dist variants/$(or $(VARIANT),$(firstword $(VARIANTS))).tex

clean:
	rm -rf dist
