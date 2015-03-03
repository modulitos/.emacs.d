;; THEMING
;; (add-to-list 'custom-theme-load-path "~/workspace/emacs/.emacs.d/elisp/themes/color-theme-6.6.0/color-theme.el")
;; (load-theme 'light-blue t)
(add-to-list 'load-path "~/.emacs.d/elisp/themes/color-theme-6.6.0")
(require 'color-theme)
;; (color-theme-initialize);; try "color-theme-select" to try out themes
    ;; (color-theme-charcoal-black)
    ;; (color-theme-renegade)

(add-to-list 'custom-theme-load-path "~/.emacs.d/elisp/themes/")
(load-theme 'zenburn t)

;; Add highlighting to the current pointer line.
;; Change the color of the highlighted line.

(global-hl-line-mode)
;; (set-face-background hl-line-face "gray30") ;lighter grey


;; Transparency:
 ;;(set-frame-parameter (selected-frame) 'alpha '(<active> [<inactive>]))
(set-frame-parameter (selected-frame) 'alpha '(90 75))
(add-to-list 'default-frame-alist '(alpha 90 75))
;; (add-to-list 'default-frame-alist '(alpha 100 100))
(set-face-attribute 'default nil :foreground "white")
(set-face-attribute 'default nil :background "#2E2E2E")
(set-face-attribute 'region nil :background "#4E4E4E")
;; (set-face-background 'hl-line "#9A9A9A")
(set-face-foreground 'highlight nil)

(eval-when-compile (require 'cl))
(defun toggle-transparency ()
  (interactive)
  (if (/=
       (cadr (frame-parameter nil 'alpha))
       100)
      (set-frame-parameter nil 'alpha '(100 100))
    (set-frame-parameter nil 'alpha '(98 80))))
;; (global-set-key (kbd "C-t t") 'toggle-transparency)
;; (global-set-key (kbd "C-;") 'comment-eclipse)
;; (global-unset-key (kbd "C-c t"))

;; MODELINE-POSN
(column-number-mode 1)
(size-indication-mode 1) ; Turn on Size Indication mode


;; TERMINAL
(setq term-default-bg-color "#6F6F6F") ;; light grey
(setq term-default-fg-color "#FAFAFA") ;; letters
(add-hook 'ansi-term-mode-hook
    (lambda ()
      (local-set-key (kbd "C-j") 'term-line-mode)
      (local-set-key (kbd "C-k") 'term-char-mode)))
      
;; YASNIPPET AND AUTO-COMPLETION
;;; yasnippet
;;; should be loaded before auto complete so that they can work together
;; (require 'yasnippet)
;; (yas-global-mode 1)
;; help from: http://stackoverflow.com/questions/8225183/emacs-yasnippet-install
;; (require 'yasnippet "~/.emacs.d/elpa//yasnippet-20140514.1649/yasnippet.el")
(add-to-list 'load-path "~/.emacs.d/elpa/yasnippet-20140514.1649/yasnippet.el")
(require 'yasnippet)
(yas-global-mode 1)
;; (yas/initialize)
(setq yas/root-directory "~/.emacs.d/elpa/yasnippet-20140514.1649/snippets")
(yas/load-directory yas/root-directory)
(add-hook 'term-mode-hook (lambda()
        (setq yas-dont-activate t)))
(add-hook 'term-mode-hook 'evil-emacs-state)
(add-hook 'ansi-term-mode-hook 'evil-emacs-state)

;;; auto complete mod
;;; should be loaded after yasnippet so that they can work together
(require 'auto-complete-config)
;; (add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)
;;; set the trigger key so that it can work together with yasnippet on tab key,
;;; if the word exists in yasnippet, pressing tab will cause yasnippet to
;;; activate, otherwise, auto-complete will
(ac-set-trigger-key "TAB")
(ac-set-trigger-key "<tab>")


;; TEXT EDITING
(add-hook 'before-save-hook
          (lambda ()
            (when buffer-file-name
              (let ((dir (file-name-directory buffer-file-name)))
                (when (and (not (file-exists-p dir))
                           (y-or-n-p (format "Directory %s does not exist. Create it?" dir)))
                  (make-directory dir t))))))

(setq ring-bell-function 
      (lambda ()
	(unless (memq this-command
		      '(isearch-abort abort-recursive-edit exit-minibuffer keyboard-quit))
	  (ding))))

(add-to-list 'load-path (expand-file-name "~/.emacs.d/elisp/expand-region"))

(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)


;; Lazy highlighting while searching (can instead use M-s h r to highlight regex)
;; (setq lazy-highlight-cleanup nil)

;; Delete words in minibuffer without adding it to the kill ring.
(add-hook 'minibuffer-setup-hook'
          (lambda ()
            (make-local-variable 'kill-ring)))

;; BUFFER NAVIGATION

;; Sentence navigation
(setq sentence-end-double-space nil)   

;; Scrolling
(setq scroll-conservatively 10000)

;; Show matching PARENTHESIS, BRACES
(show-paren-mode 1)

;; Paragraph edit mode for balancing parentheses
;; (define-key js-mode-map "{" 'paredit-open-curly)
;; (define-key js-mode-map "}" 'paredit-close-curly-and-newline)
(add-hook 'js-mode-hook 'my-paredit-nonlisp)

;; MINOR MODES
;; Camel Case subword mode
  (add-hook 'prog-mode-hook 'subword-mode)
  (add-hook 'text-mode-hook 'subword-mode)

;; Fly spell checker mode
  (add-hook 'text-mode-hook 'flyspell-mode)
  (add-hook 'markdown-mode-hook 'flyspell-mode)

;; (if term-mode
    ;; (hl-line-mode -1))
(make-variable-buffer-local 'global-hl-line-mode)
(add-hook 'ansi-term-mode-hook (lambda () (setq global-hl-line-mode nil)))
(add-hook 'Java/l-mode-hook (lambda () (setq global-hl-line-mode nil)))
(add-hook 'Lisp-mode-hook (lambda () (setq global-hl-line-mode nil)))

(tool-bar-mode -1)

;; use shift to move around windows
(windmove-default-keybindings 'shift)
(show-paren-mode t)
 ; Turn beep off
(setq visible-bell nil)

;; Prompt to save the desktop upon exit
(desktop-save-mode 1)

(fset 'yes-or-no-p 'y-or-n-p)
;; (global-visual-line-mode)
;; (toggle-truncate-lines)
;; (setq-default truncate-lines t)
(setq-default global-visual-line-mode t)
(setq visual-line-mode t)
(setq make-backup-files nil) 
