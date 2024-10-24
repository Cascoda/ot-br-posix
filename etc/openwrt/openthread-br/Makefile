#
#  Copyright (c) 2020, The OpenThread Authors.
#  All rights reserved.
#
#  Redistribution and use in source and binary forms, with or without
#  modification, are permitted provided that the following conditions are met:
#  1. Redistributions of source code must retain the above copyright
#     notice, this list of conditions and the following disclaimer.
#  2. Redistributions in binary form must reproduce the above copyright
#     notice, this list of conditions and the following disclaimer in the
#     documentation and/or other materials provided with the distribution.
#  3. Neither the name of the copyright holder nor the
#     names of its contributors may be used to endorse or promote products
#     derived from this software without specific prior written permission.
#
#  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
#  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
#  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
#  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
#  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
#  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
#  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
#  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
#  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
#  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
#  POSSIBILITY OF SUCH DAMAGE.
#

LOCAL_SOURCE_DIR:=$(abspath $(realpath $(dir $(lastword $(MAKEFILE_LIST))))/../../..)

include $(TOPDIR)/rules.mk

PKG_NAME:=openthread-br
PKG_LICENSE:=BSD-3-Clause
PKG_LICENSE_FILES:=LICENSE
PKG_RELEASE:=1
PKG_VERSION:=1.0

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

CMAKE_SOURCE_DIR=$(LOCAL_SOURCE_DIR)
CMAKE_OPTIONS+= \
	-DBUILD_TESTING=OFF \
	-DCMAKE_INSTALL_PREFIX=/usr \
	-DCMAKE_BUILD_TYPE=Release \
	-DOTBR_OPENWRT=ON \
	-DOTBR_BORDER_AGENT=ON \
	-DOTBR_BORDER_ROUTING=ON \
	-DOTBR_MDNS=avahi \
	-DOTBR_SRP_ADVERTISING_PROXY=ON \
	-DOTBR_WEB=OFF \
	-DOTBR_INFRA_IF_NAME=br-lan \
	-DOTBR_VENDOR_NAME=Cascoda \
	-DOTBR_UNSECURE_JOIN=ON \
	-DOT_READLINE=OFF \
	-DOT_LINK_METRICS_INITIATOR=OFF \
	-DOT_LINK_METRICS_SUBJECT=OFF \
	-DOT_FIREWALL=OFF \
	-DOT_LOG_LEVEL=DEBG \
	-DOT_LOG_LEVEL_DYNAMIC=ON \
	-DOT_SRP_SERVER=ON \
	-DOT_SERVICE=ON \
	-DCASCODA_OPENTHREAD_MESSAGE_BUFS=8000
	

define Package/openthread-br
	SECTION:=base
	CATEGORY:=Network
	TITLE:=OpenThread Border Router
	DEPENDS:=+libstdcpp +libjson-c +libubus +libblobmsg-json +libavahi-client +hidapi +kmod-tun +smcroute
endef

define Package/openthread-br/description
    A Thread border router for POSIX-based platforms.
endef

define Package/openthread-br/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/otbr-agent $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/pskc $(1)/usr/sbin
	
	$(CP) $(PKG_BUILD_DIR)/_deps/cascoda-sdk-build/bin/ot-ctl $(1)/usr/sbin

	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/etc/init.d/otbr-agent $(1)/etc/init.d
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/etc/init.d/smcroute $(1)/etc/init.d
	$(INSTALL_CONF) $(PKG_INSTALL_DIR)/etc/smcroute.conf $(1)/etc

	$(INSTALL_DIR) $(1)/etc/crontabs
	$(INSTALL_CONF) $(PKG_INSTALL_DIR)/etc/crontabs/root $(1)/etc/crontabs

	$(INSTALL_DIR) $(1)/lib
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/br-config.sh $(1)/lib
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/br-omr-enable.sh $(1)/lib
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/br-smcroute-prefix.sh $(1)/lib
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/install-multicast-commands.sh $(1)/lib
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/add-route.py $(1)/lib
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/remove-routes.py $(1)/lib
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/view-routes.py $(1)/lib
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/make_switch.sh $(1)/lib
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/make_router.sh $(1)/lib


	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller/admin
	$(INSTALL_BIN) $(LOCAL_SOURCE_DIR)/src/openwrt/controller/thread.lua $(1)/usr/lib/lua/luci/controller/admin

	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view
	$(CP) $(LOCAL_SOURCE_DIR)/src/openwrt/view/admin_thread $(1)/usr/lib/lua/luci/view

	$(INSTALL_DIR) $(1)/www/luci-static/resources
	$(CP) $(LOCAL_SOURCE_DIR)/src/openwrt/handle_error.js $(1)/www/luci-static/resources
	$(CP) $(LOCAL_SOURCE_DIR)/src/openwrt/d3.v4.min.js $(1)/www/luci-static/resources
	$(CP) $(LOCAL_SOURCE_DIR)/src/openwrt/html5-qrcode.min.js $(1)/www/luci-static/resources

	$(INSTALL_DIR) $(1)/usr/share/rpcd/acl.d
	$(INSTALL_DATA) $(LOCAL_SOURCE_DIR)/src/openwrt/luci-app-otbr.json $(1)/usr/share/rpcd/acl.d
endef

$(eval $(call BuildPackage,openthread-br))
