;;; package -- summary
;;; commentary:
;; RUST MODE
;; (with-eval-after-load 'rust-mode
;; (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))


(require 'init-elpa)

;;; code:
(require-package 'company)
(require-package 'racer)
(require-package 'rust-mode)
(require-package 'flycheck)
(require-package 'flycheck-rust)

(require 'company)
(require 'racer)
(require 'rust-mode)
(require 'electric)
(require 'eldoc)
(require 'flycheck)
(require 'flycheck-rust)

(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode))
(setq rust-mode-hook nil)
(add-hook 'rust-mode-hook  #'company-mode)
(add-hook 'rust-mode-hook  #'racer-mode)
(add-hook 'racer-mode-hook #'eldoc-mode)
(add-hook 'flycheck-mode-hook #'flycheck-rust-setup)

(defun my-rust-mode-hook ()
  "Hooks for Rust mode."
  (message "inside rust hook3!!!")
  (setq racer-cmd (concat (getenv "HOME") "/.cargo/bin/racer"))
  (setq racer-rust-src-path (getenv "RUST_SRC_PATH"))
  (my-code-editor-hook)
  (format-all-mode)

  ;; debug when racer-mode causes hangs...
  ;; (toggle-debug-on-quit)
  (racer-mode)

  ;; (when superword-mode
  ;;     (message "superword mode enabled!"))
  ;; (superword-mode nil) ;; not working...
  (local-set-key (kbd "C-S-i") 'rust-format-buffer)
  (modify-syntax-entry ?_ "w") ;; allows us to treat _ as part of a word!
  (electric-pair-mode 1)
  (setq electric-pair-preserve-balance nil) ;; allows us to type over the closing bracket, avoiding "Node<T>>"
  )

(add-hook 'rust-mode-hook  'my-rust-mode-hook);

(provide 'init-rust)
;;; init-rust.el ends here
