# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-utils udev #autotools

DESCRIPTION="stm32 discovery line linux programmer"
HOMEPAGE="https://github.com/texane/stlink"

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="git://github.com/texane/stlink.git"
	inherit git-r3
else
	SRC_URI="https://github.com/texane/stlink/archive/${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

#LICENSE=""
SLOT="0"
IUSE="gtk"

DEPEND="
	virtual/libusb:1
	virtual/pkgconfig
	gtk? (
		x11-libs/gtk+:3
		>dev-libs/glib-2.32
	)
"

RDEPEND="${DEPEND}"

AUTOTOOLS_AUTORECONF=1

DOCS=( README doc/tutorial/tutorial.pdf doc/tutorial/tutorial.tex )

#src_prepare() {
#	eautoreconf || die
#}

src_configure() {
#	econf $(use_with gtk)
	local myeconfargs=(
		$(use_with gtk)
	)
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile
}

src_install() {
	udev_dorules 49-stlinkv1.rules
	udev_dorules 49-stlinkv2-1.rules
	udev_dorules 49-stlinkv2.rules
	autotools-utils_src_install
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
