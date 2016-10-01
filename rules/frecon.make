# -*-makefile-*-
#
# Copyright (C) 2016 by Niklas Schulze <me@jns.io>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.

#
# We provide this package
#
PACKAGES-$(PTXCONF_FRECON) += frecon

FRECON_BRANCH	:= master
FRECON_VERSION	:= $(FRECON_BRANCH)
FRECON		:= frecon-$(FRECON_BRANCH)
FRECON_DIR	:= $(BUILDDIR)/$(FRECON)
FRECON_URL	:= git://github.com/nischu7/frecon.git

FRECON_CONF_TOOL	:= NO
FRECON_MAKE_ENV	:= $(CROSS_ENV) \
	ARCH=$(PTXCONF_ARCH_STRING) \
	OUT=$(FRECON_DIR) \
	CFLAGS="-Wno-maybe-uninitialized"

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

$(STATEDIR)/frecon.get:
	@$(call targetinfo)

	$(call clean, $(FRECON_DIR))

	git clone --depth 1 $(FRECON_URL) $(FRECON_DIR)

	@$(call touch)

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

$(STATEDIR)/frecon.extract:
	@$(call targetinfo)
	@$(call touch)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

$(STATEDIR)/frecon.prepare:
	@$(call targetinfo)
	@$(call touch)


# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

#$(STATEDIR)/frecon.compile:
#	@$(call targetinfo)
#	@$(call touch)


# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

#$(STATEDIR)/frecon.install:
#	@$(call targetinfo)
#	@$(call touch)


# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/frecon.targetinstall:
	@$(call targetinfo)

	@$(call install_init, frecon)
	@$(call install_fixup, frecon,PRIORITY,optional)
	@$(call install_fixup, frecon,SECTION,base)
	@$(call install_fixup, frecon,AUTHOR,"Niklas Schulze <me@jns.io>")
	@$(call install_fixup, frecon,DESCRIPTION,missing)

	@$(call install_copy, frecon, 0, 0, 0755, $(FRECON_DIR)/frecon, /usr/sbin/frecon)

	@$(call install_finish, frecon)
	@$(call touch)

# vim: syntax=make
