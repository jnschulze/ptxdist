# -*-makefile-*-
# $Id$
#
# Copyright (C) 2008 by mol@pengutronix.de
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
HOST_PACKAGES-$(PTXCONF_HOST_INTLTOOL) += host-intltool

#
# Paths and names
#
HOST_INTLTOOL_VERSION	:= 0.37.0
HOST_INTLTOOL		:= intltool-$(HOST_INTLTOOL_VERSION)
HOST_INTLTOOL_SUFFIX	:= tar.bz2
HOST_INTLTOOL_URL	:= http://ftp.gnome.org/pub/gnome/sources/intltool/0.37/$(HOST_INTLTOOL).$(HOST_INTLTOOL_SUFFIX)
HOST_INTLTOOL_SOURCE	:= $(SRCDIR)/$(HOST_INTLTOOL).$(HOST_INTLTOOL_SUFFIX)
HOST_INTLTOOL_DIR	:= $(HOST_BUILDDIR)/$(HOST_INTLTOOL)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

$(HOST_INTLTOOL_SOURCE):
	@$(call targetinfo)
	@$(call get, HOST_INTLTOOL)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

HOST_INTLTOOL_PATH	:= PATH=$(HOST_PATH)
HOST_INTLTOOL_ENV 	:= $(HOST_ENV)

#
# autoconf
#
HOST_INTLTOOL_AUTOCONF	:= $(HOST_AUTOCONF)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

host-intltool_clean:
	rm -rf $(STATEDIR)/host-intltool.*
	rm -rf $(HOST_INTLTOOL_DIR)

# vim: syntax=make
