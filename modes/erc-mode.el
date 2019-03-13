;;; Package --- Summary
;;; Commentary:
;;; configs for various modes

;;; Code:
;; ERC page-me
;; from http://www.emacswiki.org/emacs/ErcPageMe#toc4

(add-hook 'erc-mode-hook
          (lambda ()
            (flyspell-mode)
            (local-set-key (kbd "C-c C-o") 'org-open-at-point)
            ))
;; setting keywords is based off of the default erc-match.el
;; http://www.emacswiki.org/emacs/ErcChannelTracking

;; from http://bradyt.com/#sec-3
(setq erc-hide-list '("JOIN" "PART" "QUIT" "MODE"))
(add-hook 'erc-send-pre-hook 'tl-erc-send-pre-hook)
(defun tl-erc-send-pre-hook (string)
  (require 'cl-lib)
  (when (and (or (>= (cl-count ?\n string) 2)
                 (>= (length string) 400))
             (not (y-or-n-p "Long message! Send?")))
    (setq erc-send-this nil)))

;; ("MYNICK *[,:;]" "\\bMY-FIRST-NAME[!?.]+$" "hey MY-FIRST-NAME")
(erc-match-mode 1)
(defvar my-erc-page-message "%s is calling your name."
  "Format of message to display in dialog box")

(defvar my-erc-page-nick-alist nil
  "Alist of nicks and the last time they tried to trigger a
notification")

(defvar my-erc-page-timeout 30
  "Number of seconds that must elapse between notifications from
the same person.")

;; Notify via alarm bell and save all messages to a buffer
(defun erc-global-notify-arch (match-type nick message)
  "Notify when a message is recieved."
  (when (and  ;; I don't want to see anything from the erc server
             (null (string-match "\\`\\([sS]erver:\\|localhost\\)" nick))
             ;; or my ZNC bouncer
             (null (string-match "zncuser!" nick))
             ;; or bots
             (null (string-match "\\(bot\\|serv\\)!" nick)))
    ;; This only works on Ubuntu, or when configured with DBUS notifications
    ;; (notifications-notify
    ;;  :title nick
    ;;  :body message
    ;;  :app-icon "/usr/share/notify-osd/icons/gnome/scalable/status/notification-message-im.svg"
    ;;  :urgency 'low)))
    (progn
      (start-process-shell-command "whatever" nil "play ~/music/sounds/bell-ringing-04.wav")
      (append-message-to-buffer "erc notifications" (concat nick "\n\t" message))
      )
    ))

(defun my-erc-page-allowed (nick &optional delay)
  "Return non-nil if a notification should be made for NICK.
If DELAY is specified, it will be the minimum time in seconds
that can occur between two notifications.  The default is
`my-erc-page-timeout'."
  (unless delay (setq delay my-erc-page-timeout))
  (let ((cur-time (time-to-seconds (current-time)))
        (cur-assoc (assoc nick my-erc-page-nick-alist))
        (last-time))
    (if cur-assoc
        (progn
          (setq last-time (cdr cur-assoc))
          (setcdr cur-assoc cur-time)
          (> (abs (- cur-time last-time)) delay))
      (push (cons nick cur-time) my-erc-page-nick-alist)
      t)))

(defun my-erc-page-me (match-type nick message)
  "Notify the current user when someone sends a message that
matches a regexp in `erc-keywords'."
  (interactive)
  (when (and (eq match-type 'keyword)
             ;; I don't want to see anything from the erc server
             (null (string-match "\\`\\([sS]erver\\|localhost\\)" nick))
             ;; or bots
             (null (string-match "\\(bot\\|serv\\)!" nick))
             ;; or from those who abuse the system
             (my-erc-page-allowed nick 1))
      (erc-global-notify-arch match-type nick message)))
(add-hook 'erc-text-matched-hook 'my-erc-page-me)

(defun my-erc-page-me-PRIVMSG (proc parsed)
  (let ((nick (car (erc-parse-user (erc-response.sender parsed))))
        (target (car (erc-response.command-args parsed)))
        (msg (erc-response.contents parsed)))
    (when (and (erc-current-nick-p target)
               (not (erc-is-message-ctcp-and-not-action-p msg))
               (my-erc-page-allowed nick 1))
      (message "logging erc-page-me-PRIVMSG statement!")
      (message "proc is: %s" proc)
      (erc-global-notify-arch nil nick msg)
      (message "finished calling erc-global-notify-arch from prviate message")
      nil)))
(add-hook 'erc-server-PRIVMSG-functions 'my-erc-page-me-PRIVMSG)
