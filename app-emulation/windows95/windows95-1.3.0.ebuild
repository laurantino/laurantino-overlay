# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils rpm xdg-utils

DESCRIPTION="Windows 95 in Electron"
HOMEPAGE="https://github.com/felixrieseberg/windows95"
SRC_URI="https://github.com/felixrieseberg/${PN}/releases/download/v${PV}/${PN}-linux-${PV}.x86_64.rpm"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=""
DEPEND=""

RESTRICT="strip"

S="${WORKDIR}"

src_install() {
	insinto /usr
	doins -r usr/*

	exeinto usr/share/windows95
	doexe usr/share/windows95/windows95

	domenu usr/share/applications/windows95.desktop
	doicon usr/share/pixmaps/windows95.png
}

pkg_postinst() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
}
