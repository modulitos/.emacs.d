;;; package -- summary
;;; commentary:
;; ORG ROAM MODE

;;; Code:

;; https://www.orgroam.com/manual.html

;; (make-directory "~/docs/org-roam" t)
;; (setq org-roam-directory (file-truename "~/docs/org-roam"))

;; (org-roam-db-autosync-mode)

(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory "~/docs/org-roam")
  :bind
  (("C-c n l" . org-roam-buffer-toggle)
   ("C-c n f" . org-roam-node-find)
   ("C-c n i" . org-roam-node-insert)
   )
  :config
  (org-roam-db-autosync-enable)
  ;; (org-roam-setup)
  ;; :hook
  ;; (after-init . org-roam-mode)
  )

(provide 'init-org-roam)
;;; init-org-roam.el ends here
