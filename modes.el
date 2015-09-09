;; JDEE for java support
(add-to-list 'load-path "~/.emacs.d/jdee-2.4.1/lisp")
;; (load "jde") ;; Lazy-load instead
;;Lazy-load JDEE
(setq defer-loading-jde t)
(if defer-loading-jde
    (progn
      (autoload 'jde-mode "jde" "JDE mode." t)
      (setq auto-mode-alist
        (append
         '(("\\.java\\'" . jde-mode))
         auto-mode-alist)))
  (require 'jde))

;; PYTHON
;; Andreas' python-mode support
;; (eval-after-load "Python"
;;   '(load "~/.emacs.d/minimal-emacs-python-configuration.el"))
;;rnj
(setenv "PYTHONPATH” “/usr/bin/python")
;; For Python 3
;;(setenv "PYTHONPATH” “/usr/bin/python3")
 (elpy-enable)
 ;; Fixing a key binding bug in elpy
 (define-key yas-minor-mode-map (kbd "C-c e") 'yas-expand)
 ;; Fixing another key binding bug in iedit mode
 (define-key global-map (kbd "C-c o") 'iedit-mode)
(add-hook 'python-mode-hook
          (lambda ()
            (local-unset-key (kbd "M-."))
            (local-set-key (kbd "f3") 'elpy-goto-definition)
            (add-hook 'before-save-hook (lambda () (delete-trailing-whitespace)))
            (linum-mode)
            ))

(add-to-list 'auto-mode-alist '("\\.po\\'" . python-mode))
(defalias 'workon 'pyvenv-workon)

;; Use jedi instead of ropemacs when TRAMP is detected
;; Taken here: https://github.com/jorgenschaefer/elpy/issues/170
(defadvice elpy-rpc--open (around native-rpc-for-tramp activate)
  (interactive)
  (let ((elpy-rpc-backend
         (if (ignore-errors (tramp-tramp-file-p (elpy-project-root)))
             "native"
           elpy-rpc-backend)))
     (message "Using elpy backend: %s for %s" elpy-rpc-backend (elpy-project-root))
     ad-do-it))

;; CONF MODE
(add-to-list 'auto-mode-alist '("Dockerfile" . conf-mode))

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
(add-hook 'sql-mode-hook 'linum-mode)

(setq-default indent-tabs-mode nil)
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


;; JAVASCRIPT-MODE

;; js2-mode provides 4 level of syntax highlighting. They are * 0 or a negative value means none. * 1 adds basic syntax highlighting. * 2 adds highlighting of some Ecma built-in properties. * 3 adds highlighting of many Ecma built-in functions.
(setq js2-highlight-level 3)
;;keybindings
;; (eval-after-load "js2-mode"
  ;; '(progn
     ;; Add an alternative local binding for the command
     ;; bound to <f3>
     ;; (define-key js2-mode <f3>
       ;; 'ac-js2-jump-to-definition))
     ;; Unbind <f3> from the local keymap
     ;; (define-key js2-mode <f3> nil)
;; ))
(add-hook 'js2-mode-hook
          (lambda ()
            ;; (global-unset-key [<f1>])
            ;; (local-set-key [<f3>] 'ac-js2-jump-to-definition)
            ;; (define-key js2-mode-map [<f3>] 'ac-js2-jump-to-definition)

            ;; allow window resizing via M-l and M-h
            (local-unset-key (kbd "M-l"))
            (local-unset-key (kbd "M-h"))
            (local-unset-key (kbd "M-j"))
            (local-unset-key (kbd "M-"))

            (local-set-key (kbd "C-j") 'ac-js2-jump-to-definition)
            (local-set-key (kbd "C-c C-n") 'js2-next-error)
            (add-hook 'before-save-hook (lambda () (delete-trailing-whitespace)))
            (define-key js2-mode-map (kbd "C-j") 'ac-js2-jump-to-definition)
            (linum-mode)
            (js2-reparse t)
            (ac-js2-mode)))

;; (global-unset-key [<f3>])
;; (global-set-key [<f3>] nil)

;; (autoload 'js2-mode "elp/js2-mode-20140603.1818/js2.el" nil t)
(setq auto-mode-alist
       (cons '("\\.js$" . js2-mode) auto-mode-alist))
;; (add-to-list 'auto-mode-alist '("\\.js$" . js2-mode)) ;; same thing as above

(require 'js2-refactor)
(js2r-add-keybindings-with-prefix "C-c C-m")

;; HTML MODE
(add-hook 'html-mode-hook 'linum-mode)


;; MATLAB-MODE
;; '.m' confilcts with obj-c mode. Default to matlab for '.m' files.
(setq auto-mode-alist
       (cons '("\\.m$" . matlab-mode) auto-mode-alist))
(add-hook 'matlab-mode-hook 'linum-mode)

;; LATEX
  (setq latex-run-command "pdflatex")
  ;; (setq latex-run-command "xelatex")
(add-hook 'latex-mode-hook 'flyspell-mode)
(add-hook 'doc-view-mode-hook 'auto-revert-mode)
(add-hook 'latex-mode-hook 'auto-revert-mode)
(add-hook 'flyspell-mode-hook
;; (add-hook 'latex-mode-hook
          (lambda()
            (local-unset-key (kbd "C-;"))
            (local-set-key (kbd "C-;") 'comment-eclipse)))

;; MARKDOWN
(custom-set-variables
 '(markdown-command "/usr/bin/pandoc"))

;; github-flavored-markdown is not longer available...
;; (autoload 'markdown-mode "markdown-mode"
;; (autoload 'markdown-mode "gfm-mode"
;;   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'". markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'". markdown-mode))


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

;; WEB MODE
;; http://web-mode.org/
;; (require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(defun my-web-mode-hook ()
  "Hooks for Web mode."
  ;; (setq web-mode-markup-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-enable-current-element-highlight t)
  (lambda ()
    (linum-mode))
)
(add-hook 'web-mode-hook  'my-web-mode-hook)

;; ORG MODE
(setq org-log-done t)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-export-html-style
      "<link rel=\"stylesheet\" type=\"text/css\" href=\"org-style.css\" />")
(setq org-export-html-style-include-scripts nil
      org-export-html-style-include-default nil)

(setq org-todo-keywords
  '((sequence "TODO" "IN-PROGRESS" "WAITING" "DONE")))
(setq org-html-xml-declaration (quote (("html" . "")
                                       ("was-html" . "<?xml version=\"1.0\" encoding=\"%s\"?>")
                                       ("php" . "<?php echo \"<?xml version=\\\"1.0\\\" encoding=\\\"%s\\\" ?>\"; ?>"))))

(org-babel-do-load-languages
      'org-babel-load-languages
      '((python . t)
        (js . t)
        (org . t)
        (sh . t)))
        ;; (R . t)))

(setq org-src-fontify-natively t)
(defun indent-org-block-automatically ()
  (when (org-in-src-block-p)
   (org-edit-special)
    (indent-region (point-min) (point-max))
    (org-edit-src-exit)))

;; (run-at-time 1 10 'indent-org-block-automatically)

(setq org-mode-hook nil)
(add-hook 'org-mode-hook
          (lambda()
            (local-unset-key [C-tab])
            ;; allow window resizing via M-l and M-h
            (local-unset-key (kbd "M-l"))
            (local-unset-key (kbd "M-h"))
            (local-unset-key (kbd "C-q"))

            ;; (local-set-key (kbd "C-c C-c") 'org-table-align)
            ;; (local-unset-key (kbd "C-c C-c"))
            (local-set-key (kbd "C-c C-f") 'org-table-calc-current-TBLFM)
            (toggle-truncate-lines 0)

            (org-indent-mode t)
            ;; https://github.com/org-trello/org-trello/issues/249
            (let ((filename (buffer-file-name (current-buffer))))
              (when (and filename (string= "trello" (file-name-extension filename)))
                (org-trello-mode)))))
            ;; (local-unset-key (kbd "C-tab"))))
            ;; (local-unset-key (kbd "<C-tab>"))))
;; (org-force-cycle-archived) It is bound to <C-tab>.

;; ORG-TRELLO
(custom-set-variables '(org-trello-files '("~/Documents/mgmt-docs/calendar.trello" "~/Documents/mgmt-docs/haxgeo-trello.trello" "~/Documents/mgmt-docs/floortek-calendar.trello") ))

;; org-trello major mode for all .trello files
(add-to-list 'auto-mode-alist '("\\.trello$" . org-mode))

(add-hook 'org-trello-mode-hook
          (lambda ()
            (org-indent-mode t)
            (toggle-truncate-lines 0)))


;; EVIL MODE
(eval-after-load "evil-maps"
  (dolist (map '(evil-motion-state-map
                 evil-insert-state-map
                 evil-emacs-state-map))
    (define-key (eval map) "\C-w" nil)))
;; Clipboard bypassing START
;; http://www.codejury.com/bypassing-the-clipboard-in-emacs-evil-mode/
;;;; Support

(defmacro without-evil-mode (&rest do-this)
  ;; Check if evil-mode is on, and disable it temporarily
  `(let ((evil-mode-is-on (evil-mode?)))
     (if evil-mode-is-on
         (disable-evil-mode))
     (ignore-errors
       ,@do-this)
     (if evil-mode-is-on
         (enable-evil-mode))))

(defmacro evil-mode? ()
  "Checks if evil-mode is active. Uses Evil's state to check."
  `evil-state)

(defmacro disable-evil-mode ()
  "Disable evil-mode with visual cues."
  `(progn
     (evil-mode 0)
     (message "Evil mode disabled")))

(defmacro enable-evil-mode ()
  "Enable evil-mode with visual cues."
  `(progn
     (evil-mode 1)
     (message "Evil mode enabled")))

;;;; Clipboard bypass

;; delete: char
(evil-define-operator evil-destroy-char (beg end type register yank-handler)
  :motion evil-forward-char
  (evil-delete-char beg end type ?_))

;; delete: char (backwards)
(evil-define-operator evil-destroy-backward-char (beg end type register yank-handler)
  :motion evil-forward-char
  (evil-delete-backward-char beg end type ?_))

;; delete: text object
(evil-define-operator evil-destroy (beg end type register yank-handler)
  "Vim's 's' without clipboard."
  (evil-delete beg end type ?_ yank-handler))

;; delete: to end of line
(evil-define-operator evil-destroy-line (beg end type register yank-handler)
  :motion nil
  :keep-visual t
  (interactive "<R><x>")
  (evil-delete-line beg end type ?_ yank-handler))

;; delete: whole line
(evil-define-operator evil-destroy-whole-line (beg end type register yank-handler)
  :motion evil-line
  (interactive "<R><x>")
  (evil-delete-whole-line beg end type ?_ yank-handler))

;; change: text object
(evil-define-operator evil-destroy-change (beg end type register yank-handler delete-func)
  (evil-change beg end type ?_ yank-handler delete-func))

;; paste: before
(defun evil-destroy-paste-before ()
  (interactive)
  (without-evil-mode
     (delete-region (point) (mark))
     (evil-paste-before 1)))

;; paste: after
(defun evil-destroy-paste-after ()
  (interactive)
  (without-evil-mode
     (delete-region (point) (mark))
     (evil-paste-after 1)))

;; paste: text object
(evil-define-operator evil-destroy-replace (beg end type register yank-handler)
  (evil-destroy beg end type register yank-handler)
  (evil-paste-before 1 register))

;; Clipboard bypass key rebindings
(define-key evil-normal-state-map "s" 'evil-destroy)
(define-key evil-normal-state-map "S" 'evil-destroy-line)
(define-key evil-normal-state-map "c" 'evil-destroy-change)
(define-key evil-normal-state-map "x" 'evil-destroy-char)
(define-key evil-normal-state-map "X" 'evil-destroy-whole-line)
(define-key evil-normal-state-map "Y" 'evil-copy-to-end-of-line)
(define-key evil-visual-state-map "P" 'evil-destroy-paste-before)
(define-key evil-visual-state-map "p" 'evil-destroy-paste-after)

;; Clipboard bypassing END

;; Enable Evil mode as defuault
(evil-mode 1)
(add-hook 'evil-mode-hook
          (lambda()
            (local-unset-key "C-/")
            (local-unset-key "C-z")))
(eval-after-load "evil-maps"
  (dolist (map '(evil-motion-state-map

                 evil-insert-state-map
                 evil-emacs-state-map))
    (define-key (eval map) "\C-z" nil)))
;;    (define-key (eval map) (kbd "C-/") nil)))

(add-hook 'undo-tree-mode (lambda () (local-unset-key "C-/")))

(define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
(define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)
;; (define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up) ;; C-u interferes with org-mode bindings
;; (define-key evil-visual-state-map (kbd "C-u") 'evil-scroll-up)
(define-key evil-insert-state-map (kbd "C-u")
  (lambda ()
    (interactive)
    (evil-delete (point-at-bol) (point))))

;; key translations
;; ie: translate zh to C-h and zx to C-x
(define-key evil-normal-state-map "z" nil)
(define-key evil-motion-state-map "zu" 'universal-argument)
(define-key key-translation-map (kbd "zh") (kbd "C-h"))
(define-key key-translation-map (kbd "zx") (kbd "C-x"))

;;; esc quits pretty much anything (like pending prompts in the minibuffer)

(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)

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

;; Hooks to enabe/disable evil in other modes
(add-hook 'term-mode-hook 'evil-emacs-state)
(add-hook 'ansi-term-mode-hook 'evil-emacs-state)

;; CALENDAR MODE
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

;; IMAGE-DIRED
(evil-set-initial-state 'image-dired-thumbnail-mode 'emacs)
(add-hook 'image-dired-thumbnail-mode-hook
	  (lambda ()
            (define-key image-dired-thumbnail-mode-map (kbd "j") 'image-dired-next-line)
            (define-key image-dired-thumbnail-mode-map (kbd "k") 'image-dired-previous-line)
            (define-key image-dired-thumbnail-mode-map (kbd "l") 'image-dired-forward-image)
            (define-key image-dired-thumbnail-mode-map (kbd "h") 'image-dired-backward-image)
            (define-key image-dired-thumbnail-mode-map (kbd "u") 'image-dired-unmark-thumb-original-file)
            (define-key image-dired-thumbnail-mode-map (kbd "m") 'image-dired-mark-thumb-original-file)
            (define-key image-dired-thumbnail-mode-map (kbd "d") 'image-dired-flag-thumb-original-file)
            (define-key image-dired-thumbnail-mode-map (kbd "t") 'image-dired-list-tags)
            (define-key image-dired-thumbnail-mode-map (kbd "z") 'image-dired-thumb-size)
            (define-key image-dired-thumbnail-mode-map (kbd "w") 'image-dired-write-tags)
            (define-key image-dired-thumbnail-mode-map (kbd "r") 'image-dired-remove-tag)
            (define-key image-dired-thumbnail-mode-map (kbd "L") 'image-dired-rotate-original-left)
            (define-key image-dired-thumbnail-mode-map (kbd "R") 'image-dired-rotate-original-right)
            )
          )

(eval-after-load "image-dired"
  '(progn
     (setq image-dired-cmd-create-thumbnail-options
           (replace-regexp-in-string "-strip" "-auto-orient -strip" image-dired-cmd-create-thumbnail-options)
           image-dired-cmd-create-temp-image-options
           (replace-regexp-in-string "-strip" "-auto-orient -strip" image-dired-cmd-create-temp-image-options))))


;; ERC page-me
;; from http://www.emacswiki.org/emacs/ErcPageMe#toc4

(add-hook 'erc-mode-hook
          (lambda ()
            (flyspell-mode)))
;; setting keywords is based off of the default erc-match.el
;; http://www.emacswiki.org/emacs/ErcChannelTracking
(makunbound 'erc-keywords)
(setq erc-keywords `("lswart" "JakeRake"))
;; ("MYNICK *[,:;]" "\\bMY-FIRST-NAME[!?.]+$" "hey MY-FIRST-NAME")
(erc-match-mode 1)
(defvar my-erc-page-message "%s is calling your name."
  "Format of message to display in dialog box")

(defvar my-erc-page-nick-alist nil
  "Alist of nicks and the last time they tried to trigger a
notification")

(defvar my-erc-page-timeout 30
  "Number of seconds that must elapse between notifications from
the same person.")

;; Notify via alarm bell and save all messages to a buffer
(defun erc-global-notify-arch (match-type nick message)
  "Notify when a message is recieved."
  (when (and  ;; I don't want to see anything from the erc server
             (null (string-match "\\`\\([sS]erver:\\|localhost\\)" nick))
             ;; or my ZNC bouncer
             (null (string-match "zncuser!" nick))
             ;; or bots
             (null (string-match "\\(bot\\|serv\\)!" nick)))
    ;; This only works on Ubuntu, or when configured with DBUS notifications
    ;; (notifications-notify
    ;;  :title nick
    ;;  :body message
    ;;  :app-icon "/usr/share/notify-osd/icons/gnome/scalable/status/notification-message-im.svg"
    ;;  :urgency 'low)))
    (progn
      (start-process-shell-command "whatever" nil "ffplay -t 0.5 -autoexit -nodisp ~/Music/sounds/bell-ringing-04.wav")
      (append-message-to-buffer "erc notifications" (concat nick "\n\t" message))
      )
    ))

(defun my-erc-page-allowed (nick &optional delay)
  "Return non-nil if a notification should be made for NICK.
If DELAY is specified, it will be the minimum time in seconds
that can occur between two notifications.  The default is
`my-erc-page-timeout'."
  (unless delay (setq delay my-erc-page-timeout))
  (let ((cur-time (time-to-seconds (current-time)))
        (cur-assoc (assoc nick my-erc-page-nick-alist))
        (last-time))
    (if cur-assoc
        (progn
          (setq last-time (cdr cur-assoc))
          (setcdr cur-assoc cur-time)
          (> (abs (- cur-time last-time)) delay))
      (push (cons nick cur-time) my-erc-page-nick-alist)
      t)))

(defun my-erc-page-me (match-type nick message)
  "Notify the current user when someone sends a message that
matches a regexp in `erc-keywords'."
  (interactive)
  (when (and (eq match-type 'keyword)
             ;; I don't want to see anything from the erc server
             (null (string-match "\\`\\([sS]erver\\|localhost\\)" nick))
             ;; or bots
             (null (string-match "\\(bot\\|serv\\)!" nick))
             ;; or from those who abuse the system
             (my-erc-page-allowed nick 1))
      (erc-global-notify-arch match-type nick message)))
(add-hook 'erc-text-matched-hook 'my-erc-page-me)

(defun my-erc-page-me-PRIVMSG (proc parsed)
  (let ((nick (car (erc-parse-user (erc-response.sender parsed))))
        (target (car (erc-response.command-args parsed)))
        (msg (erc-response.contents parsed)))
    (when (and (erc-current-nick-p target)
               (not (erc-is-message-ctcp-and-not-action-p msg))
               (my-erc-page-allowed nick 1))
      (message "logging erc-page-me-PRIVMSG statement!")
      (message "proc is: %s" proc)
      (erc-global-notify-arch nil nick msg)
      (message "finished calling erc-global-notify-arch from prviate message")
      nil)))
(add-hook 'erc-server-PRIVMSG-functions 'my-erc-page-me-PRIVMSG)

;; Shell Script Mode
(add-hook 'shell-script-mode-hook 'linum-mode)

;; Conf mode
(add-hook 'conf-mode-hook 'linum-mode)

;; YAML mode
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-hook 'yaml-mode-hook
          '(lambda ()
             (define-key yaml-mode-map "\C-m" 'newline-and-indent)))
