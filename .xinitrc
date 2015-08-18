#!/bin/sh
[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources
xset -b
VARS=$(start-desktop-session)
echo $VARS
export $VARS
urxvtd &
compton &
sleep 3
walls.pl &

conky -c $HOME/.config/dwm-conky.rc | while [ 1 ] ; do read out ; xsetroot -name "$out" ; done &
dwm
#xmonad
#enlightenment_start
killall conky
kill $(< $HOME/.walls.pid)
killall dbus-daemon
