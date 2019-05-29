FILESEXTRAPATHS_append := "${THISDIR}/files:"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${QUANTABASE}/COPYING.apache-2.0;md5=34400b68072d710fecd0a2940a0d1658"

HASHSTYLE = "gnu" 

DEPENDS += "systemd"
RDEPENDS_${PN} += "libsystemd"

DEPENDS += "sdbusplus"
DEPENDS += "phosphor-dbus-interfaces"
DEPENDS += "sdeventplus"
DEPENDS += "phosphor-logging"

INSANE_SKIP_${PN} += "installed-vs-shipped"
FILES_${PN} += "${libdir}/*"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI_append = " file://mac-address.cpp"
SRC_URI_append = " file://mac-address.hpp"
SRC_URI_append = " file://mac-address.service"

S = "${WORKDIR}"

CXXFLAGS += "-std=c++17"  

do_compile() {
        ${CXX} ${CXXFLAGS} -I${S} -c mac-address.cpp mac-address.hpp -lsdbusplus -lsystemd -lphosphor_dbus -Wl,--hash-style=${HASHSTYLE}
        ${CXX} ${CXXFLAGS} -I${S} -o mac-address mac-address.o -lsdbusplus -lsystemd -lphosphor_dbus -lsdeventplus -Wl,--hash-style=${HASHSTYLE}
}

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/mac-address ${D}/${bindir}

    install -d ${D}${systemd_unitdir}/system/
    install -m 0644 ${WORKDIR}/mac-address.service ${D}${systemd_unitdir}/system
}

NATIVE_SYSTEMD_SUPPORT = "1"
SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE_${PN} = "mac-address.service"

inherit systemd
