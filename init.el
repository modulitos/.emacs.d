;; Requisites: Emacs >= 24
(require 'package)
(package-initialize)

;; Paused due to slow connection
(add-to-list 'package-archives 
  '("melpa" . "http://melpa.milkbox.net/packages/") t)


;; (add-to-list 'package-archives
;; 	     '("melpa" . "http://melpa.milkbox.net/packages/"))
;; (add-to-list 'package-archives
;;   '("melpa" . "http://melpa.milkbox.net/packages/") t)
 ;; (add-to-list 'package-archives
 ;; 	     '("marmalade" . "http://marmalade-repo.org/packages/") t)
 ;; (add-to-list 'package-archives
 ;; 	     '("marmalade" . "http://marmalade-repo.org/packages/"))

(package-refresh-contents)	     

(add-to-list 'load-path (expand-file-name "~/.emacs.d/elisp"))
;; (add-to-list 'load-path (expand-file-name "~/workspace/emacs/.emacs.d/elisp"))
(add-to-list 'load-path "~/workspace/emacs/.emacs.d/plugins")
;; (add-to-list 'load-path "~/.emacs.d/plugins")

;; Load Luke's personal settings.
(load "~/Dropbox/workspaces/emacs/.emacs.d/my-config.el")
;; (load "~/.emacs.d/my-config.el")

;; -------------------- extra nice things --------------------
;; use shift to move around windows
(windmove-default-keybindings 'shift)
(show-paren-mode t)
 ; Turn beep off
(setq visible-bell nil)

(desktop-save-mode 1)

;; Not needed - use MELPA
;; xquery mode
;; (load "~/Dropbox/workspaces/emacs/.emacs.d/plugins/xquery-mode.el")
;; (require 'xquery-mode)
;; (autoload 'xquery-mode "xquery-mode" "XQuery mode" t )
;; (setq auto-mode-alist
;;       (append '(("\\.xqy$" . xquery-mode)) auto-mode-alist))
