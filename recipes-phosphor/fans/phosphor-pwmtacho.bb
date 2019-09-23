LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

inherit allarch
inherit pythonnative

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI_append= " file://pwm_tacho.py"

do_install() {
    install -d ${D}${sbindir}
    install -m 0755 ${WORKDIR}/pwm_tacho.py ${D}${sbindir}
}
