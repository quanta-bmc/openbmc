KBRANCH = "Poleg-4.19.16-OpenBMC"
LINUX_VERSION = "4.19.16"

KSRC = "git://github.com/Nuvoton-Israel/linux;protocol=git;branch=${KBRANCH}"
SRCREV = "${AUTOREV}"

FILESEXTRAPATHS_prepend_gsj := "${THISDIR}/linux-nuvoton:"
SRC_URI_append_gsj = " file://gsj.cfg"
SRC_URI_append_gsj = " file://0002-Add-MAX31725-to-Quanta-GSJ-board.patch"
SRC_URI_append_gsj = " file://support-haven.patch"
SRC_URI_append_gsj = " file://0001-i2c-npcm-version-KF-debug-version.patch"
SRC_URI_append_gsj = " file://0003-i2c-npcm7xx-Add-workaround-for-Delta-Brick.patch"
