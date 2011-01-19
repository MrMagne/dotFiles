#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

#if which dbus-launch >/dev/null && test -z "$DBUS_SESSION_BUS_ADDRESS"; then
#       eval "$(dbus-launch --sh-syntax --exit-with-session)"
#fi

#nautilus -n &
#sleep 2
urxvtd -q -f -o
xscreensaver -log .xscreensaver.log -nosplash &
thunar --daemon &
########## awesome #####################
eval $(ssh-agent)
exec ck-launch-session dbus-launch awesome
########################################
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
