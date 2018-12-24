# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

#KREY: D - /var/tmp/portage/media-gfx/NoxMentor-0.1/image/
#KREY: P - NoxMentor-0.1
#KREY: V - 
#KREY: PV - 0.1 -> something/something-${PV}
#KREY: S - ${WORKDIR}/${P}

# Compile in workdir, install in imagedir

# E-build API
EAPI=6

inherit qmake-utils

# VARS
NAME="flameshot"
CATEGORY="media-gfx"

WORKDIR="/var/tmp/portage/${CATEGORY}/${NAME}-${PV}/work/"
REPO="https://github.com/lupoDharkael/flameshot/archive/"
DESCRIPTION="Powerful yet simple to use screenshot software."
BUILD="${S}/build/"

S="/var/tmp/portage/${CATEGORY}/${NAME}-${PV}/work/flameshot-${PV}"
D="/var/tmp/portage/${CATEGORY}/${NAME}-${PV}/image/"
P="${NAME}-${PV}"
#v = ???
#PV = VERSION

if [[ ${NAME}-${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="${REPO}"
	SRC_URI=""
	KEYWORDS=""

	else
		SRC_URI="${REPO}/v${PV}.tar.gz"
		KEYWORDS="~x86 ~amd64"
fi

HOMEPAGE="https://flameshot.js.org/"
LICENSE="FreeArt GPL-3+ Apache-2.0"
SLOT="0"

#S=$WORKDIR

DEPEND="
	>=dev-qt/qtcore-5.3
	>=sys-devel/gcc-4.9.2
	"

RDEPEND="
	>=dev-qt/qtcore-5.3"
	# SVG

# USE FLAGS
## SVG
## JPEG
## PNG
## git?
## dunno

src_configure () {
	cd ${S}
	mkdir ${BUILD}
	
}

src_compile() {
	cd ${BUILD}
	qmake CONFIG+=silent ${WORKDIR}/${NAME}-${PV} # To make output readable
	make

}

src_install () {
	cd ${BUILD}
	emake INSTALL_ROOT="${D}" install

}
