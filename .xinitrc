#!/bin/sh
#       _       _ _            
# __  _(_)_ __ (_) |_ _ __ ___ 
# \ \/ / | '_ \| | __| '__/ __|
#  >  <| | | | | | |_| | | (__ 
# /_/\_\_|_| |_|_|\__|_|  \___|

# merge in defaults and keymaps
userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap


if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# Load british keymap and set caps to escape
setxkbmap gb
setxkbmap -option ctrl:nocaps
xcape -e 'Control_L=Escape'

# Load fonts
xset +fp /usr/share/fonts/local

# Set nice background
nitrogen --restore

# Load compositor
picom --experimental-backends &

# Set nice pointer cursor.
xsetroot -cursor_name left_ptr &
unclutter &

# Run dunst in background
dunst &

# Load trayer and polybar
polybar mybar --config=~/.config/polybar/config &
trayer --edge top --align right --height 15 --width 5 --iconspacing 5 &

pa-applet &
nm-applet &

exec dbus-launch --exit-with-session emacs -mm --debug-init
