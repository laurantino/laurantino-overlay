# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_EAUTORECONF="yes"

inherit gnome2

DESCRIPTION="X-Apps playlist parsing library"
HOMEPAGE="https://github.com/linuxmint/xplayer-plparser"
SRC_URI="https://github.com/linuxmint/${PN}/archive/${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="archive crypt +introspection +quvi"

RDEPEND="
	>=dev-libs/glib-2.31:2
	dev-libs/gmime:2.6
	>=net-libs/libsoup-2.43:2.4
	archive? ( >=app-arch/libarchive-3 )
	crypt? ( dev-libs/libgcrypt:0= )
	introspection? ( >=dev-libs/gobject-introspection-0.9.5:= )
	quvi? ( >=media-libs/libquvi-0.9.1:0= )
"

DEPEND="${COMMON_DEPEND}
	gnome-base/gnome-common
	introspection? ( dev-libs/gobject-introspection-common )
	>=dev-util/gtk-doc-am-1
	>=dev-util/intltool-0.50.1
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
"

src_configure() {
	DOCS="AUTHORS ChangeLog NEWS README"

	gnome2_src_configure \
		--disable-static \
		$(use_enable archive libarchive) \
		$(use_enable crypt libgcrypt) \
		$(use_enable quvi) \
		$(use_enable introspection)
}
