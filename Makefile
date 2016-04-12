WD:=$(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
SHELL:=/usr/bin/zsh

DOTFILES:=$(shell find $(WD)/src -type f)

link-targets:=
define gen-link-targets
$(lastword $(subst :, ,$1)):
	ln -s $(firstword $(subst :, ,$1)) $$(@)
link-targets+=$(lastword $(subst :, ,$1))
endef

sudo-link-targets:=
define sudo-gen-link-targets
$(lastword $(subst :, ,$1)):
	sudo ln -s $(firstword $(subst :, ,$1)) $$(@)
sudo-link-targets+=$(lastword $(subst :, ,$1))
endef

to-symlink:=
to-symlink+=$(WD)/src/zsh/.zshrc:$(HOME)/.config/zsh/.zshrc
to-symlink+=$(WD)/src/xmonad/xmonad.hs:$(HOME)/.xmonad/xmonad.hs
to-symlink+=$(WD)/src/xmonad/.xmobarrc:$(HOME)/.xmobarrc
to-symlink+=$(WD)/src/x11/.xinitrc:$(HOME)/.xinitrc
to-symlink+=$(WD)/src/x11/.Xresources:$(HOME)/.Xresources
to-symlink+=$(WD)/src/emacs/.emacs:$(HOME)/.emacs

to-sudo-symlink:=
to-sudo-symlink+=$(WD)/src/x11/pointer/thinkpad-x61/20-trackpoint.conf:/etc/X11/xorg.conf.d/20-trackpoint.conf
to-sudo-symlink+=$(WD)/src/x11/keyboard/10-keyboard.conf:/etc/X11/xorg.conf.d/10-keyboard.conf


testing:
	@$(foreach f,$(to-symlink),$(info $(call gen-link-targets,$(f))))
	@$(foreach f,$(to-sudo-symlink),$(info $(call sudo-gen-link-targets,$(f))))

symlink-dotfiles: $(foreach f,$(to-symlink),$(eval $(call gen-link-targets,$(f))))
sudo-symlink-dotfiles: $(foreach f,$(to-sudo-symlink),$(eval $(call sudo-gen-link-targets,$(f))))
