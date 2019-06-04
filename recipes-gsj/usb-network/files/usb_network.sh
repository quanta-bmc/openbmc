#!/bin/bash

cd /sys/kernel/config/usb_gadget

if [ ! -f "g1" ]; then
    mkdir g1
    cd g1

    echo 0x1d6b > idVendor  # Linux foundation
    echo 0x0104 > idProduct # Multifunction composite gadget
    mkdir -p strings/0x409
    echo "Linux" > strings/0x409/manufacturer
    echo "Etherned/RNDIS gadget" > strings/0x409/product

    mkdir -p configs/c.1
    echo 100 > configs/c.1/MaxPower
    mkdir -p configs/c.1/strings/0x409
    echo "RNDIS" > configs/c.1/strings/0x409/configuration

    mkdir -p functions/rndis.usb0
    cat /tmp/usb0_dev > functions/rndis.usb0/dev_addr # write device mac address
    cat /tmp/usb0_host > functions/rndis.usb0/host_addr # write usb mac address

    ln -s functions/rndis.usb0 configs/c.1

    echo f0839000.udc > UDC

    rm /tmp/usb0_dev
    rm /tmp/usb0_host

fi
exit 0