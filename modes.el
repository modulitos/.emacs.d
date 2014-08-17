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
(add-hook 'doc-view-mode-hook 'auto-revert-mode)
(add-hook 'latex-mode-hook 'auto-revert-mode)

;; MARKDOWN 
(custom-set-variables
 '(markdown-command "/usr/bin/pandoc"))
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
(add-hook 'markdown-mode-hook (lambda ()
  (if (regexp-match-p networks-list-buffer-regexp (buffer-name))
      ;; condition true:
      (highlight-regexp "^\\([^(\#,)]*\\),"     font-lock-keyword-face) 
    ;; condition false:
      'nil) ) )

;; ORG MODE
(setq org-log-done t)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)

(add-hook 'org-mode-hook
          (lambda()
            (local-unset-key [C-tab])))
            ;; (local-unset-key (kbd "C-tab"))))
            ;; (local-unset-key (kbd "<C-tab>"))))
;; (org-force-cycle-archived) It is bound to <C-tab>.

