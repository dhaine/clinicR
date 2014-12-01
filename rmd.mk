#======================================================================
# Create Markdown versions of R Markdown files.
#
# 'make -f rmd.mk'
# ======================================================================

#----------------------------------------------------------------------
# Specify the default target before any other targets are defined so
# that we're sure which one Make will choose.
#----------------------------------------------------------------------

all : rmd

#----------------------------------------------------------------------
# Rules.
#----------------------------------------------------------------------

# Chunk options for knitr
CHUNK_OPTS = src/chunk_options.R

# R Markdown files.  Add patterns here to convert files stored in
# other locations.
RMD_SRC = \
	$(wildcard src/??????-*.Rmd)

# Files converted to Markdown.
RMD_TX = $(patsubst %.Rmd,%.md,$(RMD_SRC))

# Convert a .Rmd to .md.
%.md: %.Rmd $(CHUNK_OPTS)
	cd $$(dirname $<) && \
        Rscript -e "knitr::knit('$$(basename $<)', \
                                output = '$$(basename $@)')"

# Target.
rmd : $(RMD_TX)
