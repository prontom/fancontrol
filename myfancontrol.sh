#!/bin/bash
case $1 in
    stop)
        `sudo killall myfancontrol.sh`
        echo "stopped!"
        return 0
        ;;
    restart)
        #`sudo killall myfancontrol.sh || sudo $0`
        `$0 "$@" &`
        return 0
        ;;
    *)
        ;;
esac

# if [ "$1" == "restart" ]
#     then
#     `sudo killall myfancontrol.sh && sudo $0`
# fi

fan="/sys/class/hwmon/hwmon4/pwm2"
fan2="/sys/class/hwmon/hwmon5/pwm2"
echo "255" > $fan
echo "255" > $fan2

#method=linear|discret
method="discret"
delay=3
max_temp=80
result_pwm=150
max_ssd_temp=55
#temp|pwm
#pwm from 20 to 255
discret_temp_pwm=(
"42|100"
"45|100"
"50|110"
"55|120"
"60|110"
"70|250"
"75|255"
"$max_temp|255"
)


while [ true ]
do
    sleep $delay
    speed_fan=`sensors | grep "fan2" | awk '{print $2}'`
    ssd_nvme_temp=`sensors | grep Composite | awk '{print int($2)}'`
    ssd_nvme_temp1=`sensors | grep 'Sensor 2' | awk '{print int($3)}'`
    ssd_temp=`hdsentinel | grep Temperature | awk '{print $3}' | tail -1`
    temp_case=`sensors | grep "Package id 0" | awk '{print int($4)}'`

    case $method in
        discret)
            for item in "${discret_temp_pwm[@]}"
            do
                temp=$(echo "${item}"|awk -F "|" '{print $1}')
                pwm=$(echo "${item}"|awk -F "|" '{print $2}')
                if [ $temp_case -gt $temp ]; then
                    result_pwm=$pwm
                fi
            done

            # ssd 1000Gb nvme temp control
            if [ $ssd_nvme_temp1 -gt $max_ssd_temp ] && [ $result_pwm -lt "250" ]; then
                result_pwm=255
            fi

            # ssd 500Gb temp control
            if [ $ssd_temp -gt $max_ssd_temp ] && [ $result_pwm -lt "250" ]; then
                result_pwm=255
            fi

            ;;
        *)
            result_pwm=$(( 255*$temp_case/$max_temp ))
            ;;
    esac
    echo "ssd_temp=$ssd_temp ssd_nvme_temp=$ssd_nvme_temp1 max_ssd_temp=$max_ssd_temp cpu=$temp_case max_temp=$max_temp fan=$speed_fan pwm=$result_pwm"
    # echo "$result_pwm" > $fan
    echo "$result_pwm" > $fan2

done

echo "255" > $fan
echo "255" > $fan2
