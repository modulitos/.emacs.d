;;; package -- summary
;;; commentary:
;; RUST MODE
;; (with-eval-after-load 'rust-mode
  ;; (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))

(setenv "PYTHONPATH” “/usr/bin/python")
;; For Python 3
;;(setenv "PYTHONPATH” “/usr/bin/python3")
 (elpy-enable)
 ;; Fixing a key binding bug in elpy
 (define-key yas-minor-mode-map (kbd "C-c e") 'yas-expand)
 ;; Fixing another key binding bug in iedit mode
 (define-key global-map (kbd "C-c o") 'iedit-mode)
(defun python-mode-config ()
  (local-unset-key (kbd "M-."))
  (local-set-key (kbd "C-c d") 'elpy-goto-definition)
  (local-set-key (kbd "C-c r") 'elpy-refactor)
  (local-set-key (kbd "C-c C-r") 'elpy-refactor)
  ;; https://github.com/lassik/emacs-format-all-the-code#how-to-add-new-languages
  ;; (format-all-mode)

  (my-code-editor-hook)
  ;; Refactor using 'C-c C-r r' (rename variables, etc)
  ;; (add-hook 'before-save-hook (lambda () (delete-trailing-whitespace)))
  ;; enable code folding "hideshow":
  (hs-minor-mode))

(add-hook 'python-mode-hook 'python-mode-config)

(defalias 'workon 'pyvenv-workon)
(pyvenv-workon 'utils)
(setq elpy-rpc-backend "jedi")

;; Use jedi instead of ropemacs when TRAMP is detected
;; Taken here: https://github.com/jorgenschaefer/elpy/issues/170
(defadvice elpy-rpc--open (around native-rpc-for-tramp activate)
  (interactive)
  (let ((elpy-rpc-backend
         (if (ignore-errors (tramp-tramp-file-p (elpy-project-root)))
             "native"
           elpy-rpc-backend)))
     (message "Using elpy backend: %s for %s" elpy-rpc-backend (elpy-project-root))
     ad-do-it))

;;; init-python.el ends here
