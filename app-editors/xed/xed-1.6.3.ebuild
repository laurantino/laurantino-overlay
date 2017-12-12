# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_EAUTORECONF="yes"
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python{3_4,3_5} )

inherit gnome2 python-single-r1 xdg-utils

DESCRIPTION="X-Apps [Text] Editor"
HOMEPAGE="https://github.com/linuxmint/xed"
SRC_URI="https://github.com/linuxmint/${PN}/archive/${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+introspection spell"

COMMOND_DEPEND="
	${PYTHON_DEPS}
	>=dev-python/pygobject-3:3[${PYTHON_USEDEP}]
	>=dev-libs/libpeas-1.12.0[python,${PYTHON_USEDEP}]
	>=dev-libs/libxml2-2.5:2
	>=dev-libs/glib-2.40:2[dbus]
	>=x11-libs/gtk+-3.18:3
	>=x11-libs/gtksourceview-3.18:3
	>=dev-libs/libpeas-1.12.0[gtk]
	gnome-base/gsettings-desktop-schemas
	gnome-base/gvfs
	x11-libs/libX11
	x11-libs/libSM
	introspection ? ( dev-libs/gobject-introspection-0.9.3:= )
	spell? (
		>=app-text/enchant-1.2.0
		>=app-text/iso-codes-0.35
	)
"

RDEPEND="${COMMON_DEPEND}"

DEPEND="${COMMON_DEPEND}
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
	DOCS="AUTHORS README"

	gnome2_src_configure \
		--disable-deprecations \
		--enable-gvfs-metadata \
		$(use_enable introspection) \
		$(use_enable spell)
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
