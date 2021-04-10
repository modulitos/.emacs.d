;;; Package --- Summary
;;; Commentary:
;;; config for golang mode


;;; Code:


(use-package go-mode
  :mode (("\\.go$" . go-mode))
  :config
  (defun my-go-mode-hook ()
    "Hooks for 'sh-mode'."
    (message "inside go mode hook")
    (my-code-editor-hook)
    (format-all-mode)
    )
  ;; :bind ("C-S-i" . gofmt)

  ;; :init
  ;; (add-hook 'go-mode-hook 'my-go-mode-hook)

  ;; same as:
  :hook ((go-mode . my-go-mode-hook))
  )

(provide 'init-go)
;;; init-go.el ends here
