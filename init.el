;; Requisites: Emacs >= 24
(require 'package)
(package-initialize)

;; PACKAGE MANAGEMENT
;; Paused due to slow connection
(add-to-list 'package-archives 
  '("melpa" . "http://melpa.milkbox.net/packages/") t)

;; ;; Install extensions if they're missing
;; (defun init--install-packages ()
;;   (packages-install
;;    '(
;;      flycheck
;;      flycheck
;;      markdown-mode
     ;; clojure-mode)))

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

;; SYSTEM DIRECTORY
(setq default-directory "~/")        
;; (setq default-directory "~/workspace/emacs/")
(message "Default Dir: %S" default-directory)

;; SESSION MANAGEMENT - Windows Mode
  ;; (require 'desktop-menu)
;; (add-to-list 'load-path "~/workspace/emacs/.emacs.d/elisp/windows2.el") 
  (add-to-list 'load-path (expand-file-name "~/.emacs.d/elisp"))
  ;; (add-to-list 'load-path "~/workspace/emacs/.emacs.d/elisp/windows.el")
  (require 'windows)
  (win:startup-with-window)
  (define-key ctl-x-map "C" 'see-you-again)

  (require 'uniquify)
  (setq uniquify-buffer-name-style 'reverse)

;; REQUIREMENTS
(load "~/.emacs.d/load_packages")

;; MAJOR MODES
(load "~/.emacs.d/modes")

;; FUNCTIONS
(load "~/.emacs.d/functions")

;; SETTINGS
(load "~/.emacs.d/settings")
;; KEY BINDINGS
(load "~/.emacs.d/keybindings")



