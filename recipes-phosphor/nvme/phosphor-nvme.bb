PR = "r1"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${PHOSPHORBASE}/COPYING.apache-2.0;md5=34400b68072d710fecd0a2940a0d1658"

inherit autotools pkgconfig
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

FILES_${PN} += " ${datadir}/nvme_config.json"

do_install() {
    install -d ${D}${sbindir}
    install -m 0755  nvme_main ${D}${sbindir}

    install -d ${D}${datadir}/
    install -m 0644 -D ${S}/nvme_config.json \
        ${D}${datadir}/nvme_config.json
}