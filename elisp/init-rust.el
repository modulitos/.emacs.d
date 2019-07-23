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
  (superword-mode nil) ;; not working...
  (local-set-key (kbd "C-S-i") 'rust-format-buffer)
  (electric-pair-mode 1))

(add-hook 'rust-mode-hook  'my-rust-mode-hook);

(provide 'init-rust)
;;; init-rust.el ends here
