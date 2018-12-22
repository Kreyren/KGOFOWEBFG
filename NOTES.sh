# GDTISSIHLBMS_YAAY 
# SRC_URI and scr_install () are the most important
## SRC_URI == SOURCE URL
## Everythinig in SRC_URI is placed+unarchived in WORKDIR
# SLOT is mandatory
## SLOT DOES NOT works with "", "0" is acceptable
# *   The source directory '/var/tmp/portage/media-gfx/NoxMentor-0.1/work/NoxMentor-0.1' doesn't exist
## Portage needs this dir
## NoxMentor-0.1 needs to be created or S VAR specified
##
# ${S} == SOurce directory?
## Can be set to multiple dirs
## Needs to be a dir(?)
# After each change in an ebuild, the ebuild has to be re-ebuild using 'ebuild $package manifest' command.
# ${WORKDIR} == /var/tmp/portage/media-gfx/NoxMentor-0.1/work/
# RDEPEND == Runtime Dependancy
# DEPEND == Build dependancy
# If $WORKDIR is present making build dir is not required(?)
# $WORKDIR/build
## 1) you are doing it manually, not through portage, docs don't know portage. so they randomly take a name for a build folder, coincidental it's called build
## 2) they propose you to build in different folder out of runtime reasoning so I propose you to do the next thing
# WARN: We are in sandbox chroot isolated from main system e.i: make install, pwd, etc. won't work as they should probably
# doins/insinto
## insinto where_i_want
## doins what_i_want

#KREY: D - /var/tmp/portage/media-gfx/NoxMentor-0.1/image/
#KREY: P - NoxMentor-0.1
#KREY: V - 
#KREY: PV - 0.1 -> something/something-${PV}
