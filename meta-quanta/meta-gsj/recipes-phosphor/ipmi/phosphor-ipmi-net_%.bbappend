FILESEXTRAPATHS_prepend_gsj := "${THISDIR}/${PN}:"
SRC_URI_append_gsj = " file://0001-add-startPayloadInstance-retry.patch"

SRCREV_gsj := "49a94b2f82fb1aa68d608f28c4863bb36661a3a4"

DEFAULT_RMCPP_IFACE := "eth1"
RMCPP_IFACE := "${DEFAULT_RMCPP_IFACE}"

ALT_RMCPP_IFACE = "usb0"
SYSTEMD_SERVICE_${PN} += " \
    ${PN}@${ALT_RMCPP_IFACE}.service \
    ${PN}@${ALT_RMCPP_IFACE}.socket \
    "
