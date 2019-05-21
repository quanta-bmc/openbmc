FILESEXTRAPATHS_prepend_gsj := "${THISDIR}/linux-nuvoton:"

KBRANCH = "Poleg-4.19.16-OpenBMC"
LINUX_VERSION = "4.19.16"

KSRC = "git://github.com/Nuvoton-Israel/linux;protocol=git;branch=${KBRANCH}"
SRCREV = "6884abab8fa5c632e7b42532513e2ed8b06d35f9"

SRC_URI_append_gsj = " file://gsj.cfg"
SRC_URI_append_gsj = " file://0002-Add-MAX31725-to-Quanta-GSJ-board.patch"
SRC_URI_append_gsj = " file://0002-Add-i2c-slave-mqueue-driver.patch"
SRC_URI_append_gsj = " file://0001-i2c-npcm-version-KF-debug-version.patch"
