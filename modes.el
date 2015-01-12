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
;;(add-hook 'python-mode-hook #'linum-on)
(add-hook 'python-mode-hook 'linum-mode)
(add-to-list 'auto-mode-alist '("\\.po\\'" . python-mode))

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

;; (add-hook 'js-mode-hook 'js2-minor-mode)
;;(add-hook 'js2-mode-hook #'linum-on)
;; (add-hook 'js2-mode-hook 'linum-mode)
;; (add-hook 'js2-mode-hook 'ac-js2-mode)

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
            (linum-mode)
            (js2-minor-mode)
            (ac-js2-mode)
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

;; HTML mode
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
            (local-unset-key [C-tab])
            (org-indent-mode t)))
            ;; (local-unset-key (kbd "C-tab"))))
            ;; (local-unset-key (kbd "<C-tab>"))))
;; (org-force-cycle-archived) It is bound to <C-tab>.

;; EVIL MODE
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
(define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up)
(define-key evil-visual-state-map (kbd "C-u") 'evil-scroll-up)
(define-key evil-insert-state-map (kbd "C-u")
  (lambda ()
    (interactive)
    (evil-delete (point-at-bol) (point))))


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
;;
(define-key evil-insert-state-map "k" #'cofi/maybe-exit-kj)
;; Set 'kj' to exit insert mode
(evil-define-command cofi/maybe-exit-kj ()
  :repeat change
  (interactive)
  (let ((modified (buffer-modified-p)))
    (insert "k")
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

(define-key evil-insert-state-map "j" #'cofi/maybe-exit-jk)
(evil-define-command cofi/maybe-exit-jk ()
  :repeat change
  (interactive)
  (let ((modified (buffer-modified-p)))
    (insert "j")
    (let ((evt (read-event (format "Insert %c to exit insert state" ?k)
               nil 0.5)))
      (cond
       ((null evt) (message ""))
       ((and (integerp evt) (char-equal evt ?k))
    (delete-char -1)
    (set-buffer-modified-p modified)
    (push 'escape unread-command-events))
       (t (setq unread-command-events (append unread-command-events
                          (list evt))))))))

;; DOC-VIEW
;; adjust docview mode
(setq doc-view-continuous nil)
(defun adjust-doc-view ()
  (local-unset-key (kbd "k"))
  (local-unset-key (kbd "j"))
  (local-unset-key (kbd "l"))
  (local-unset-key (kbd "h"))
  (local-set-key (kbd "k") 
    'doc-view-previous-line-or-previous-page)
  (local-set-key (kbd "j") 
    'doc-view-next-line-or-next-page)
  (local-set-key (kbd "h") 
    'image-backward-hscroll)
  (local-set-key (kbd "l") 
    'image-forward-hscroll)
  ;; (-local-set-key (kbd "M-i")
  ;;   'doc-view-previous-line-or-previous-page)
  ;; (ergoemacs-local-set-key (kbd "M-k")
  ;;   'doc-view-next-line-or-next-page)
)
(add-hook 'doc-view-mode-hook 'adjust-doc-view)

;; ERC page-me 
;; from http://www.emacswiki.org/emacs/ErcPageMe#toc4

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

;; Uses DBUS notification (Ubuntu only?)
(require 'notifications)
(defun erc-global-notify (match-type nick message)
  "Notify when a message is recieved."
  (when (and  ;; I don't want to see anything from the erc server
             (null (string-match "\\`\\([sS]erver:\\|localhost\\)" nick))
             ;; or my ZNC bouncer
             (null (string-match "!~lucas@" nick))
             ;; or bots
             (null (string-match "\\(bot\\|serv\\)!" nick)))
             ;; (null (string-match "\\(bot\\|serv\\)!" nick))
             ;; or from those who abuse the system
             ;; (my-erc-page-allowed nick))
    (notifications-notify
     :title nick
     :body message
     :app-icon "/usr/share/notify-osd/icons/gnome/scalable/status/notification-message-im.svg"
     :urgency 'low)))

(add-hook 'erc-text-matched-hook 'erc-global-notify)

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
             ;; (null (string-match "\\`\\([sS]erver\\|localhost\\)" nick))
             ;; or bots
             (null (string-match "\\(bot\\|serv\\)!" nick))
             ;; or from those who abuse the system
             (my-erc-page-allowed nick))
    ;; (my-erc-page-popup-notification nick)))
    (erc-global-notify match-type nick message)))
(add-hook 'erc-text-matched-hook 'my-erc-page-me)

(defun my-erc-page-me-PRIVMSG (proc parsed)
  (let ((nick (car (erc-parse-user (erc-response.sender parsed))))
        (target (car (erc-response.command-args parsed)))
        (msg (erc-response.contents parsed)))
    (when (and (erc-current-nick-p target)
               (not (erc-is-message-ctcp-and-not-action-p msg))
               (my-erc-page-allowed nick))
      ;; (my-erc-page-popup-notification nick)
      (message "logging erc-page-me-PRIVMSG statement!")
      (message "proc is: %s" proc)
      (erc-global-notify nil nick msg)
      (message "finished calling erc-global-notify from prviate message")
      nil)))
(add-hook 'erc-server-PRIVMSG-functions 'my-erc-page-me-PRIVMSG)
