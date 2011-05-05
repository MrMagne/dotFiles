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
#pidgin &

#use white appearance for openoffice/libreoffice
export SAL_USE_VCLPLUGIN=gen
#dbus-launch --sh-syntax --exit-with-session thunar --daemon &
#thunar --daemon &
########## awesome #####################
#export $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh)
eval $(ssh-agent)
#(sleep 2 && ~/bin/mount_sshfs) &
#exec ck-launch-session awesome
exec ck-launch-session dbus-launch --sh-syntax --exit-with-session awesome
#exec awesome
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
