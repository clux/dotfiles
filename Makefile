
SHELL := /bin/bash

define green
	@tput -T xterm setaf 2
	@echo -n "$1"
	@tput -T xterm sgr0
	@echo -e "\t$2"
endef
define red
	@tput -T xterm setaf 1
	@echo -n "$1"
	@tput -T xterm sgr0
	@echo -e "\t$2"
endef

# All targets herein are technically PHONY, but this rarely matters
# We list a few of them that MIGHT cause the `'target' is up to date` failure.
.PHONY: config ui sublime help font guake gconf dconf

help:
	@tput -T xterm bold
	$(call green,"Valid targets:")
	$(call green," config", "symlink configuration files to ~/")
	$(call green," ui", "set gconf and dconf settings")

directories:
	@mkdir -p ~/.config/{autostart,profanity,sublime-text-3/Packages}
	@mkdir -p ~/.templates/{npm,cargo,git/hooks}
	@mkdir -p ~/{.mpd/playlists,.ncmpcpp,Music}

sublime:
	$(call red, "Linking User package in sublime-text-3")
	@ln -s "$$PWD/.config/sublime-text-3/Packages/User" ~/.config/sublime-text-3/Packages/User

config: directories
	$(call green," ln","configs in \$$HOME")
	@find "$$PWD" -maxdepth 1 -name ".*" -not -name ".travis.yml" -type f -print -exec ln -sfn {} ~/ \;
	$(call green," ln","configs subdirs in \$$HOME")
	@for d in {.config{,/profanity},.templates/{npm,cargo,git/hooks},.ncmpcpp}; do\
		echo $$d; \
		find "$$PWD/$$d" -maxdepth 1 -type f -print -exec ln -sfn {} ~/$$d \; ; \
	done
	@[ -d ~/.config/sublime-text-3/Packages/User ] || make sublime

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
	@gconftool-2 --set /apps/guake/general/window_height_f 92 --type int
	@gconftool-2 --set /apps/guake/general/window_tabbar true --type bool
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

has_font:
	$(call green, "Guarding on Liberations font presence")
	@find /usr/share/fonts/ | grep -q Liberation

dconf: has_font
	$(call green, "Importing main dconf settings")
	@dconf load /org/ < org.dconf

ui: gconf dconf
