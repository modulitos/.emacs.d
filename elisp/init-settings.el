;;; package --- summary
;;; Commentary:

(global-auto-revert-mode t)

;; THEMING
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (add-to-list 'custom-theme-load-path "~/workspace/emacs/.emacs.d/elisp/themes/color-theme-6.6.0/color-theme.el")
(message "loading init-settings.el")
;; (load-theme 'light-blue t)
;;; Code:
(add-to-list 'load-path "~/.emacs.d/elisp/themes/color-theme-6.6.0")
;; (require 'color-theme)

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

(menu-bar-mode -1)

;; ref: https://juanjoalvarez.net/es/detail/2014/sep/19/vim-emacsevil-chaotic-migration-guide/
;; set cursor colors based on edit mode:
(setq evil-emacs-state-cursor '("red" box))
(setq evil-normal-state-cursor '("green" box))
(setq evil-visual-state-cursor '("orange" box))
(setq evil-insert-state-cursor '("red" bar))
(setq evil-replace-state-cursor '("red" bar))
(setq evil-operator-state-cursor '("red" hollow))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; FONT DISPLAY

(defun font-big ()
  (interactive)
  (set-face-attribute 'default nil :height
                      (min 720
                           (+ (face-attribute 'default :height) 10))))

(defun font-small ()
  (interactive)
  (set-face-attribute 'default nil :height
                      (max 80
                           (- (face-attribute 'default :height) 10))))

;; (global-set-key (kbd "<C-wheel-down>") 'font-small)
;; (global-set-key (kbd "<C-wheel-up>") 'font-big)
(global-set-key (kbd "<C-mouse-5>") 'font-small)
(global-set-key (kbd "<C-mouse-4>") 'font-big)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MODELINE-POSN
(column-number-mode 1)
(size-indication-mode 1) ; Turn on Size Indication mode


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; YASNIPPET AND AUTO-COMPLETION
;;; yasnippet
;;; should be loaded before auto complete so that they can work together
;; (require 'yasnippet)
;; (yas-global-mode 1)
;; help from: http://stackoverflow.com/questions/8225183/emacs-yasnippet-install
;; (yas/initialize)

;; http://stackoverflow.com/questions/8225183/emacs-yasnippet-install
;; (yas/initialize)
;; ;; (setq yas/root-directory "~/.emacs.d/snippets")
;; (setq yas/root-directory "~/.emacs.d/elpa/yasnippets/snippets")
;; (yas/load-directory yas/root-directory)

;; http://blog.binchen.org/posts/how-to-configure-yasnippet-0-7-0-and-use-it-with-auto-complete-mode.html


;;; auto complete mod
;;; should be loaded after yasnippet so that they can work together
;; (add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
;;; set the trigger key so that it can work together with yasnippet on tab key,
;;; if the word exists in yasnippet, pressing tab will cause yasnippet to
;;; activate, otherwise, auto-complete will


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)


;; Lazy highlighting while searching (can instead use M-s h r to highlight regex)
;; (setq lazy-highlight-cleanup nil)

;; Delete words in minibuffer without adding it to the kill ring.
(add-hook 'minibuffer-setup-hook'
          (lambda ()
            (make-local-variable 'kill-ring)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; COMMENTING
;; auto line-breaking comments:
;; (Note that this is broken in languauges using mulitiple chars for commenting
;; - only auto-fills a single comment char)
;; (setq comment-auto-fill-only-comments 1)
;; (setq-default auto-fill-function 'do-auto-fill)
;; (setq-default auto-fill-function nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
;; (add-hook 'js-mode-hook 'my-paredit-nonlisp)

;; Jump to last point
(setq mark-ring-max 3)
(global-set-key (kbd "C-M--")
                (lambda () (interactive)
                  (let ((current-prefix-arg '(1))) ; C-u
                    (call-interactively 'set-mark-command))))
;; Equivalent keybinding:
;; (global-set-key (kbd "M-SPC") (kbd "C-u C-SPC"))

;; LANGUAGES (INPUT METHOD)
;; toggle input method: C-M-/
(defun set-input-to-korean ()
  (interactive)
  (set-input-method "korean-hangul"))

(defun set-input-to-espanol ()
  (interactive)
  (set-input-method "spanish-postfix"))

(defun set-input-to-vietnamese ()
  (interactive)
  (set-input-method "vietnamese-vni"))

(global-set-key (kbd "C-M-k") 'set-input-to-korean)
(global-set-key (kbd "C-M-e") 'set-input-to-espanol)
(global-set-key (kbd "C-M-v") 'set-input-to-vietnamese)

;; MINOR MODES

;; Fly spell checker mode
(add-hook 'text-mode-hook 'flyspell-mode)
(add-hook 'markdown-mode-hook 'flyspell-mode)

;; http://www.aaronbedra.com/emacs.d/
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)


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
;; Turn beep off
(setq visible-bell nil)

(fset 'yes-or-no-p 'y-or-n-p)
;; (global-visual-line-mode)
;; (toggle-truncate-lines)
;; (setq-default truncate-lines t)
(setq-default major-mode 'markdown-mode)

(setq-default global-visual-line-mode t)
(setq visual-line-mode t)
(setq make-backup-files nil)
(setq auto-save-default nil)

(setq helm-M-x-fuzzy-match                  t
      helm-bookmark-show-location           t
      helm-buffers-fuzzy-matching           t
      helm-completion-in-region-fuzzy-match t
      helm-file-cache-fuzzy-match           t
      helm-imenu-fuzzy-match                t
      helm-mode-fuzzy-match                 t
      helm-locate-fuzzy-match               t
      helm-quick-update                     t
      helm-recentf-fuzzy-match              t
      helm-semantic-fuzzy-match             t)


;; Dumb-jump
;; Add .mjs file extensions as javascript to our dumb jump configuration:
(push '(:language "javascript" :ext "mjs" :agtype "mjs" :rgtype "mjs")
      (cdr (last dumb-jump-language-file-exts)))

;; company mode
(eval-after-load 'company
  '(progn
     (define-key company-active-map (kbd "TAB") 'company-select-next)
     (define-key company-active-map [tab] 'company-select-next)
     (define-key company-active-map (kbd "C-n") 'company-select-next)
     (define-key company-active-map (kbd "C-p") 'company-select-previous)))

;; Emacs Privacy Agent

;; tells emacs where to listen for gpg key's pin when opening an encrypted gpp file:
(setf epa-pinentry-mode 'loopback)


(provide 'init-settings)
;;; settings.el ends here
