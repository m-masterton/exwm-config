#!/bin/sh

nitrogen --restore &
picom &
setxkbmap gb
exec dbus-launch --exit-with-session emacs -mm --debug-init
