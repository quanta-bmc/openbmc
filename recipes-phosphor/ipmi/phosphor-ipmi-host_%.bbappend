SRC_URI_remove_gsj = "git://github.com/openbmc/phosphor-host-ipmid"
SRC_URI_prepend_gsj := "git://github.com/quanta-bmc/phosphor-host-ipmid.git"

SRCREV_gsj := "${AUTOREV}"

FILESEXTRAPATHS_prepend_gsj := "${THISDIR}/${PN}:"
SRC_URI_append_gsj = " file://gsj-ipmid-whitelist.conf"

WHITELIST_CONF_remove_gsj = " ${S}/host-ipmid-whitelist.conf"
WHITELIST_CONF_append_gsj = " ${WORKDIR}/gsj-ipmid-whitelist.conf"

EXTRA_OECONF_append_gsj = "--with-journal-sel \
                          SENSOR_YAML_GEN=${STAGING_DIR_NATIVE}${sensor_datadir}/sensor.yaml \
                          "
