include $(TOPDIR)/rules.mk
PKG_NAME:=luci-app-weaknetwork
PKG_VERSION=1.0
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-weaknetwork
    SECTION:=luci
    CATEGORY:=LuCI
    SUBMENU:=3. Applications
    TITLE:=weaknetwork config for LuCI
    PKGARCH:=all
endef

define Package/luci-app-weaknetwork/description
    This package contains LuCI configuration pages for lcodecore weaknetwork.
endef

define Build/Prepare
endef

define Package/luci-app-weaknetwork/postinst
#!/bin/sh
rm -rf /tmp/luci*
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/luci-app-weaknetwork/install
    $(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
