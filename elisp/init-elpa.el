;;; package --- summary
;;; commentary:
;;; initialize elpa and package loading

;; reference:
;; https://manenko.com/2016/08/03/setup-emacs-for-rust-development.html
(require 'package)

;;; code:
(defun require-package (package)
  "Install given PACKAGE if it was not installed before."
  (if (package-installed-p package)
      t
    (progn
      (unless (assoc package package-archive-contents)
	(package-refresh-contents))
      (package-install package))))

;; uncomment this if you want to update:
;; (saves startup time, especially when not on the web)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))

;; tells use where the elpa folder is
(package-initialize)

(provide 'init-elpa)
;;; init-elpa ends here
