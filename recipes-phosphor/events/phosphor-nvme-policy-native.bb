SUMMARY = "Event policy for NVMe"
PR = "r1"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${PHOSPHORBASE}/COPYING.apache-2.0;md5=34400b68072d710fecd0a2940a0d1658"

inherit native
inherit phosphor-dbus-monitor

FILESEXTRAPATHS_prepend_gsj := "${THISDIR}/${PN}:"
SRC_URI_append_gsj = " file://nvme-policy.yaml"

do_install() {
        install -D ${WORKDIR}/nvme-policy.yaml ${D}${config_dir}/nvme-policy.yaml
}
