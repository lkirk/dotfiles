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
(setq initial-scratch-message "")
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


(require 'powerline)
(powerline-default-theme)

(global-set-key (kbd "M-`") 'select-next-window)
(global-set-key (kbd "C-x c") 'comment-region)
(global-set-key (kbd "C-x C") 'uncomment-region)

;; useful for clearing out highlighting presets from xterm config
(set-face-attribute 'region nil :background "#666")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#000000" "#8b0000" "#00ff00" "#ffa500" "#7b68ee" "#dc8cc3" "#93e0e3" "#dcdccc"])
 '(custom-enabled-themes (quote (darktooth)))
 '(custom-safe-themes
   (quote
    ("e8a976fbc7710b60b069f27f5b2f1e216ec8d228fe5091f677717d6375d2669f" "71ecffba18621354a1be303687f33b84788e13f40141580fa81e7840752d31bf" "f0a99f53cbf7b004ba0c1760aa14fd70f2eabafe4e62a2b3cf5cabae8203113b" default)))
 '(fci-rule-color "#383838")
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
