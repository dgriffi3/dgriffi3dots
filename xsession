#!/usr/bin/env sh

xmodmap ~/.xmodmap
unclutter -idle 1 -root &
exec ck-launch-session xmonad
