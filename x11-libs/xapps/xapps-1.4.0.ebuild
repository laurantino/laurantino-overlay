# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{3_5,3_6} )

inherit meson gnome2-utils python-single-r1 xdg-utils

DESCRIPTION="Cross-desktop libraries and common resources"
HOMEPAGE="https://github.com/linuxmint/xapps/"
LICENSE="GPL-3"

SRC_URI="https://github.com/linuxmint/xapps/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

SLOT="0"
IUSE="doc +introspection"

RDEPEND="
	${PYTHON_DEPS}
	>=dev-libs/glib-2.37.3:2
	dev-libs/gobject-introspection:0=[${PYTHON_USEDEP}]
	gnome-base/libgnomekbd
	gnome-base/gnome-common
	x11-libs/cairo
	>=x11-libs/gdk-pixbuf-2.22.0:2[introspection?]
	>=x11-libs/gtk+-3.3.16:3[introspection?]
	x11-libs/libxkbfile
"
DEPEND="${RDEPEND}
	sys-devel/gettext
	doc? (
		dev-util/gtk-doc
		dev-util/gtk-doc-am
	)
"

src_configure() {
	local emesonargs=(
		-Ddocs=$(usex doc true false)
	)
	meson_src_configure
}

src_install() {
	default
	meson_src_install
	rm -rf "${ED%/}"/usr/bin || die

	# package provides .pc files
	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}