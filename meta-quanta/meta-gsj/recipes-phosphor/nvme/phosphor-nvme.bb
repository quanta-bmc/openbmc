PR = "r1"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

inherit meson pkgconfig
inherit obmc-phosphor-dbus-service
inherit obmc-phosphor-systemd
inherit phosphor-dbus-yaml
inherit pythonnative

DEPENDS += "sdbusplus"
DEPENDS += "phosphor-dbus-interfaces"
DEPENDS += "sdeventplus"
DEPENDS += "phosphor-logging"
DEPENDS += "sdbusplus-native"
DEPENDS += "autoconf-archive-native"
DEPENDS += "nlohmann-json"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI := "git://github.com/quanta-bmc/phosphor-nvme.git;protocol=git"
SRCREV := "${AUTOREV}"
S = "${WORKDIR}/git"

DBUS_SERVICE_${PN} = "xyz.openbmc_project.nvme.manager.service"
