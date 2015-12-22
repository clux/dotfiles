define green
	@[ -n "$TERM" ] && tput setaf 2
	@echo -n "$1"
	@[ -n "$TERM" ] && tput sgr0
	@echo -e "\t$2"
endef
define red
	@[ -n "$TERM" ] && tput setaf 1
	@echo -n "$1"
	@[ -n "$TERM" ] && tput sgr0
	@echo -e "\t$2"
endef


.PHONY: config ui etc directories sublime help font has_font guake
.PHONY: debkeyboard has_etc_keyboard

help:
	@tput bold
	$(call green,"Valid targets:")
	$(call green," config", "symlink configuration files to ~/")
	$(call green," ui", "set gconf and dconf settings")
	$(call green," etc", "echo install /etc files")

has_etc_keyboard:
	$(call green, "Guarding on debian /etc/default/keyboard")
	[ -f /etc/default/keyboard ]

debkeyboard: has_etc_keyboard
	$(call red," etc","Setting default keyboard")
	@sed -i.bak 's/XKBVARIANT=.*/XKBVARIANT="colemak"/' /etc/default/keyboard
	@diff /etc/default/keyboard.bak /etc/default/keyboard || true

etc:
	$(call red," etc","Updating motd")
	@cp etc/profile.d/motd.sh /etc/profile.d/
	$(call red," pam","Disabling mail notification via ssh")
	@sed -i.bak "s/.*pam_mail.so.*//" /etc/pam.d/sshd
	@diff /etc/pam.d/sshd.bak /etc/pam.d/sshd || true

directories:
	@mkdir -p ~/.config/sublime-text-3/Packages
	@mkdir -p ~/.config/autostart
	@mkdir -p ~/.config/profanity
	@mkdir -p ~/.templates/npm

sublime:
	$(call red, "Linking User package in sublime-text-3")
	@ln -s "$$PWD/.config/sublime-text-3/Packages/User" ~/.config/sublime-text-3/Packages/User

config: directories
	$(call green, "Linking .files to ~/")
	@find "$$PWD" -name ".*" -not -name ".gitignore" -type f -print -exec ln -sfn {} ~/ \;
	$(call green, "Linking .config to ~/.config")
	@find "$$PWD/.config" -maxdepth 1 -type f -print -exec ln -sfn {} ~/.config \;
	$(call green, "Linking .templates to ~/.templates")
	@find "$$PWD/.templates/npm" -maxdepth 1 -type f -print -exec ln -sfn {} ~/.templates/npm \;
	$(call green, "Linking .config/autostart to ~/.config/autostart")
	@find "$$PWD/.config/autostart" -maxdepth 1 -type f -print -exec ln -sfn {} ~/.config/autostart \;
	$(call green, "Linking .config/profanity to ~/.config/profanity")
	@find "$$PWD/.config/profanity" -maxdepth 1 -type f -print -exec ln -sfn {} ~/.config/profanity \;
	@[ -d ~/.config/sublime-text-3/Packages/User ] || make sublime

has_font:
	$(call green, "Guarding on Liberations font presence")
	@find /usr/share/fonts/TTF/ | grep -q Liberation
font: has_font
	$(call green, "Setting cinnamon font settings")
	@gsettings set org.cinnamon.desktop.interface font-name 'Liberation Sans 9'
	@gsettings set org.nemo.desktop font 'Liberation Serif 9'
	@gsettings set org.gnome.desktop.interface document-font-name 'Liberation Sans 9'
	@gsettings set org.cinnamon.desktop.wm.preferences titlebar-font 'Liberation Sans Bold 10'
	@gsettings set org.gnome.desktop.interface monospace-font-name 'Liberation Mono 11'
	@gsettings set org.cinnamon.settings-daemon.plugins.xsettings hinting 'slight'

gconf:
	$(call green, "Setting guake style")
	@gconftool-2 --set /apps/guake/style/background/transparency 20 --type int
	@gconftool-2 --set /apps/guake/style/font/style "Monospace 16" --type string
	@gconftool-2 --set /apps/guake/general/use_default_font false --type bool
	@gconftool-2 --set /apps/guake/general/history_size 8000 --type int
	@gconftool-2 --set /apps/guake/general/use_trayicon false --type bool
	@gconftool-2 --set /apps/guake/general/use_popup false --type bool
	@gconftool-2 --set /apps/guake/general/mouse_display false --type bool
	@gconftool-2 --set /apps/guake/general/prompt_on_quit false --type bool
	@gconftool-2 --set /apps/guake/general/window_height 60 --type int
	@gconftool-2 --set /apps/guake/general/window_tabbar false --type bool
	@gconftool-2 --set /apps/guake/general/window_ontop false --type bool
	$(call green, "Setting guake keybindings")
	@gconftool-2 --set /apps/guake/keybindings/global/show_hide "F1" --type string
	@gconftool-2 --set /apps/guake/keybindings/local/toggle_fullscreen "F11" --type string
	@gconftool-2 --set /apps/guake/keybindings/local/new_tab "<Primary>t" --type string
	@gconftool-2 --set /apps/guake/keybindings/local/close_tab "<Primary>w" --type string
	@gconftool-2 --set /apps/guake/keybindings/local/rename_current_tab "<Control>F2" --type string
	@gconftool-2 --set /apps/guake/keybindings/local/previous_tab "<Primary>Left" --type string
	@gconftool-2 --set /apps/guake/keybindings/local/next_tab "<Primary>Right" --type string
	@gconftool-2 --set /apps/guake/keybindings/local/clipboard_copy "<Control><Shift>"c --type string
	@gconftool-2 --set /apps/guake/keybindings/local/clipboard_paste "<Control><Shift>v" --type string

dconf:
	$(call green, "Importing main dconf settings")
	dconf load /org/ < org.dconf

ui: gconf dconf
