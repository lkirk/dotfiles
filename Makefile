WD:=$(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
SHELL:=/bin/bash

DOTFILES:=$(shell find $(WD)/src -type f)

_print_vars:
	@echo $(WD)/src/zsh/.zshrc $(HOME)/.config/zsh/.zshrc
	@echo $(WD)/src/xmonad/xmonad.hs $(HOME)/.xmonad/xmonad.hs
	@echo $(WD)/src/xmonad/.xmobarrc $(HOME)/.xmobarrc
	@echo $(WD)/src/x11/.xinitrc $(HOME)/.xinitrc
	@echo $(WD)/src/x11/pointer/thinkpad-x61/20-trackpoint.conf /etc/X11/xorg.conf.d
	@echo $(WD)/src/x11/keyboard/10-keyboard.conf /etc/X11/xorg.conf.d
	@echo $(WD)/src/x11/.Xresources $(HOME)/.Xresources
	@echo $(WD)/src/emacs/.emacs $(HOME)/.emacs

symlink:	
	ln -s $(WD)/src/zsh/.zshrc $(HOME)/.config/zsh/.zshrc
	ln -s $(WD)/src/xmonad/xmonad.hs $(HOME)/.xmonad/xmonad.hs
	ln -s $(WD)/src/xmonad/.xmobarrc $(HOME)/.xmobarrc
	ln -s $(WD)/src/x11/.xinitrc $(HOME)/.xinitrc
	sudo ln -s $(WD)/src/x11/pointer/thinkpad-x61/20-trackpoint.conf /etc/X11/xorg.conf.d
	sudo ln -s $(WD)/src/x11/keyboard/10-keyboard.conf /etc/X11/xorg.conf.d
	ln -s $(WD)/src/x11/.Xresources $(HOME)/.Xresources
	ln -s $(WD)/src/emacs/.emacs $(HOME)/.emacs
