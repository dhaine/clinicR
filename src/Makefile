#======================================================================
# Default Makefile.  Use 'make' on its own to see a list of targets.
#
# To add new session, add their Markdown files to the MOST_SRC target.
#
# Note that this Makefile uses $(wildcard pattern) to match sets of
# files instead of using shell wildcards, and $(sort list) to ensure
# that matches are ordered when necessary.
#======================================================================

# Directories.
SRC_DIR = .
DST_DIR = ..

# Make sure everything is built.
all : $(DST_DIR)/201412-data-import.html

# Build files.
$(DST_DIR)/201412-data-import.html : $(SRC_DIR)/201412-data-import.md $(SRC_DIR)/_layout/session.html
	pandoc -s -t html \
	--template=_layout/session \
	-o $@ $<

## Clean up
clean :
	@rm -rf $$(find .. -name '*~' -print)

#----------------------------------------------------------------------
# Rules to launch builds of formats other than Markdown.
#----------------------------------------------------------------------

## rmd      : convert R Markdown files to Markdown.
#  This uses an auxiliary Makefile 'rmd.mk'.
rmd :
	make -f rmd.mk

## ---------------------------------------
