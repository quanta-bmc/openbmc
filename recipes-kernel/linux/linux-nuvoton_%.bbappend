FILESEXTRAPATHS_prepend_gsj := "${THISDIR}/linux-nuvoton:"

KBRANCH = "Poleg-4.19.16-OpenBMC"
LINUX_VERSION = "4.19.16"

KSRC = "git://github.com/Nuvoton-Israel/linux;protocol=git;branch=${KBRANCH}"
SRCREV = "307e374d3d8efa43adeb9322ac4b5a7cf2ad5d1a"

SRC_URI_append_gsj = " file://gsj.cfg"
SRC_URI_append_gsj = " file://0002-Add-MAX31725-to-Quanta-GSJ-board.patch"
SRC_URI_append_gsj = " file://0002-Add-i2c-slave-mqueue-driver.patch"
# SRC_URI_append_gsj = " file://0004-Modify-slave-mqueue-dts.patch"
