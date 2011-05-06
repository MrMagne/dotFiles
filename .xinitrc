#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

numlockx on

#pcmanfm --daemon-mode &
#thunar --daemon &
urxvtd -q -f -o
#xscreensaver -log .xscreensaver.log -nosplash &
#pidgin &

## jack and alsa to jack bridge
/home/archy/.jack_alsa.sh &

#use white appearance for openoffice/libreoffice
export SAL_USE_VCLPLUGIN=gen
#dbus-launch --sh-syntax --exit-with-session thunar --daemon &
#thunar --daemon &
########## awesome #####################
#export $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh)
#eval $(ssh-agent)
#(sleep 2 && ~/bin/mount_sshfs) &
#exec ck-launch-session awesome
exec ck-launch-session dbus-launch --sh-syntax --exit-with-session awesome
#exec awesome
########################################
killall jackd

killall urxvtd

