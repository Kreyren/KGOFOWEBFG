# Copyright 2019 Jacob Hrbek, Kreyren
# Distributed under the terms of the Krey's Anti-Harrasment Licence based on GNU GENERAL PUBLIC LICENSE v2
# Based on master index https://devmanual.gentoo.org/

# @ECLASS: jazzhands.eclass
# @MAINTAINER: Jacob Hrbek <kreyren@rixotstudio.cz>
# @SUPPORTED_EAPIS: 0 1 2 3 4 5 6 7
# @AUTHOR: Jacob Hrbek <kreyren@rixotstudio.cz>
# @BLURB: Improved variable definitions for enoch builds

PFN=$PN-$MPV-${PR:+-$PR} # Package Full Name (Package, Version, Revision (if any)
## Expected $PN-$MPV if $PR=""
## Relevant: Parameter Expansion expands parameters: "$foo", "$1". You can use it to perform string or array operations: "${file%.mp3}", "${0##*/}", "${files[@]: -4}". They should *always* be quoted. See: http://mywiki.wooledge.org/BashFAQ/073 and "Parameter Expansion" in man bash. Also see http://wiki.bash-hackers.org/syntax/pe.


PC=${CATEGORY} # Package Category


PN=$PN # Package Name


PV=$PV # Package Version


PR=$PR # Package Revision


PVAR=${PVR} # Package Version And Revision


PF=$PFN # Package Full Name


PORTDIR=/var/tmp/portage # PORTage DIRectory
	t=${PORTDIR}


PACKDIR=${PORTDIR}/${PC}/${PNAV} # PACKage DIRectory
	=${PACKDIR}


BUILDDIR=${PACKDIR}/build # Package Build Directory
	PBD=${BUILDDIR}


#FILESDIR=${PACKDIR}/files # TODO: Causes readonly
	PFD=${FILESDIR}


#WORKDIR=${PACKDIR}/work - Causes readonly
	PWD=${WORKDIR} 
## Conflicts with $PWD (Print Working Directory)


HOMEDIR=${PACKDIR}/homedir
	PHD=${HOMEDIR}


DISTDIR=${PACKDIR}/distdir
	PDD=${DISTDIR}


IMAGEDIR=${PACKDIR}/image
	PID=${IMAGEDIR}


#SOURCEDIR=${PACKDIR}/${PNAV} - Causes readonly
	PSD=${SOURCEDIR}


ROOT=/ # I AM ROOT

# Modified Package Full Name
MPFN=$PN-$MPV
