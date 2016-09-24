# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-utils

DESCRIPTION="The WebSocket library in C"
HOMEPAGE="https://tatsuhiro-t.github.io/wslay/"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://github.com/tatsuhiro-t/wslay.git"
	inherit git-r3
else
	SRC_URI="https://github.com/tatsuhiro-t/wslay/archive/release-${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-release-${PV}"
fi


LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test examples static-libs"

RDEPEND=">=dev-util/cmake-2.8
	examples? ( >=dev-libs/nettle-2.4 )"
DEPEND="${RDEPEND}
	test? ( >=dev-util/cunit-2.1 )"


AUTOTOOLS_AUTORECONF=1

DOCS=( AUTHORS ChangeLog COPYING NEWS README README.rst )

src_configure() {
	cp -fa "${S}"/doc/sphinx/conf.py.in "${S}"/doc/sphinx/conf.py
	local myconfargs=(
		$(use_enable static-libs enable-static)
	)

	autotools-utils_src_configure
}
