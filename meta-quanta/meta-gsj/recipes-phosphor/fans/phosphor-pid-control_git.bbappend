FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI = "git://github.com/quanta-bmc/phosphor-pid-control.git;protocol=git"
SRC_URI += "file://config.json"
SRCREV = "${AUTOREV}"

FILES_${PN} += "${datadir}/swampd/config.json"

inherit obmc-phosphor-systemd
DEPENDS += "cli11"

SYSTEMD_SERVICE_${PN} += "phosphor-pid-control.service"

do_install_append() {
    install -d ${D}${datadir}/swampd
    install -m 0644 -D ${WORKDIR}/config.json \
        ${D}${datadir}/swampd/config.json

}

