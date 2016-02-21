# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils multilib python-single-r1 cmake-utils vim-plugin flag-o-matic

if [[ ${PV} == 9999* ]] ; then
	EGIT_REPO_URI="git://github.com/Valloric/YouCompleteMe.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://dev.gentoo.org/~radhermit/vim/${P}.tar.xz"
fi

DESCRIPTION="vim plugin: a code-completion engine for Vim"
HOMEPAGE="http://valloric.github.io/YouCompleteMe/"

LICENSE="GPL-3"
IUSE="+clang go javascript test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

COMMON_DEPEND="
	${PYTHON_DEPS}
	clang? ( >=sys-devel/clang-3.3 )
	dev-libs/boost[python,threads,${PYTHON_USEDEP}]
	|| (
		app-editors/vim[python,${PYTHON_USEDEP}]
		app-editors/gvim[python,${PYTHON_USEDEP}]
	)
"
RDEPEND="
	${COMMON_DEPEND}
	dev-python/bottle[${PYTHON_USEDEP}]
	virtual/python-futures[${PYTHON_USEDEP}]
	dev-python/jedi[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/waitress[${PYTHON_USEDEP}]
"
DEPEND="
	${COMMON_DEPEND}
	go? (
		dev-lang/go
	)
	javascript? (
		net-libs/nodejs[npm]
	)
	test? (
		>=dev-python/mock-1.0.1[${PYTHON_USEDEP}]
		>=dev-python/nose-1.3.0[${PYTHON_USEDEP}]
		dev-cpp/gmock
		dev-cpp/gtest
	)
"

CMAKE_IN_SOURCE_BUILD=1
CMAKE_USE_DIR=${S}/third_party/ycmd/cpp

VIM_PLUGIN_HELPFILES="${PN}"

src_prepare() {
	if ! use test ; then
		sed -i '/^add_subdirectory( tests )/d' third_party/ycmd/cpp/ycm/CMakeLists.txt || die
	fi
	for third_party_module in pythonfutures; do
		rm -r "${S}"/third_party/${third_party_module} || die "Failed to remove third party module ${third_party_module}"
	done
	# Argparse is included in python 2.7
	for third_party_module in argparse bottle waitress requests; do
		rm -r "${S}"/third_party/ycmd/third_party/${third_party_module} || die "Failed to remove third party module ${third_party_module}"
	done
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_use clang CLANG_COMPLETER)
		$(cmake-utils_use_use clang SYSTEM_LIBCLANG)
		-DUSE_SYSTEM_BOOST=ON
		-DUSE_SYSTEM_GMOCK=ON
	)
	## TODO use clang
	## use clang && mycmakeargs+=( -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_C_COMPILER=clang ) 

	replace-flags -O2 -O3
	## TODO test CC support c++11

	cmake-utils_src_configure
}

src_compile() {

	cmake-utils_src_compile ycm_support_libs

	if use "javascript" ; then
		cd "${S}"/third_party/ycmd/third_party/tern_runtime || die
		npm install --production || die
	else
		rm -rf "${S}"/third_party/ycmd/third_party/tern_runtime || die
	fi

	if use "go" ; then
		cd "${S}"/third_party/ycmd/third_party/gocode && go build || die
		cd "${S}"/third_party/ycmd/third_party/godef && go build || die
	else
		rm -rf "${S}"/third_party/ycmd/third_party/gocode || die
		rm -rf "${S}"/third_party/ycmd/third_party/godef || die
	fi

	## TODO add typescript use && support
	## TODO add rust support && support
}

src_test() {
	cd "${S}/third_party/ycmd/cpp/ycm/tests" || die
	LD_LIBRARY_PATH="${EROOT}"/usr/$(get_libdir)/llvm \
		./ycm_core_tests || die

	cd "${S}"/python/ycm || die

	local dirs=( "${S}"/third_party/*/ "${S}"/third_party/ycmd/third_party/*/ )
	local -x PYTHONPATH=${PYTHONPATH}:$(IFS=:; echo "${dirs[*]}")

	nosetests --verbose || die
}

src_install() {

	rm -rf third_party/ycmd/ci

	dodoc *.md third_party/ycmd/*.md || true
	rm -r *.md *.sh COPYING.txt third_party/ycmd/cpp || die
	rm -r third_party/ycmd/{*.md,*.sh} || die

	! use test && find python -name *test* -exec rm -rf {} + || die
	! use test && rm -rf third_party/ycmd/clang_includes
	egit_clean
	rm third_party/ycmd/libclang.so* || die

	find ./ -name *.pyc -exec rm -rf {} + || die
	find ./ -name *.pyo -exec rm -rf {} + || die

	vim-plugin_src_install

	python_optimize "${ED}"
	python_fix_shebang "${ED}"
}

pkg_postinst() {
	vim-plugin_pkg_postinst

	optfeature "install typescript with npm for Typescript autocompletion"
}
