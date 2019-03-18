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
(add-hook 'rust-mode-hook
          '(lambda ()
	     ;; (setq racer-cmd (concat (getenv "HOME") "/.rust-dev/racer/target/release/racer"))
	     (setq racer-cmd (concat (getenv "HOME") "/.cargo/bin/racer"))
	     ;; (setq racer-rust-src-path (concat (getenv "HOME") "/.rust-dev/rust/src"))
	     (setq racer-rust-src-path (getenv "RUST_SRC_PATH"))
             (local-set-key (kbd "TAB") #'company-indent-or-complete-common)
	     (electric-pair-mode 1)))

(provide 'init-rust)
;;; init-rust.el ends here
