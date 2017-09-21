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
;;(set-display-table-slot standard-display-table 'wrap ?\ )


;; SLIME config
;; (setq inferior-lisp-program "/usr/bin/sbcl")

(setf slime-lisp-implementations
      `((sbcl    ("/usr/bin/sbcl"))
	(roswell ("/usr/bin/ros" "-L" "sbcl" "-Q" "-l" "~/.sbclrc" "run"))))
(setf slime-default-lisp 'roswell)
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


;;;;;C Editing;;;;;;;;

(setq c-default-style "k&r" c-basic-offset 4)
;; Enable helm-gtags-mode
(add-hook 'c-mode-hook 'helm-gtags-mode)
(add-hook 'c++-mode-hook 'helm-gtags-mode)
(add-hook 'asm-mode-hook 'helm-gtags-mode)

;; Set key bindings
(eval-after-load "helm-gtags"
  '(progn
     (define-key helm-gtags-mode-map (kbd "C-c j") 'helm-gtags-find-tag)
     (define-key helm-gtags-mode-map (kbd "C-c r") 'helm-gtags-find-rtag)
     (define-key helm-gtags-mode-map (kbd "C-c s") 'helm-gtags-find-symbol)
     (define-key helm-gtags-mode-map (kbd "C-c p") 'helm-gtags-parse-file)
     (define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
     (define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)
     (define-key helm-gtags-mode-map (kbd "C-c ,") 'helm-gtags-pop-stack)))

(require 'flymake-cppcheck)
(add-hook 'c-mode-hook 'flymake-cppcheck-load)
(add-hook 'c++-mode-hook 'flymake-cppcheck-load)
;; (add-hook 'c-mode-hook 'my-flymake-show-help)

;; (defun my-flymake-show-help ()
;;    (when (get-char-property (point) 'flymake-overlay)
;;      (let ((help (get-char-property (point) 'help-echo)))
;;        (if help (message "%s" help)))))



(defvar my-flymake-minor-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c n") 'flymake-goto-next-error)
    (define-key map (kbd "C-c N") 'flymake-goto-prev-error)
    (define-key map (kbd "C-c e") 'my-flymake-err-echo)
    map)
  "Keymap for my flymake minor mode.")

(defun my-flymake-err-at (pos)
  (let ((overlays (overlays-at pos)))
    (remove nil
            (mapcar (lambda (overlay)
                      (and (overlay-get overlay 'flymake-overlay)
                           (overlay-get overlay 'help-echo)))
                    overlays))))

(defun my-flymake-err-echo ()
  (message "%s" (mapconcat 'identity (my-flymake-err-at (point)) "\n")))

(defadvice flymake-goto-next-error (after display-message activate compile)
  (my-flymake-err-echo))

(defadvice flymake-goto-prev-error (after display-message activate compile)
  (my-flymake-err-echo))

(define-minor-mode my-flymake-minor-mode
  "Simple minor mode which adds some key bindings for moving to the next and previous errors.

Key bindings:

\\{my-flymake-minor-mode-map}"
  nil
  nil
  :keymap my-flymake-minor-mode-map)

;; Enable this keybinding (my-flymake-minor-mode) by default
;; Added by Hartmut 2011-07-05
(add-hook 'c-mode-hook 'my-flymake-minor-mode)




;; (eval-after-load "flymake-cppcheck"
;;   '(progn
;;      (local-set-key (kbd "C-c n") 'flymake-goto-next-error)
;;      (local-set-key (kbd "C-c N") 'flymake-goto-prev-error)
;;      (local-set-key (kbd "C-c e") 'my-flymake-err-echo)))

;; Enable all messages
;; (custom-set-variables
;;  '(flymake-cppcheck-enable "all"))

;; Example of limiting checks
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#000000" "#8b0000" "#00ff00" "#ffa500" "#7b68ee" "#dc8cc3" "#93e0e3" "#dcdccc"])
 '(custom-enabled-themes (quote (zenburn)))
 '(custom-safe-themes
   (quote
    ("67e998c3c23fe24ed0fb92b9de75011b92f35d3e89344157ae0d544d50a63a72" "4af6fad34321a1ce23d8ab3486c662de122e8c6c1de97baed3aa4c10fe55e060" "9d91458c4ad7c74cf946bd97ad085c0f6a40c370ac0a1cbeb2e3879f15b40553" "bcc6775934c9adf5f3bd1f428326ce0dcd34d743a92df48c128e6438b815b44f" "4e753673a37c71b07e3026be75dc6af3efbac5ce335f3707b7d6a110ecb636a3" "2eccc1073f44cf1e0da01e20f3e7954cdd003ec18abfb24302f2b40cf6c1a78d" "e8a976fbc7710b60b069f27f5b2f1e216ec8d228fe5091f677717d6375d2669f" "71ecffba18621354a1be303687f33b84788e13f40141580fa81e7840752d31bf" "f0a99f53cbf7b004ba0c1760aa14fd70f2eabafe4e62a2b3cf5cabae8203113b" default)))
 '(fci-rule-color "#383838")
 '(flymake-cppcheck-enable "warning,performance,style")
 '(flymake-mode-line-e-w t t)
 '(fringe-mode 0 nil (fringe))
 '(line-number-mode nil)
 '(menu-bar-mode nil)
 '(nrepl-message-colors
   (quote
    ("#CC9393" "#DFAF8F" "#F0DFAF" "#7F9F7F" "#BFEBBF" "#93E0E3" "#94BFF3" "#DC8CC3")))
 '(package-selected-packages
   (quote
    (cmake-font-lock cmake-ide flymake-cppcheck helm-gtags gandalf-theme go-eldoc go-autocomplete markdown-mode docker golint go-mode toml-mode hc-zenburn-theme zenburn-theme labburn-theme yaml-mode systemd slime simple-httpd rust-mode rainbow-mode powerline-evil nginx-mode jsx-mode json-mode js2-mode jedi haskell-mode evil-magit dockerfile-mode darktooth-theme cyberpunk-theme)))
 '(pdf-view-midnight-colors (quote ("#DCDCCC" . "#383838")))
 '(pos-tip-background-color "color-23")
 '(pos-tip-foreground-color "color-230")
 '(scroll-bar-mode nil)
 '(tool-bar-mode nil)
 '(tooltip-mode nil)
 '(vc-annotate-background "#2B2B2B")
 '(vc-annotate-color-map
   (quote
    ((20 . "#BC8383")
     (40 . "#CC9393")
     (60 . "#DFAF8F")
     (80 . "#D0BF8F")
     (100 . "#E0CF9F")
     (120 . "#F0DFAF")
     (140 . "#5F7F5F")
     (160 . "#7F9F7F")
     (180 . "#8FB28F")
     (200 . "#9FC59F")
     (220 . "#AFD8AF")
     (240 . "#BFEBBF")
     (260 . "#93E0E3")
     (280 . "#6CA0A3")
     (300 . "#7CB8BB")
     (320 . "#8CD0D3")
     (340 . "#94BFF3")
     (360 . "#DC8CC3"))))
 '(vc-annotate-very-old-color "#DC8CC3"))

;;;;;;C Editing;;;;;;;;;

;; golang
(add-hook 'go-mode-hook 'go-eldoc-setup)
(add-hook 'before-save-hook #'gofmt-before-save)

(require 'go-autocomplete)
(require 'auto-complete-config)
(ac-config-default)

(add-to-list 'load-path "/home/lkirk/repo/godev/src/github.com/golang/lint/misc/emacs")
(require 'golint)

(require 'powerline)
(powerline-default-theme)

(global-set-key (kbd "M-`") 'select-next-window)
(global-set-key (kbd "C-x c") 'comment-region)
(global-set-key (kbd "C-x C") 'uncomment-region)

;; useful for clearing out highlighting presets from xterm config
(set-face-attribute 'region nil :background "#666")


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((((class color) (min-colors 89)) (:foreground "#d3d3d3" :background "#000000" :family "Ubuntu Mono derivative Powerline" :foundry "DAMA" :slant normal :weight normal :height 98 :width normal)))))
