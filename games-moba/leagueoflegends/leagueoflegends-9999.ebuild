# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Based on https://devmanual.gentoo.org/ebuild-writing/
# ebuild functions https://devmanual.gentoo.org/ebuild-writing/functions/index.html

# KNOWN ISSUES
## Client is slow
### Adobe Air needed?
#### Adobe Air is broken in winetricks, created issue https://github.com/Winetricks/winetricks/issues/1158 = ROADBLOCK
## Game-window crashes on startup
### Andew Wesie patches are mandatory
## Game-window has no audio
### Fix unknown
### Related: https://bugs.winehq.org/show_bug.cgi?id=45934
## Game-window ignores input from keyword
### Fix unknown


# Related: https://github.com/winepak/applications/blob/master/com.leagueoflegends.Client/com.leagueoflegends.Client.yml
# Related: https://lutris.net/games/install/3552/view
# Related: https://bugs.winehq.org/show_bug.cgi?id=45934
# Related: https://github.com/bobwya/gentoo-wine-esync

## Version: Work in progress

# IMPROVEMENT(?):  take a look at dxvk / bobwya for extra ideas. btw, you should really use bobwya repo for wine as it comes with esync patches.
# Make automatic with interactive

# TODO: winetricks is annoying with GUI, sourcing them with ebuild might be more effective?
## Related: https://github.com/Winetricks/winetricks/pull/1090


# E-build API
EAPI=6

# inherid

NAME="leagueoflegends"
## Forcing it above a filename to prevent issues if renamed.

CATEGORY="games-emulation"
# TODO: make games-moba

HOMEPAGE="https://${REGION}.leagueoflegends.com/"
## Capitalization is irelevant for this URL

DESCRIPTION="Multiplayer online battle arena video game developed and published by Riot Games."
## Grabbed from wiki

KEYWORDS="amd64 x86"
# PBE will use testing

SLOT="0"

LICENSE="2018 Riot Games, Inc. All rights reserved."
## TODO: Verify if correct

#SRC_URI="https://riotgamespatcher-a.akamaihd.net/releases/live/installer/deploy/League%20of%20Legends%20installer%20EUNE.exe"
## Grabbed from lutris

IUSE="staging run-exes vulkan mono" 
## https://devmanual.gentoo.org/ebuild-writing/variables/index.html#iuse
## wine-staging has staging use flag

#REQUIRED_USE="" https://devmanual.gentoo.org/ebuild-writing/variables/index.html#required_use
## No need for REQUIRED_USE?

RESTRICT="bindist,mirror,test,strip,fetch"
## bindist   = Distribution of built packages is restricted.
### Downloding installer from leagueoflegends.com == restricted(?)
## mirror    = files in SRC_URI will not be downloaded from the GENTOO_MIRRORS.
### Downloding from non-gentoo source
## test 	 = do not run src_test even if user has FEATURES=test.
### We won't compile, no need to test.
## strip 	 = final binaries/libraries will not be stripped of debug symbols.
### We won't compile, no need to strip. Trying to prevent corrruption.

#DEPEND=""
## We won't compile no need for deps

#BDEPEND=""
## EAPI=7 function

RDEPEND="
|| (
>=app-emulation/wine-staging-3.14
>=app-emulation/wine-any-3.14
)
=app-emulation/winetricks-99999999"
## >=app-emulation/wine-any-3.14::gentoo[${MULTILIB_USEDEP},vulkan] ?

PDEPEND=""
## A list of packages to be installed (if possible) after the package is merged. Use this only when RDEPEND would cause cyclic dependencies.
## No need atm

PROPERTIES="interactive"
## A space-delimited list of properties, with conditional syntax support. interactive is the only valid value for now.
## I have no hugging idea what it means and i'm scared that it starts talking at me.
## TIP: See the cdrom eclass for PROPERTIES=interactive examples

#DOCS=""
## An array or space-delimited list of documentation files for the default src_install function to install using dodoc. If undefined, a reasonable default list is used.
## Useless? In theory i can install it with licence or something?.. with PORO document! 

#HTML_DOCS=""
## An array or space-delimited list of documentation files or directories for the einstalldocs function to install recursively.
## Wth is this





jazzhands () {
##################################################################################
##               JAZZHANDS! (Krey's version of gentoo's short hands)            ##
##     License: None from gentoo can use this untill kreyren is ebuild master   ##
##################################################################################

# Gentoo's variables are read-only it may cause issues

PN="${NAME}"
# PN   = Package Name

PC="${CATEGORY}"
# PC   = Package Category

PV="${PV}"
# PV   = Package Version

PNV="${PNV}"
# PNV  = Package Name Version

#PR="${PR}"
PR=""
# PR   = Package Revision

PVR="${PVR}"
# PVR  = Package Version Revision

FPN="${PN}-${PV}-${PR}"
# FPN  = Full Package Name

SOURCEDIR="/var/tmp/portage/${FPN}"

DISTDIR="${SOURCEDIR}/distdir"

WORKDIR="${SOURCEDIR}/work/"

BUILDDIR="${SOURCEDIR}/build/"

TEMPDIR="${SOURCEDIR}/image/"
## Temporary Install Directory (Gentoo - D) ... don't ask me why do they call it 'D'

FILESDIR="${SOURCEDIR}/files"

HOMEDIR="${SOURCEDIR}/homedir"

GAMEDIR="/home/${USER}/Games"


# A   == 	All the source files for the package (excluding those which are not available because of USE flags).

EP="${D%/}${EPREFIX}/"
## Shorthand for ${D%/}${EPREFIX}/

EROOT="${ROOT%/}${EPREFIX}/"
## Shorthand for ${ROOT%/}${EPREFIX}/

# ROOT=""
## The absolute path to the root directory into which the package is to be merged. Only allowed in pkg_* phases. (https://devmanual.gentoo.org/ebuild-writing/variables/index.html#root)
## Might be required

# DISTDIR=""
## Contains the path to the directory where all the files fetched for the package are stored.
## What?

# EPREFIX=""
## The normalised offset-prefix path of an offset installation.
## WHAAAT
## Prefix of what
## Offset meaning?

}




region_selection () {
	# Not working, ebuild $ebuild manifest outputs regression
	# VERIFY: no ebuild that i know of reads input from stdin. the only way i can think of to do this is to use useflags. region_us, region_eu and so on. I think you could use net-misc/curl as possible inspiration.
while [[ ${REGION} != @(EUNE|NA|EUW|BR|LAN|LAS|OCE|RU|JP|SEA) ]]; do 
echo "Select your region:
EUNE  - Europe Nordic and East
NA    - North America
EUW   - Europe West
BR    - Brazil
AN    - Latin America North
LAS   - Latin America South
OCE   - Oceania
RU    - Russia
TR    - Turkey
JP    - Japan
SEA   - South East Asia
"

read REGION

done

wget https://riotgamespatcher-a.akamaihd.net/releases/live/installer/deploy/League%20of%20Legends%20installer%20${REGION}.exe

}

pkg_setup () {
	jazzhands
	
	# We are in HOMEDIR
	echo "WARNING: This ebuild is not idiot-proof, proceed with care!
	"
	echo "WARNING: To unmerge remove /home/username/Games/${NAME}, ebuild is unable to do that atm."

	# Working around missing USER var.
	# TODO: can i greb USER var somehow?
	echo "fixme: ebuild is unable to fetch it from user space..
	"
	echo "Enter your username to which we will install wine (case-sensitive!)"
	read USER

	region_selection

	mkdir -p /home/$USER/Games/${NAME}

	# TODO: winetricks shoudn't run as root."
	WINEDEBUG="-all" WINEPREFIX="/home/${USER}/Games/${NAME}-${REGION}" winetricks corefonts adobeair vcrun2008 vcrun2017 winxp glsl=disabled
	## Adobeair = unconfirmed

	WINEDEBUG="-all" WINEPREFIX="/home/${USER}/Games/${NAME}-${REGION}" wine "{HOMEDIR}/'League of Legends installer EUNE.exe'"

	# https://appdb.winehq.org/objectManager.php?sClass=version&iId=36323 is mandatory
	echo "Downloading Anti-Cheat patchset (Credit: Andrew Wesie)"
	echo "WARNING: Those patches are safe in case you get banned sent a ticket on riot support and they will unban you."

	wget "https://raw.githubusercontent.com/RXT067/krey-overlay/master/games-moba/leagueoflegends/patches/0003-Pretend-to-have-a-wow64-dll.patch"
	wget "https://raw.githubusercontent.com/RXT067/krey-overlay/master/games-moba/leagueoflegends/patches/0006-Refactor-LdrInitializeThunk.patch"	
	wget "https://raw.githubusercontent.com/RXT067/krey-overlay/master/games-moba/leagueoflegends/patches/0007-Refactor-RtlCreateUserThread-into-NtCreateThreadEx.patch"
	wget "https://raw.githubusercontent.com/RXT067/krey-overlay/master/games-moba/leagueoflegends/patches/0009-Refactor-__wine_syscall_dispatcher-for-i386.patch"

	mv "${HOMEDIR}/0003-Pretend-to-have-a-wow64-dll.patch" "${FILESDIR}/"
	mv "${HOMEDIR}/0006-Refactor-LdrInitializeThunk.patch" "${FILESDIR}/"
	mv "${HOMEDIR}/0007-Refactor-RtlCreateUserThread-into-NtCreateThreadEx.patch" "${FILESDIR}/"
	mv "${HOMEDIR}/0009-Refactor-__wine_syscall_dispatcher-for-i386.patch" "${FILESDIR}/"

	# TODO: https://devmanual.gentoo.org/ebuild-writing/misc-files/patches/index.html
	#if [[ -e ${FILESDIR}/@(0003-Pretend-to-have-a-wow64-dll.patch&0006-Refactor-LdrInitializeThunk.patch&0007-Refactor-RtlCreateUserThread-into-NtCreateThreadEx.patch&0009-Refactor-__wine_syscall_dispatcher-for-i386.patch) ]]; then
	if [[ -e "${FILESDIR}/0003-Pretend-to-have-a-wow64-dll.patch" ]] && [[ -e "${FILESDIR}/0006-Refactor-LdrInitializeThunk.patch" ]] && [[ -e "${FILESDIR}/0007-Refactor-RtlCreateUserThread-into-NtCreateThreadEx.patch" ]] && [[ -e "${FILESDIR}/0009-Refactor-__wine_syscall_dispatcher-for-i386.patch" ]]; then
		epatch -p1 "${FILESDIR}/0003-Pretend-to-have-a-wow64-dll.patch"
		epatch -p1 "${FILESDIR}/0006-Refactor-LdrInitializeThunk.patch"
		epatch -p1 "${FILESDIR}/0007-Refactor-RtlCreateUserThread-into-NtCreateThreadEx.patch"
		epatch -p1 "${FILESDIR}/0009-Refactor-__wine_syscall_dispatcher-for-i386.patch"

		else
			echo "FATAL: Patches was NOT detected in ${FILESDIR}"
			echo "Please apply them manually from https://github.com/RXT067/krey-overlay/tree/master/games-moba/leagueoflegends/patches"
	fi

	echo "WARNING: TEST IN PRACTICE TOOL BEFORE GAME!"

	echo "INFO: Report issues on https://github.com/RXT067/krey-overlay, any info is helpful."

}
