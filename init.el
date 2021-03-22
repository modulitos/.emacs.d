;;; package --- summary
;;; Commentary:
;; Requisites: Emacs >= 24

;;; Code:
;; PACKAGE MANAGEMENT
(require 'package)

;; Install extensions if they're missing:
;; (add-to-list 'package-archives
;;              '("melpa" . "http://melpa.org/packages/") t)
;; (package-initialize)

;; (package-refresh-contents)

;; (package-install 'flycheck)


;; (package-refresh-contents)

;; tells use where the elpa folder is


;;; code:
(add-to-list 'load-path (expand-file-name "elisp" user-emacs-directory))
(require 'init-elpa)
(require 'init-exec-path)

;; SYSTEM DIRECTORY
(setq default-directory "~/")
(message "Default Dir: %S" default-directory)

;; SESSION MANAGEMENT - Windows Mode
;; (require 'desktop-menu)
;; (add-to-list 'load-path "~/workspace/emacs/.emacs.d/elisp/windows2.el")
;; (add-to-list 'load-path "~/workspace/emacs/.emacs.d/elisp/windows.el")

(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse)

;; OS specific package
(if (eq system-type 'darwin)
    ;; something for OS X if true
    ;; optional something if not
    (require 'macos-setup)
  )

;; REQUIREMENTS
(require 'load-packages)

;; FUNCTIONS
(require 'init-functions)

;; MAJOR MODES

(require 'init-modes)
(require 'init-erc)
(require 'init-javascript)
(require 'init-rust)
(require 'init-ruby)
(require 'init-python)

;; SETTINGS
(require 'init-settings)
;; KEY BINDINGS
(require 'keybindings)


(require 'init-servers)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#3F3F3F" "#CC9393" "#7F9F7F" "#F0DFAF" "#8CD0D3" "#DC8CC3" "#93E0E3" "#DCDCCC"])
 '(coffee-args-compile '("-c" "--no-header" "--bare"))
 '(coffee-indent-like-python-mode t)
 '(coffee-tab-width 2)
 '(company-search-regexp-function 'company-search-flex-regexp)
 '(css-indent-offset 2)
 '(custom-enabled-themes '(zenburn))
 '(custom-safe-themes
   '("3c9d994e18db86ae397d077b6324bfdc445ecc7dc81bb9d528cd9bba08c1dac1" default))
 '(emojify-program-contexts '(comments))
 '(erc-prompt-for-password nil)
 '(fci-rule-color "#383838")
 '(js-indent-level 2)
 '(js-switch-indent-offset 2)
 '(js2-include-node-externs t)
 '(js2-missing-semi-one-line-override t)
 '(js2-strict-missing-semi-warning nil)
 '(json-reformat:indent-width 2)
 '(markdown-command "~/.cabal/bin/pandoc")
 '(mu4e-view-prefer-html t)
 '(mu4e-view-show-images t)
 '(org-agenda-files
   '("~/Documents/mgmt-docs/calendar.trello" "~/Documents/mgmt-docs/floortek-calendar.trello"))
 '(org-agenda-log-mode-items '(closed clock state))
 '(org-export-date-timestamp-format "%Y-%m-%d")
 '(org-trello-current-prefix-keybinding "C-c o" nil (org-trello))
 '(org-trello-files '("~/Documents/mgmt-docs/haxgeo-trello.trello") nil (org-trello))
 '(package-selected-packages
   '(undo-fu undo-tree dtrace-script-mode flymake-shellcheck rubocopfmt rubocop json-mode markdown-mode flycheck-mypy format-all iedit flymake-json use-package racer flycheck-rust rust-mode emojify prettier-js add-node-modules-path evil company-web tide pdf-tools git-gutter evil-magit magit yaml-mode web-mode w3m tss timesheet tern-auto-complete swiper php-mode paredit org-trello markdown-mode+ js2-refactor js-comint ix image+ htmlize helm-fuzzy-find helm-fuzzier helm-flyspell helm-dired-recent-dirs haskell-mode haml-mode flycheck exec-path-from-shell evil-smartparens evil-org erc-hl-nicks elpy dumb-jump django-snippets dired+ coffee-mode bookmark+ ac-js2))
 '(python-indent-guess-indent-offset nil)
 '(safe-local-variable-values
   '((encoding . utf-8)
     (js2-basic-offset . 4)
     (js2-basic-offset . 2)
     (truncate-lines . 1)))
 '(sh-basic-offset 2)
 '(sh-indentation 2)
 '(show-trailing-whitespace t)
 '(timesheet-invoice-number 135)
 '(tls-program
   '("gnutls-cli --insecure -p %p %h" "gnutls-cli --insecure -p %p %h --protocols ssl3" "openssl s_client -connect %h:%p -no_ssl2 -ign_eof" "openssl s_client -connect %h:%p -no_ssl2 -ign_eof -CAfile ~/.ssl/spi_ca.pem -cert ~/.ssl/nick.pem " "gnutls-cli --priority SECURE256 --x509cafile ~/.ssl/spi_ca.pem --x509certfile ~/.ssl/nick.pem -p %p %h"))
 '(typescript-auto-indent-flag t)
 '(typescript-expr-indent-offset 0)
 '(typescript-indent-level 2)
 '(undo-tree-auto-save-history nil)
 '(vc-annotate-background "#2B2B2B")
 '(vc-annotate-color-map
   '((20 . "#BC8383")
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
     (360 . "#DC8CC3")))
 '(vc-annotate-very-old-color "#DC8CC3")
 '(w3m-default-display-inline-images t)
 '(web-mode-attr-indent-offset 2)
 '(web-mode-attr-value-indent-offset 2)
 '(web-mode-code-indent-offset 2)
 '(web-mode-comment-style 1)
 '(web-mode-css-indent-offset 2)
 '(web-mode-enable-auto-quoting nil)
 '(web-mode-enable-comment-keywords nil t nil "TODO")
 '(web-mode-enable-control-block-indentation nil)
 '(web-mode-markup-indent-offset 2)
 '(whitespace-style '(trailing))
 '(znc-erc-ssl-connector 'erc-tls))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;; https://www.emacswiki.org/emacs/DesktopMultipleSaveFiles
(setq desktop-path '("~/workspaces/emacs/main" "~" "."))

;;; init.el ends here
