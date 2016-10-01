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
PACKAGES-$(PTXCONF_MINIGBM) += minigbm

MINIGBM_BRANCH	:= dev
MINIGBM_VERSION	:= $(MINIGBM_BRANCH)
MINIGBM		:= minigbm-$(MINIGBM_BRANCH)
MINIGBM_DIR	:= $(BUILDDIR)/$(MINIGBM)
MINIGBM_URL	:= git://github.com/nischu7/minigbm.git

MINIGBM_DRIVERS-$(PTXCONF_MINIGBM_EXYNOS)	+= -DDRV_EXYNOS
MINIGBM_DRIVERS-$(PTXCONF_MINIGBM_GMA500)	+= -DDRV_GBA500
MINIGBM_DRIVERS-$(PTXCONF_MINIGBM_I915)	+= -DDRV_I915
MINIGBM_DRIVERS-$(PTXCONF_MINIGBM_MARVELL)	+= -DDRV_MARVELL
MINIGBM_DRIVERS-$(PTXCONF_MINIGBM_MEDIATEK)	+= -DDRV_MEDIATEK
MINIGBM_DRIVERS-$(PTXCONF_MINIGBM_ROCKCHIP)	+= -DDRV_ROCKCHIP
MINIGBM_DRIVERS-$(PTXCONF_MINIGBM_TEGRA)	+= -DDRV_TEGRA
MINIGBM_DRIVERS-$(PTXCONF_MINIGBM_VC4)		+= -DDRV_VC4

MINIGBM_CONF_TOOL	:= NO
MINIGBM_MAKE_ENV	:= $(CROSS_ENV) \
	ARCH=$(PTXCONF_ARCH_STRING) \
	OUT=$(MINIGBM_DIR) \
	CFLAGS="$(MINIGBM_DRIVERS-y)"

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

$(STATEDIR)/minigbm.get:
	@$(call targetinfo)

	$(call clean, $(MINIGBM_DIR))

	git clone --depth 1 $(MINIGBM_URL) $(MINIGBM_DIR)

	@$(call touch)

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

$(STATEDIR)/minigbm.extract:
	@$(call targetinfo)
	@$(call touch)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

$(STATEDIR)/minigbm.prepare:
	@$(call targetinfo)
	@$(call touch)


# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

#$(STATEDIR)/minigbm.compile:
#	@$(call targetinfo)
#	@$(call touch)


# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

#$(STATEDIR)/minigbm.install:
#	@$(call targetinfo)
#	@$(call touch)


# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/minigbm.targetinstall:
	@$(call targetinfo)

	@$(call install_init, minigbm)
	@$(call install_fixup, minigbm,PRIORITY,optional)
	@$(call install_fixup, minigbm,SECTION,base)
	@$(call install_fixup, minigbm,AUTHOR,"Niklas Schulze <me@jns.io>")
	@$(call install_fixup, minigbm,DESCRIPTION,missing)

	@$(call install_lib, minigbm, 0, 0, 0644, libminigbm)

	@$(call install_finish, minigbm)
	@$(call touch)
