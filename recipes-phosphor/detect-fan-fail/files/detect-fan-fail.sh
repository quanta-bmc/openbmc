#!/bin/bash

function get_threshold_value() {
  #$1 gpio pin
    get_property_path='xyz.openbmc_project.Sensor.Threshold.Critical CriticalLow'
    # echo "busctl get-property $1 $2 $get_property_path"
    threshold_value="$(busctl get-property $1 $2 $get_property_path | awk '{print $2}')"
    echo "$threshold_value"
}

function get_fan_value() {
  #$1 gpio pin
    get_property_path='xyz.openbmc_project.Sensor.Value Value'
    # echo "busctl get-property $1 $2 $get_property_path"
    fan_value="$(busctl get-property $1 $2 $get_property_path | awk '{print $2}')"
    echo "$fan_value"
}

function set_fan_value() {
  #$1 gpio pin
    set_property_path='xyz.openbmc_project.Control.FanPwm'
    # echo " busctl set-property $1 $2 $set_property_path Target t 100 "
    busctl set-property $1 $2 $set_property_path Target t 255
}

echo "================Start Fan Detect: ==============="

hwmon_path='xyz.openbmc_project.Hwmon-377141964.Hwmon1'
fan_tach_path=( '/xyz/openbmc_project/sensors/fan_tach/Fan0_0_RPM'
                '/xyz/openbmc_project/sensors/fan_tach/Fan0_1_RPM'
                '/xyz/openbmc_project/sensors/fan_tach/Fan1_0_RPM'
                '/xyz/openbmc_project/sensors/fan_tach/Fan1_1_RPM'
                '/xyz/openbmc_project/sensors/fan_tach/Fan2_0_RPM'
                '/xyz/openbmc_project/sensors/fan_tach/Fan2_1_RPM'
                )

critical_threshold=$(get_threshold_value $hwmon_path ${fan_tach_path[0]})
# echo "$critical_threshold"

check_fail_flag=0
set_count=0
current_fan_value=()
while true; do
    sleep 2
    echo 'Begining to Detect......'
    pwm_tacho.py -l
    for i in ${!fan_tach_path[@]};
    do
        # echo "i: $i"
        current_fan_value[$i%2]=$(get_fan_value $hwmon_path ${fan_tach_path[$i]}) 
        # echo ${current_fan_value[$i]}
        # echo "Current array length: ${#current_fan_value[@]}"
        if [ ${#current_fan_value[@]} -eq 2 ] && [ ${current_fan_value[0]} -lt $critical_threshold ] && [ ${current_fan_value[1]} -lt $critical_threshold ];then
            echo "Detected fan fail !!!"
            # echo "${current_fan_value[0]} ${current_fan_value[1]}"
            # echo ${fan_tach_path[$i]}
            systemctl stop phosphor-pid-control
            for j in ${!fan_tach_path[@]};
            do
                if [ $j -ne $(($i-1)) ] && [ $j -ne $(($i)) ] && [ $(($j%2)) -ne 1 ];then
                    # echo "j: $j , i: $i , i-1: $(($i-1)) , j%2: $(($j%2))"
                    # echo "${fan_tach_path[$j]}"
                    set_fan_value $hwmon_path ${fan_tach_path[$j]}
                    set_count=$(($set_count+1))
                    check_fail_flag=1
                    set_count=0
                fi
            done
            current_fan_value=()
            break
        fi
        # echo 'Fans are going to normal'

        if [ $i -eq $((${#fan_tach_path[@]}-1)) ] && [ $check_fail_flag -eq 1 ]; then
           check_fail_flag=0
           systemctl restart phosphor-pid-control
           echo "Fans are going to normal"
           sleep 15
        fi
    done
    
done
