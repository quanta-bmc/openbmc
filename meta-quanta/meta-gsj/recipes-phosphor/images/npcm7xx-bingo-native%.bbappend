FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI_remove = "file://BootBlockAndHeader_EB.xml"
SRC_URI_remove = "file://UbootHeader_EB.xml"
SRC_URI += " file://BootBlockAndHeader_GSJ.xml"
SRC_URI += " file://UbootHeader_GSJ.xml"


do_install_append() {
	install ${WORKDIR}/BootBlockAndHeader_GSJ.xml ${D}${bindir}/BootBlockAndHeader_EB.xml
    install ${WORKDIR}/UbootHeader_GSJ.xml ${D}${bindir}/UbootHeader_EB.xml
}

