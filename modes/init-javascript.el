;;; Package --- Summary
;;; Commentary:
;;; configs for various modes

(require 'init-elpa)
;; (require-package 'flycheck)
(require 'flycheck)
;; (require-package 'js2-mode)
;; (require-package 'web-mode)
(require 'js2-mode)
(require 'web-mode)


;;; Code:
;; JAVASCRIPT-MODE
(add-to-list 'auto-mode-alist '("\\.json$" . json-mode))

;; js2-mode provides 4 level of syntax highlighting. They are * 0 or a
;; negative value means none. * 1 adds basic syntax highlighting. * 2
;; adds highlighting of some Ecma built-in properties. * 3 adds
;; highlighting of many Ecma built-in functions.
(setq js2-highlight-level 3)

(add-to-list 'interpreter-mode-alist '("node" . js2-mode))

(add-to-list 'auto-mode-alist
      '("\\.js$" . js2-mode))
      ;; '("\\.[m]?js$" . js2-mode))
;; (add-to-list 'auto-mode-alist
;;       '("\\.mjs$" . js2-mode))


(require 'js2-refactor)
(js2r-add-keybindings-with-prefix "C-c C-m")
(add-hook 'js2-mode-hook #'js2-refactor-mode)

;; flycheck configs:
;; (flycheck-add-mode 'javascript-eslint 'javascript-mode)
(flycheck-add-mode 'javascript-eslint 'web-mode)
;; (setq flycheck-disabled-checkers '(javascript-jshint))
;; (setq flycheck-checkers '(javascript-eslint))

;; ((js2-mode
;;   (flycheck-checker . javascript-standard)))
;; (setq prettier-target-mode "js2-mode")

;; (flycheck-add-mode 'javascript-eslint 'web-mode)

(add-to-list 'safe-local-variable-values
             '(flycheck-checkers . (javascript-eslint)))

             ;; '(js2-jsx-mode . ((flycheck-disabled-checkers . (javascript-jshint))
             ;;  (flycheck-checkers . (javascript-eslint)))))
             ;; '(js2-jsx-mode . "lualatex -shell-escape"))
(add-to-list 'load-path "~/.emacs.d/tern/emacs/")
(autoload 'tern-mode "tern.el" nil t)
(add-hook 'js-mode-hook
          (lambda ()
            ;; (add-hook 'before-save-hook 'prettier-before-save)
            (tern-mode t)))

(add-to-list 'flycheck-checkers 'javascript-eslint)

;; (modify-syntax-entry ?` "\"" js2-mode-syntax-table)

(add-hook 'js2-jsx-mode-hook
          (lambda ()
            ;; (add-hook 'before-save-hook 'prettier-before-save)
            (flycheck-mode)
            ;; (flycheck-select-checker javascript-eslint)

            ;; allow window resizing via M-l and M-h
            (local-unset-key (kbd "M-l"))
            (local-unset-key (kbd "M-h"))
            (local-unset-key (kbd "M-j"))))

;; Moved from down below:
(defun setup-js2-mode ()
  (flycheck-select-checker 'javascript-eslint)
  (flycheck-mode))

(add-hook 'js2-mode-hook #'setup-js2-mode)
;; (add-to-list 'flycheck-checkers 'javascript-tide)
;; (flycheck-add-next-checker 'javascript-eslint 'javascript-tide 'append)
(add-hook 'js2-mode-hook #'setup-tide-mode)
(add-hook 'js2-mode-hook
          (lambda ()
            ;; (add-hook 'before-save-hook 'prettier-before-save)

            ;; allow window resizing via M-l and M-h
            (local-unset-key (kbd "M-l"))
            (local-unset-key (kbd "M-h"))
            (local-unset-key (kbd "M-j"))

            (local-set-key (kbd "C-c r") 'tern-rename-variable)
            (local-set-key (kbd "C-j") 'tern-find-definition)
            (local-set-key (kbd "M-.") 'tern-find-definition)
            (local-set-key (kbd "C-c d") 'tern-find-definition)
            (local-set-key (kbd "C-c C-n") 'js2-next-error)
            (setq js2-mode-show-parse-errors nil)
            (setq js2-mode-show-strict-warnings nil)
            (define-key js2-mode-map (kbd "C-j") 'ac-js2-jump-to-definition)
            (js2-reparse t)
            (ac-js2-mode)))

;; (flycheck-add-next-checker 'javascript-eslint 'jsx-tide 'append)

;; (js2-jsx-mode . ((flycheck-disabled-checkers . (javascript-jshint))
;;               (flycheck-checkers . (javascript-eslint))))


;; JS2-MODE AND JSX-MODE
(add-to-list 'auto-mode-alist '("\\.jsx?\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.jsx?\\'" . typescript-mode))
(add-to-list 'flycheck-checkers 'jsx-tide)
;; (flycheck-add-next-checker 'javascript-eslint 'jsx-tide 'append)

(add-to-list 'auto-mode-alist '("\\.mjs\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.mjs\\'" . typescript-mode))
(setq js2-mode-show-parse-errors nil)
(setq js2-mode-show-strict-warnings nil)

;; use local eslint from node_modules before global
;; http://emacs.stackexchange.com/questions/21205/flycheck-with-file-relative-eslint-executable
(defun my/use-eslint-from-node-modules ()
  (let* ((root (locate-dominating-file
                (or (buffer-file-name) default-directory)
                "node_modules"))
         (eslint (and root
                      (expand-file-name "node_modules/eslint/bin/eslint.js"
                                        root))))
    (when (and eslint (file-executable-p eslint))
      (setq-local flycheck-javascript-eslint-executable eslint))))
(add-hook 'flycheck-mode-hook #'my/use-eslint-from-node-modules)

;; Disable JSCS linting (optional but if you're using ESLint you probably don't
;; need this).
(let ((checkers (get 'javascript-eslint 'flycheck-next-checkers)))
  (put 'javascript-eslint 'flycheck-next-checkers
       (remove '(warning . javascript-jscs) checkers)))

;; COFFEESCRIPT MODE
(add-to-list 'auto-mode-alist '("\\.coffee\\'" . coffee-mode))

(custom-set-variables
 '(coffee-indent-like-python-mode t)
 '(coffee-tab-width 2)
 '(coffee-args-compile '("-c" "--no-header" "--bare")))

(eval-after-load "coffee-mode"
  '(progn
     (define-key coffee-mode-map [(meta r)] 'coffee-compile-buffer)
     (define-key coffee-mode-map (kbd "C-j") 'coffee-newline-and-indent)))


;; TYPESCRIPT MODE
(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  ;; The following line might be needed, ala: https://github.com/ananthakumaran/tide/issues/67
  ;; (flycheck-add-next-checker 'typescript-tide '(t . typescript-tslint) 'append)
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1))

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)

;; formats the buffer before saving
;; (add-hook 'before-save-hook 'tide-format-before-save)
;; (remove-hook 'before-save-hook 'tide-format-before-save)

(add-hook 'typescript-mode-hook #'setup-tide-mode)

(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode))


;; WEB MODE
;; http://web-mode.org/

;; allow web-mode to treat .mjs extensions as js files:
(add-to-list 'auto-mode-alist '("\\.css?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jinja2\\'" . web-mode))
(setq web-mode-enable-engine-detection t)
(setq web-mode-engines-alist
      '(("ctemplate"   .  "\\.html\\'")
        ("php"    . "\\.phtml\\'")
        ("blade"  . "\\.blade\\."))
)
(add-to-list 'auto-mode-alist '("\\.php\\'" . php-mode))

;; TOOD: enable prettier for .js and .jsx file only (no html files!)
;; (add-hook 'web-mode-hook 'prettier-js-mode)
(setq prettier-js-args '(
  ;; "--trailing-comma" "all"
  ;; "--semi" "false"
))

;; (defun enable-minor-mode (my-pair)
;;   "Enable minor mode if filename match the regexp.  MY-PAIR is a cons cell (regexp . minor-mode)."
;;   (if (buffer-file-name)
;;       (if (string-match (car my-pair) buffer-file-name)
;;       (funcall (cdr my-pair)))))

;; (add-hook 'web-mode-hook #'(lambda ()
;;                             (enable-minor-mode
;;                              '("\\.jsx?\\'" . prettier-js-mode))))

(eval-after-load 'web-mode
    '(progn
       (add-hook 'web-mode-hook #'add-node-modules-path)
       (add-hook 'web-mode-hook #'prettier-js-mode)))

(defun my-web-mode-hook ()
  "Hooks for Web mode."
  ;;; http://web-mode.org/
  (flycheck-mode)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-enable-current-element-highlight t)

  (local-set-key (kbd "C-c r") 'tern-rename-variable)
  (local-set-key (kbd "C-j") 'tern-find-definition)
  (local-set-key (kbd "M-.") 'tern-find-definition)
  (local-set-key (kbd "C-c d") 'tern-find-definition)
  (local-set-key (kbd "C-c C-n") 'js2-next-error)
  (js2-reparse t)
)

(add-hook 'web-mode-hook  'my-web-mode-hook);
(setq-default web-mode-comment-formats
              '(("java"       . "/*")
                ("javascript" . "//")
                ("jsx" . "//")
                ("php"        . "/*")))

(rplacd (assoc "javascript" web-mode-content-types)
        "\\.\\([jt]s\\|mjs\\|[jt]s\\.erb\\)\\'")


;; JSX with WEB MODE
;; Source here: http://paste.lisp.org/display/317176
;; (add-to-list 'auto-mode-alist '("\\.jsx\\'" . web-mode))

;; (setq web-mode-content-types-alist
;;   '(("jsx" . "\\.js[x]?\\'")))
;;   '(("jsx" . "\\.[m]?js[x]?\\'")))

;; (defadvice web-mode-highlight-part (around tweak-jsx activate)
;;   (if (or (equal web-mode-content-type "jsx") (equal web-mode-content-type "js"))
;;       (let ((web-mode-enable-part-face nil))
;;         ad-do-it)
;;     ad-do-it))

;; http://codewinds.com/blog/2015-04-02-emacs-flycheck-eslint-jsx.html
(setq-default flycheck-disabled-checkers
             (append flycheck-disabled-checkers
                     '(javascript-jshint)))

;; customize flycheck temp file prefix
(setq-default flycheck-temp-prefix ".flycheck")

;; disable json-jsonlist checking for json files
(setq-default flycheck-disabled-checkers
  (append flycheck-disabled-checkers
    '(json-jsonlist)))

;; (flycheck-add-mode 'javascript-eslint 'web-mode)
(flycheck-add-mode 'javascript-eslint 'js-mode)
(flycheck-add-mode 'javascript-eslint 'js2-mode)
(flycheck-add-mode 'javascript-eslint 'jsx-mode)

;;(setq-default flycheck-disabled-checkers
;;              (append flycheck-disabled-checkers
;;                      '(json-jsonlist)))

;; HTML with WEB-MODE
(defun html-with-web-mode ()
  ;; enable web mode
  (web-mode)
  (flycheck-mode -1)
  ;; disable the minor prettier-js-mode
  (prettier-js-mode -1))

(add-to-list 'auto-mode-alist '("\\.html$" . html-with-web-mode))

;; PHP with WEB-MODE
(defun php-with-web-mode ()
  ;; enable web mode
  (web-mode)

  (setq web-mode-comment-style 2)
  (add-to-list 'web-mode-comment-formats '("php" . "^//"))

  ;; make these variables local
  (make-local-variable 'web-mode-code-indent-offset)
  (make-local-variable 'web-mode-markup-indent-offset)
  (make-local-variable 'web-mode-css-indent-offset)

  ;; set indentation, can set different indentation level for different code type
  (setq web-mode-code-indent-offset 4)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-markup-indent-offset 2))

(add-to-list 'auto-mode-alist '("\\.phtml$" . php-with-web-mode))

(provide 'init-javascript)
;;; init-javascript.el ends here
