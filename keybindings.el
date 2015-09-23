(define-key text-mode-map (kbd "M-s t") 'testing-MapAppLog.txt)
(global-set-key (kbd "C-x C-;") 'comment-or-uncomment-region-or-line)

(global-set-key (kbd "C-=") 'er/expand-region)



(global-set-key (kbd "C-c k") 'delete-this-buffer-and-file)

;; WINDOWS AND BUFFERS
; Cycle between windows
(global-set-key (kbd "C-~") 'other-window)
(global-set-key (kbd "C-`") 
    (lambda ()
      (interactive)
      (other-window -1)))

(global-set-key (kbd "M-j") 'other-window)
(global-set-key (kbd "M-k") 
    (lambda ()
      (interactive)
      (other-window -1)))

(global-set-key (kbd "M-h") 'enlarge-window-horizontally)
(global-set-key (kbd "M-l") 'shrink-window-horizontally)

; Cycle between buffers
(global-set-key [(control f9)] 'buffer-stack-bury-and-kill)
(global-set-key [(f12)] 'buffer-stack-track)
(global-set-key [(control f12)] 'buffer-stack-untrack)

(global-set-key [C-tab] 'buffer-stack-down)
(global-set-key [C-S-iso-lefttab] 'buffer-stack-up);Linux
(global-set-key [C-S-tab] 'buffer-stack-up);Windows/Linux
;; (global-set-key [tab] 'shift-right)
;; (global-set-key [backtab] 'shift-left)

;; (global-set-key [(f10)] 'buffer-stack-up)
;; (global-set-key [(f11)] 'buffer-stack-down)
;; end buffer-stack keybindings

;; (global-set-key [C-tab] 'next-buffer)
;; (global-set-key [C-S-iso-lefttab] 'previous-buffer);Linux
;; (global-set-key [C-S-tab] 'previous-buffer);Windows/Linux

;; Kill buffer
(global-set-key (kbd "C-w") 'kill-buffer)
; Re-open recently killed buffers
(global-set-key (kbd "C-S-t") 'reopen-killed-file)
;; (define-key global-map (kbd "C-S-t") 'find-last-killed-file)

;; SHELLS
;; Start eshell or switch to it if it's active.
(global-set-key (kbd "C-x m") 'eshell)

;; Start a new eshell even if one is active.
(global-set-key (kbd "C-x M") (lambda () (interactive) (eshell t)))

;; ;; Bind (shift-right) and (shift-left) function to your favorite keys. I use
;; the following so that Ctrl-Shift-Right Arrow moves selected text one 
;; column to the right, Ctrl-Shift-Left Arrow moves selected text one
;; column to the left:
(global-set-key [C-S-right] 'shift-right)
(global-set-key [C-S-left] 'shift-left)

(global-set-key (kbd "<backtab>") 'un-indent-by-removing-4-spaces)
;; (global-set-key (kbd "<S-tab>") 'un-indent-by-removing-4-spaces)


;; (global-set-key [\M-\S-up] 'move-text-up)
;; (global-set-key [\M-\S-down] 'move-text-down)
(global-set-key (kbd "C-M-p") 'move-text-up)
(global-set-key (kbd "C-M-n") 'move-text-down)
;; end move text up or down.

;; MISC KEY-BINDINGS
;; (global-set-key (kbd "C-z") 'undo)
(dolist (key '("\C-z"))
  (global-unset-key key))
;; (dolist (key '("\C-Caps_Lock" "\C-x \C-z"))
;;   (global-unset-key key))
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

(global-set-key (kbd "C-+") 'copy-line)

(global-set-key (kbd "C-S-SPC") 'duplicate-current-line-or-region)

(global-set-key (kbd "C-c C-t") 'ansi-term)

;; COMMENTING OUT
;; (add-hook 'undo-tree-mode (lambda () (local-unset-key "C-/")))
(eval-after-load "flyspell"
  '(define-key flyspell-mode-map (kbd "C-;") nil))
(global-set-key (kbd "C-;") 'comment-line-or-region)
;; (global-set-key (kbd "C-;") 'comment-line-or-region)
(global-set-key (kbd "C-:") 'comment-dwim-line)

(global-set-key "\M-;" 'comment-dwim-line)
(global-set-key (kbd "C-?") 'comment-dwim-line)

;; Minor mode to prevent keybindings from getting overidden
(defvar my-keys-minor-mode-map (make-keymap) "my-keys-minor-mode keymap.")

;; (define-minor-mode my-keys-minor-mode
;;   "A minor mode so that my key settings override annoying major modes."
;;   t " my-keys" 'my-keys-minor-mode-map)

(define-key my-keys-minor-mode-map (kbd "C-;") 'comment-line-or-region)
;; ;; Minor mode to prevent keybindings from getting overidden
;; (defvar my-keys-minor-mode-map (make-keymap) "my-keys-minor-mode keymap.")

;; (define-key my-keys-minor-mode-map (kbd "C-;") 'comment-line-or-region)
;; (my-keys-minor-mode 1)

;; INPUT METHODS
(global-set-key (kbd "C-M-/") 'toggle-input-method)
