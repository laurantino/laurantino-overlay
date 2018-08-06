# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
GNOME2_EAUTORECONF="yes"
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python2_7 )

inherit gnome2 python-single-r1

DESCRIPTION="Python binding for Nemo components"
HOMEPAGE="https://github.com/linuxmint/nemo-extensions"
SRC_URI="https://github.com/linuxmint/nemo-extensions/archive/${PV}.tar.gz -> nemo-extensions-${PV}.tar.gz"
S="${WORKDIR}/nemo-extensions-${PV}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	>=gnome-extra/nemo-${PV}[introspection]
	>=dev-util/gtk-doc-am-1.9
	virtual/pkgconfig
"

src_prepare() {
	gnome2_src_prepare
}
