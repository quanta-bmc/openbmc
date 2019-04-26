#!/bin/bash

function set_gpio() {
  #$1 gpio pin
  echo $1 > /sys/class/gpio/export
}

function set_gpio_direction(){
    #$1 gpio pin, $2 'in','high','low'
    echo $2 > /sys/class/gpio/gpio$1/direction
}

function read_gpio_input(){
    #$1 read input gpio pin
    cat /sys/class/gpio/gpio$1/value
}

function unexport_gpio(){
  #$1 gpio pin
  echo $1 > /sys/class/gpio/unexport
}

function read_present_set_related_power(){
    #$1 read present gpio, $2 output power gpio,$3 output direction
    var=$(cat /sys/class/gpio/gpio$1/value)
    # present 0 is plugged,present 1 is removal
    if [ "$var" == "0" ];then
        set_gpio_direction $2 "high"
    else 
        set_gpio_direction $2 "low"
    fi
}

function check_powergood_update_reset(){
    #$1 read powergood gpio, $2 output reset gpio
    var=$(cat /sys/class/gpio/gpio$1/value)
    if [ "$var" == "1" ];then
        sleep 0.1
        set_gpio_direction $2 "high"
    else
        sleep 0.1
        set_gpio_direction $2 "low"
    fi
}

## Initial U2_PRESENT_N
U2_PRESENT=( 148 149 150 151 152 153 154 155 )
for i in "${U2_PRESENT[@]}";
do 
    set_gpio $i;
    set_gpio_direction $i 'in';
done

## Initial POWER_U2_EN
POWER_U2=( 195 196 202 199 198 197 127 126 )
for i in "${POWER_U2[@]}";
do
    set_gpio $i;
done

## Initial PWRGD_U2
PWRGD_U2=( 161 162 163 164 165 166 167 168 )
for i in "${PWRGD_U2[@]}";
do 
    set_gpio $i;
    set_gpio_direction $i 'in';
done

## Initial RST_BMC_U2
RST_BMC_U2=( 72 73 74 75 76 77 78 79 )
for i in "${RST_BMC_U2[@]}";
do
    set_gpio $i;
done

### Initial related Power by Present
for i in {0..7};
do
    read_present_set_related_power "${U2_PRESENT[$i]}" "${POWER_U2[$i]}";
    check_powergood_update_reset "${PWRGD_U2[$i]}" "${RST_BMC_U2[$i]}";
done 

## Unexport script
# for i in {148..155};
# do 
#     unexport_gpio $i;
# done

# RunBMC input test, GPIO 194 input
# set_gpio 194
# set_gpio_direction 194 'in'
# set_gpio 111
# read_present_set_related_power 194 111

# unexport_gpio 194
# unexport_gpio 111

exit 0;
