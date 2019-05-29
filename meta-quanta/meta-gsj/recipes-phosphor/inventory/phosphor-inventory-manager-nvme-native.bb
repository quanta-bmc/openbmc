SUMMARY = "Recipe to create nvme property in inventory manager"
PR = "r1"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${PHOSPHORBASE}/COPYING.apache-2.0;md5=34400b68072d710fecd0a2940a0d1658"

inherit native
inherit phosphor-inventory-manager

PROVIDES += "virtual/phosphor-inventory-manager-nvme"

SRC_URI_append = " file://nvme.yaml"

S = "${WORKDIR}"

do_install() {
    install -d ${D}${base_datadir}/events.d/
    install nvme.yaml ${D}${base_datadir}/events.d/nvme.yaml
}
