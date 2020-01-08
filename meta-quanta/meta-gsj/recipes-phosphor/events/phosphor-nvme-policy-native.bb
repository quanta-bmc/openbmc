SUMMARY = "Event policy for NVMe"
PR = "r1"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

inherit native
inherit phosphor-dbus-monitor

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI_append = " file://nvme-policy.yaml"

do_install() {
    install -D ${WORKDIR}/nvme-policy.yaml ${D}${config_dir}/nvme-policy.yaml
}
