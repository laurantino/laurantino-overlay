# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_6,3_7,3_8} )

VALA_USE_DEPEND="vapigen"

inherit gnome2-utils meson python-r1 vala xdg-utils

DESCRIPTION="Cross-desktop libraries and common resources"
HOMEPAGE="https://github.com/linuxmint/xapps/"
LICENSE="GPL-3"

SRC_URI="https://github.com/linuxmint/xapps/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

SLOT="0"
IUSE="gtk-doc +introspection static-libs"

RDEPEND="
	>=dev-libs/glib-2.37.3:2
	dev-libs/gobject-introspection:0=
	dev-libs/libdbusmenu[gtk3]
	gnome-base/libgnomekbd
	x11-libs/cairo
	>=x11-libs/gdk-pixbuf-2.22.0:2[introspection?]
	>=x11-libs/gtk+-3.3.16:3[introspection?]
	x11-libs/libX11
	x11-libs/libxkbfile
"

DEPEND="${RDEPEND}"

BDEPEND="
	${PYTHON_DEPS}
	dev-util/gdbus-codegen
	sys-devel/gettext
	gtk-doc? ( dev-util/gtk-doc )
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
		-Dpy-overrides-dir="/pygobject"
	)
	meson_src_configure
}

src_install() {
	default
	meson_src_install
	rm -rf "${ED%/}"/usr/bin || die

	# copy pygobject files to each active python target
	# work-around for "py-overrides-dir" only supporting a single target
	install_pygobject_override() {
		PYTHON_GI_OVERRIDESDIR=$("${PYTHON}" -c 'import gi;print(gi._overridesdir)') || die
		einfo "gobject overrides directory: $PYTHON_GI_OVERRIDESDIR"
		mkdir -p "${ED}/$PYTHON_GI_OVERRIDESDIR/"
		cp -r "${D}"/pygobject/* "${ED}/$PYTHON_GI_OVERRIDESDIR/" || die
		python_optimize
	}
	python_foreach_impl install_pygobject_override
	rm -rf "${D}/pygobject" || die
}

pkg_postinst() {
	gnome2_schemas_update
	xdg_icon_cache_update
}

pkg_postrm() {
	gnome2_schemas_update
	xdg_icon_cache_update
}
