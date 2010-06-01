#!/usr/bin/env sh

xmodmap ~/.xmodmap
unclutter -idle 1 -root -jitter 1 &
exec ck-launch-session xmonad
