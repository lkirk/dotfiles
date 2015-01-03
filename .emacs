;;---------------;;
; EMACS INIT FILE ;
;;---------------;;


;;------------------------;;
; SERVER SHUTDOWN FUNCTION ;
;;------------------------;;

;; define function to shutdown emacs server instance
(defun ss()
  "Save buffers, Quit, and Shutdown (kill) server"
  (interactive)
  (save-some-buffers)
  (kill-emacs)
  )

;;------------------------;;
; MELPA PACKAGE MANAGEMENT ;
;;------------------------;;

(require 'package)
  (package-initialize)
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)

(add-to-list 'custom-theme-load-path "~/.emacs.d/elpa/cyberpunk-theme-20140319.1853/cyberpunk-theme.el")

(load-theme 'cyberpunk t)

;;-----;;
;  ESS  ;
;;-----;;

;;(require 'ess-site)

;;--------;;
; ORG MODE ;
;;--------;;

(require 'org)
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)

;;---------;;
; I DO MODE ;
;;---------;;

(ido-mode t)

;;-----------------;;
;  TURN OFF SPLASH  ;
;;-----------------;;

(setq inhibit-splash-screen t)

;;---------------------------;;
;  TURN OFF BACKUP (~) FILES  ;
;;---------------------------;;

(setq make-backup-files nil)

;;---------------------;;
;; SAVE AS KEY COMMAND ;;
;;---------------------;;

(global-set-key (kbd "C-x C-a") 'set-visited-file-name)

;;-------------------------------;;
;; SWITCHING WINDOWS KEY COMMAND ;;
;;-------------------------------;;

(defun select-next-window ()
  "Switch to the next window"
  (interactive)
  (select-window (next-window)))

(global-set-key (kbd "M-`") 'select-next-window)

;;-----------;;
;; MODE-LINE ;;
;;-----------;;

;; Get rid of the old mode-line and replace with a more informative and organized mode-line
(setq-default mode-line-format
   (list
      " -- "

      ;; Modified shows *
      "{"
      '(:eval
        (if (buffer-modified-p)
         "*"
         (if buffer-read-only
                "!"
                " "
         )))
      "} "
  
      ;; Buffer (tooltip - file name)
      '(:eval (propertize "%b" 'face 'bold 'help-echo (buffer-file-name)))
  

      " "
  
      ;; Spaces 20 - "buffer"
      '(:eval
        (make-string
         (- 20
           (min
           20
           (length (buffer-name))))
        ?-))
  
    " "
      ;; Current (row,column)
    "("(propertize "%01l") "," (propertize "%01c") ") "
  
      ;; Spaces 7 - "(r,c)"
      '(:eval
        (make-string
         (- 7
           (min
           4
           (length (number-to-string (current-column)))
           )
           (min
           3
           (length (number-to-string (1+ (count-lines 1 (point)))))))
        ?-))
  
      ;; Percentage of file traversed (current line/total lines)
      " ["
      '(:eval (number-to-string (/ (* (1+ (count-lines 1 (point))) 100) (count-lines 1 (point-max)))))
      "%%] "
  
      ;; Spaces 4 - %
      '(:eval
        (make-string
         (- 4 (length (number-to-string (/ (* (count-lines 1 (point)) 100) (count-lines 1 (point-max))))))
        ?-))
  
      ;; Major Mode
      " [" '(:eval mode-name) "] "
  
      ;; Spaces 18 - %
      '(:eval
        (make-string
         (- 18
           (min
           18
           (length mode-name)))
        ?-))
      
      " ("

      ;; Time
      '(:eval (propertize (format-time-string "%H:%M")
                          'help-echo
                          (concat (format-time-string "%c; ")
                                  (emacs-uptime "Uptime:%hh"))))
  
      ;; Fill with '-'
      ")"

      ;; Spaces 13 - Battery info
      (if (string= (user-full-name) "root") " --- [SUDO]")
      " %-"
      ))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (cyberpunk)))
 '(custom-safe-themes
   (quote
    ("f0a99f53cbf7b004ba0c1760aa14fd70f2eabafe4e62a2b3cf5cabae8203113b" default)))
 '(menu-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
