# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
GNOME2_EAUTORECONF="yes"
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python{3_5,3_6} )

inherit gnome2 python-single-r1

DESCRIPTION="X-Apps image viewer plugins"
HOMEPAGE="https://github.com/linuxmint/xviewer-plugins"
SRC_URI="https://github.com/linuxmint/${PN}/archive/${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="+exif map +python"
REQUIRED_USE="
	map? ( exif )
	python? ( ${PYTHON_REQUIRED_USE} )
"

RDEPEND="
	>=dev-libs/glib-2.38:2
	>=dev-libs/libpeas-0.7.4:=
	>=media-gfx/xviewer-1.2.0:0
	>=x11-libs/gtk+-3.14:3
	exif? ( >=media-libs/libexif-0.6.16 )
	map? (
		media-libs/libchamplain:0.12[gtk]
		>=media-libs/clutter-1.9.4:1.0
		>=media-libs/clutter-gtk-1.1.2:1.0 )
	python? (
		${PYTHON_DEPS}
		>=dev-libs/glib-2.32:2[dbus]
		dev-libs/libpeas:=[gtk,python,${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		gnome-base/gsettings-desktop-schemas
		media-gfx/xviewer[introspection]
		x11-libs/gtk+:3[introspection] )
"
DEPEND="${RDEPEND}
	gnome-base/gnome-common
	>=dev-util/intltool-0.50.1
	sys-devel/gettext
	virtual/pkgconfig
"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	local plugins="fit-to-width,send-by-mail,light-theme"
	use exif && plugins="${plugins},exif-display"
	use map && plugins="${plugins},map"
	use python && plugins="${plugins},slideshowshuffle,pythonconsole,export-to-folder"
	gnome2_src_configure \
		$(use_enable python) \
		--with-plugins=${plugins}
}
