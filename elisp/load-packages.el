;;; Package --- Summary
;;; Commentary:
;;; configs for various modes

;;; Code:
(message "loading load-packages.el")
(require 'cl)


(require 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)
(add-to-list 'flycheck-emacs-lisp-load-path "~/.emacs.d/elisp/")


(require 'buffer-stack)
;; (require 'znc)

;; (require 'magit)
;; (require 'org)
;; Commented out to prevent `Warning: assignment to free variable "isearchp-reg-beg"`:
;; (defvar isearchp-reg-beg)                 ; In `isearch+.el'
;; (require 'modeline-posn)

(require 'org-trello)

(require 'erc-hl-nicks)


;; (require 'js2-mode)
;; (require 'web-mode)

(require 'dired+)

(dumb-jump-mode)

(require 'nginx-mode)

(require 'haml-mode)
(require 'sass-mode)

;;; yasnippet
;;; should be loaded before auto complete so that they can work together
;; (require 'yasnippet)
;; (yas-global-mode 1)
;; help from: http://stackoverflow.com/questions/8225183/emacs-yasnippet-install
;; (yas/initialize)
(require 'yasnippet)
(yas-global-mode 1)

;; (add-to-list 'load-path "~/path-to/auto-complete")
; Load the default configuration
;; (require 'auto-complete-config)

; Make sure we can find the dictionaries
;; (add-to-list 'ac-dictionary-directories "~/.emacs.d/elpa/auto-complete/dict")
; Use dictionaries by default
;; (setq-default ac-sources (add-to-list 'ac-sources 'ac-source-dictionary))
;; (global-auto-complete-mode t)
;; ; Start auto-completion after 2 characters of a word
;; (setq ac-auto-start 2)
;; ; case sensitivity is important when finding matches
;; (setq ac-ignore-case nil)

(require 'prettier-js)

(add-to-list 'load-path "/usr/share/emacs/site-list/")

(provide 'load-packages)
;;; load-packages.el ends here
