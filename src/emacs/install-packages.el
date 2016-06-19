(require 'package)

(setq package-list '(evil cyberpunk-theme haskell-mode slime
			  jedi magit evil-magit dockerfile-mode systemd))

(add-to-list 'package-archives
	     '("melpa" . "http://melpa.milkbox.net/packages/") t)

(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))
