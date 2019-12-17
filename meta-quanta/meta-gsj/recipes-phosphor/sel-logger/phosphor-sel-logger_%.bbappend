SRC_URI_gsj := "git://github.com/quanta-bmc/phosphor-sel-logger.git"
SRCREV_gsj := "${AUTOREV}"

# Enable threshold monitoring
EXTRA_OECMAKE_append_gsj = "-DSEL_LOGGER_MONITOR_THRESHOLD_EVENTS=ON"
