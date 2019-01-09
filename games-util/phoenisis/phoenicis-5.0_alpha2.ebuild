# Copyright 2019 Jacob Hrbek, Kreyren
# Distributed under the terms of the Krey's Anti-Harrasment Licence based on GNU GENERAL PUBLIC LICENSE v2
# Based on master index https://devmanual.gentoo.org/

EAPI=6
## java-vm-2 doesn't support EAPI=7

inherit java-vm-2 jazzhands 

LINK_ON_REPOSITORY="github.com/Kreyren/KreyOverlay"

DESCRIPTION="Allows you to install and use non-native applications on your favorite operating system."

HOMEPAGE="https://phoenicis.org/"

if [[ $PV == "9999" ]]; then
	EGIT_REPO_URI="git@github.com:PhoenicisOrg/phoenicis.git"
	EGIT_BRANCH="master"
	MPV=${PVR}
	inherit git-r3
	unset SRC_URI
	unset KEYWORDS	

	elif [[ $PV =~ _(alpha|beta|gamma) ]]; then
		MPV=${PV/"_${BASH_REMATCH[1]}"/-"${BASH_REMATCH[1]}".}
	    SRC_URI="https://github.com/PhoenicisOrg/phoenicis/archive/v${MPV}.tar.gz"
	   	KEYWORDS="~amd64 ~x86"

	elif [[ $PV == @([0-9].[0-9]-rc[0-9]|[0-9].[0-9]) ]]; then
		SRC_URI="https://github.com/PhoenicisOrg/phoenicis/archive/v${PVR}.tar.gz"
		KEYWORDS="amd64 x86"
		MPV=${PVR}

	else 
		die "This file version is not supported by this ebuild, please issue an issue on $LINK_ON_REPOSITORY with:

Unsupported file version
- FPN : $FPN"

fi

LICENSE="LGPL-3.0"

SLOT=${MPV}

DEPEND="
	|| (
		>=dev-java/openjdk-bin-11_p28
		>=dev-java/openjdk-11.0.1_p13
)
	>=dev-java/maven-bin-3.6.0
"
# Relevant https://github.com/PhoenicisOrg/phoenicis/issues/1694#issuecomment-450743692

RDEPEND="$DEPEND"

PROPERTIES="interactive"

S=${WORKDIR}

pkg_setup () {

	echo ">>> This ebuild depends on app-text/wgetpaste for compilation, this is used for easier diagnostics in case of ebuild phase failure."

	while [[ JAVA_HOME == "" && ! -e $JAVA_HOME/release ]]; do
		echo "!!! FATAL: JAVA_HOME is invalid, expected JAVA_HOME pointing to valid java directory, please input it manually:"
		read -p JAVA_HOME{=,}
	done

}

src_unpack () {

	if [ "${A}" != "" ]; then
		unpack ${A}
	fi
}

src_compile () {

		if [[ -x $(command -v mvn) && -r $PWD/$MPFN/pom.xml ]]; then
			cd $PWD/$MPFN && mvn clean package --quiet || die "
!!! FATAL: Maven compilation failed.
!!! Try invoking 'emerge --sync' and re-emerge the package.

>>> If that didn't work file an issue to upstream on $LINK_ON_REPOSITORY with:
$([ ! -x $(command -v mvn) ] && echo '!!! FATAL: Maven is not executable!')$([ -x $(command -v mvn) ] && echo '>>> Maven is executable.')
$([ ! -r $PWD/$MPFN/pom.xml ] && echo '!!! FATAL: '$PWD/$MPFN/pom.xml' is not readable!')$([ -r $PWD/$MPFN/pom.xml ] && echo '>>> '$PWD/$MPFN/pom.xml' is readable.')
emerge --info : $(wgetpaste -c 'emerge --info' || echo "!!! Unable to fetch output of emerge --info, please provide it manually.")
JAVA_HOME     : $JAVA_HOME
pwd           : '$(pwd)'"

			else
				 die "
!!! FATAL: Maven is not executable or $PWD/$PFN/pom.xml is not readable.
!!! Try invoking 'emerge --sync' and re-emerge the package.

>>> If that didn't work file an issue to upstream on $LINK_ON_REPOSITORY with:
$([ ! -x $(command -v mvn) ] && echo '!!! FATAL: Maven is not executable!')$([ -x $(command -v mvn) ] && echo '>>> Maven is executable.')
$([ ! -r $PWD/$MPFN/pom.xml ] && echo '!!! FATAL: "$PWD/$MPFN/pom.xml" is not readable!')$([ -r $PWD/$MPFN/pom.xml ] && echo '>>> "$PWD/$MPFN/pom.xml" is readable.')
emerge --info : $(wgetpaste -c 'emerge --info' || echo "!!! Unable to fetch output of emerge --info, please provide it manually.")
JAVA_HOME     : $JAVA_HOME
pwd           : '$(pwd)'"

		fi
}

src_install () {
	if [[ -x $(command -v mvn) ]]; then

		cd $PWD/$MPFN || die "Unable to cd in $PWD/$MPFN."

		# TODO: Check if package is compiled.
		mvn install || die "Maven was unable to install $MPFN, try invoke it manually in $PWD/$PFN/phoenicis-javafx" # TODO: Test if fail triggers die

	fi

}

pkg_postinst () {

	mv $PWD/$PFN/phoenicis-javafx $PID/opt/phoenicis-$MPV || die "Unable to mv $PWD/$PFN/phoenicis-javafx /opt/phoenicis-$MPV."

		if [[ ! -x /usr/bin/phoenicis-$MPV ]]; then
			echo "#!/bin/bash
cd /opt/phoenicis && mvn exec:java /opt/phoenicis-$MPV || echo 'Unable to execute phoenicis-$MPV' " >> $PID/usr/bin/phoenicis-$MPV || die "Unable to create a shotcut."
			chmod +x /usr/bin/phoenicis-$MPV || die "Unable to set executable permission on shortcut in /usr/bin/phoenici-$MPV"
		fi

}
