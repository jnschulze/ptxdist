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
HOST_PACKAGES-$(PTXCONF_HOST_DEPOT_TOOLS) += host-depot_tools

DEPOT_TOOLS		:= depot_tools
DEPOT_TOOLS_GIT		:= https://chromium.googlesource.com/chromium/tools/$(DEPOT_TOOLS).git
HOST_DEPOT_TOOLS_DIR	:= $(HOST_BUILDDIR)/$(DEPOT_TOOLS)

$(STATEDIR)/host-depot_tools.get:
	$(call targetinfo)

	@if [ ! -d $(HOST_DEPOT_TOOLS_DIR) ]; then \
	git clone --depth=1 $(DEPOT_TOOLS_GIT) $(HOST_DEPOT_TOOLS_DIR) \
	; fi

	@$(call touch)

$(STATEDIR)/host-depot_tools.extract:
	@$(call targetinfo)
	@$(call touch)

$(STATEDIR)/host-depot_tools.compile:
	@$(call targetinfo)
	@$(call touch)

$(STATEDIR)/host-depot_tools.install:
	@$(call targetinfo)
	@$(call touch)
