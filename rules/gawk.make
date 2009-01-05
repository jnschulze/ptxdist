# -*-makefile-*-
# $Id$
#
# Copyright (C) 2003 by Ixia Corporation, By Milan Bobde
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_GAWK) += gawk

#
# Paths and names
#
GAWK_VERSION	:= 3.1.6
GAWK		:= gawk-$(GAWK_VERSION)
GAWK_SUFFIX	:= tar.gz
GAWK_URL	:= $(PTXCONF_SETUP_GNUMIRROR)/gawk/$(GAWK).$(GAWK_SUFFIX)
GAWK_SOURCE	:= $(SRCDIR)/$(GAWK).$(GAWK_SUFFIX)
GAWK_DIR	:= $(BUILDDIR)/$(GAWK)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

$(GAWK_SOURCE):
	@$(call targetinfo)
	@$(call get, GAWK)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

GAWK_PATH	:= PATH=$(CROSS_PATH)
GAWK_ENV 	:= $(CROSS_ENV)

#
# autoconf
#
GAWK_AUTOCONF := $(CROSS_AUTOCONF_USR)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/gawk.targetinstall:
	@$(call targetinfo)

	@$(call install_init, gawk)
	@$(call install_fixup, gawk,PACKAGE,gawk)
	@$(call install_fixup, gawk,PRIORITY,optional)
	@$(call install_fixup, gawk,VERSION,$(GAWK_VERSION))
	@$(call install_fixup, gawk,SECTION,base)
	@$(call install_fixup, gawk,AUTHOR,"Carsten Schlote <schlote\@konzeptpark.de>")
	@$(call install_fixup, gawk,DEPENDS,)
	@$(call install_fixup, gawk,DESCRIPTION,missing)

	@$(call install_copy, gawk, 0, 0, 0755, $(GAWK_DIR)/gawk, /usr/bin/gawk)
	$(call install_link, gawk, /usr/bin/gawk, /usr/bin/awk)

ifdef PTXCONF_GAWK_PGAWK
	@$(call install_copy, gawk, 0, 0, 0755, $(GAWK_DIR)/pgawk, /usr/bin/pgawk)
endif

ifdef PTXCONF_GAWK_AWKLIB
	@$(call install_copy, gawk, 0, 0, 0755, $(GAWK_DIR)/awklib/igawk, /usr/bin/igawk)
	@$(call install_copy, gawk, 0, 0, 0755, $(GAWK_DIR)/awklib/pwcat, /usr/libexec/gawk/pwcat)
	@$(call install_copy, gawk, 0, 0, 0755, $(GAWK_DIR)/awklib/grcat, /usr/libexec/gawk/grcat)
endif

	@$(call install_finish, gawk)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

gawk_clean:
	rm -rf $(STATEDIR)/gawk.*
	rm -rf $(PKGDIR)/gawk_*
	rm -rf $(GAWK_DIR)

# vim: syntax=make
