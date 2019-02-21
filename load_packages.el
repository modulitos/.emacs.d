;;; Package --- Summary
;;; Commentary:
;;; configs for various modes

;;; Code:
(require 'cl)
(require 'recentf)
(require 'buffer-stack)
(require 'evil)
(require 'znc)
;; (require 'magit)
;; (require 'org)
(require 'modeline-posn)

(require 'org-trello)

(require 'erc-hl-nicks)

(require 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)

(require 'js2-mode)
(require 'web-mode)

(require 'dired+)
(require 'evil-little-word)
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

; Make sure we can find the dictionaries
;; (add-to-list 'ac-dictionary-directories "~/.emacs.d/elpa/auto-complete/dict")
; Use dictionaries by default

(require 'prettier-js)

(add-to-list 'load-path "/usr/share/emacs/site-list/")

