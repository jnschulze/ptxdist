# -*-makefile-*-
#
# Copyright (C) 2016 by Niklas Schulze <me@jns.io>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_MXT_APP) += mxt-app

#
# Paths and names
#
MXT_APP_VERSION	:= 1.27
MXT_APP_MD5     := bd7f88a39369ca2b7e43b5be46b3412a
MXT_APP         := mxt-app-$(MXT_APP_VERSION)
MXT_APP_SUFFIX  := tar.bz2
MXT_APP_URL     := git://github.com/atmel-maxtouch/mxt-app;tag=v$(MXT_APP_VERSION)
MXT_APP_SOURCE  := $(SRCDIR)/$(MXT_APP).$(MXT_APP_SUFFIX)
MXT_APP_DIR     := $(BUILDDIR)/$(MXT_APP)
MXT_APP_LICENSE := MIT

MXT_APP_CONF_TOOL := autoconf

$(STATEDIR)/mxt-app.extract.post:
	@$(call targetinfo)

	@cd $(MXT_APP_DIR) && ./autogen.sh

	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/mxt-app.targetinstall:
	@$(call targetinfo)

	@$(call install_init, mxt-app)
	@$(call install_fixup, mxt-app,PRIORITY,optional)
	@$(call install_fixup, mxt-app,SECTION,base)
	@$(call install_fixup, mxt-app,AUTHOR,"Niklas Schulze <me@jns.io>")
	@$(call install_fixup, mxt-app,DESCRIPTION,missing)

	@$(call install_copy, mxt-app, 0, 0, 0755, -, /usr/bin/mxt-app)

	@$(call install_finish, mxt-app)

	@$(call touch)

# vim: syntax=make
