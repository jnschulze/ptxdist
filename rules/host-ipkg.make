# -*-makefile-*-
# $Id:$
#
# Copyright (C) 2005 by Robert Schwebel
#               2008 by Marc Kleine-Budde <mkl@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
HOST_PACKAGES-$(PTXCONF_HOST_IPKG) += host-ipkg

#
# Paths and names
#

HOST_IPKG	= $(IPKG)
HOST_IPKG_DIR	= $(HOST_BUILDDIR)/$(HOST_IPKG)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

$(STATEDIR)/host-ipkg.get: $(STATEDIR)/ipkg.get
	@$(call targetinfo)
	@$(call touch)

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

$(STATEDIR)/host-ipkg.extract: $(STATEDIR)/ipkg.get
	@$(call targetinfo)
	@$(call clean, $(HOST_IPKG_DIR))
	@$(call extract, IPKG, $(HOST_BUILDDIR))
	@$(call patchin, IPKG, $(HOST_IPKG_DIR))
	@$(call touch)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

host-ipkg_prepare: $(STATEDIR)/host-ipkg.prepare

HOST_IPKG_PATH	:= PATH=$(HOST_PATH)
HOST_IPKG_ENV	:= $(HOSTCC_ENV)

#
# autoconf
#
HOST_IPKG_AUTOCONF := $(HOST_AUTOCONF)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

host-ipkg_clean:
	rm -rf $(STATEDIR)/host-ipkg.*
	rm -rf $(HOST_IPKG_DIR)

# vim: syntax=make
