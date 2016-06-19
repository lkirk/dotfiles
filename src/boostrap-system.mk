# this makefile is designed to create a single harddrive, single user arch system
# from 0 to full system, reboot to xmonad and fun times
# WARNING: DANGER: your partition table will be overwritten immediately upon running

# you must specify USER and DISK on the command line like so:
# 	make bootstrap-system USER=your-username DISK=/dev/to/be/destroyed

DISK:=
USER:=

ifndef DISK
$(error no DISK specified)
endif

ifndef USER
$(error no USER specified)
endif

LINUX_FS:=8300
LINUX_LVM:=8e00
ALIGNMENT:=4096

BOOT_PARTITION:=$(DISK)1
LVM_PARTITION:=$(DISK)2

ARCH-CHROOT:=arch-chroot /mnt
ARCH-CHROOT-AS-USER:=$(ARCH-CHROOT) su $(USER) -c

DOTFILES-REPO:=https://www.github.com/lloydkirk/dotfiles
GITHUB-USERNAME:=lloydkirk
GITHUB-EMAIL:=kirklloyd@gmail.com

HOSTNAME:=twix

partition-physical-disk:
	sgdisk -Z "$(DISK)" #zap disk
	sgdisk -g "$(DISK)" #gpt setup
	sgdisk -a$(ALIGNMENT) -n0:0:+200M -t0:$(LINUX_FS) -c0:"boot" "$(DISK)"
	sgdisk -a$(ALIGNMENT) -n0:0:0 -t0:$(LINUX_LVM) -c0:"lvm" "$(DISK)"
	sgdisk -p "$(DISK)"

create-luks-container:
	cryptsetup luksFormat $(LVM_PARTITION)
	cryptsetup luksOpen $(LVM_PARTITION) lvm

partition-luks-container:
	pvcreate /dev/mapper/lvm
	vgcreate brain /dev/mapper/lvm
	lvcreate -L 6G brain -n swap
	lvcreate -L 15G brain -n root
	lvcreate -l 100%FREE brain -n home

format-virtual-partitions:
	mkfs.ext4 /dev/mapper/brain-root
	mkfs.ext4 /dev/mapper/brain-home
	mkswap /dev/mapper/brain-swap

mount-virtual-partitions:
	mount /dev/mapper/brain-root /mnt
	mkdir /mnt/home
	mount /dev/mapper/brain-home /mnt/home
	swapon /dev/mapper/brain-swap

format-physical-boot-partition:
	mkfs.ext4 $(BOOT_PARTITION)
	mkdir /mnt/boot
	mount $(BOOT_PARTITION) /mnt/boot

pacstrap-base-devel:
	wifi-menu
	pacstrap /mnt base base-devel

configure-system: ## can be run multiple times, can be used to refresh the fstab
	echo -e '# \n# /etc/fstab: static file system information\n#\n# <file system>	<dir>	<type>	<options>	<dump>	<pass>\n' > /mnt/etc/fstab
	genfstab -U /mnt >> /mnt/etc/fstab
	[ -f /mnt/etc/localtime ] || ln -s /usr/share/zoneinfo/UTC /mnt/etc/localtime
	sed -i -e's/^#\(en_US.UTF-8\)/\1/' /mnt/etc/locale.gen
	echo 'LANG=en_US.UTF-8' > /mnt/etc/locale.conf
	echo $(HOSTNAME) > /mnt/etc/hostname
	egrep '^HOOK.*encrypt lvm' /mnt/etc/mkinitcpio.conf \
		|| sed -i -r -e's/(^HOOKS=.*)(filesystems)/\1encrypt lvm2 \2/' /mnt/etc/mkinitcpio.conf
	$(ARCH-CHROOT) locale-gen
	$(ARCH-CHROOT) mkinitcpio -p linux

install-packages:
	$(ARCH-CHROOT) pacman -S \
		sudo syslinux gdisk cabal-install \
		git mercurial curl wget ghc sbcl docker \
		zsh grml-zsh-config htop xterm emacs vim \
		chromium \
		networkmanager wpa_supplicant dialog openssh\
		xorg-server xorg-server-utils xorg-xinit \
		xf86-video-intel xf86-video-fbdev xf86-video-vesa \
		ttf-ubuntu-font-family terminus-font \
		mplayer alsa-utils rtorrent

make-user:
	$(ARCH-CHROOT) useradd --create-home --shell /usr/bin/zsh $(USER)
	$(ARCH-CHROOT) passwd $(USER)
	$(ARCH-CHROOT) passwd root
	$(ARCH-CHROOT) groupadd sudo
	$(ARCH-CHROOT) usermod -a -G sudo $(USER)
	$(ARCH-CHROOT-AS-USER) 'mkdir -p /home/$(USER)/repo'
	$(ARCH-CHROOT-AS-USER) 'git config --global user.name $(GITHUB-USERNAME)'
	$(ARCH-CHROOT-AS-USER) 'git config --global user.email $(GITHUB-EMAIL)'
	$(ARCH-CHROOT-AS-USER) 'cabal update'
	$(ARCH-CHROOT-AS-USER) 'cabal install x11 xmonad xmonad-contrib xmobar'
	$(ARCH-CHROOT-AS-USER) 'rm /home/$(USER)/.zshrc' # remove grml stock .zshrc
	$(ARCH-CHROOT) pacman -Rns ca-certificates
	$(ARCH-CHROOT) pacman -S ca-certificates
	$(ARCH-CHROOT-AS-USER) 'git clone $(DOTFILES-REPO) /home/$(USER)/repo/dotfiles'
	$(ARCH-CHROOT-AS-USER) 'rm /home/$(USER)/.gitconfig'
	echo '%sudo ALL=(ALL) NOPASSWD: ALL' >> /mnt/etc/sudoers
	$(ARCH-CHROOT-AS-USER) 'make -f /home/$(USER)/repo/dotfiles/Makefile install'
	sed -i -e'/^%sudo ALL=(ALL) NOPASSWD: ALL/d' /mnt/etc/sudoers
	sed -i -e's/# \(%sudo ALL=$(ALL) ALL\)/\1/' /mnt/etc/sudoers
	$(ARCH-CHROOT) mkdir /mnt/$(USER)
	$(ARCH-CHROOT) chown '$(USER):$(USER)' /mnt/$(USER)
	$(ARCH-CHROOT) systemctl enable NetworkManager
	$(ARCH-CHROOT-AS-USER) systemctl --user enable ssh-agent.service
	$(ARCH-CHROOT-AS-USER) systemctl --user enable emacs.service
	$(ARCH-CHROOT-AS-USER) 'ssh-keygen -f /home/lkirk/.ssh/$(HOSTNAME) -N ""'

configure-emacs:
	$(ARCH-CHROOT-AS-USER) 'emacs -Q --script /home/$(USER)/repo/dotfiles/src/emacs/install-packages.el'

install-yaourt:
	echo '%sudo ALL=(ALL) NOPASSWD: ALL' >> /mnt/etc/sudoers
	$(ARCH-CHROOT-AS-USER) "git clone 'https://aur.archlinux.org/package-query.git' /home/$(USER)/repo/package-query"
	$(ARCH-CHROOT-AS-USER) 'cd /home/$(USER)/repo/package-query && makepkg -si'
	$(ARCH-CHROOT-AS-USER) "git clone 'https://aur.archlinux.org/yaourt.git' /home/$(USER)/repo/yaourt"
	$(ARCH-CHROOT-AS-USER) 'cd /home/$(USER)/repo/yaourt && makepkg -si'
	sed -i -e'/^%sudo ALL=(ALL) NOPASSWD: ALL/d' /mnt/etc/sudoers
	$(ARCH-CHROOT-AS-USER) 'rm -rf /home/$(USER)/repo/yaourt && rm -rf /home/$(USER)/repo/package-query'

install-bootloader:
	$(ARCH-CHROOT) syslinux-install_update -i -a -m
	sed -i -e's/\(APPEND root\).\+/APPEND root=UUID=$(shell lsblk -f -r | awk '$$1=="brain-root"{print $$3}') cryptdevice=UUID=$(shell lsblk -f -r | awk '$$2=="crypto_LUKS"{print $$3}'):lvm rw/' /mnt/boot/syslinux/syslinux.cfg

bootstrap-system: partition-physical-disk create-luks-container partition-luks-container format-virtual-partitions mount-virtual-partitions format-physical-boot-partition pacstrap-base-devel configure-system install-packages make-user configure-emacs install-yaourt install-bootloader
