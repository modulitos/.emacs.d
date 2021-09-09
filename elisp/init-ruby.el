;;; package -- summary
;;; commentary:
;; RUBY MODE

;;; Code:
(defun my-ruby-mode-hook ()
  "Ruby mode hook!"
  (my-code-editor-hook)
  ;; This causes a "peculiar error"?:
  ;; (format-all-mode)
  (envrc-global-mode)
  ;; TODO: pass this as a function hook to 'my-code-editor-hook'
  ;; (local-set-key (kbd "C-S-i") 'rubocopfmt)
  (local-set-key (kbd "C-S-i") 'rubocop-autocorrect-current-file)
  )

(add-hook 'ruby-mode-hook  'my-ruby-mode-hook)

(provide 'init-ruby)
;;; init-ruby.el ends here
