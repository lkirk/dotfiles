#+TITLE: README.md

This repo contains a unified set of dotfiles
  it will eventually contain a conditionally defined set of dotfiles

* Dexpendencies:

  - xmonad-contrib
  - xmonad
  - xmobar
  - emacs
  - tmux

* Dotfiles contained:
  
  - .Xresources
  - .tmux.conf
  - .emacs
  - .emacs.elc
  - .emacs.d/
  - .xmobarrc
  - .xmonad/
  - .zshrc


* TODO Make Contidional [0/6]
  - [ ] read operating system
  - [ ] read hostname as an alternative
  - [ ] shell script to modify file options
  - [ ] in particular, .zshrc needs to be conditionally copied
        into home dir
  - [ ] conditional copying script (shell)
  - [ ] or ve?

* TODO Theme selection [0/3]
  - [ ] find good themes (with modifications)
  - [ ] locate corresponding emacs themes
  - [ ] couple changing of emacs theme with xterm
