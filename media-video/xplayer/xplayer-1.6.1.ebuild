# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_EAUTORECONF="yes"
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads"

inherit gnome2 python-single-r1

DESCRIPTION="X-Apps media player"
HOMEPAGE="https://github.com/linuxmint/xplayer"
SRC_URI="https://github.com/linuxmint/${PN}/archive/${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+introspection lirc python zeitgeist"
REQUIRED_USE="
	python? ( introspection ${PYTHON_REQUIRED_USE} )
	zeitgeist? ( introspection )
"

RDEPEND="
	>=dev-libs/glib-2.35:2[dbus]
	>=dev-libs/libpeas-1.1.0[gtk]
	>=dev-libs/libxml2-2.6:2
	>=dev-libs/xplayer-plparser-1.0.0:0=[introspection?]
	>=media-libs/clutter-1.17.3:1.0[gtk]
	>=media-libs/clutter-gst-2.99.2:3.0
	>=media-libs/clutter-gtk-1.5.5:1.0
	>=x11-libs/cairo-1.14
	>=x11-libs/gdk-pixbuf-2.23.0:2
	>=x11-libs/gtk+-3.16:3[introspection?]
	>=x11-libs/xapps-1.0.0[introspection?]
	>=media-libs/gstreamer-1.3.1:1.0
	>=media-libs/gst-plugins-base-1.4.2:1.0[X,introspection?,pango]
	media-libs/gst-plugins-good:1.0
	media-plugins/gst-plugins-meta:1.0
	media-plugins/gst-plugins-taglib:1.0
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	>=x11-libs/libXxf86vm-1.0.1
	gnome-base/gsettings-desktop-schemas
	introspection? ( >=dev-libs/gobject-introspection-0.6.7:= )
	lirc? ( app-misc/lirc )
	python? (
		${PYTHON_DEPS}
		>=dev-libs/libpeas-1.1.0[${PYTHON_USEDEP}]
		>=dev-python/pygobject-2.90.3:3[${PYTHON_USEDEP}]
		dev-python/pyxdg[${PYTHON_USEDEP}]
		dev-python/dbus-python[${PYTHON_USEDEP}]
		>=x11-libs/gtk+-3.5.2:3[introspection]
	)
	zeitgeist? ( >=gnome-extra/zeitgeist-0.9.12 )
"

DEPEND="${RDEPEND}
	>=dev-lang/vala-0.14.1
	app-text/docbook-xml-dtd:4.5
	app-text/yelp-tools
	dev-libs/appstream-glib
	>=dev-util/gtk-doc-am-1.14
	>=dev-util/intltool-0.50.1
	sys-devel/gettext
	virtual/pkgconfig
	x11-proto/xextproto
	x11-proto/xproto

	dev-libs/gobject-introspection-common
	gnome-base/gnome-common
"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	gnome2_src_prepare

	# FIXME: upstream should provide a way to set GST_INSPECT, bug #358755 & co.
	# gst-inspect causes sandbox violations when a plugin needs write access to
	# /dev/dri/card* in its init phase.
	sed -e "s|\(gst10_inspect=\).*|\1$(type -P true)|" -i configure || die
}

src_configure() {
	DOCS="AUTHORS README"

	# Disabled: sample-python, sample-vala
	local plugins="apple-trailers,autoload-subtitles,brasero-disc-recorder"
	plugins+=",chapters,im-status,gromit,media-player-keys,ontop"
	plugins+=",properties,recent,rotation,screensaver,screenshot"
	plugins+=",sidebar-test,skipto"
	use lirc && plugins+=",lirc"
	use python && plugins+=",dbusservice,pythonconsole,opensubtitles"
	use zeitgeist && plugins+=",zeitgeist-dp"

	#--with-smclient=auto needed to correctly link to libICE and libSM
	# XXX: always set to true otherwise tests fails due to pylint not
	# respecting EPYTHON (wait for python-r1)
	# pylint is checked unconditionally, but is only used for make check
	gnome2_src_configure \
		--disable-run-in-source-tree \
		--disable-static \
		--with-smclient=auto \
		--enable-easy-codec-installation \
		--enable-vala \
		$(use_enable introspection) \
		$(use_enable python) \
		PYLINT=$(type -P true) \
		VALAC=$(type -P true)
}
