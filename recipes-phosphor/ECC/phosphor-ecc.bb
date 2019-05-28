LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${PHOSPHORBASE}/COPYING.apache-2.0;md5=34400b68072d710fecd0a2940a0d1658"
PR = "r1"
S = "${WORKDIR}/git"

inherit autotools pkgconfig
inherit obmc-phosphor-dbus-service obmc-phosphor-systemd

HASHSTYLE = "gnu"
CXXFLAGS += "-std=c++17"

DEPENDS += "sdbusplus"
DEPENDS += "phosphor-dbus-interfaces"
DEPENDS += "sdeventplus"
DEPENDS += "phosphor-logging"
DEPENDS += "sdbusplus-native"
DEPENDS += "autoconf-archive-native"
DEPENDS += "phosphor-sel-logger"

SRC_URI_gsj = "git://github.com/quanta-bmc/phosphor-ecc.git;protocol=git"
SRCREV_gsj := "${AUTOREV}"

FILESEXTRAPATHS_prepend_gsj := "${THISDIR}/${PN}:"
DBUS_SERVICE_${PN}_append_gsj = " phosphor-ecc.service"
