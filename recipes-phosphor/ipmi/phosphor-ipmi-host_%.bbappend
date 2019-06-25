SRC_URI_gsj := "git://github.com/quanta-bmc/phosphor-host-ipmid.git"
#SRCREV_gsj := "${AUTOREV}"
SRCREV_gsj := "92af79f1c330c4ba45330da26e3fa98e8e9a48ca"
FILESEXTRAPATHS_prepend_gsj := "${THISDIR}/${PN}:"
SRC_URI_append_gsj = " file://gsj-ipmid-whitelist.conf"
SRC_URI_append_gsj = " file://merge_yamls.py"

WHITELIST_CONF_remove_gsj = " ${S}/host-ipmid-whitelist.conf"
WHITELIST_CONF_append_gsj = " ${WORKDIR}/gsj-ipmid-whitelist.conf"

EXTRA_OECONF_append_gsj = "--with-journal-sel \
                          SENSOR_YAML_GEN=${STAGING_DIR_NATIVE}${sensor_datadir}/sensor.yaml \
                          "
