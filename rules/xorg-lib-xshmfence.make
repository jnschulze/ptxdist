# -*-makefile-*-
#
# Copyright (C) 2014 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_XORG_LIB_XSHMFENCE) += xorg-lib-xshmfence

#
# Paths and names
#
XORG_LIB_XSHMFENCE_VERSION	:= 1.2
XORG_LIB_XSHMFENCE_MD5		:= 66662e76899112c0f99e22f2fc775a7e
XORG_LIB_XSHMFENCE		:= libxshmfence-$(XORG_LIB_XSHMFENCE_VERSION)
XORG_LIB_XSHMFENCE_SUFFIX	:= tar.bz2
XORG_LIB_XSHMFENCE_URL		:= $(call ptx/mirror, XORG, individual/lib/$(XORG_LIB_XSHMFENCE).$(XORG_LIB_XSHMFENCE_SUFFIX))
XORG_LIB_XSHMFENCE_SOURCE	:= $(SRCDIR)/$(XORG_LIB_XSHMFENCE).$(XORG_LIB_XSHMFENCE_SUFFIX)
XORG_LIB_XSHMFENCE_DIR		:= $(BUILDDIR)/$(XORG_LIB_XSHMFENCE)
XORG_LIB_XSHMFENCE_LICENSE	:= MIT

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
XORG_LIB_XSHMFENCE_CONF_TOOL	:= autoconf
XORG_LIB_XSHMFENCE_CONF_OPT	:= \
	$(CROSS_AUTOCONF_USR) \
	--disable-selective-werror \
	--disable-strict-compilation \
	--enable-futex

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/xorg-lib-xshmfence.targetinstall:
	@$(call targetinfo)

	@$(call install_init, xorg-lib-xshmfence)
	@$(call install_fixup, xorg-lib-xshmfence,PRIORITY,optional)
	@$(call install_fixup, xorg-lib-xshmfence,SECTION,base)
	@$(call install_fixup, xorg-lib-xshmfence,AUTHOR,"Michael Olbrich <m.olbrich@pengutronix.de>")
	@$(call install_fixup, xorg-lib-xshmfence,DESCRIPTION,missing)

	@$(call install_lib, xorg-lib-xshmfence, 0, 0, 0644, libxshmfence)

	@$(call install_finish, xorg-lib-xshmfence)

	@$(call touch)

# vim: syntax=make
