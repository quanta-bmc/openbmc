#!/bin/bash

# get fan threshold by d-bus command
function get_threshold_value() {
    get_property_path='xyz.openbmc_project.Sensor.Threshold.Critical CriticalLow'
    # echo "busctl get-property $1 $2 $get_property_path"
    threshold_value="$(busctl get-property $1 $2 $get_property_path | awk '{print $2}')"
    echo "$threshold_value"
}

# get fan rpm by d-bus command
function get_fan_value() {
    get_property_path='xyz.openbmc_project.Sensor.Value Value'
    # echo "busctl get-property $1 $2 $get_property_path"
    fan_value="$(busctl get-property $1 $2 $get_property_path | awk '{print $2}')"
    echo "$fan_value"
}

# set fan pwm by d-bus command
function set_fan_value() {
    set_property_path='xyz.openbmc_project.Control.FanPwm'
    # echo " busctl set-property $1 $2 $set_property_path Target t 100 "
    busctl set-property $1 $2 $set_property_path Target t 255
}

#find hwmon path of fan
function find_hwmon_path() {
    # calculate number of hwmons
    hwmon_num="$(ls /sys/class/hwmon/ | awk '{count+= 1} END {print count}')"
    for i in $(seq 1 $hwmon_num); 
    do 
        # echo $i 
        #combine number + p
        i+="p"
        #get path of hwmon
        path="$(busctl --no-pager | grep Hwmon[0-9] | awk '{print $1}' | sed -n "$i")" 
        # echo "$path"
        #perform busctl tree to show content of each path of hwmon, and grep fan_tach
        busctl_tree="$(busctl tree $path --no-pager | grep fan_tach)"
        # echo $busctl_tree
        # $? is used to record last command state
        if [ $? -eq 0 ];then
            echo "$path"
            break
            # echo "Find"
        fi
    done
}

echo "================Start Fan Detect: ==============="
fan_tach_path=( '/xyz/openbmc_project/sensors/fan_tach/Fan0_0_RPM'
                '/xyz/openbmc_project/sensors/fan_tach/Fan0_1_RPM'
                '/xyz/openbmc_project/sensors/fan_tach/Fan1_0_RPM'
                '/xyz/openbmc_project/sensors/fan_tach/Fan1_1_RPM'
                '/xyz/openbmc_project/sensors/fan_tach/Fan2_0_RPM'
                '/xyz/openbmc_project/sensors/fan_tach/Fan2_1_RPM'
                )

hwmon_path=$(find_hwmon_path)
critical_threshold=$(get_threshold_value $hwmon_path ${fan_tach_path[0]})
# echo "$critical_threshold"
check_fail_flag=0
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
                    check_fail_flag=1
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
        # debug for late code run 
        #    sleep 15 
        fi
    done
done
