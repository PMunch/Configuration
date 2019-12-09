export QT_QPA_PLATFORMTHEME="qt5ct"
export EDITOR=/usr/bin/vim
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
# fix "xdg-open fork-bomb" export your preferred browser from here
export BROWSER=/usr/bin/vivaldi-stable
export PATH=/home/peter/.nimble/bin:$PATH
export PATH=/home/peter/Scripts:$PATH

if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx
fi
