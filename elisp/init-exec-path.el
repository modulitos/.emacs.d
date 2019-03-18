;;; package -- summary
;;; commentary:
(require 'init-elpa)

;;; code:
(message "loading init-exec-path.el")
(require-package 'exec-path-from-shell)
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

(provide 'init-exec-path)
;;; init-exec-path.el ends here
