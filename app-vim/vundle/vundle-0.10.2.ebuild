# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit vim-plugin
SRC_URI=""

#DISTDIR="Vundle.vim"
#SRC_URI="https://github.com/VundleVim/${DISTDIR}/archive/v${PV}.tar.gz"
inherit git-r3
EGIT_REPO_URI="https://github.com/VundleVim/Vundle.vim.git"
EGIT_COMMIT="v${PV}"

#VIM_PLUGIN_VIM_VERSION="7.0"

DESCRIPTION="vim plugin: Vundle, the plug-in manager for Vim"
HOMEPAGE="https://github.com/VundleVim/Vundle.vim"
LICENSE="MIT"
KEYWORDS="~amd64"

SLOT="0"

src_prepare() {
	rm -f *.md
	rm -rf test
}


VIM_PLUGIN_HELPFILES="{PN}"
VIM_PLUGIN_HELPTEXT=""
VIM_PLUGIN_HELPURI=""
VIM_PLUGIN_MESSAGES=""

