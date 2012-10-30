#!/bin/sh

xrandr --output HDMI-0 --off

sudo /home/surface/Downloads/SurfaceRacer/polytracker/polytracker > /dev/null &
TP=$!

sleep 2

/home/surface/Downloads/SurfaceRacer/application.linux32/SurfaceRacer > /dev/null &
PP=$!

/usr/bin/sudo wminput --config /home/surface/Downloads/SurfaceRacer/wiimote.conf --reconnect --wait &
WPA=$!

sleep 15

/usr/bin/sudo wminput --config /home/surface/Downloads/SurfaceRacer/wiimote2.conf --reconnect --wait &
WPB=$!

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

