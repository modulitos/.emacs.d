;;; package -- summary
;;; commentary:
;; RUBY MODE

;;; Code:

;; (setq flycheck-ruby-rubocop-executable "~/.asdf/shims/ruby")

(defun my-ruby-mode-hook ()
  "Ruby mode hook!"
  (my-code-editor-hook)
  ;; (message "loaded!")

  ;; Treat underscores as part of the word:
  ;; https://emacs.stackexchange.com/a/27350/2676
  (modify-syntax-entry ?_ "w")

  ;; (envrc-global-mode) ;; using direnv-mode instead
  ;; (direnv-mode)  ;; this slows down switching between buffers, and might not be needed?

  ;; This causes a "peculiar error"?:
  ;; (format-all-mode)
  ;; TODO: pass this as a function hook to 'my-code-editor-hook'
  ;; (local-set-key (kbd "C-S-i") 'rubocopfmt)
  (local-set-key (kbd "C-S-i") 'rubocop-autocorrect-current-file)
  )

(add-hook 'ruby-mode-hook  'my-ruby-mode-hook)

(provide 'init-ruby)
;;; init-ruby.el ends here
