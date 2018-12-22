# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python3_{5,6} )

inherit gnome2 meson python-single-r1 xdg-utils

DESCRIPTION="X-Apps [Text] Editor"
HOMEPAGE="https://github.com/linuxmint/xed"
SRC_URI="https://github.com/linuxmint/${PN}/archive/${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="spell"

RDEPEND="
	${PYTHON_DEPS}
	>=dev-libs/libxml2-2.5.0:2
	>=dev-libs/glib-2.44:2[dbus]
	>=dev-libs/gobject-introspection-0.9.3:=
	>=x11-libs/gtk+-3.21.3:3[introspection]
	>=x11-libs/gtksourceview-3.22.0:3.0[introspection]
	>=dev-libs/libpeas-1.14.1[gtk,python,${PYTHON_USEDEP}]
	>=dev-python/pygobject-3:3[cairo,${PYTHON_USEDEP}]

	gnome-base/gsettings-desktop-schemas
	gnome-base/gvfs

	x11-libs/libX11

	spell? ( >=app-text/gspell-0.2.5:0= )
"

DEPEND="${RDEPEND}
	gnome-base/gnome-common
	app-text/docbook-xml-dtd:4.1.2
	app-text/yelp-tools
	dev-libs/libxml2:2
	>=dev-util/gtk-doc-am-1
	>=dev-util/intltool-0.50.1
	dev-util/itstool
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		-Ddeprecated_warnings=false
		-Ddocs=false
		-Denable_spell=$(usex spell true false)
		-Denable_gvfs_metadata=true
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
	elog "optional dependencies: gnome-extra/yelp (view help contents)"
}

pkg_postrm() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
}
