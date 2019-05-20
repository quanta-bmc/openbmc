SRC_URI := "git://github.com/quanta-bmc/phosphor-sel-logger.git"
SRCREV := "${AUTOREV}"

# Enable threshold monitoring
EXTRA_OECMAKE += "-DSEL_LOGGER_MONITOR_THRESHOLD_EVENTS=ON"
