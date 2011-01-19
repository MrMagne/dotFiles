#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

numlockx on

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

