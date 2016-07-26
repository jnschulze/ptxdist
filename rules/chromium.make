# -*-makefile-*-
#
# Copyright (C) 2015 by Niklas Schulze <me@jns.io>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.

#
# We provide this package
#
PACKAGES-$(PTXCONF_CHROMIUM) += chromium

CHROMIUM_VERSION	:= 53.0.2783.2
CHROMIUM		:= chromium-$(CHROMIUM_VERSION)
CHROMIUM_DIR		:= $(BUILDDIR)/$(CHROMIUM)
CHROMIUM_SRCDIR		:= $(SRCDIR)/$(CHROMIUM)
CHROMIUM_OUTDIR		:= $(CHROMIUM_DIR)/src/_out/Release

#
# Platform specific switches
# 

ifeq ($(PTXCONF_GNU_TARGET), aarch64-v8a-linux-gnu)

 CHROMIUM_ARCH := armv8-a
 CHROMIUM_TUNE := cortex-a53
 CHROMIUM_FPU  := fp-armv8
 CHROMIUM_FLOATABI := hard
 CHROMIUM_ARM_VERSION := 8
 CHROMIUM_ARM_NEON := true
 CHROMIUM_ARM_THUMB := true

else ifeq ($(PTXCONF_GNU_TARGET), arm-v8a-linux-gnueabihf)

 CHROMIUM_ARCH := armv8-a
 CHROMIUM_TUNE := cortex-a53
 CHROMIUM_FPU  := fp-armv8
 CHROMIUM_FLOATABI := hard
 CHROMIUM_ARM_VERSION := 8
 CHROMIUM_ARM_NEON := true
 CHROMIUM_ARM_THUMB := true

else ifeq ($(PTXCONF_GNU_TARGET), arm-v7a-linux-gnueabihf)

 CHROMIUM_ARCH := armv7-a

 ifeq ($(PTXCONF_PLATFORM), tx6-pong)
  CHROMIUM_TUNE := cortex-a9
 else
  CHROMIUM_TUNE := cortex-a7
 endif

 CHROMIUM_FPU  := neon
 CHROMIUM_FLOATABI := hard
 CHROMIUM_ARM_VERSION := 7
 CHROMIUM_ARM_NEON := true
 CHROMIUM_ARM_THUMB := true

else ifeq ($(PTXCONF_GNU_TARGET), arm-1136jfs-linux-gnueabihf)

 CHROMIUM_ARCH := armv6j
 CHROMIUM_TUNE := arm1136jf-s
 CHROMIUM_FPU  := vfp
 CHROMIUM_FLOATABI := hard
 CHROMIUM_ARM_VERSION := 6
 CHROMIUM_ARM_NEON := false
 CHROMIUM_ARM_THUMB := false

else

 @$(error Unsupported Chromium Platform)

endif


# 
# Build Options
#

# custom_toolchain=\"foo:arm\"
CHROMIUM_DEFINES := \
	is_clang=false \
	toolchain_prefix=\"$(PTXCONF_GNU_TARGET)-\" \
	use_sysroot=false \
	target_cpu=\"arm\" \
	arm_version=$(CHROMIUM_ARM_VERSION) \
	arm_use_thumb=$(CHROMIUM_ARM_THUMB) \
	arm_use_neon=$(CHROMIUM_ARM_NEON) \
	arm_tune=\"$(CHROMIUM_TUNE)\" \
	arm_float_abi=\"$(CHROMIUM_FLOATABI)\" \
	is_desktop_linux=false \
	enable_webrtc=false \
	enable_media_router=false \
	disable_ftp_support=true \
	enable_session_service=false \
	enable_supervised_users=false \
	enable_google_now=false \
	enable_one_click_signin=false \
	enable_basic_printing=false \
	enable_print_preview=false \
	enable_pdf=false \
	enable_remoting=false \
	enable_mdns=false \
	enable_captive_portal_detection=false \
	enable_nacl=false \
	use_pulseaudio=false \
	use_alsa=false \
	use_cups=false \
	use_glib=false \
	use_gio=false \
	use_gconf=false \
	use_libpci=false \
	use_kerberos=false \
	use_libjpeg_turbo=true \
	use_vulcanize=false \
	use_aura=true \
	use_ozone=true \
	ozone_auto_platforms=false \
	toolkit_views=false \
	safe_browsing_mode=0 \
	proprietary_codecs=false \
	linux_use_bundled_binutils=false \
	remove_webcore_debug_symbols=true \
	symbol_level=1 \
	treat_warnings_as_errors=false


# Build shared libraries?
ifdef PTXCONF_CHROMIUM_SHARED
	CHROMIUM_DEFINES += is_component_build=true
endif

#
# Targets
#
CHROMIUM_TARGETS-y := sandbox/linux:chrome_sandbox

CHROMIUM_TARGETS-$(PTXCONF_CHROMIUM_BROWSER)		+= chrome
CHROMIUM_TARGETS-$(PTXCONF_CHROMIUM_APPSHELL)		+= app_shell
CHROMIUM_TARGETS-$(PTXCONF_CHROMIUM_CONTENTSHELL)	+= content/shell:content_shell

ifneq (,$(filter y,$(PTXCONF_CHROMIUM_BROWSER) $(PTXCONF_CHROMIUM_APPSHELL)))
	CHROMIUM_DEFINES += enable_extensions=true use_dbus=true
else
	CHROMIUM_DEFINES += enable_extensions=false use_dbus=false
endif



# GBM
ifdef PTXCONF_CHROMIUM_OZONE_GBM
	CHROMIUM_DEFINES += ozone_platform_gbm=true use_system_minigbm=true
	CHROMIUM_TARGETS-y += ui/ozone/platform/drm:gbm
endif

# EGL
ifdef PTXCONF_CHROMIUM_OZONE_EGL
	CHROMIUM_DEFINES += ozone_platform_egl=true
	CHROMIUM_TARGETS-y += ui/ozone/platform/egl:egl
endif

# eglest
ifdef PTXCONF_CHROMIUM_OZONE_EGLTEST
        CHROMIUM_DEFINES += ozone_platform_egltest=true
        CHROMIUM_TARGETS-y += ui/ozone/platform/egltest:egltest
endif

# X11
ifdef PTXCONF_CHROMIUM_OZONE_X11
	CHROMIUM_DEFINES += ozone_platform_x11=true
	CHROMIUM_TARGETS-y += ui/ozone/platform/x11:x11
endif

# Wayland
ifdef PTXCONF_CHROMIUM_OZONE_WAYLAND
	CHROMIUM_DEFINES += ozone_platform_wayland=true use_wayland_egl=true
	CHROMIUM_TARGETS-y += ui/ozone/platform/wayland:wayland
endif

# Caca
ifdef PTXCONF_CHROMIUM_OZONE_CACA
	CHROMIUM_DEFINES += ozone_platform_caca=true
	CHROMIUM_TARGETS-y += ui/ozone/platform/caca:caca
endif


CHROMIUM_ENV = $(CROSS_ENV) \
	PATH=$(HOST_DEPOT_TOOLS_DIR):$(PATH) \
	PYTHONPATH=$(HOST_DEPOT_TOOLS_DIR):$(PYTHONPATH) \
	PKG_CONFIG_PATH=$(PTXDIST_PLATFORMDIR)/sysroot-target/usr/lib/pkgconfig \
	GYP_CHROMIUM_NO_ACTION=1

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

$(STATEDIR)/chromium.get:
	@$(call targetinfo)

	@if [ ! -d $(CHROMIUM_SRCDIR) ]; then \
	mkdir -p $(CHROMIUM_SRCDIR) && \
	cd $(CHROMIUM_SRCDIR) && \
	$(HOST_DEPOT_TOOLS_DIR)/fetch --nohooks chromium --nosvn=True && \
	cd src && \
	git checkout -b stable tags/$(CHROMIUM_VERSION) && \
	PATH=$(HOST_DEPOT_TOOLS_DIR):$(PATH) PYTHONPATH=$(HOST_DEPOT_TOOLS_DIR):$(PYTHONPATH) $(HOST_DEPOT_TOOLS_DIR)/gclient sync --with_branch_heads --jobs 16 \
	; fi

	@$(call touch)

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

$(STATEDIR)/chromium.extract:
	@$(call targetinfo)

	@$(call clean, $(CHROMIUM_DIR))

	@mkdir -p $(CHROMIUM_DIR) && cp -r $(CHROMIUM_SRCDIR)/* $(CHROMIUM_DIR)

	@cd $(CHROMIUM_DIR)/src && \
	QUILT_PATCHES=$(PTXDIST_TOPDIR)/patches/$(CHROMIUM) quilt push -a || true

	@$(call touch)


$(STATEDIR)/chromium.extract.post:
	@$(call targetinfo)

	@$(call touch)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

$(STATEDIR)/chromium.prepare:
	@$(call targetinfo)

# EGL Backend
ifeq ($(PTXCONF_CHROMIUM_OZONE_EGL),y)
	@if [ ! -d $(CHROMIUM_DIR)/src/ozone-egl ]; then cd $(CHROMIUM_DIR)/src && git clone --depth 1 https://github.com/nischu7/ozone-egl; fi
endif

	@cd $(CHROMIUM_DIR)/src && \
	$(CHROMIUM_ENV) $(HOST_DEPOT_TOOLS_DIR)/gn gen $(CHROMIUM_OUTDIR) --args="$(CHROMIUM_DEFINES)"

	@$(call touch)


# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

$(STATEDIR)/chromium.compile:
	@$(call targetinfo)

	@cd $(CHROMIUM_DIR)/src && \
		$(HOST_DEPOT_TOOLS_DIR)/ninja -v -C $(CHROMIUM_OUTDIR) $(CHROMIUM_TARGETS-y)

	@$(call touch)


# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/chromium.install:
	@$(call targetinfo)
	@$(call touch)


# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/chromium.targetinstall:
	@$(call targetinfo)

	@$(call install_init, chromium)
	@$(call install_fixup, chromium,PRIORITY,optional)
	@$(call install_fixup, chromium,SECTION,base)
	@$(call install_fixup, chromium,AUTHOR,"Niklas Schulze <me@jns.io>")
	@$(call install_fixup, chromium,DESCRIPTION,missing)

	@$(call install_copy, chromium, 0, 0, 0755, /usr/lib/chromium)

ifeq ($(PTXCONF_CHROMIUM_BROWSER),y)
	@$(call install_copy, chromium, 0, 0, 0755, $(CHROMIUM_OUTDIR)/chrome, /usr/lib/chromium/chrome)	
endif

ifeq ($(PTXCONF_CHROMIUM_APPSHELL),y)
	@$(call install_copy, chromium, 0, 0, 0755, $(CHROMIUM_OUTDIR)/app_shell, /usr/lib/chromium/app_shell)
endif

ifeq ($(PTXCONF_CHROMIUM_CONTENTSHELL),y)
	@$(call install_copy, chromium, 0, 0, 0755, $(CHROMIUM_OUTDIR)/content_shell, /usr/lib/chromium/content_shell)
endif

	@$(call install_copy, chromium, 0, 0, 0644, $(CHROMIUM_OUTDIR)/icudtl.dat, /usr/lib/chromium/icudtl.dat)

# Sandbox
	@$(call install_copy, chromium, 0, 0, 4755, $(CHROMIUM_OUTDIR)/chrome_sandbox, /usr/lib/chromium/sandbox)
	@$(call install_link, chromium, sandbox, /usr/lib/chromium/chrome-sandbox)

# V8 Blobs
	@$(call install_copy, chromium, 0, 0, 0644, $(CHROMIUM_OUTDIR)/snapshot_blob.bin, /usr/lib/chromium/snapshot_blob.bin)
	@$(call install_copy, chromium, 0, 0, 0644, $(CHROMIUM_OUTDIR)/natives_blob.bin, /usr/lib/chromium/natives_blob.bin)

# UI Resources
	@$(call install_copy, chromium, 0, 0, 0644, $(CHROMIUM_OUTDIR)/content_shell.pak, /usr/lib/chromium/content_shell.pak)
	@$(call install_copy, chromium, 0, 0, 0644, $(CHROMIUM_OUTDIR)/ui_test.pak, /usr/lib/chromium/ui_test.pak)

ifneq (,$(filter y,$(PTXCONF_CHROMIUM_BROWSER) $(PTXCONF_CHROMIUM_APPSHELL)))
	@$(call install_copy, chromium, 0, 0, 0644, $(CHROMIUM_OUTDIR)/extensions_shell_and_test.pak, /usr/lib/chromium/extensions_shell_and_test.pak)
endif

# Shared Libraries
ifeq ($(PTXCONF_CHROMIUM_SHARED),y)
	@cd $(CHROMIUM_OUTDIR)/lib && \
                for file in *.so*; do \
                        $(call install_copy, chromium, 0, 0, 0644, $(CHROMIUM_OUTDIR)/lib/$$file,\
                                /usr/lib/chromium/lib/$$file); \
                done
endif

	@$(call install_finish, chromium)
	@$(call touch)

# vim: syntax=make
