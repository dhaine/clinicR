#======================================================================
# Default Makefile.  Use 'make' on its own to see a list of targets.
#
# To add new session, add their Markdown files to the MOST_SRC target.
#
# Note that this Makefile uses $(wildcard pattern) to match sets of
# files instead of using shell wildcards, and $(sort list) to ensure
# that matches are ordered when necessary.
#======================================================================

#----------------------------------------------------------------------
# Settings.
#----------------------------------------------------------------------

# Output directory for local build.
SITE = _site

# Jekyll configuration file.
CONFIG = _config.yml

#----------------------------------------------------------------------
# Specify the default target before any other targets are defined so
# that we're sure which one Make will choose.
#----------------------------------------------------------------------

all : commands

#----------------------------------------------------------------------
# Convert Markdown to HTML exactly as GitHub will when files are
# committed in the repository's gh-pages branch.
#----------------------------------------------------------------------

# Source Markdown files.
ALL_SRC = \

# Other files that the site depends on.
EXTRAS = \
       $(wildcard css/*.css) \
       $(wildcard css/*/*.css)

# Principal target files
INDEX = $(SITE)/index.html

# Convert from Markdown to HTML.  This builds *all* the pages (Jekyll
# only does batch mode), and erases the SITE directory first, so
# having the output index.html file depend on all the page source
# Markdown files triggers the desired build once and only once.
$(INDEX) : ./index.html $(ALL_SRC) $(CONFIG) $(EXTRAS)
	 jekyll build -t -d $(SITE)

#----------------------------------------------------------------------
# Targets.
#----------------------------------------------------------------------

## ---------------------------------------

## commands : show all commands.
commands :
	 @grep -E '^##' Makefile | sed -e 's/##//g'

## ---------------------------------------

## site     : build the site as GitHub will see it.
site : $(INDEX)

## clean    : clean up all generated files.
clean : tidy
	rm -rf $(SITE)

## ---------------------------------------

#----------------------------------------------------------------------
# Rules to launch builds of formats other than Markdown.
#----------------------------------------------------------------------

## rmd      : convert R Markdown files to Markdown.
#  This uses an auxiliary Makefile 'rmd.mk'.
rmd :
	make -f rmd.mk

## ---------------------------------------


.PHONY: all clean commands site tidy rmd
