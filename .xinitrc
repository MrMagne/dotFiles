#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

xset m 3 1

#pcmanfm --daemon-mode &
#thunar --daemon &
urxvtd -q -f -o
#xscreensaver -log .xscreensaver.log -nosplash &
#pidgin &

## jack and alsa to jack bridge
#/home/archy/.jack_alsa.sh &

#use white appearance for openoffice/libreoffice
export SAL_USE_VCLPLUGIN=gen
#dbus-launch --sh-syntax --exit-with-session thunar --daemon &
########## awesome #####################
#export $(dbus-launch --sh-syntax --exit-with-session gnome-keyring-daemon -r -s --components=pkcs11,secrets,ssh,gpg,login)
export $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg,login)
#eval $(ssh-agent)
(sleep 2 && ~/bin/mount_sshfs) &
#/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
#exec ck-launch-session awesome
#exec ck-launch-session dbus-launch --sh-syntax --exit-with-session awesome

#exec dbus-launch --sh-syntax --exit-with-session awesome
exec awesome
########################################
#killall jackd
killall gnome-keyring-daemon
killall urxvtd

