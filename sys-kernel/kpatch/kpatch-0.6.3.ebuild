# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
## BREAKS GENTOO GUIDELINES!! USE WITH CARE!!

EAPI="0"
# linux-info doesn't support EAPI7
# EAPI="0" -> because i'm sick and tired of gentoo function calling `use() calls are not allowed in global scope`.

inherit linux-info linux-mod flag-o-matic jazzhands

echo "INFO: This ebuild is KREYRENIZED."

DESCRIPTION="Dynamic kernel patching for Linux"
HOMEPAGE="https://github.com/dynup/kpatch"
LINK_ON_REPOSITORY="https://github.com/Kreyren/KreyOverlay"

LICENSE="GPL-2+"
IUSE="examples +modules test"

UPSTREAM="dynup"

## Get keywords, version, source and slot
# For live build
if [[ $PV == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="git@github.com:${UPSTREAM}/${PN}.git"
	EGIT_BRANCH="master"
	MPV=${PV}
	SLOT="${MPV}"
	unset SRC_URI
	unset KEYWORDS

	# HELPER: tagged new release based on https://github.com/dynup/kpatch/issues/948
	elif [[ $PV == "0.6.3" ]]; then
		inherit git-r3
		EGIT_REPO_URI="https://github.com/${UPSTREAM}/${PN}.git"
		EGIT_COMMIT="da3eed612df1d26e19b0678763e116f666da13b2"
		KEYWORDS="~amd64 ~x86"

	# For versioning 0.0.0 || 0.0.0-rc0
	elif [[ $PV == @([0-9].[0-9].[0-9]|[0-9].[0-9].[0-9]]-rc[0-9]) ]]; then
				# SANITY: if Linux-<=4.19 is used on 0.6.2 and lower ; else force compatible version.
				if [[ $major -ge 4 && $minor -ge 19 && ${PV//.-rc} -ge "063*" && KREYRENIZED != "" ]]; then # SANITY: is ${PV//.-rc} sane?
					echo "ERROR: Blocked by bug https://github.com/dynup/kpatch/issues/948"
					echo "KREYRENIZED: Ebuild forced >=sys-kernel/kpatch-0.6.3 for compatibility to avoid FATAL error which is not an option."
					RDEPEND=">=sys-kernel/kpatch-0.6.3"
					exit 0 # Exit since we will use different ebuild

					else # If sanity is passed, download source
						SRC_URI="https://github.com/${UPSTREAM}/${PN}/archive/v${PV}.tar.gz"
						KEYWORDS="amd64 x86"
						MPV=${PV}
						SLOT="${MPV}"
				fi

	elif [[ ${PV} == "0" ]]; then # TESTING USE ONLY!
		return

	else
		die "This file version is not supported for ${PFN}, please issue an issue on $LINK_ON_REPOSITORY with:
Unsupported file version
- FPN : ${FPN}"

fi

RDEPEND="
	app-crypt/pesign
	dev-libs/openssl:0=
	sys-libs/zlib
	sys-apps/pciutils
"

DEPEND="
	${RDEPEND}
	test? ( dev-util/shellcheck )
	dev-libs/elfutils
	sys-devel/bison
"

pkg_pretend() {
  if [[ $major -ge 4 && $minnor -ge 19 ]]; then
		if ! linux_config_exists; then
			eerror "Unable to check the currently running kernel for kpatch support"
			eerror "Please be sure a .config file is available in the kernel src dir"
			eerror "and ensure the kernel has been built."
		else
			# Fail to build if these kernel options are not enabled (see kpatch/kmod/core/Makefile)
			CONFIG_CHECK="FUNCTION_TRACER HAVE_FENTRY MODULES SYSFS KALLSYMS_ALL"
			ERROR_FUNCTION_TRACER="CONFIG_FUNCTION_TRACER must be enabled in the kernel's config file"
			ERROR_HAVE_FENTRY="CONFIG_HAVE_FENTRY must be enabled in the kernel's config file"
			ERROR_MODULES="CONFIG_MODULES must be enabled in the kernel's config file"
			ERROR_SYSFS="CONFIG_SYSFS must be enabled in the kernel's config file"
			ERROR_KALLSYMS_ALL="CONFIG_KALLSYMS_ALL must be enabled in the kernel's config file"
		fi
	else
		eerror
		eerror "kpatch is not available for Linux kernels below 4.0.0"
		eerror
		die "Upgrade the kernel sources before installing kpatch."
	fi

	check_extra_config
}

src_prepare() {
	replace-flags '-O?' '-O1'
	default
}

src_compile() {
	set_arch_to_kernel
	emake all
}

src_install() {
	set_arch_to_kernel
	emake DESTDIR="${D}" PREFIX="/usr" install

	einstalldocs
}
