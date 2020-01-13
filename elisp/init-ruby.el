;;; package -- summary
;;; commentary:
;; RUBY MODE

;;; Code:
(defun my-ruby-mode-hook ()
  (my-code-editor-hook)
  (format-all-mode)
  ;; TODO: use prettier-ruby instead, ideally via format-all-mode
  ;; TODO: pass this as a function hook to 'my-code-editor-hook'
  (local-set-key (kbd "C-S-i") 'rubocopfmt)
  )

(add-hook 'ruby-mode-hook  'my-ruby-mode-hook)

(provide 'init-ruby)
;;; init-ruby.el ends here
