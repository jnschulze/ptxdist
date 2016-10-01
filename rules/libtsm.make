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
PACKAGES-$(PTXCONF_LIBTSM) += libtsm

#
# Paths and names
#
LIBTSM_VERSION	:= 3
LIBTSM_MD5	:= c1b297a69d11a72f207ec35ae5ce7d69
LIBTSM		:= libtsm-$(LIBTSM_VERSION)
LIBTSM_SUFFIX	:= tar.xz
LIBTSM_URL	:= https://freedesktop.org/software/kmscon/releases/$(LIBTSM).$(LIBTSM_SUFFIX)
LIBTSM_SOURCE 	:= $(SRCDIR)/$(LIBTSM).$(LIBTSM_SUFFIX)
LIBTSM_DIR	:= $(BUILDDIR)/$(LIBTSM)
LIBTSM_LICENSE	:= unknown

LIBTSM_CONF_TOOL	:= autoconf

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/libtsm.targetinstall:
	@$(call targetinfo)

	@$(call install_init, libtsm)
	@$(call install_fixup, libtsm, PRIORITY, optional)
	@$(call install_fixup, libtsm, SECTION, base)
	@$(call install_fixup, libtsm, AUTHOR, "Niklas Schulze <me@jns.io>")
	@$(call install_fixup, libtsm, DESCRIPTION, missing)

	@$(call install_lib, libtsm, 0, 0, 0644, libtsm)

	@$(call install_finish, libtsm)

	@$(call touch)

# vim: syntax=make
