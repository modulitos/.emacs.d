;;; package -- summary
;;; commentary:
;; RUBY MODE

;;; Code:
(defun my-ruby-mode-hook ()
  (my-code-editor-hook)
  (format-all-mode))

(add-hook 'ruby-mode-hook  'my-ruby-mode-hook)

(provide 'init-ruby)
;;; init-ruby.el ends here
