
SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

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
.PHONY: config ui sublime vim help guake dconf

help:
	@tput -T xterm bold
	$(call green,"Main targets:")
	$(call green," config", "symlink configuration files to ~/")
	$(call green," ui", "set dconf settings")
	$(call green," editors", "configure sublime and vim")

directories:
	@mkdir -p ~/.config/{autostart,profanity,sublime-text-3/{Local,Packages}}
	@mkdir -p ~/.templates/{npm,cargo,git/hooks}
	@mkdir -p ~/{.mpd/playlists,.ncmpcpp,.jira.d,Music}

sublime_ln:
	$(call red, "Linking User package in sublime-text-3")
	@ln -s "$$PWD/.config/sublime-text-3/Packages/User" ~/.config/sublime-text-3/Packages/User
sublime_license:
	$(call red, "Decrypting sublime license")
	@pass sublime > ~/.config/sublime-text-3/Local/License.sublime_license
sublime: sublime_ln sublime_license

vim:
	$(call green," installing vim plugins")
	@[ -f ~/.vim/autoload/plug.vim ] && vim +PlugUpdate +qall

config: directories
	$(call green," ln","configs in \$$HOME")
	@find "$$PWD" -maxdepth 1 -name ".*" -not -name ".travis.yml" -type f -print -exec ln -sfn {} ~/ \;
	$(call green," ln","configs subdirs in \$$HOME")
	@for d in {.config{,/profanity,/alacritty},.templates/{npm,cargo,git/hooks},.ncmpcpp,.jira.d}; do\
		echo $$d; \
		find "$$PWD/$$d" -maxdepth 1 -type f -print -exec ln -sfn {} ~/$$d \; ; \
	done
	@touch ~/.bash_completion

editors: directories
	$(call green," configuring sublime and installing vim plugins")
	@[ -d ~/.config/sublime-text-3/Packages/User ] || make sublime
	@[ -f ~/.config/sublime-text-3/Local/License.sublime_license ] || make sublime_license
	@[ -d ~/.vim/plugged ] || make vim

has_fonts:
	$(call green, "Guarding on Liberations + powerline font presence")
	@find /usr/share/fonts/ | grep -q Liberation
	#@find ~/.local/share/fonts/ | grep -q Powerline
	@find /usr/share/fonts/ | grep -q Powerline

dconf: has_fonts
	$(call green, "Importing dconf settings")
	@dconf load /org/ < org.dconf
	@dconf load /apps/ < apps.dconf

ui: dconf

lint:
	docker run \
    -e SHELLCHECK_OPTS="-e SC1091 -e SC1090 -e SC1117 -s bash" \
    -v $$PWD:/volume -w /volume \
    -t koalaman/shellcheck:stable \
      .aliases .exports .bashrc .bash_completion .bash_profile .path .prompt .functions .xprofile
