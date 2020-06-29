# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit gnome2-utils meson xdg

DESCRIPTION="X-Apps document reader"
HOMEPAGE="https://github.com/linuxmint/xreader"
SRC_URI="https://github.com/linuxmint/${PN}/archive/${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="dbus comics djvu dvi epub gnome-keyring gtk-doc +introspection +postscript t1lib tiff xps"

REQUIRED_USE="t1lib? ( dvi )"

PATCHES=( "${FILESDIR}"/${PN}-{metadata,wayland}.patch )

RDEPEND="
	>=dev-libs/glib-2.36:2[dbus]
	>=dev-libs/libxml2-2.5:2
	sys-libs/zlib:=
	x11-libs/gdk-pixbuf:2
	>=x11-libs/libSM-1:0
	x11-libs/libX11:0
	>=x11-libs/cairo-1.14:=
	>=x11-libs/gtk+-3.14:3[introspection?]
	>=x11-libs/xapps-1.1.0
	>=app-text/poppler-0.22:=[cairo]
	djvu? ( >=app-text/djvu-3.5.17:= )
	dvi? (
		virtual/tex-base
		dev-libs/kpathsea:=
		t1lib? ( >=media-libs/t1lib-5:= )
	)
	epub? (
		>=dev-libs/mathjax-2:=
		>=net-libs/webkit-gtk-2.4.3:4
	)
	gnome-keyring? ( >=app-crypt/libsecret-0.5 )
	introspection? ( >=dev-libs/gobject-introspection-0.6:= )
	postscript? ( >=app-text/libspectre-0.2:0 )
	tiff? ( >=media-libs/tiff-3.6:0= )
	xps? ( >=app-text/libgxps-0.2.1:= )
"

DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.1.2
	app-text/yelp-tools:0
	gtk-doc? ( >=dev-util/gtk-doc-1 )
	>=dev-util/intltool-0.50.1
	sys-devel/gettext
	virtual/pkgconfig"

src_configure() {
	local emesonargs=(
		-Ddeprecated_warnings=false
		-Dhelp_files=true
		-Dpixbuf=true
		-Dpdf=true
		-Dpreviewer=true
		-Dthumbnailer=true
		$(meson_use gnome-keyring keyring)
		$(meson_use gtk-doc docs)
		$(meson_use comics)
		$(meson_use dbus enable_dbus)
		$(meson_use djvu)
		$(meson_use dvi)
		$(meson_use epub)
		$(meson_use introspection)
		$(meson_use postscript ps)
		$(meson_use t1lib)
		$(meson_use tiff)
		$(meson_use xps)
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
	gnome2_schemas_update
}
