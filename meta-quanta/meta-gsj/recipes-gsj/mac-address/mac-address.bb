SRC_URI_gsj = "git://github.com/quanta-bmc/mac-address.git;protocol=git"
SRCREV_gsj = "${AUTOREV}"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${QUANTABASE}/COPYING.apache-2.0;md5=34400b68072d710fecd0a2940a0d1658"

inherit autotools pkgconfig
inherit systemd
inherit obmc-phosphor-systemd

HASHSTYLE = "gnu"

DEPENDS += "systemd"
DEPENDS += "autoconf-archive-native"
RDEPENDS_${PN} += "libsystemd"
FILES_${PN} += "${libdir}/*"
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SYSTEMD_SERVICE_${PN} += "mac-address.service"

S = "${WORKDIR}/git"
CXXFLAGS += "-std=c++17"

NATIVE_SYSTEMD_SUPPORT = "1"
SYSTEMD_PACKAGES = "${PN}"