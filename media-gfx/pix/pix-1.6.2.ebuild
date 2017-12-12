# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_EAUTORECONF="yes"
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="X-Apps image management application"
HOMEPAGE="https://github.com/linuxmint/pix"
SRC_URI="https://github.com/linuxmint/${PN}/archive/${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cdr exif gnome-keyring gstreamer http jpeg json map raw slideshow svg tiff webkit webp"
REQUIRED_USE="map? ( exif )"

RDEPEND="
	>=dev-libs/glib-2.36.0:2[dbus]
	>=x11-libs/gtk+-3.10.0:3
	>=gnome-base/gsettings-desktop-schemas-0.1.4
	media-libs/libpng:0=
	sys-libs/zlib
	x11-libs/libICE
	x11-libs/libSM
	cdr? ( >=app-cdr/brasero-3.2 )
	exif? ( >=media-gfx/exiv2-0.21 )
	gnome-keyring? ( >=app-crypt/libsecret-0.11 )
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
	)
	http? ( >=net-libs/libsoup-2.42.0:2.4 )
	jpeg? ( virtual/jpeg:0= )
	json? ( >=dev-libs/json-glib-0.15.0 )
	map? ( >=media-libs/libchamplain-0.12[gtk] )
	raw? ( >=media-libs/libopenraw-0.0.8 )
	!raw? ( media-gfx/dcraw )
	slideshow? (
		>=media-libs/clutter-1.12.0:1.0
		>=media-libs/clutter-gtk-1:1.0
	)
	svg? ( >=gnome-base/librsvg-2.34:2 )
	tiff? ( media-libs/tiff:= )
	webkit? ( net-libs/webkit-gtk:4 )
	webp? ( >=media-libs/libwebp-0.2.0 )
"

DEPEND="${RDEPEND}
	gnome-base/gnome-common
	app-text/yelp-tools
	>=dev-util/gtk-doc-am-1
	>=dev-util/intltool-0.50.1
	dev-util/itstool
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
"

src_configure() {
	DOCS="AUTHORS README"

	gnome2_src_configure \
		--disable-static \
		$(use_enable cdr libbrasero) \
		$(use_enable exif exiv2) \
		$(use_enable gnome-keyring libsecret) \
		$(use_enable gstreamer) \
		$(use_enable http libsoup) \
		$(use_enable jpeg) \
		$(use_enable json libjson-glib) \
		$(use_enable map libchamplain) \
		$(use_enable raw libopenraw) \
		$(use_enable slideshow clutter) \
		$(use_enable svg librsvg) \
		$(use_enable tiff) \
		$(use_enable webkit webkit2) \
		$(use_enable webp libwebp)
}
