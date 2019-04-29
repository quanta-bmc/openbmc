#include "mac-address.hpp"

#include <phosphor-logging/log.hpp>

using namespace phosphor::logging;

int main() 
{
    size_t dataLen = 0;
    size_t bytesRead = 0;
    size_t macAddressNum = 4;

    // get eeprom data
    FILE* fruFilePointer = std::fopen(MACADDRESS_EEPROM_FILE, "rb");
    if (fruFilePointer == NULL)
    {
        log<level::ERR>("Unable to open FRU file",
                        entry("FILE=%s", MACADDRESS_EEPROM_FILE),
                        entry("ERRNO=%s", std::strerror(errno)));
        cleanupError(fruFilePointer);
        return generateRandomMacAddress();
    }

    // get size of file
    if (std::fseek(fruFilePointer, 0, SEEK_END))
    {
        log<level::ERR>("Unable to seek FRU file",
                        entry("FILE=%s", MACADDRESS_EEPROM_FILE),
                        entry("ERRNO=%s", std::strerror(errno)));
        cleanupError(fruFilePointer);
        return generateRandomMacAddress();
    }

    // read file
    dataLen = std::ftell(fruFilePointer);
    uint8_t fruData[dataLen] = {0};

    std::rewind(fruFilePointer);
    bytesRead = std::fread(fruData, dataLen, 1, fruFilePointer);
    if (bytesRead != 1)
    {
        log<level::ERR>("Unable to read FRU file",
                        entry("FILE=%s", MACADDRESS_EEPROM_FILE),
                        entry("ERRNO=%s", std::strerror(errno)));
        cleanupError(fruFilePointer);
        return generateRandomMacAddress();
    }

    std::fclose(fruFilePointer);
    fruFilePointer = NULL;

    // get offset
    uint8_t offset[5];
    for (size_t i = 0; i < 5; i++)
    {
        offset[i] = fruData[i + 1];
    }

    if (offset[0] == 0)
    {
        log<level::ERR>("No internal use area",
                        entry("FILE=%s", MACADDRESS_EEPROM_FILE),
                        entry("ERRNO=%s", std::strerror(errno)));
        return generateRandomMacAddress();
    }

    // get mac address end offset
    uint8_t macAddressEndOffset = 5;
    for (size_t i = 1; i < 5; i++)
    {
        if (offset[i] != 0)
        {
            macAddressEndOffset = offset[i];
            break;
        }
    }

    // check sum
    uint8_t checksum = 0;
    for (size_t i = 0; i < uint8ToInt(macAddressEndOffset - offset[0]) * 8; i++)
    {
        checksum += fruData[i + offset[0] * 8];
    }
    if (checksum != 0)
    {
        log<level::ERR>("Mac address check sum error. Use random mac address instead.",
                        entry("FILE=%s", MACADDRESS_EEPROM_FILE),
                        entry("ERRNO=%s", std::strerror(errno)));
        return generateRandomMacAddress();
    }

    // get mac address num
    size_t count = uint8ToInt(macAddressEndOffset) * 8 - 2;
    while (fruData[count] == 0xff)
    {
        count--;
    }
    macAddressNum = uint8ToInt(fruData[count]);

    // read mac address
    std::stringstream ss;
    std::string macAddress[macAddressNum];
    macAddress[0] = "";
    for (size_t i = 0; i < 5; i++)
    {
        ss << std::hex << std::setfill('0');
	    ss << std::hex << std::setw(2) << static_cast<int>(fruData[i + offset[0] * 8 + 3]);
        macAddress[0] += ss.str();
        macAddress[0] += ":";
        ss.str(std::string());
    }
    ss << std::hex << std::setfill('0');
    ss << std::hex << std::setw(2) << static_cast<int>(fruData[5 + offset[0] * 8 + 3]);
    macAddress[0] += ss.str();
    ss.str(std::string());

    for (size_t i = 1; i < macAddressNum; i++)
    {
        macAddress[i] = macAddressAddOne(macAddress[i - 1]);
    }

    // set mac address
    std::string port0 = "eth1";
    std::string port1 = "usb0_dev";
    std::string port2 = "usb0_host";
    std::string port3 = "eth0";
    writeMacAddress(port0, macAddress[0]);
    writeMacAddress(port1, macAddress[1]);
    writeMacAddress(port2, macAddress[2]);
    writeMacAddress(port3, macAddress[3]);

    return 0;
}