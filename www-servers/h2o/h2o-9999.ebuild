# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

DESCRIPTION="H2O - the optimized HTTP/1, HTTP/2 server"
HOMEPAGE="https://h2o.examp1e.net"
if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://github.com/h2o/h2o.git"
	inherit git-r3
else
	SRC_URI="https://github.com/h2o/h2o/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="mruby wslay"

DEPEND="dev-lang/ruby
	mruby? ( dev-ruby/mruby )
	wslay? ( net-libs/wslay )
	dev-libs/openssl
	sys-devel/bison"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DWITH_MRUBY=$(usex mruby)
	)
	cmake-utils_src_configure
}
