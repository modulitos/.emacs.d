;;; Package --- Summary
;;; Commentary:
;;; configs for various modes, dumping ground
;;; TODO: break this out into separate files

;; functions shared across modes:
(defun my-code-editor-hook ()
  "Hooks for all modes."
  (local-set-key (kbd "C-p") 'helm-buffers-list)
  (local-set-key (kbd "C-/") 'comment-line-or-region)
  (local-set-key (kbd "C-S-i") 'format-all-buffer)
  )

(use-package format-all
  :ensure t
  ;; Select the default formatter without opening a dialog:
  :hook ((format-all-mode . format-all-ensure-formatter))

  ;; ;; Override default formatters:
  ;; :config
  ;;   (custom-set-variables
  ;;  '(format-all-formatters
  ;;    (quote
  ;;     (("Python" yapf)))))
  )

;; ELISP-MODE

(defun elisp-mode-config ()
  (message "initializing elisp editor mode hook")
  (my-code-editor-hook)
  (format-all-mode t))

(add-hook 'emacs-lisp-mode-hook 'elisp-mode-config)


;; HELM mode
(require 'helm)
(require 'helm-config)

;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))

(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "M-x") 'helm-M-x)

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

(when (executable-find "curl")
  (setq helm-google-suggest-use-curl-p t))

(setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t)

(helm-mode 1)

;; DTRACE SCRIPT MODE
(add-to-list 'auto-mode-alist '("\\.d\\'" . dtrace-script-mode))


;; NGINX
(add-to-list 'auto-mode-alist '("\\.conf\\'" . nginx-mode))
(add-hook 'nginx-mode-hook 'nginx-mode-config)

;; SQL
;; Capitalizes all mySQL words
(defun point-in-comment ()
  (let ((syn (syntax-ppss)))
    (and (nth 8 syn)
         (not (nth 3 syn)))))

(defun my-capitalize-all-mysql-keywords ()
  (interactive)
  (require 'sql)
  (save-excursion
    (dolist (keywords sql-mode-mysql-font-lock-keywords)
      (goto-char (point-min))
      (while (re-search-forward (car keywords) nil t)
        (unless (point-in-comment)
          (goto-char (match-beginning 0))
          (upcase-word 1))))))
;; TODO: error here!
;; (eval-after-load "sql"
;;   '(load-library "sql-indent.el"))

(setq-default indent-tabs-mode nil)
;; RUBY-MODE
(add-hook 'ruby-mode-hook
          (lambda ()
            (define-key ruby-mode-map "\C-c#" 'comment-or-uncomment-region)
            )
          )
(defadvice comment-or-uncomment-region (before slick-comment activate compile)
  "When called interactively with no active region, comment a single line instead."
  (interactive
   (if mark-active (list (region-beginning) (region-end))
     (list (line-beginning-position)
           (line-beginning-position 2)))))
;; MATLAB-MODE
;; '.m' confilcts with obj-c mode. Default to matlab for '.m' files.
(add-to-list 'auto-mode-alist
             '("\\.m$" . matlab-mode))

;; LATEX
;; (setq latex-run-command "pdflatex")
;; (setq latex-run-command "xelatex")
;; (add-hook 'latex-mode-hook 'flyspell-mode)
;; (add-hook 'latex-mode-hook
(add-hook 'latex-mode-hook
          (lambda ()
            (flyspell-mode)))

(add-hook 'doc-view-mode-hook 'auto-revert-mode)
(add-hook 'latex-mode-hook 'auto-revert-mode)
;; (add-hook 'flyspell-mode-hook
;; ;; (add-hook 'latex-mode-hook
;;           (lambda()
;;             ;; (local-unset-key (kbd "C-;"))
;;             ;; (local-set-key (kbd "C-;") 'comment-line-or-region)
;;             ))

;; Add xelatex hook to our list of auctex commands:
(add-hook 'LaTeX-mode-hook #'my-latex-mode-hook)

(defun my-latex-mode-hook ()
  (add-to-list 'TeX-command-list
               '("XeLaTeX" "%`xelatex%(mode)%' %t" TeX-run-TeX nil t)))

;; MARKDOWN
(custom-set-variables
 '(markdown-command "~/.cabal/bin/pandoc"))
(setq markdown-fontify-code-blocks-natively t)
(add-to-list 'auto-mode-alist '("\\.text\\'" "\\.markdown\\'" "\\.md\\'" . markdown-mode))

;; Custom highlighting modes (useful for job searches/tracking)
(defvar networks-list-buffer-regexp '("contacts.md")
  ;; More examples:
  ;; "\\.txt" "\\.md" "\\.pm" "\\.conf" "\\.htaccess" "\\.html" "\\.tex" "\\.el"
  ;; "\\.yasnippet" "user_prefs" "\\.shtml" "\\.cgi" "\\.pl" "\\.js" "\\.css"
  ;; "\\*eshell\\*")
  "Regexp of file / buffer names that will be matched using `regexp-match-p` function.")

;; https://github.com/kentaro/auto-save-buffers-enhanced
;; `regexp-match-p` function modified by @sds on stackoverflow
;; http://stackoverflow.com/a/20343715/2112489
(defun regexp-match-p (regexps string)
  (and string
       (catch 'matched
         (let ((inhibit-changing-match-data t)) ; small optimization
           (dolist (regexp regexps)
             (when (string-match regexp string)
               (throw 'matched t)))))))

;; (add-hook 'text-mode-hook (lambda ()
;;   (if (regexp-match-p text-mode-buffer-regexp (buffer-name))
;;       ;; condition true:
;;       (highlight-regexp "^\\([^(\#,)]*\\),"     font-lock-keyword-face)
;;     ;; condition false:
;;       'nil) ) )

;; Required for 'markdown-export-and-preview:
;; NOTE: in some installs, this may be `markdown-command`
(setq markdown-open-command "pandoc -c file:///home/lucas/.emacs.d/github-pandoc.css --from markdown_github -t html5 --mathjax --highlight-style pygments --standalone")

(add-hook 'markdown-mode-hook
          (lambda ()
            (if (regexp-match-p networks-list-buffer-regexp (buffer-name))
                ;; condition true:
                (highlight-regexp "^\\([^(\#,)]*\\),"     font-lock-keyword-face)
              ;; condition false:
              'nil)
            (local-set-key (kbd "C-c o") 'markdown-export-and-preview)))

;; SASS/SCSS MODE
(add-to-list 'auto-mode-alist '("\\.scss?\\'" . scss-mode))

;; ORG MODE
(require 'org-tempo)
;; (setq org-log-done t)
;; (define-key global-map "\C-cl" 'org-store-link)
;; (setq org-export-html-style
;;       "<link rel=\"stylesheet\" type=\"text/css\" href=\"org-style.css\" />")
(setq org-export-html-style-include-scripts nil
      org-export-html-style-include-default nil)

;; (setq org-todo-keywords
;;       '((sequence "TODO" "IN-PROGRESS" "WAITING" "DONE")))
;; (setq org-html-xml-declaration (quote (("html" . "")
;;                                        ("was-html" . "<?xml version=\"1.0\" encoding=\"%s\"?>")
;;                                        ("php" . "<?php echo \"<?xml version=\\\"1.0\\\" encoding=\\\"%s\\\" ?>\"; ?>"))))

;; shortcut this with C-c C-v d then language
;; (org-babel-do-load-languages
;;  'org-babel-load-languages
;;  '((python . t)
;;    (js . t)
;;    (org . t)
;;    (shell . t)))
;; (R . t)))

;; (setq org-src-fontify-natively t)
;; (defun indent-org-block-automatically ()
;;   (when (org-in-src-block-p)
;;     (org-edit-special)
;;     (indent-region (point-min) (point-max))
;;     (org-edit-src-exit)))

;; (run-at-time 1 10 'indent-org-block-automatically)

;; (setq org-mode-hook nil)

(use-package org
  :mode (("\\.org$" . org-mode))
  :config
  (defun my-org-mode-hook ()
    "Hooks for Org mode."
    (local-unset-key [C-tab])
    ;; allow window resizing via M-l and M-h
    (local-unset-key (kbd "M-l"))
    (local-unset-key (kbd "M-h"))
    (local-unset-key (kbd "C-q"))

    ;; override default keybinding here:
    (local-set-key (kbd "C-S-i") 'whitespace-cleanup)

    ;; (local-set-key (kbd "C-c C-c") 'org-table-align)
    ;; (local-unset-key (kbd "C-c C-c"))
    ;; (local-set-key (kbd "C-c C-f") 'org-table-calc-current-TBLFM)
    ;; default is "C-c C-x C-j"
    ;; (local-set-key (kbd "C-c C-g c") 'org-clock-goto)

    ;; (local-set-key (kbd "C-c C-b") 'org-babel-demarcate-block)

    (toggle-truncate-lines 0)

    (org-indent-mode t)
    ;; https://github.com/org-trello/org-trello/issues/249
    ;; (let ((filename (buffer-file-name (current-buffer))))
    ;;   (when (and filename (string= "trello" (file-name-extension filename)))
    ;;     (org-trello-mode)))
    )
  :hook ((org-mode . my-org-mode-hook))
  )


;; (add-hook 'org-mode-hook  'my-org-mode-hook);
;; (local-unset-key (kbd "C-tab"))))
;; (local-unset-key (kbd "<C-tab>"))))
;; (org-force-cycle-archived) It is bound to <C-tab>.

;; ORG-AGENDA
(define-key global-map "\C-ca" 'org-agenda)

;; ORG-TRELLO
;; (custom-set-variables '(org-trello-files '("~/Documents/mgmt-docs/calendar.trello" "~/Documents/mgmt-docs/haxgeo-trello.trello" "~/Documents/mgmt-docs/floortek-calendar.trello") ))

;; org-trello major mode for all .trello files
;; (add-to-list 'auto-mode-alist '("\\.trello$" . org-mode))

;; (add-hook 'org-trello-mode-hook
;;           (lambda ()
;;             (org-indent-mode t)
;;             (toggle-truncate-lines 0)))


;; ORG-TIMESHEET and ORG-AGENDA
;; "Symbol's value as variable is void: org-agenda-custom-commands" ???
;; (add-to-list 'org-agenda-custom-commands
;;              '("r" "Weekly Timesheet"
;;                ((agenda ""))
;;                ((org-agenda-overriding-header "Weekly timesheet")
;;                 (org-agenda-span 'week)
;;                 (org-agenda-start-on-weekday 1)
;;                 (org-agenda-start-with-clockreport-mode t)
;;                 (org-agenda-time-grid nil))) t)

;; EVIL MODE


;; Enable Evil mode as defuault
;; (require 'evil)
;; (evil-mode 1)

;; (global-undo-tree-mode -1)
;; (evil-set-undo-system 'undo-fu)

(use-package evil
  :ensure t
  :config
  (evil-mode 1)
  (global-undo-tree-mode -1)
  (evil-set-undo-system 'undo-fu)
  ;; This prevents us from typing 'j', so using the cofi solution below:
  ;; (define-key evil-insert-state-map "jj" 'evil-normal-state)
  (define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
  (define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)

  (define-key evil-normal-state-map [escape] 'keyboard-quit)
  (define-key evil-visual-state-map [escape] 'keyboard-quit)
  (define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
  (define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
  (define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
  (define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
  (define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)
  )

(use-package undo-fu
  :config
  (global-undo-tree-mode -1)
  (define-key evil-normal-state-map "u" 'undo-fu-only-undo)
  (define-key evil-normal-state-map "\C-r" 'undo-fu-only-redo))


;; Enable smash escape
;; Type 'jj' for smash escape
(define-key evil-insert-state-map "j" #'cofi/maybe-exit-jj)
(evil-define-command cofi/maybe-exit-jj ()
  :repeat change
  (interactive)
  (let ((modified (buffer-modified-p)))
    (insert "j")
    (let ((evt (read-event (format "Insert %c to exit insert state" ?j)
                           nil 0.5)))
      (cond
       ((null evt) (message ""))
       ((and (integerp evt) (char-equal evt ?j))
        (delete-char -1)
        (set-buffer-modified-p modified)
        (push 'escape unread-command-events))
       (t (setq unread-command-events (append unread-command-events
                                              (list evt))))))))

;; (add-hook 'evil-mode-hook
;;           (lambda()
;;             (local-unset-key "C-/")
;;             (local-unset-key "C-z")
;;             (define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
;;             (define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)
;;             )
;;           )

(eval-after-load "evil-maps"
  (dolist (map '(evil-motion-state-map

                 evil-insert-state-map
                 evil-emacs-state-map))
    (define-key (eval map) "\C-z" nil)
    (define-key (eval map) "\C-w" nil)
    )
  )

;; Hooks to enabe/disable evil in other modes
(add-hook 'term-mode-hook 'evil-emacs-state)
(add-hook 'ansi-term-mode-hook 'evil-emacs-state)



;;    (define-key (eval map) (kbd "C-/") nil)))

;; (add-hook 'undo-tree-mode (lambda () (local-unset-key "C-/")))

;; (define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
;; (define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)
;; ;; (define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up) ;; C-u interferes with org-mode bindings
;; ;; (define-key evil-visual-state-map (kbd "C-u") 'evil-scroll-up)
;; (define-key evil-insert-state-map (kbd "C-u")
;;   (lambda ()
;;     (interactive)
;;     (evil-delete (point-at-bol) (point))))

;; evil-little-word bindings for camelCase:
;; (define-key evil-operator-state-map (kbd "b") 'evil-backward-little-word-begin)
;; (define-key evil-normal-state-map (kbd "w") 'subword-right)
;; (define-key evil-normal-state-map (kbd "b") 'subword-left)

;; ;; key translations
;; ;; ie: translate zh to C-h and zx to C-x
;; (define-key evil-normal-state-map "z" nil)
;; (define-key evil-motion-state-map "zu" 'universal-argument)
;; (define-key key-translation-map (kbd "zh") (kbd "C-h"))
;; (define-key key-translation-map (kbd "zx") (kbd "C-x"))

;;; esc quits pretty much anything (like pending prompts in the minibuffer)

;; (define-key evil-normal-state-map [escape] 'keyboard-quit)
;; (define-key evil-visual-state-map [escape] 'keyboard-quit)
;; (define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
;; (define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
;; (define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
;; (define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
;; (define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)

;; (define-key evil-insert-state-map "ㅏ" #'cofi/maybe-exit-ㅏㅓ)
;;(define-key evil-insert-state-map "j" #'cofi/maybe-exit-ㅏㅓ)
;; Set 'ㅏㅓ' to exit insert mode
;;(evil-define-command cofi/maybe-exit-ㅏㅓ ()
;;  :repeat change
;;  (interactive)
;;  (let ((modified (buffer-modified-p)))
;;    (insert "ㅏ")
;;    (let ((evt (read-event (format "Insert %c to exit insert state" ?ㅓ)
;; (let ((evt (read-event (format "Insert %c to exit insert state" ?)
;;               nil 0.5)))
;;      (cond
;;       ((null evt) (message ""))
;;       ((and (integerp evt) (char-equal evt ?ㅓ))
;;    (delete-char -1)
;;    (set-buffer-modified-p modified)
;;    (push 'escape unread-command-events))
;;       (t (setq unread-command-events (append unread-command-events
;;                          (list evt))))))))

;; (evil-define-command cofi/maybe-exit-kj-korean ()
;;   :repeat change
;;   (interactive)
;;   (let ((modified (buffer-modified-p)))
;;     (self-insert-command 1)
;;     (let ((evt (read-event (format "Insert %c to exit insert state"
;;                                    (if (equal current-input-method
;;                                               "arabic") ; "korean-hangul"
;;                                        ?ؤ               ; ?ㅓ
;;                                      ?j))
;;                            nil 0.5)))
;;       (cond
;;        ((null evt) (message ""))
;;        ((and (integerp evt) (memq evt '(?j ?ؤ))) ; '(?j ?ㅓ)
;;         (delete-char -1)
;;         (set-buffer-modified-p modified)
;;         (push 'escape unread-command-events))
;;        (t
;;         (setq unread-command-events (append unread-command-events
;;                                             (list evt))))))))

;; (define-key evil-insert-state-map "ر" #'cofi/maybe-exit-kj-korean) ; "ㅏ"

;;(defun test-my-key ()
;;  (interactive)
;;  (self-insert-command 1)
;;  (message "This key works!")
;;  (sit-for 2))
;;
;;(define-key evil-insert-state-map "a" #'test-my-key)
;;(define-key evil-insert-state-map "ㅏ" #'test-my-key) ; Not working!

;;; Code:
;; INFO MODE
(message "loading init-modes.el")
(evil-set-initial-state 'Info-mode 'emacs)


;; CALENDAR MODE
(copy-face 'default 'calendar-iso-week-header-face)
(set-face-attribute 'calendar-iso-week-header-face nil
                    :height 0.7)
(setq calendar-intermonth-header
      (propertize "Wk"                  ; or e.g. "KW" in Germany
                  'font-lock-face 'calendar-iso-week-header-face))
(copy-face font-lock-constant-face 'calendar-iso-week-face)
(set-face-attribute 'calendar-iso-week-face nil
                    :height 0.7)
(setq calendar-intermonth-text
      '(propertize
        (format "%2d"
                (car
                 (calendar-iso-from-absolute
                  (calendar-absolute-from-gregorian (list month day year)))))
        'font-lock-face 'calendar-iso-week-face))


(evil-set-initial-state 'calendar-mode 'emacs)
(defun adjust-calendar-view ()
  ;; (local-unset-key (kbd "u"))
  ;; (local-unset-key (kbd "d"))

  (local-unset-key (kbd "k"))
  (local-unset-key (kbd "j"))
  (local-unset-key (kbd "l"))
  (local-unset-key (kbd "h"))

  (local-set-key (kbd "k")
                 'calendar-backward-week)
  (local-set-key (kbd "j")
                 'calendar-forward-week)
  (local-set-key (kbd "h")
                 'calendar-backward-day)
  (local-set-key (kbd "l")
                 'calendar-forward-day))
(add-hook 'calendar-mode-hook
          'adjust-calendar-view)

;; DOC-VIEW
;; adjust docview mode
(setq doc-view-continuous nil)
(defun adjust-doc-view ()
  (local-unset-key (kbd "u"))
  (local-unset-key (kbd "d"))

  (local-unset-key (kbd "k"))
  (local-unset-key (kbd "j"))
  (local-unset-key (kbd "l"))
  (local-unset-key (kbd "h"))

  (local-set-key (kbd "d")
                 ;; (message "scrolling down")
                 'image-scroll-up)
  (local-set-key (kbd "u")
                 ;; (message "scrolling down")
                 'image-scroll-down)

  (local-set-key (kbd "k")
                 'doc-view-previous-line-or-previous-page)
  (local-set-key (kbd "j")
                 'doc-view-next-line-or-next-page)
  (local-set-key (kbd "h")
                 'image-backward-hscroll)
  (local-set-key (kbd "l")
                 'image-forward-hscroll))

(add-hook 'doc-view-mode-hook
          'adjust-doc-view)

(setq doc-view-resolution 300)

;; IMAGE MODE
(setq image-continuous nil)
(evil-set-initial-state 'image-mode 'emacs)
(defun adjust-image-view ()
  (local-unset-key (kbd "l"))
  (local-unset-key (kbd "h"))
  (local-unset-key (kbd "j"))
  (local-unset-key (kbd "k"))
  (local-unset-key (kbd "d"))
  (local-unset-key (kbd "u"))

  (local-set-key (kbd "j")
                 'image-next-line)
  (local-set-key (kbd "k")
                 'image-previous-line)
  (local-set-key (kbd "d")
                 'image-scroll-up)
  (local-set-key (kbd "u")
                 'image-scroll-down)
  (local-set-key (kbd "l")
                 'image-forward-hscroll)
  (local-set-key (kbd "h")
                 'image-backward-hscroll))
(add-hook 'image-mode-hook
          'adjust-image-view)
;; Image+ extension
;; https://github.com/mhayashi1120/Emacs-imagex
;;  C-c + / C-c -: Zoom in/out image.
;; C-c M-m: Adjust image to current frame size.
;; C-c C-x C-s: Save current image.
;; C-c M-r / C-c M-l: Rotate image.
;; C-c M-o: Show image image+ have not modified.
(eval-after-load 'image '(require 'image+))
(eval-after-load 'image+ '(imagex-global-sticky-mode 1))

;; DIRED
(defun dired-mode-activate ()
  "Turn on modes for `dired-mode' function."
  (interactive)
  (dired-hide-details-mode 0))

(add-hook 'dired-mode-hook 'dired-mode-activate)

;; SHELL SCRIPT MODE
(use-package flymake-shellcheck
  :commands flymake-shellcheck-load
  :config
  (defun my-shell-mode-hook ()
    "Hooks for 'sh-mode'."
    (message "inside sh mode hook")
    (flymake-shellcheck-load)
    (flymake-mode)
    ;; (setq flymake-shellcheck-path )
    )
  :mode (("\\.sh$" . sh-mode) ("\\.bash*" . sh-mode) (".direnvrc" . sh-mode))
  :hook ((sh-mode . my-shell-mode-hook))
  )


;; CONF MODE
;; CONF SPACE MODE
(add-to-list 'auto-mode-alist '("Dockerfile\\'" . conf-space-mode))
(add-to-list 'auto-mode-alist '("\\.env\\'" . conf-mode))
(add-to-list 'auto-mode-alist '("\\.ovpn\\'" . conf-mode))
(add-to-list 'auto-mode-alist '("\\.env*" . conf-mode))
(add-to-list 'auto-mode-alist '("*requirements.txt" . conf-mode))
(add-to-list 'auto-mode-alist '("requirements.txt" . conf-mode))
;; This interferes with our ".ts" files and typescript:
;; (add-to-list 'auto-mode-alist '("\\.tf*" . conf-mode))

(defun conf-mode-activate ()
  "Custom settings for 'conf-mode'."
  (interactive)
  (message "conf mode!!!")
  (my-code-editor-hook))

(add-hook 'conf-mode-hook 'conf-mode-activate)

;; YAML MODE
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
;; (print auto-mode-alist)
(add-hook 'yaml-mode-hook
          '(lambda ()
             (define-key yaml-mode-map "\C-m" 'newline-and-indent)))

;; C++ MODE
(add-hook 'c-mode-common-hook
          (lambda ()
            (local-unset-key (kbd "M-j"))))

;; PO MODE
(setq auto-mode-alist
      (cons '("\\.po\\'\\|\\.po\\." . po-mode) auto-mode-alist))
(autoload 'po-mode "po-mode" "Major mode for translators to edit PO files" t)

;; GIT-GUTTER MODE
(require 'git-gutter)

;; ;; If you enable global minor mode
(global-git-gutter-mode t)
;; (global-git-gutter-mode +1)

;; ;; If you would like to use git-gutter.el and linum-mode
;; (git-gutter:linum-setup)

;; ;; If you enable git-gutter-mode for some modes
;; (add-hook 'ruby-mode-hook 'git-gutter-mode)

;; (global-set-key (kbd "C-x C-g") 'git-gutter)
;; (global-set-key (kbd "C-x v =") 'git-gutter:popup-hunk)

;; Jump to next/previous hunk
(global-set-key (kbd "C-x p") 'git-gutter:previous-hunk)
(global-set-key (kbd "C-x n") 'git-gutter:next-hunk)


(provide 'init-modes)
;;; init-modes.el ends here
