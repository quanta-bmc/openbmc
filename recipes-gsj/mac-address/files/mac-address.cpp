#include "mac-address.hpp"

#include <phosphor-logging/log.hpp>

using namespace phosphor::logging;

int main() 
{
    size_t dataLen = 0;
    size_t bytesRead = 0;
    size_t macAddressNum = 4;

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

    // convert data into hex format
    std::string fruHexData[dataLen];

    for (size_t i = 0; i < dataLen; i++)
    {
        char buff[3] = {0};        
        sprintf(buff, "%02x", fruData[i]);
        std::string str = buff;
        fruHexData[i] = str;
    }

    std::stringstream ss;

    // get offset
    size_t offset[5];
    for (size_t i = 0; i < 5; i++)
    {
        ss << std::dec << std::stoi(fruHexData[i + 1], nullptr, 16);
        offset[i] = (size_t)std::stoi(ss.str(), nullptr, 10);
        ss.str(std::string());
    }

    // get mac address end offset
    size_t macAddressEndOffset = 5;
    for (size_t i = 1; i < 5; i++)
    {
        if (offset[i] != 0)
        {
            macAddressEndOffset = offset[i];
            break;
        }
    }

    // check sum
    size_t checksum = 0;
    for (size_t i = 0; i < (macAddressEndOffset - offset[0]) * 8; i++)
    {
        ss << std::dec << std::stoi(fruHexData[i + offset[0] * 8], nullptr, 16);
        checksum += (size_t)std::stoi(ss.str(), nullptr, 10);
        ss.str(std::string());
    }
    if (checksum % 256 != 0)
    {
        log<level::ERR>("Mac address check sum error. Use random mac address instead.",
                        entry("FILE=%s", MACADDRESS_EEPROM_FILE),
                        entry("ERRNO=%s", std::strerror(errno)));
        return generateRandomMacAddress();
    }

    // get mac address num
    size_t count = macAddressEndOffset * 8 - 2;
    while (fruHexData[count] == "ff")
    {
        count--;
    }
    macAddressNum = (size_t)std::stoi(fruHexData[count], nullptr, 16);

    // read mac address
    std::string macAddress[macAddressNum];
    macAddress[0] = (fruHexData[offset[0] * 8 + 3] + ":" + \
        fruHexData[1 + offset[0] * 8 + 3] + ":" + \
        fruHexData[2 + offset[0] * 8 + 3] + ":" + \
        fruHexData[3 + offset[0] * 8 + 3] + ":" + \
        fruHexData[4 + offset[0] * 8 + 3] + ":" + \
        fruHexData[5 + offset[0] * 8 + 3]).c_str();
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