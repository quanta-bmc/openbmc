DEPENDS += "bison-native"
LIC_FILES_CHKSUM = "file://Licenses/README;md5=30503fd321432fc713238f582193b78e"
UBRANCH = "npcm7xx-v2019.01"
SRC_URI = "git://github.com/Nuvoton-Israel/u-boot.git;branch=${UBRANCH}"
SRCREV = "${AUTOREV}"

FILESEXTRAPATHS_prepend_gsj := "${THISDIR}/${PN}:"
SRC_URI_append_gsj = " file://0002-add-runBMCflash-into-spi-flash.patch"
#SRC_URI_append_gsj = " file://0003-poleg_uboot2019_correct_dram_size.patch"