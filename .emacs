;; after copy Ctrl+c in X11 apps, you can paste by `yank' in emacs
(setq x-select-enable-clipboard t)
;; after mouse selection in X11, you can paste by `yank' in emacs
(setq x-select-enable-primary t)
(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)
(setq user-emacs-directory (expand-file-name "~/Dropbox/workspaces/emacs/.emacs.d/"))
(load (locate-user-emacs-file "init.el"))
