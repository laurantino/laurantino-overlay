# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
GNOME2_EAUTORECONF="yes"
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="X-Apps image viewer"
HOMEPAGE="https://github.com/linuxmint/xviewer"
SRC_URI="https://github.com/linuxmint/${PN}/archive/${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+exif +introspection +jpeg lcms +svg tiff xmp"

PATCHES=( "${FILESDIR}"/${PN}-metadata.patch )

RDEPEND="
	>=dev-libs/glib-2.38.0:2[dbus]
	>=x11-libs/gtk+-3.10.0:3[introspection?,X]
	>=dev-libs/libpeas-0.7.4:=[gtk]
	>=gnome-extra/cinnamon-desktop-3.2.0
	>=gnome-base/gsettings-desktop-schemas-2.91.92
	>=dev-libs/libxml2-2.0:2
	sys-libs/zlib
	>=x11-libs/gdk-pixbuf-2.4.0:2[jpeg?,tiff?]
	x11-libs/libX11
	exif? ( >=media-libs/libexif-0.6.14 )
	introspection? ( >=dev-libs/gobject-introspection-0.9.3:= )
	jpeg? ( virtual/jpeg:0 )
	lcms? ( media-libs/lcms:2 )
	svg? ( >=gnome-base/librsvg-2.36.2:2 )
	xmp? ( >=media-libs/exempi-1.99.5:2 )
"

DEPEND="${RDEPEND}
	gnome-base/gnome-common
	app-text/yelp-tools
	>=dev-util/gtk-doc-am-1.16
	>=dev-util/intltool-0.50.1
	dev-util/itstool
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	DOCS="AUTHORS ChangeLog NEWS README"

	gnome2_src_configure \
		$(use_enable introspection) \
		$(use_with jpeg libjpeg) \
		$(use_with exif libexif) \
		$(use_with xmp) \
		$(use_with svg librsvg)
}
