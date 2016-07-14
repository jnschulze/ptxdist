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
PACKAGES-$(PTXCONF_WAYLAND_PROTOCOLS) += wayland-protocols

#
# Paths and names
#
WAYLAND_PROTOCOLS_VERSION	:= 1.4
WAYLAND_PROTOCOLS_MD5		:= fd8089abf13a1d04e4baa6509ee72baf
WAYLAND_PROTOCOLS		:= wayland-protocols-$(WAYLAND_PROTOCOLS_VERSION)
WAYLAND_PROTOCOLS_SUFFIX	:= tar.xz
WAYLAND_PROTOCOLS_URL		:= http://wayland.freedesktop.org/releases/$(WAYLAND_PROTOCOLS).$(WAYLAND_PROTOCOLS_SUFFIX)
WAYLAND_PROTOCOLS_SOURCE	:= $(SRCDIR)/$(WAYLAND_PROTOCOLS).$(WAYLAND_PROTOCOLS_SUFFIX)
WAYLAND_PROTOCOLS_DIR		:= $(BUILDDIR)/$(WAYLAND_PROTOCOLS)
WAYLAND_PROTOCOLS_LICENSE	:= MIT

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
WAYLAND_PROTOCOLS_CONF_TOOL	:= autoconf
WAYLAND_PROTOCOLS_CONF_OPT	:= $(CROSS_AUTOCONF_USR)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/wayland-protocols.targetinstall:
	@$(call targetinfo)

	@$(call install_init, wayland-protocols)
	@$(call install_fixup, wayland-protocols,PRIORITY,optional)
	@$(call install_fixup, wayland-protocols,SECTION,base)
	@$(call install_fixup, wayland-protocols,AUTHOR,"Niklas Schulze <me@jns.io>")
	@$(call install_fixup, wayland-protocols,DESCRIPTION,wayland-protocols)

	@$(call install_tree, wayland-protocols, 0, 0, -, /usr/share)

	@$(call install_finish, wayland-protocols)

	@$(call touch)

# vim: syntax=make
