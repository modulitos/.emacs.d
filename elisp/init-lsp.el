;;; Package --- Summary
;;; Commentary:
;;; config for c languages

;;; Code:

;; https://github.com/FredeEB/.emacs.d#lsp
(use-package lsp-mode
  :hook
  ((c++-mode c-mode cmake-mode) . lsp)
  :custom
  (lsp-diagnostic-package :flycheck)
  (lsp-prefer-capf t)
  (read-process-output-max (* 1024 1024)))
(use-package lsp-ui
  :custom
  (lsp-ui-doc-max-width 80)
  (lsp-ui-doc-position 'top))

(provide 'init-lsp)
;;; init-lsp.el ends here
