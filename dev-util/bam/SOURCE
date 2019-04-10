# Copyright 2019 Jacob "Kreyren" Hrbek
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit eutils python-any-r1 toolchain-funcs

DESCRIPTION="Fast and flexible Lua-based build system"
HOMEPAGE="https://matricks.github.com/bam/"

## Get keywords, version, source and slot
# For live build
if [[ $PV == "9999" ]]; then
	EGIT_REPO_URI="git@github.com:matricks/bam.git"
	EGIT_BRANCH="master"
	MPV=${PV}
	SLOT="${MPV}"
	inherit git-r3
	unset SRC_URI
	unset KEYWORDS

	# For versioning that contains: alpha, beta, gamma
	elif [[ $PV =~ _(alpha|beta|gamma) ]]; then
		MPV=${PV/"_${BASH_REMATCH[1]}"/-"${BASH_REMATCH[1]}".}
	    SRC_URI="https://github.com/matricks/${PN}/archive/v${PV}.tar.gz"
	   	KEYWORDS="~amd64 ~x86"
			SLOT="${MPV}"

	# For versioning 0.0.0-00-abce1234
	elif [[ $PV =~ @([0-9].[0-9].[0-9]-[0-9][0-9]-^[a-z0-9]{8}$) ]]; then
		SRC_URI="https://github.com/matricks/${PN}/archive/v${PV}.tar.gz"
		KEYWORDS="~amd64 ~x86"
		SLOT="${MPV}"

	# For versioning {0.}0.0-rc0 -- OR -- {0.}0.0
	elif [[ $PV == @([0-9].[0-9]-rc[0-9]|[0-9].[0-9].[0-9]-rc[0-9]|[0-9].[0-9]|[0-9].[0-9].[0-9]) ]]; then
		SRC_URI="https://github.com/matricks/${PN}/archive/v${PV}.tar.gz"
		KEYWORDS="amd64 x86"
		MPV=${PV}
		SLOT="${MPV}"

	else
		die "This file version is not supported by this ebuild, please issue an issue on $LINK_ON_REPOSITORY with:
Unsupported file version
- FPN : ${P}"

fi

# HELPER: Get patch version for 0.5.1 which is 0.4.0 for some reason..
if [[ $MPV == "0.5.1" ]]; then
	PATCH_VERSION="0.4.0"
	else
		PATCH_VERSION=${MPV}
fi

LICENSE="ZLIB"
IUSE="doc test"

RDEPEND="dev-lang/lua:="
DEPEND="${RDEPEND}
	doc? ( ${PYTHON_DEPS} )
	test? ( ${PYTHON_DEPS} )"

PATCHES="(
	${FILESDIR}/${PATCH_VERSION}/${P}-test.py.patch
)"

pkg_setup() {
	if use doc || use test; then
		python-any-r1_pkg_setup
	fi

	mv "${FILESDIR}/${P}" "${FILESDIR}/${P}.tar.xpf"
}

src_prepare() {
	eapply_user
	tc-export CC
}

src_compile() {
	emake ${PN}
	if use doc; then
		"${PYTHON}" scripts/gendocs.py || die "doc generation failed"
	fi
}

src_install() {
	dobin ${PN}
	if use doc; then
		dohtml docs/${PN}{.html,_logo.png}
	fi
}
