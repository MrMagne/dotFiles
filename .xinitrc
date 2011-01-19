#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

numlockx on

#if which dbus-launch >/dev/null && test -z "$DBUS_SESSION_BUS_ADDRESS"; then
#       eval "$(dbus-launch --sh-syntax --exit-with-session)"
#fi
#pcmanfm --daemon-mode &
#thunar --daemon &
urxvtd -q -f -o

## jack and alsa to jack bridge
/home/archy/.jack_alsa.sh &

########## awesome #####################
exec ck-launch-session dbus-launch --sh-syntax --exit-with-session awesome
########################################
killall jackd
killall urxvtd

########## idesk+openbox ###############
#idesk &
#pypanel &
#exec ck-launch-session openbox-session
########################################

########### nautilus desktop ###########
#nautilus -n &
#lxpanel &
##rox -b Default -p default; 
#exec ck-launch-session openbox-session
########################################

#exec ck-launch-session openbox-session
# exec gnome-session
# exec startkde
# exec startxfce4
# ...or the Window Manager of your choice
