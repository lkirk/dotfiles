WD:=$(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
SHELL:=/usr/bin/zsh

#.PHONY:=install symlink-dotfiles sudo-symlink-dotfiles

install:
	$(MAKE) -f <($(MAKE) -f $(abspath $(lastword $(MAKEFILE_LIST))) testing) $$($(MAKE) -f $(abspath $(lastword $(MAKEFILE_LIST))) testing | grep -v 'is up to date' | grep -v 'make' | grep ':' | sed -e's/://' | xargs)

link-targets:=
define gen-link-targets
$(lastword $(subst :, ,$1)):
	mkdir -p $$(dirname $$(@))
	ln -s $(firstword $(subst :, ,$1)) $$(@)
link-targets+=$(lastword $(subst :, ,$1))
endef

hard-link-targets:=
define gen-hard-link-targets
$(lastword $(subst :, ,$1)):
	mkdir -p $$(dirname $$(@))
	ln -P $(firstword $(subst :, ,$1)) $$(@)
link-targets+=$(lastword $(subst :, ,$1))
endef

sudo-link-targets:=
define sudo-gen-link-targets
$(lastword $(subst :, ,$1)):
	sudo mkdir -p $$(dirname $(@))
	sudo ln -s $(firstword $(subst :, ,$1)) $$(@)
sudo-link-targets+=$(lastword $(subst :, ,$1))
endef

to-symlink:=
to-symlink+=$(WD)/src/zsh/.zshenv:$(HOME)/.zshenv
to-symlink+=$(WD)/src/zsh/.zlogin:$(HOME)/.config/zsh/.zlogin
to-symlink+=$(WD)/src/zsh/.zshrc:$(HOME)/.config/zsh/.zshrc
to-symlink+=$(WD)/src/zsh/.zprofile:$(HOME)/.config/zsh/.zprofile
to-symlink+=$(WD)/src/xmonad/xmonad.hs:$(HOME)/.xmonad/xmonad.hs
to-symlink+=$(WD)/src/xmonad/.xmobarrc:$(HOME)/.xmobarrc
to-symlink+=$(WD)/src/x11/.xinitrc:$(HOME)/.xinitrc
to-symlink+=$(WD)/src/x11/.Xresources:$(HOME)/.Xresources
to-symlink+=$(WD)/src/emacs/.emacs:$(HOME)/.emacs
to-symlink+=$(WD)/src/git/.gitconfig:$(HOME)/.gitconfig

to-hardlink:=
to-hardlink+=$(WD)/src/systemd/ssh-agent.service:$(HOME)/.config/systemd/user/ssh-agent.service
to-hardlink+=$(WD)/src/systemd/emacs.service:$(HOME)/.config/systemd/user/emacs.service

to-sudo-symlink:=
to-sudo-symlink+=$(WD)/src/x11/pointer/thinkpad-x61/20-trackpoint.conf:/etc/X11/xorg.conf.d/20-trackpoint.conf
to-sudo-symlink+=$(WD)/src/x11/keyboard/10-keyboard.conf:/etc/X11/xorg.conf.d/10-keyboard.conf

testing:
	@$(foreach f,$(to-symlink),$(info $(call gen-link-targets,$(f))))
	@$(foreach f,$(to-sudo-symlink),$(info $(call sudo-gen-link-targets,$(f))))
	@$(foreach f,$(to-hardlink),$(info $(call hard-link-targets,$(f))))

symlink-dotfiles: $(foreach f,$(to-symlink),$(eval $(call gen-link-targets,$(f))))
hard-link-dotfiles: $(foreach f,$(to-hardlink),$(eval $(call hard-link-targets,$(f))))
sudo-symlink-dotfiles: $(foreach f,$(to-sudo-symlink),$(eval $(call sudo-gen-link-targets,$(f))))

DISK:=
USER:=
bootstrap-system:
	$(MAKE) -f $(WD)/src/bootstrap-system.mk DISK=$(DISK) USER=$(USER)
