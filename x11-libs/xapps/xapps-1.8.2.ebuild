# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_6,3_7,3_8} )

inherit meson python-single-r1 vala xdg-utils

DESCRIPTION="Cross-desktop libraries and common resources"
HOMEPAGE="https://github.com/linuxmint/xapps/"
LICENSE="GPL-3"

SRC_URI="https://github.com/linuxmint/xapps/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

SLOT="0"
IUSE="gtk-doc +introspection static-libs"

DEPEND="
	${PYTHON_DEPS}
	>=dev-libs/glib-2.37.3:2
	dev-libs/gobject-introspection:0=[${PYTHON_SINGLE_USEDEP}]
	dev-libs/libdbusmenu[gtk3]
	gnome-base/libgnomekbd
	x11-libs/cairo
	>=x11-libs/gdk-pixbuf-2.22.0:2[introspection?]
	>=x11-libs/gtk+-3.3.16:3[introspection?]
	x11-libs/libX11
	x11-libs/libxkbfile
"
RDEPEND="${DEPEND}"

BDEPEND="
	sys-devel/gettext
	gtk-doc? ( dev-util/gtk-doc	)
	$(vala_depend)
"

src_prepare() {
	xdg_environment_reset
	vala_src_prepare
	default
}

src_configure() {
	local emesonargs=(
		$(meson_use gtk-doc docs)
	)
	meson_src_configure
}

src_install() {
	default
	meson_src_install
	python_optimize

	rm -rf "${ED%/}"/usr/bin || die
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
