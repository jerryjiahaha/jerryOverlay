# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit vim-plugin
SRC_URI=""

inherit git-r3
EGIT_REPO_URI="https://github.com/aklt/plantuml-syntax.git"

#VIM_PLUGIN_VIM_VERSION="7.0"

DESCRIPTION="vim plugin: PlantUML, a vim syntax file for PlantUML"
HOMEPAGE="https://github.com/aklt/plantuml-syntax"
LICENSE="MIT"
KEYWORDS="~amd64"

SLOT="0"

src_prepare() {
	rm -f *.md
	rm -rf test
}


VIM_PLUGIN_HELPFILES=""
VIM_PLUGIN_HELPTEXT=""
VIM_PLUGIN_HELPURI=""
VIM_PLUGIN_MESSAGES=""

