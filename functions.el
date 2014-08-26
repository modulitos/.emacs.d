;; Custom highlighting
(defun testing-MapAppLog.txt ()
  "Toggle highlighting `TestQueryLogic' or `invoking fork-join' and `testGudermann'."
  (interactive)
  (cond
   ((get this-command 'state)
    ;; (highlight-regexp "TestQueryLogic"     font-lock-variable-name-face) ;orange
    (highlight-regexp "TestQueryLogic"     font-lock-preprocessor-face) ;bold blue
    (highlight-regexp "Global logger is initialized" font-lock-keyword-face) ;
    (highlight-regexp "BEGINS" font-lock-keyword-face) ;
    (unhighlight-regexp "testGudermann")
    (message "Highlighting: TestQueryLogic, invoking fork-join")
    (put this-command 'state nil))
   (t
    (unhighlight-regexp "TestQueryLogic")
    (unhighlight-regexp "Global logger is initialized")
    (highlight-regexp "testGudermann" font-lock-preprocessor-face) ;bold blue
    (message "Highlighting: testGudermann") 
    (put this-command 'state t))))
(defun highlight-contacts.md ()
  "Toggle highlighting `TestQueryLogic' or `invoking fork-join' and `testGudermann'."
  (interactive)
    (highlight-regexp "^\\([^(\#,)]*\\),"     font-lock-keyword-face) 
    (message "Highlighting: contacts"))

(defun highlight-untangler ()
  "Toggle highlighting `Found relationship' or `updated region' or 'SEVERE' or 'WARNING'."
  (interactive)
    (highlight-regexp "SEVERE"                font-lock-type-face) 
    (highlight-regexp "WARNING"               font-lock-type-face) 
    (highlight-regexp "Found relationship"     font-lock-warning-face) 
    (highlight-regexp "updated region"     font-lock-type-face) 
    (highlight-regexp "new region"     font-lock-type-face) 
    (message "Highlighting: untangler log file"))
;; Font-lock faces to choose from:
;; font-lock-warning-face ;gold
;; font-lock-function-name-face ;blue
;; font-lock-variable-name-face
;; font-lock-keyword-face ; bold yellow
;; font-lock-comment-face ;; bold green
;; font-lock-comment-delimiter-face ;dark green
;; font-lock-type-face ;blue
;; font-lock-constant-face  green
;; font-lock-builtin-face ;white
;; font-lock-preprocessor-face ;bold blue
;; font-lock-string-face
;; font-lock-doc-face
;; font-lock-negation-char-face

(defun find-last-killed-file ()
  (interactive)
  (let ((active-files (loop for buf in (buffer-list)
                            when (buffer-file-name buf) collect it)))
    (loop for file in recentf-list
          unless (member file active-files) return (find-file file))))

(defun string/reverse (str)
  "Reverse the str where str is a string"
  (apply #'string 
         (reverse 
          (string-to-list str))))

(defun cm-reverse-region (&optional arg)
  "Reverse current region, like this: \"a(bc) d\" -> \"d )cb(a\"."
  (interactive "P")
  (let ((reversed (apply 'string (reverse (string-to-list (buffer-substring-no-properties (region-beginning) (region-end)))))))
    (delete-region (region-beginning) (region-end))
    (insert reversed)))

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
                  (goto-char (region-end));;move point to region end
                  ;; (end-of-line);;move point to end of line
                  (forward-line -1) ;; Exclude line with cursor as part of region
                  (end-of-line)
                  ;; (print (concat "current point: " (number-to-string (point))))
                  (point))))
    (comment-or-uncomment-region start end)))
  ;; (if (not (region-active-p))
  ;; (comment-dwim arg)))

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

;; Cycle forward through the kill ring
(defun yank-pop-forwards (arg)
  (interactive "p")
  (yank-pop (- arg)))
(global-set-key "\M-Y" 'yank-pop-forwards) ; M-Y (Meta-Shift-Y)


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

;; BUFFER NAVIGATION
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

(defun my-paredit-nonlisp ()
  "Turn on paredit mode for non-lisps."
  (interactive)
  (set (make-local-variable 'paredit-space-for-delimiter-predicates)
       '((lambda (endp delimiter) nil)))
  (paredit-mode 1))

;; copy line
  (defun copy-line (arg)
    "Copy lines (as many as prefix argument) in the kill ring.
      Ease of use features:
      - Move to start of next line.
      - Appends the copy on sequential calls.
      - Use newline as last char even on the last line of the buffer.
      - If region is active, copy its lines."
    (interactive "p")
    (let ((beg (line-beginning-position))
          (end (line-end-position arg)))
      (when mark-active
        (if (> (point) (mark))
            (setq beg (save-excursion (goto-char (mark)) (line-beginning-position)))
          (setq end (save-excursion (goto-char (mark)) (line-end-position)))))
      (if (eq last-command 'copy-line)
          (kill-append (buffer-substring beg end) (< end beg))
        (kill-ring-save beg end)))
    (kill-append "\n" nil)
    (beginning-of-line (or (and arg (1+ arg)) 2))
    (if (and arg (not (= 1 arg))) (message "%d lines copied" arg)))

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
