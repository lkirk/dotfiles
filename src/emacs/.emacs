;;
;; emacs init file
;;

;; define function to shutdown emacs server instance
(defun ss()
  "Save buffers, Quit, and Shutdown (kill) server"
  (interactive)
  (save-some-buffers)
  (kill-emacs))

;; setup melpa
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

;; set up some defaults
(ido-mode t)
(setq inhibit-splash-screen t) 
(setq make-backup-files nil)   ;; no ~ files
(load-theme 'cyberpunk t)
(set-display-table-slot standard-display-table 'wrap ?\ )
(setq inferior-lisp-program "/usr/bin/sbcl")
(setq slime-contribs '(slime-fancy))

;; evil mode settings
(require 'evil)
(evil-mode 1)
(setq evil-insert-state-cursor '"box")

;; keyboard settings
(defun select-next-window ()
  "Switch to the next window with M-`"
  (interactive)
  (select-window (next-window)))

(global-set-key (kbd "M-`") 'select-next-window)
(global-set-key (kbd "C-x c") 'comment-region)
(global-set-key (kbd "C-x C") 'uncomment-region)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (cyberpunk)))
 '(custom-safe-themes
   (quote
    ("f0a99f53cbf7b004ba0c1760aa14fd70f2eabafe4e62a2b3cf5cabae8203113b" default)))
 '(fringe-mode 0 nil (fringe))
 '(line-number-mode nil)
 '(menu-bar-mode nil)
 '(scroll-bar-mode nil)
 '(tool-bar-mode nil)
 '(tooltip-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Ubuntu Mono" :foundry "DAMA" :slant normal :weight normal :height 90 :width normal)))))
