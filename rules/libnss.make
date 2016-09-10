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
PACKAGES-$(PTXCONF_LIBNSS) += libnss

#
# Paths and names
#
LIBNSS_VERSION	:= 3.26
LIBNSS_MD5	:= b71ab412cf07af436726679b204b0777
LIBNSS		:= libnss-$(LIBNSS_VERSION)
LIBNSS_SUFFIX	:= tar.gz
LIBNSS_URL	:= https://ftp.mozilla.org/pub/mozilla.org/security/nss/releases/NSS_$(subst .,_,$(LIBNSS_VERSION))_RTM/src/nss-$(LIBNSS_VERSION).tar.gz
LIBNSS_SOURCE	:= $(SRCDIR)/$(LIBNSS).$(LIBNSS_SUFFIX)
LIBNSS_DIR	:= $(BUILDDIR)/$(LIBNSS)
LIBNSS_LICENSE	:= MPL

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

LIBNSS_CROSS_ENV := $(CROSS_ENV)

#LIBNSS_CFLAGS := \
#	-I$(LIBNSS_DIR)/nss/lib/util \
#	-I$(LIBNSS_DIR)/nss/lib/freebl \
#	-I$(LIBNSS_DIR)/nss/lib/freebl/ecl \
##	-I$(LIBNSS_DIR)/nss/lib/dbm/include \
#	-I$(LIBNSS_DIR)/nss/lib/base \
#	-Wno-overflow -Wno-missing-braces

LIBNSS_CFLAGS := \
	-Wno-overflow -Wno-missing-braces

LIBNSS_BUILD_VARS = \
	SOURCE_MD_DIR=$(LIBNSS_DIR)/dist \
	DIST=$(LIBNSS_DIR)/dist \
	MOZILLA_CLIENT=1 \
	NSPR_INCLUDE_DIR=$(PTXDIST_SYSROOT_TARGET)/usr/include/nspr \
	NSPR_LIB_DIR=$(PTXDIST_SYSROOT_TARGET)/usr/lib \
	BUILD_OPT=1 \
	NS_USE_GCC=1 \
	NSS_USE_SYSTEM_SQLITE=1 \
	NSS_ENABLE_ECC=1 \
	NSS_BUILD_WITHOUT_SOFTOKEN=0 \
	NATIVE_CC="$(CC)" \
	TARGETCC="$(CROSS_CC) $(LIBNSS_CFLAGS)" \
	TARGETCCC="$(CROSS_CXX) $(LIBNSS_CFLAGS)" \
	TARGETRANLIB="$(CROSS_RANLIB)" \
	OS_ARCH="Linux" \
	OS_RELEASE="$(PTXCONF_KERNEL_VERSION)" \
	OS_TEST="$(PTXCONF_ARCH_STRING)" \
	TARGET_OPTIMIZER="" \
	NATIVE_FLAGS="" \
	CHECKLOC=""


ifdef PTXCONF_ARCH_ARM64
	LIBNSS_BUILD_VARS += USE_64=1
endif


define LIBNSS_PKGCONFIG
prefix=/usr
exec_prefix=$${prefix}
libdir=$${prefix}/lib
includedir=$${prefix}/include/nss

Name: NSS
Description: Mozilla Network Security Services
Version: $(LIBNSS_VERSION)
Requires: nspr
Libs: -L/usr/lib -lnss3 -lnssutil3 -lsmime3 -lssl3
Cflags: -I$${includedir}
endef

define newline


endef

$(STATEDIR)/libnss.prepare:
	@$(call targetinfo)
	@$(call touch)

$(STATEDIR)/libnss.compile:
	@$(call targetinfo)

	@cd $(LIBNSS_DIR)/nss && \
	$(LIBNSS_CROSS_ENV) $(MAKE) all $(LIBNSS_BUILD_VARS)
	@$(call touch)

$(STATEDIR)/libnss.install:
	@$(call targetinfo)

	@mkdir -p $(LIBNSS_PKGDIR)/usr/include/nss
	@mkdir -p $(LIBNSS_PKGDIR)/usr/lib/pkgconfig

	@cd $(LIBNSS_DIR)/dist && \
	install -v -m755 lib/*.so		$(LIBNSS_PKGDIR)/usr/lib && \
	install -v -m755 -d			$(LIBNSS_PKGDIR)/usr/include/nss && \
	cp -v -RL {public,private}/nss/*	$(LIBNSS_PKGDIR)/usr/include/nss && \
	chmod -v 644				$(LIBNSS_PKGDIR)/usr/include/nss/*

	@echo -e '$(subst $(newline),\n,${LIBNSS_PKGCONFIG})' > $(LIBNSS_PKGDIR)/usr/lib/pkgconfig/nss.pc

	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/libnss.targetinstall:
	@$(call targetinfo)

	@$(call install_init, libnss)
	@$(call install_fixup, libnss,PRIORITY,optional)
	@$(call install_fixup, libnss,SECTION,base)
	@$(call install_fixup, libnss,AUTHOR,"Niklas Schulze <me@jns.io>")
	@$(call install_fixup, libnss,DESCRIPTION,missing)

	#@$(call install_lib, libnss, 0, 0, 0644, libnss3)
	@$(call install_tree, libnss, 0, 0, -, /usr/lib)

	@$(call install_finish, libnss)

	@$(call touch)

# vim: ft=make noet
