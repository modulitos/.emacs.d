(setq default-directory "~/")
(message "Default Dir: %S" default-directory)

; error here
(eval-after-load "sql"
  '(load-library "sql-indent.el"))

;; Capitalizes all SQL words
(defun my-capitalize-all-mysql-keywords ()
  (interactive)
  (require 'sql)
  (dolist (keywords sql-mode-mysql-font-lock-keywords) 
    (goto-char (point-min))
    (while (re-search-forward (car keywords) nil t)
      (goto-char (match-beginning 0))
      (upcase-word 1))))


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
(load-theme 'light-blue t)
;setq default-directory "~/")

;; (defun xp-read-file-name (prompt &optional dir default-filename mustmatch initial predicate)
;; (setq last-nonmenu-event nil)
;;   (funcall (or read-file-name-function #'read-file-name-default)
;;            prompt dir default-filename mustmatch initial predicate))

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
(defun comment-or-uncomment-region-or-line ()
    "Comments or uncomments the region or the current line if there's no active region."
    (interactive)
    (let (beg end)
        (if (region-active-p)
            (setq beg (region-beginning) end (region-end))
            (setq beg (line-beginning-position) end (line-end-position)))
        (comment-or-uncomment-region beg end)
        (next-line)))
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
(setq lazy-highlight-cleanup nil)
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
;; (setq utf-translate-cjk-mode nil) ; disable CJK coding/encoding (Chinese/Japanese/Korean characters)
;; (set-language-environment 'utf-8)
;; (set-keyboard-coding-system 'utf-8-mac) ; For old Carbon emacs on OS X only
;; (setq locale-coding-system 'utf-8)
;; (set-default-coding-systems 'utf-8)
;; (set-terminal-coding-system 'utf-8)
;; (unless (eq system-type 'windows-nt)
;;  (set-selection-coding-system 'utf-16-le))
;; (prefer-coding-system 'utf-8)

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
(global-set-key [C-tab] 'next-buffer)
(global-set-key [C-S-iso-lefttab] 'previous-buffer)
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
