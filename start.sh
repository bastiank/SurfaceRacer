#!/bin/sh

xrandr --output HDMI-0 --off

sudo /home/surfaceracer/SurfaceRacer/polytracker/polytracker > /dev/null &
TP=$!

sleep 2

/home/surfaceracer/SurfaceRacer/application.linux32/SurfaceRacer > /dev/null &
PP=$!


/usr/bin/sudo stdbuf -i 0 -o 0 -e 0 wminput --config /home/surfaceracer/SurfaceRacer/wiimote.conf --reconnect --wait > /tmp/wminput_$USER.tmp &
WPA=$!

while true; do
        RESULT=`tail -n 1 /tmp/wminput_$USER.tmp`;
        if [ "$RESULT" = "Ready." ]; then
                /usr/bin/sudo wminput --config /home/surfaceracer/SurfaceRacer/wiimote2.conf --reconnect --wait &
                WPB=$!
                break
        fi
        sleep 1
done


while true; do
	if [ -f /proc/$PP/exe ] 
	then
		sleep 1
	else
		sudo kill $TP
		sudo kill $WPA
		sudo kill $WPB
		xrandr --auto
		exit 0
	fi
done

