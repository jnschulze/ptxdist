# -*-makefile-*-
#
# Copyright (C) 2015 by Niklas Schulze <me@jns.io>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_LIBNSPR) += libnspr

#
# Paths and names
#
LIBNSPR_VERSION	:= 4.12
LIBNSPR_MD5	:= 0de760c1e00a92e180e611cf06ce9589
LIBNSPR		:= libnspr-$(LIBNSPR_VERSION)
LIBNSPR_SUFFIX	:= tar.gz
LIBNSPR_URL	:= https://ftp.mozilla.org/pub/mozilla.org/nspr/releases/v$(LIBNSPR_VERSION)/src/nspr-$(LIBNSPR_VERSION).tar.gz
LIBNSPR_SOURCE	:= $(SRCDIR)/$(LIBNSPR).$(LIBNSPR_SUFFIX)
LIBNSPR_DIR	:= $(BUILDDIR)/$(LIBNSPR)
LIBNSPR_LICENSE	:= MPL

$(STATEDIR)/libnspr.extract.post:
	@$(call targetinfo)

	mv $(LIBNSPR_DIR)/nspr/* $(LIBNSPR_DIR) || true

	@$(call touch)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

LIBNSPR_CONF_ENV	:= $(CROSS_ENV)

#
# autoconf
#
LIBNSPR_CONF_TOOL	:= autoconf
LIBNSPR_CONF_OPT	:= $(CROSS_AUTOCONF_USR) \
	--target=arm-linux \
	--with-pthreads \
	--disable-debug \
	--enable-strip \
	--enable-ipv6

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/libnspr.targetinstall:
	@$(call targetinfo)

	@$(call install_init, libnspr)
	@$(call install_fixup, libnspr,PRIORITY,optional)
	@$(call install_fixup, libnspr,SECTION,base)
	@$(call install_fixup, libnspr,AUTHOR,"Niklas Schulze <me@jns.io>")
	@$(call install_fixup, libnspr,DESCRIPTION,missing)

	#@$(call install_lib, libnspr, 0, 0, 0644, libnspr4)
	@$(call install_tree, libnspr, 0, 0, -, /usr/lib)

	@$(call install_link, libnspr, libnspr4.so, /usr/lib/libnspr.so)

	@$(call install_finish, libnspr)

	@$(call touch)

