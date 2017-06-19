EAPI=6

DESCRIPTION="GitBook Editor - Simple writing from your desktop."
HOMEPAGE="https://www.gitbook.com/editor"
SRC_URI="
	x86? (http://downloads.editor.gitbook.com/download/linux-32-bit)
	amd64? (http://downloads.editor.gitbook.com/download/linux-64-bit)
"
LICENSE="GitBook"
SLOT="0"
KEYWORDS="~x86 ~amd64"

DEPEND="
	app-text/calibre
"

RDEPEND="${DEPEND}"


