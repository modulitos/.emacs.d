;;; Package --- Summary
;;; Commentary:
;;; config for c languages


;;; Code:

(defun c-mode-config ()
  (my-code-editor-hook)
  (format-all-mode t)
  ;; https://github.com/FredeEB/.emacs.d#c
  (c-set-offset 'substatement-open 0)
  (c-set-offset 'innamespace 0)
  (c-set-offset 'brace-list-open 0)
  (setq c-basic-offset 4)

  (setq lsp-clients-clangd-args
        '("-j=8"
	  "--header-insertion=never"
	  "--all-scopes-completion"
	  "--background-index"
	  "--clang-tidy"
	  "--compile-commands-dir=build"
	  "--cross-file-rename"
	  "--suggest-missing-includes"))

  ;; (use-package modern-cpp-font-lock
  ;;   :config
  ;;   (modern-c++-font-lock-global-mode))

  ;; (use-package cmake-mode)
  )

(add-hook 'c-mode-hook 'c-mode-config)


(provide 'init-c)
;;; init-c.el ends here
