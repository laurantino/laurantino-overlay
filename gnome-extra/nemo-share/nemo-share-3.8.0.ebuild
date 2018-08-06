# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
GNOME2_EAUTORECONF="yes"
GNOME2_LA_PUNT="yes"

inherit eutils gnome2 user

DESCRIPTION="Nemo extension to share folder using Samba"
HOMEPAGE="https://github.com/linuxmint/nemo-extensions"
SRC_URI="https://github.com/linuxmint/nemo-extensions/archive/${PV}.tar.gz -> nemo-extensions-${PV}.tar.gz"
S="${WORKDIR}/nemo-extensions-${PV}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="net-fs/samba"
DEPEND=">=gnome-extra/nemo-${PV}[introspection]"

pkg_preinst() {
	enewgroup sambashare
}

src_install() {
	gnome2_src_install
	dodir /var/lib/samba/usershares
	fowners root:sambashare /var/lib/samba/usershares
	fperms 1770 /var/lib/samba/usershares
}

pkg_postinst() {
	elog "A sample smb.conf to use this extension:"
	elog ""
	elog "[global]"
	elog "workgroup = HOME"
	elog "usershare path = /var/lib/samba/usershares"
	elog "usershare max shares = 100"
	elog "usershare allow guests = yes"
	elog "usershare owner only = yes"
	elog ""
	elog "Add your user to the sambashare group to be able to share"
	elog ""
}
