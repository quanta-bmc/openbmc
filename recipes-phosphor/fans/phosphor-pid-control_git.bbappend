SRC_URI_gsj = "git://github.com/openbmc/phosphor-pid-control.git;protocol=git"
SRCREV_gsj = "${AUTOREV}"

FILESEXTRAPATHS_prepend_gsj := "${THISDIR}/${PN}:"
SRC_URI_append_gsj = " file://config-8ssd.json"
SRC_URI_append_gsj = " file://config-2ssd.json"
SRC_URI_append_gsj = " file://fan-control.sh"
SRC_URI_append_gsj = " file://fan-reboot-control.sh"
SRC_URI_append_gsj = " file://fan-no-sensor-protect.sh"

FILES_${PN} += "${datadir}/swampd/config-8ssd.json"
FILES_${PN} += "${datadir}/swampd/config-2ssd.json"
FILES_${PN} += "${bindir}/fan-control.sh"
FILES_${PN} += "${bindir}/fan-reboot-control.sh"
FILES_${PN} += "${bindir}/fan-no-sensor-protect.sh"

inherit obmc-phosphor-systemd
RDEPENDS_${PN} += "bash"

SYSTEMD_SERVICE_${PN} += "phosphor-pid-control.service"
SYSTEMD_SERVICE_${PN} += "fan-reboot-control.service"

do_install_append_gsj() {
    install -d ${D}${datadir}/swampd

    install -d ${D}/${bindir}
    install -m 0755 ${WORKDIR}/fan-control.sh ${D}/${bindir}

    install -m 0644 -D ${WORKDIR}/config-8ssd.json \
        ${D}${datadir}/swampd/config-8ssd.json
    install -m 0644 -D ${WORKDIR}/config-2ssd.json \
        ${D}${datadir}/swampd/config-2ssd.json

    install -d ${D}/${bindir}
    install -m 0755 ${WORKDIR}/fan-reboot-control.sh ${D}/${bindir}
    install -d ${D}/${bindir}
    install -m 0755 ${WORKDIR}/fan-no-sensor-protect.sh ${D}/${bindir}
}