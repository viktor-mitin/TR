#!/bin/sh

move_window ()
{
#    for i in {1..5} #bash only loop (not sh)
    for i in $(seq 7)
    do
        wmctrl -r "$1" -t"$2" && return 0
        sleep 1
        echo "Sleep for 1 second, attempt #$i"
    done

	STR="ERROR: Cannot move window $1 to desktop $2"
    echo "$STR" #for log file output
    notify-send -t 0 "$STR"
}


pkill google #|| echo "cannot pkill google"
pkill chrome #|| echo "cannot pkill chrome"
sleep 3

~/w/TR/TR_aws_login.py &

sleep 15
#pkill google || echo "cannot pkill google"
#
#sleep 3
#google-chrome &

move_window Google 8
