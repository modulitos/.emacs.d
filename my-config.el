;; SYSTEM DIRECTORY
(setq default-directory "~/")        
;; (setq default-directory "~/workspace/emacs/")
(message "Default Dir: %S" default-directory)

;; WARNING: These options result in errors for non-supported encodings.
;; (setq utf-translate-cjk-mode nil) ; disable CJK coding/encoding (Chinese/Japanese/Korean characters)
;; (set-language-environment 'utf-8)
;; (set-keyboard-coding-system 'utf-8-mac) ; For old Carbon emacs on OS X only
;; (setq locale-coding-system 'utf-8)
;; (set-default-coding-systems 'utf-8)
;; (set-terminal-coding-system 'utf-8)
;; (unless (eq system-type 'windows-nt)
;;  (set-selection-coding-system 'utf-16-le))
;; (prefer-coding-system 'utf-8)


;; SESSION MANAGEMENT - Windows Mode
  ;; (require 'desktop-menu)
;; (add-to-list 'load-path "~/workspace/emacs/.emacs.d/elisp/windows2.el") 
  (add-to-list 'load-path (expand-file-name "~/.emacs.d/elisp"))
  ;; (add-to-list 'load-path "~/workspace/emacs/.emacs.d/elisp/windows.el")
  (require 'windows)
  (win:startup-with-window)
  (define-key ctl-x-map "C" 'see-you-again)

  ;; ;; Revive for Windows Mode - saves windows configuration for the desktop.
  ;; ;; Put revive.el into your elisp  directory included in load-path
  ;; ;; and write the next expressions.

  ;;   (autoload 'save-current-configuration "revive" "Save status" t)
  ;;   (autoload 'resume "revive" "Resume Emacs" t)
  ;;   (autoload 'wipe "revive" "Wipe Emacs" t)

  ;; ;; And define favorite keys to those functions.  Here is a sample.

  ;;   (define-key ctl-x-map "S" 'save-current-configuration)
  ;;   (define-key ctl-x-map "F" 'resume)
  ;;   (define-key ctl-x-map "K" 'wipe)

  (require 'uniquify)
  (setq uniquify-buffer-name-style 'reverse)


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
(package-initialize)
 (elpy-enable)
 ;; Fixing a key binding bug in elpy
 (define-key yas-minor-mode-map (kbd "C-c e") 'yas-expand)
 ;; Fixing another key binding bug in iedit mode
 (define-key global-map (kbd "C-c o") 'iedit-mode)


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
; TODO: error here! 
;; (eval-after-load "sql"
;;   '(load-library "sql-indent.el"))


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

(add-hook 'js-mode-hook 'js2-minor-mode)
(add-hook 'js2-mode-hook 'ac-js2-mode)
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

            (local-set-key (kbd "C-j") 'ac-js2-jump-to-definition)
            (define-key js2-mode-map (kbd "C-j") 'ac-js2-jump-to-definition)
            )
)

;; (global-unset-key [<f3>])
;; (global-set-key [<f3>] nil)

;; (autoload 'js2-mode "elp/js2-mode-20140603.1818/js2.el" nil t)
(setq auto-mode-alist
       (cons '("\\.js$" . js2-mode) auto-mode-alist))
;; (add-to-list 'auto-mode-alist '("\\.js$" . js2-mode)) ;; same thing as above

(require 'js2-refactor)
(js2r-add-keybindings-with-prefix "C-c C-m")


;; MATLAB-MODE
;; '.m' confilcts with obj-c mode. Default to matlab for '.m' files.
(setq auto-mode-alist
       (cons '("\\.m$" . matlab-mode) auto-mode-alist))


;; LATEX
  ;; (setq latex-run-command "pdflatex")
  (setq latex-run-command "xelatex")
  (add-hook 'latex-mode-hook 'flyspell-mode)

;; MARKDOWN 
  (custom-set-variables
   '(markdown-command "/usr/bin/pandoc"))

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

;; (load-theme zenburn-theme.el) ;; not working...
;; ;; switch to dark mode and back
;; (defun toggle-night-color-theme ()
;;       "Switch to/from night color scheme."
;;       (interactive)
;;       (require 'color-theme)
;;       (if (eq (frame-parameter (next-frame) 'background-mode) 'dark)
;;           (color-theme-snapshot) ; restore default (light) colors
;;         ;; create the snapshot if necessary
;;         (when (not (commandp 'color-theme-snapshot))
;;           (fset 'color-theme-snapshot (color-theme-make-snapshot)))
;;         (color-theme-dark-laptop)))
    
;;     (global-set-key (kbd "<f9> n") 'toggle-night-color-theme)
;;     (setq calendar-location-name "Seattle, WA") 
;;     (setq calendar-latitude 47.61)
;;     (setq calendar-longitude -122.33)

;; ;; And then specify the day and night color themes: 

;;     (add-to-list 'load-path "~/workspace/emacs/.emacs.d/elisp/theme-changer")
;;     (require 'theme-changer)
;; ;;    (change-theme 'color-theme-solarized-light 'color-theme-solarized-dark)
;;     ;; (change-theme 'misterioso 'wombat)
;;     (change-theme 'wombat 'wombat)
;; ;; in mini-buffer, this is "load-theme"

;; TERMINAL
(setq term-default-bg-color "#6F6F6F") ;; light grey
(setq term-default-fg-color "#FAFAFA") ;; letters
(add-hook 'ansi-term-mode-hook
    (lambda ()
      ;; (set-face-attribute 'term-color-blue nil :foreground "#5555FF")
      ;; (set-face-attribute 'term-color-green nil :foreground "#55FF55")
      ;; (set-face-attribute 'term-color-red nil :foreground "#FF5555")
      ;; (set-face-attribute 'term-color-magenta nil :foreground "#FF55FF")
      ;; (set-face-attribute 'term-color-cyan nil :foreground "#FF55FF")
      ;; (set-face-attribute 'term-color-yellow nil :foreground "#FFFF55")
      ;; (set-background-color "6F6F6F")

      (local-set-key (kbd "C-j") 'term-line-mode)
      (local-set-key (kbd "C-k") 'term-char-mode)))
      
;; (setq term-default-fg-color "#D787FF")
;; (add-to-list 'load-path "~/workspace/emacs/.emacs.d/elisp/mult-term.el")
;;  (require 'multi-term)
;; ;;
;; ;; And setup program that `multi-term' will need:
;; ;;
;; (setq multi-term-program "/bin/bash")
;; ;;
;; ;;      or setup like me "/bin/zsh" ;)
;; (global-set-key (kbd "M-S-t") 'ansi-term)

;; (global-set-key [M-S-t] 'ansi-term)    


;; YASNIPPET AND AUTO-COMPLETION
;;; yasnippet
;;; should be loaded before auto complete so that they can work together
(require 'yasnippet)
(yas-global-mode 1)
;; help from: http://stackoverflow.com/questions/8225183/emacs-yasnippet-install
(require 'yasnippet "~/.emacs.d/elpa//yasnippet-20140514.1649/yasnippet.el")
;; (yas/initialize)
(setq yas/root-directory "~/.emacs.d/elpa/yasnippet-20140514.1649/snippets")
(yas/load-directory yas/root-directory)
(add-hook 'term-mode-hook (lambda()
        (setq yas-dont-activate t)))

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

;; maintain highlighting after buffer refresh
(defun testing-MapAppLog.txt ()
  "Toggle highlighting `TestQueryLogic' or `invoking fork-join' and `testGudermann'."
  (interactive)
  (cond
   ((get this-command 'state)
    ;; (highlight-regexp "TestQueryLogic"     font-lock-variable-name-face) ;orange
    (highlight-regexp "TestQueryLogic"     font-lock-preprocessor-face) ;bold blue
    (highlight-regexp "invoking fork-join" font-lock-constant-face) ;green
    (unhighlight-regexp "testGudermann")
    (message "Highlighting: TestQueryLogic, invoking fork-join")
    (put this-command 'state nil))
   (t
    (unhighlight-regexp "TestQueryLogic")
    (unhighlight-regexp "invoking fork-join")
    (highlight-regexp "testGudermann" font-lock-preprocessor-face) ;bold blue
    (message "Highlighting: testGudermann") 
    (put this-command 'state t))))
;; Font-lock faces to choose from:
;; font-lock-warning-face
;; font-lock-function-name-face
;; font-lock-variable-name-face
;; font-lock-keyword-face
;; font-lock-comment-face
;; font-lock-comment-delimiter-face
;; font-lock-type-face
;; font-lock-constant-face
;; font-lock-builtin-face
;; font-lock-preprocessor-face
;; font-lock-string-face
;; font-lock-doc-face
;; font-lock-negation-char-face
(define-key text-mode-map (kbd "M-s t") 'testing-MapAppLog.txt)

(add-to-list 'load-path (expand-file-name "~/.emacs.d/elisp/expand-region"))
(require 'expand-region)
;; (require 'expand-region/expand-region-core.el)
(global-set-key (kbd "C-=") 'er/expand-region)

;; (defun comment-or-uncomment-region-or-line ()
;;     "Comments or uncomments the region or the current line if there's no active region."
;;     (interactive)
;;     (let (beg end)
;;         (if (region-active-p)
;;             (setq beg (region-beginning) end (region-end))
;;             (setq beg (line-beginning-position) end (line-end-position)))
;;         (comment-or-uncomment-region beg end)
;;         (next-line)))
(require 'cl)
(require 'recentf)

(defun find-last-killed-file ()
  (interactive)
  (let ((active-files (loop for buf in (buffer-list)
                            when (buffer-file-name buf) collect it)))
    (loop for file in recentf-list
          unless (member file active-files) return (find-file file))))

(define-key global-map (kbd "C-S-t") 'find-last-killed-file)
(global-set-key (kbd "C-x C-;") 'comment-or-uncomment-region-or-line)
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
(defun comment-or-uncomment-region-or-line ()
  "Comments or uncomments the region or the current line if there's no active region."
  (interactive)
  (let (beg end)
    (if (region-active-p)
        (setq beg (region-beginning) end (region-end))
      (setq beg (line-beginning-position) end (line-end-position)))
    (comment-or-uncomment-region beg end)))

(defun comment-eclipse (&optional arg)
  (interactive)
  (let ((start (line-beginning-position))
        (end (line-end-position)))
    (when (or (not transient-mark-mode) (region-active-p))
      (setq start (save-excursion
                    (goto-char (region-beginning))
                    (beginning-of-line)
                    (point))
            end (save-excursion
                  (goto-char (region-end))
                  (end-of-line)
                  (point))))
    (comment-or-uncomment-region start end)))
  ;; (if (not (region-active-p))
  ;; (comment-dwim arg)))

(global-set-key (kbd "C-/") 'comment-eclipse)

;; Original idea from
;; http://www.opensubscriber.com/message/emacs-devel@gnu.org/10971693.html
(defun comment-dwim-line (&optional arg)
  "Replacement for the comment-dwim command.
  If no region is selected and current line is not blank and we are not at the end of the line,
  then comment current line.
  Replaces default behaviour of comment-dwim, when it inserts comment at the end of the line."
  (interactive "*P")
  (comment-normalize-vars)
  (if (and (not (region-active-p)) (not (looking-at "[ \t]*$")))
      (comment-or-uncomment-region (line-beginning-position) (line-end-position))
    (comment-dwim arg)))
(global-set-key "\M-;" 'comment-dwim-line)
(global-set-key (kbd "C-?") 'comment-dwim-line)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)



(defun delete-this-buffer-and-file ()
  "Removes file connected to current buffer and kills buffer."
  (interactive)
  (let ((filename (buffer-file-name))
        (buffer (current-buffer))
        (name (buffer-name)))
    (if (not (and filename (file-exists-p filename)))
        (error "Buffer '%s' is not visiting a file!" name)
      (when (yes-or-no-p "Are you sure you want to remove this file? ")
        (delete-file filename)
        (kill-buffer buffer)
        (message "File '%s' successfully removed" filename)))))
(global-set-key (kbd "C-c k") 'delete-this-buffer-and-file)

; Cycle between windows
(global-set-key (kbd "C-~") 'other-window)
(global-set-key (kbd "C-`") 
    (lambda ()
      (interactive)
      (other-window -1)))
; Cycle between buffers

;; start buffer-stack keybindings
(require 'buffer-stack)

(global-set-key [(f9)] 'buffer-stack-bury)
(global-set-key [(control f9)] 'buffer-stack-bury-and-kill)
(global-set-key [(f12)] 'buffer-stack-track)
(global-set-key [(control f12)] 'buffer-stack-untrack)

(global-set-key (kbd "C-q") 'buffer-stack-bury)
(global-set-key [C-tab] 'buffer-stack-down)
(global-set-key [C-S-iso-lefttab] 'buffer-stack-up);Linux
(global-set-key [C-S-tab] 'buffer-stack-up);Windows/Linux
;; (global-set-key [(f10)] 'buffer-stack-up)
;; (global-set-key [(f11)] 'buffer-stack-down)
;; end buffer-stack keybindings

;; (global-set-key [C-tab] 'next-buffer)
;; (global-set-key [C-S-iso-lefttab] 'previous-buffer);Linux
;; (global-set-key [C-S-tab] 'previous-buffer);Windows/Linux


;; (defun my-switch-buffer ()
;;   "Switch buffers, but don't record the change until the last one."
;;   (interactive)
;;   (let ((blist (copy-sequence (buffer-list)))
;;         current
;;         (key-for-this (this-command-keys))
;;         (key-for-this-string (format-kbd-macro (this-command-keys)))
;;         done)
;;     (while (not done)
;;       (setq current (car blist))
;;       (setq blist (append (cdr blist) (list current)))
;;       (when (and (not (get-buffer-window current))
;;                  (not (minibufferp current)))
;;         (switch-to-buffer current t)
;;         (message "Type %s to continue cycling" key-for-this-string)
;;         (when (setq done (not (equal key-for-this (make-vector 1 (read-event)))))
;;           (switch-to-buffer current)
;;           (clear-this-command-keys t)
;;           (setq unread-command-events (list last-input-event)))))))

;; Start eshell or switch to it if it's active.
(global-set-key (kbd "C-x m") 'eshell)

;; Start a new eshell even if one is active.
(global-set-key (kbd "C-x M") (lambda () (interactive) (eshell t)))

;; Lazy highlighting while searching (can instead use M-s h r to highlight regex)
;; (setq lazy-highlight-cleanup nil)

;; Delete words in minibuffer without adding it to the kill ring.
(add-hook 'minibuffer-setup-hook'
          (lambda ()
            (make-local-variable 'kill-ring)))
;; (defun xp-read-file-name (prompt &optional dir default-filename mustmatch initial predicate)
;; (setq last-nonmenu-event nil)
;;   (funcall (or read-file-name-function #'read-file-name-default)
;;            prompt dir default-filename mustmatch initial predicate))

;; Shift the selected region right if distance is postive, left if
;; negative

 (defun shift-region (distance)
   (let ((mark (mark)))
     (save-excursion
       (indent-rigidly (region-beginning) (region-end) distance)
       (push-mark mark t t)
       ;; Tell the command loop not to deactivate the mark
       ;; for transient mark mode
       (setq deactivate-mark nil))))

(defun shift-right ()
  (interactive)
  (shift-region 1))

(defun shift-left ()
  (interactive)
  (shift-region -1))

;; Bind (shift-right) and (shift-left) function to your favorite keys. I use
;; the following so that Ctrl-Shift-Right Arrow moves selected text one 
;; column to the right, Ctrl-Shift-Left Arrow moves selected text one
;; column to the left:

(global-set-key [C-S-right] 'shift-right)
(global-set-key [C-S-left] 'shift-left)
;; (global-set-key [tab] 'shift-right)
;; (global-set-key [backtab] 'shift-left)

;; MATCHING TAGS src: http://blog.binchen.org/?p=775
;; make sp-select-next-thing works even the cusor is in the open/close tag
;; like matchit in vim
;; @return t => start from open tag; nil start from close tag
(defun my-sp-select-next-thing (&optional NUM)
  (interactive "p")
  (let ((b (line-beginning-position))
        (e (line-end-position))
        (char (following-char))
        (p (point))
        rbeg
        rend
        (rlt t)
        )
    ;; "<" char code is 60
    ;; search backward
    (if (not (= char 60))
        (save-excursion
          (while (and (<= b (point)) (not (= char 60)))
            (setq char (following-char))
            (setq p (point))
            (backward-char)
            )
          )
      )
    ;; search forward
    (if (not (= char 60))
        (save-excursion
          (while (and (>= e (point)) (not (= char 60)))
            (setq char (following-char))
            (setq p (point))
            (forward-char)
            )
          )
      )
    ;; do the real thing
    (when (and (= char 60) (< p e))
      (goto-char p)
      (forward-char)
      (if (= (following-char) 47)
          (progn
            ;; </
            (backward-char)
            (setq rlt nil)
            )
        (progn
          ;; < , looks fine
          (backward-char)
          (setq rlt t)
          )
        )
      (sp-select-next-thing)
      (setq rbeg (region-beginning))
      (setq rend (region-end))
 
      (while (> NUM 1)
        ;; well, sp-select-next-thing is kind of wierd
        (re-search-forward "<[^!]")
        (backward-char 2)
        (sp-select-next-thing)
        (setq rend (region-end))
        (setq NUM (1- NUM))
        )
      (push-mark rbeg t t)
      (goto-char (1-rend))
      )
    rlt
    )
  )
;; (defun xp-save-as (filename &optional confirm)
;;   (interactive
;;    (list (if buffer-file-name
;;        (xp-read-file-name "Write file: " nil nil nil nil)
;;      (xp-read-file-name "Write file: " "C:/Users/Lucas/"
;;          (expand-file-name
;;           (file-name-nondirectory (buffer-name))
;;           "C:/Users/Lucas/")
;;          nil nil))
;;    (not current-prefix-arg)))
;;   (or (null filename) (string-equal filename "")
;;       (progn
;;   (if (file-directory-p filename)
;;       (setq filename (concat (file-name-as-directory filename)
;;            (file-name-nondirectory
;;             (or buffer-file-name (buffer-name))))))
;;   (and confirm
;;        (file-exists-p filename)
;;        (not (and (eq (framep-on-display) 'ns)
;;            (listp last-nonmenu-event)
;;            use-dialog-box))
;;        (or (y-or-n-p (format "File `%s' exists; overwrite? " filename))
;;      (error "Canceled")))
;;   (set-visited-file-name filename (not confirm))))
;;   (set-buffer-modified-p t)
;;   (and buffer-file-name
;;        (file-writable-p buffer-file-name)
;;        (setq buffer-read-only nil))
;;   (save-buffer)
;;   (vc-find-file-hook))


;; Duplicates the line or selection.
(defun duplicate-current-line-or-region (arg)
  "Duplicates the current line or region ARG times.
If there's no region, the current line will be duplicated. However, if
there's a region, all lines that region covers will be duplicated."
  (interactive "p")
  (let (beg end (origin (point)))
    (if (and mark-active (> (point) (mark)))
        (exchange-point-and-mark))
    (setq beg (line-beginning-position))
    (if mark-active
        (exchange-point-and-mark))
    (setq end (line-end-position))
    (let ((region (buffer-substring-no-properties beg end)))
      (dotimes (i arg)
        (goto-char end)
        (newline)
        (insert region)
        (setq end (point)))
      (goto-char (+ origin (* (length region) arg) arg)))))

(global-set-key (kbd "C-S-SPC") 'duplicate-current-line-or-region)

;; BUFFER NAVIGATION

;; Sentence navigation
(setq sentence-end-double-space nil)   

;; Scrolling
(setq scroll-conservatively 10000)

;; Emulate Eclipse's text movement for regions and lines.
;; Moves text up or down.
(defun move-text-internal (arg)
   (cond
    ((and mark-active transient-mark-mode)
     (if (> (point) (mark))
            (exchange-point-and-mark))
     (let ((column (current-column))
              (text (delete-and-extract-region (point) (mark))))
       (forward-line arg)
       (move-to-column column t)
       (set-mark (point))
       (insert text)
       (exchange-point-and-mark)
       (setq deactivate-mark nil)))
    (t
     (beginning-of-line)
     (when (or (> arg 0) (not (bobp)))
       (forward-line)
       (when (or (< arg 0) (not (eobp)))
            (transpose-lines arg))
       (forward-line -1)))))

(defun move-text-down (arg)
   "Move region (transient-mark-mode active) or current line
  arg lines down."
   (interactive "*p")
   (move-text-internal arg))

(defun move-text-up (arg)
   "Move region (transient-mark-mode active) or current line
  arg lines up."
   (interactive "*p")
   (move-text-internal (- arg)))

;; Setting the backtab.
;; (global-set-key (kbd "<S-tab>") 'un-indent-by-removing-4-spaces)
(global-set-key (kbd "<backtab>") 'un-indent-by-removing-4-spaces)
(defun un-indent-by-removing-4-spaces ()
  "remove 4 spaces from beginning of of line"
  (interactive)
  (save-excursion
    (save-match-data
      (beginning-of-line)
      ;; get rid of tabs at beginning of line
      (when (looking-at "^\\s-+")
        (untabify (match-beginning 0) (match-end 0)))
      (when (looking-at "^    ")
        (replace-match "")))))

;; (global-set-key [\M-\S-up] 'move-text-up)
;; (global-set-key [\M-\S-down] 'move-text-down)
(global-set-key (kbd "C-M-p") 'move-text-up)
(global-set-key (kbd "C-M-n") 'move-text-down)
;; end move text up or down.

;; Show matching PARENTHESIS, BRACES
(show-paren-mode 1)

;; Paragraph edit mode for balancing parentheses
;; (define-key js-mode-map "{" 'paredit-open-curly)
;; (define-key js-mode-map "}" 'paredit-close-curly-and-newline)
(defun my-paredit-nonlisp ()
  "Turn on paredit mode for non-lisps."
  (interactive)
  (set (make-local-variable 'paredit-space-for-delimiter-predicates)
       '((lambda (endp delimiter) nil)))
  (paredit-mode 1))
(add-hook 'js-mode-hook 'my-paredit-nonlisp)


;; MISC KEY-BINDINGS
;; (global-set-key (kbd "C-z") 'undo)
(dolist (key '("\C-z"))
  (global-unset-key key))
(dolist (key '("\C-Caps_Lock" "\C-x \C-z"))
  (global-unset-key key))
(define-key global-map [M-left]
  (lambda ()
    (interactive)
    (set-mark-command t)))

;; rect-mark.el 
;; Rectangular mode editing - "C-x r" prefix, followed by normal mark/edit command.
;; reset the cursor (mark) position
    (global-set-key (kbd "C-x r C-SPC") 'rm-set-mark)
    (global-set-key (kbd "C-x r C-x") 'rm-exchange-point-and-mark)
    (global-set-key (kbd "C-x r C-w") 'rm-kill-region)
    (global-set-key (kbd "C-x r M-w") 'rm-kill-ring-save)
    (autoload 'rm-set-mark "rect-mark"
      "Set mark for rectangle." t)
    (autoload 'rm-exchange-point-and-mark "rect-mark"
      "Exchange point and mark for rectangle." t)
    (autoload 'rm-kill-region "rect-mark"
      "Kill a rectangular region and save it in the kill ring." t)
    (autoload 'rm-kill-ring-save "rect-mark"
      "Copy a rectangular region to the kill ring." t)

;; MINOR MODES
;; Camel Case subword mode
  (add-hook 'prog-mode-hook 'subword-mode)
  (add-hook 'text-mode-hook 'subword-mode)

;; Fly spell checker mode
  (add-hook 'text-mode-hook 'flyspell-mode)
  (add-hook 'markdown-mode-hook 'flyspell-mode)

;; Add highlighting to the current pointer line.
;; Change the color of the highlighted line.

(global-hl-line-mode)

;; (if term-mode
    ;; (hl-line-mode -1))
(make-variable-buffer-local 'global-hl-line-mode)
(add-hook 'ansi-term-mode-hook (lambda () (setq global-hl-line-mode nil)))
(add-hook 'Java/l-mode-hook (lambda () (setq global-hl-line-mode nil)))
(add-hook 'Lisp-mode-hook (lambda () (setq global-hl-line-mode nil)))

;; (add-hook 'term-mode
;;   (lambda()
;;     (hl-line-mode -1)
;;     (global-hl-line-mode -1))
;;   't
;; )
;; (add-hook 'Java/l-mode
;;   (lambda()
;;     (hl-line-mode -1)
;;     (global-hl-line-mode -1))
;;   't
;; )
;;    ;; (hl-line-mode))
;; (add-hook 'coding-hook 'turn-on-hl-line-mode)
;; (set-face-background hl-line-face "gray13") 
(set-face-background hl-line-face "gray30") ;lighter grey
(tool-bar-mode -1)
