# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8,9} )

inherit gnome2-utils meson python-single-r1 xdg

DESCRIPTION="X-Apps [Text] Editor"
HOMEPAGE="https://github.com/linuxmint/xed"
SRC_URI="https://github.com/linuxmint/${PN}/archive/${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+introspection +python gtk-doc spell"
REQUIRED_USE="python? ( introspection ${PYTHON_REQUIRED_USE} ) spell? ( python )"

DEPEND="
	>=dev-libs/glib-2.40:2
	>=x11-libs/gtk+-3.19.3:3[introspection?]
	>=x11-libs/gtksourceview-4.0.3:4[introspection?]
	>=dev-libs/libpeas-1.12.0[gtk]
	>=dev-libs/libxml2-2.5.0:2
	x11-libs/libX11
	>=x11-libs/xapps-1.9.0[introspection?]

	spell? ( >=app-text/gspell-0.2.5:0= )
	introspection? ( >=dev-libs/gobject-introspection-1.42.0:= )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/pycairo[${PYTHON_USEDEP}]
			>=dev-python/pygobject-3:3[cairo,${PYTHON_USEDEP}]
			dev-libs/libpeas[python,${PYTHON_SINGLE_USEDEP}]
		')
	)
"

RDEPEND="${DEPEND}
	x11-themes/adwaita-icon-theme
	gnome-base/gsettings-desktop-schemas
	gnome-base/gvfs
"
BDEPEND="
	app-text/docbook-xml-dtd:4.1.2
	app-text/yelp-tools
	gtk-doc? ( >=dev-util/gtk-doc-1 )
	>=dev-util/intltool-0.50.1
	dev-util/itstool
	>=sys-devel/gettext-0.18
	virtual/pkgconfig
"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	local emesonargs=(
		-Ddeprecated_warnings=false
		-Denable_gvfs_metadata=true
		$(meson_use gtk-doc docs)
		$(meson_use spell enable_spell)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	if use python; then
		python_optimize
		python_optimize "${ED}/usr/$(get_libdir)/xed/plugins/"
	fi
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
	elog "optional dependencies: gnome-extra/yelp (view help contents)"
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
