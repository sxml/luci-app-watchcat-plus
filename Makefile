#
# Copyright (C) 2008-2014 The LuCI Team <luci@lists.subsignal.org>
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-watchcat-plus
PKG_VERSION:=1.0
PKG_RELEASE:=202303010

PKG_MAINTAINER:=gngpp <gngppz@gmail.com>


LUCI_TITLE:=LuCI Support for Watchcat
LUCI_DEPENDS:=+watchcat

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
