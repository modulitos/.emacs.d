(require 'cl)
(require 'recentf)
(require 'buffer-stack)
(require 'evil)
(require 'znc)
;; (require 'org)
(require 'modeline-posn)
(require 'org-trello)


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
(require 'auto-complete-config)

; Make sure we can find the dictionaries
;; (add-to-list 'ac-dictionary-directories "~/.emacs.d/elpa/auto-complete/dict")
; Use dictionaries by default
(setq-default ac-sources (add-to-list 'ac-sources 'ac-source-dictionary))
(global-auto-complete-mode t)
; Start auto-completion after 2 characters of a word
(setq ac-auto-start 2)
; case sensitivity is important when finding matches
(setq ac-ignore-case nil)

