redb = "\033[1;31m"$1"\033[0m"
greenb = "\033[1;32m"$1"\033[0m"
green = "\033[0;32m"$1"\033[0m"
red = "\033[0;31m"$1"\033[0m"
yellow = "\033[0;33m"$1"\033[0m"
whiteb = "\033[1;37m"$1"\033[0m"

.PHONY: config ui etc directories help

help:
	@echo $(call greenb,"Please use make <target>' where <target> is one of:")
	@echo $(call green," config")"   symlink configuration files to ~/"
	@echo $(call green," ui")"       set gconf and dconf settings"
	@echo $(call green," etc")"      install /etc files"

directories:
	@mkdir -p ~/.config/sublime-text-3/Packages
	@mkdir -p ~/.config/autostart
	@mkdir -p ~/.templates/npm

sublime:
	@echo  $(call yellow," Linking User package in sublime-text-3")
	@ln -s "$$PWD/.config/sublime-text-3/Packages/User" ~/.config/sublime-text-3/Packages/User

config: directories
	@echo  $(call green," Linking .files to ~/")
	@find "$$PWD" -name ".*" -not -name ".gitignore" -type f -print -exec ln -sfn {} ~/ \;
	@echo  $(call green," Linking .config to ~/.config")
	@find "$$PWD/.config" -maxdepth 1 -type f -print -exec ln -sfn {} ~/.config \;
	@echo  $(call green," Linking .templates to ~/.templates")
	@find "$$PWD/.templates/npm" -maxdepth 1 -type f -print -exec ln -sfn {} ~/.templates/npm \;
	@echo  $(call green," Linking .config/autostart to ~/.config/autostart")
	@find "$$PWD/.config/autostart" -maxdepth 1 -type f -print -exec ln -sfn {} ~/.config/autostart \;
	@[ -d ~/.config/sublime-text-3/Packages/User ] || make sublime

ui:
	@echo  $(call green," Setting guake style")
	@gconftool-2 --set /apps/guake/style/background/transparency 20 --type int
	@gconftool-2 --set /apps/guake/style/font/style "Monospace 16" --type string
	@gconftool-2 --set /apps/guake/general/use_default_font false --type bool
	@gconftool-2 --set /apps/guake/general/history_size 8000 --type int
	@gconftool-2 --set /apps/guake/general/use_trayicon false --type bool
	@gconftool-2 --set /apps/guake/general/use_popup false --type bool
	@gconftool-2 --set /apps/guake/general/prompt_on_quit false --type bool
	@gconftool-2 --set /apps/guake/general/window_height 60 --type int
	@gconftool-2 --set /apps/guake/general/window_tabbar false --type bool
	@gconftool-2 --set /apps/guake/general/window_ontop false --type bool
	@echo  $(call green," Setting guake keybindings")
	@gconftool-2 --set /apps/guake/keybindings/global/show_hide "F1" --type string
	@gconftool-2 --set /apps/guake/keybindings/local/toggle_fullscreen "F11" --type string
	@gconftool-2 --set /apps/guake/keybindings/local/new_tab "<Primary>t" --type string
	@gconftool-2 --set /apps/guake/keybindings/local/close_tab "<Primary>w" --type string
	@gconftool-2 --set /apps/guake/keybindings/local/previous_tab "<Primary>Left" --type string
	@gconftool-2 --set /apps/guake/keybindings/local/next_tab "<Primary>Right" --type string
	@gconftool-2 --set /apps/guake/keybindings/local/clipboard_copy "<Control><Shift>"c --type string
	@gconftool-2 --set /apps/guake/keybindings/local/clipboard_paste "<Control><Shift>v" --type string
	@echo  $(call green," Setting cinnamon settings")
	@gsettings set org.cinnamon desktop-effects false
	@gsettings set org.cinnamon.settings-daemon.peripherals.touchpad scroll-method 'two-finger-scrolling'
	@gsettings set org.cinnamon.settings-daemon.peripherals.touchpad tap-to-click false

etc:
	@echo $(call red, " overwriting files in /etc")
