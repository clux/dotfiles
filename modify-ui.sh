#!/bin/sh

# guake style
gconftool-2 --set /apps/guake/style/background/transparency 20 --type int
gconftool-2 --set /apps/guake/style/font/style "Monospace 16" --type string
gconftool-2 --set /apps/guake/general/use_default_font false --type bool
gconftool-2 --set /apps/guake/general/history_size 8000 --type int
gconftool-2 --set /apps/guake/general/use_trayicon false --type bool
gconftool-2 --set /apps/guake/general/use_popup false --type bool
gconftool-2 --set /apps/guake/general/prompt_on_quit false --type bool
gconftool-2 --set /apps/guake/general/window_height 60 --type int
gconftool-2 --set /apps/guake/general/window_tabbar false --type bool
gconftool-2 --set /apps/guake/general/window_ontop false --type bool

# guake keybindings
gconftool-2 --set /apps/guake/keybindings/global/show_hide "F1" --type string
gconftool-2 --set /apps/guake/keybindings/local/toggle_fullscreen "F11" --type string
gconftool-2 --set /apps/guake/keybindings/local/new_tab "<Primary>t" --type string
gconftool-2 --set /apps/guake/keybindings/local/close_tab "<Primary>w" --type string
gconftool-2 --set /apps/guake/keybindings/local/previous_tab "<Primary>Left" --type string
gconftool-2 --set /apps/guake/keybindings/local/next_tab "<Primary>Right" --type string
gconftool-2 --set /apps/guake/keybindings/local/clipboard_copy "<Control><Shift>"c --type string
gconftool-2 --set /apps/guake/keybindings/local/clipboard_paste "<Control><Shift>v" --type string

# maybe do:
#/desktop/gnome/accessibility/keyboard
#/desktop/gnome/sound:
#/desktop/gnome/peripherals/mouse:

# cinnamon effects
gsettings set org.cinnamon desktop-effects false
