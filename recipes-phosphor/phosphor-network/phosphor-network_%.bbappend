EXTRA_OECONF += " --disable-link-local-autoconfiguration"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI_append_gsj += "file://0001-meta-gsj-phosphor-network-Add-property.patch"
