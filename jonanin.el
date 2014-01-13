;;
;; Jonanin's Emacs Configuration - jonanin.el
;; Basic stuff
;;

;; Don't put backup files in every directory
(setq backup-directory-alist `(("." . ,(expand-file-name
                                        (concat dotfiles-dir "backups")))))

;; load magit
(require 'magit)

;; find files in ~/dev by default
(dired "~/dev")

;; Load PATH from shell environment
(setq exec-path (split-string (getenv "PATH") ":"))

(add-hook 'after-init-hook
  (lambda()
    (global-flycheck-mode)
    (load-theme 'zenburn t)
    (mapc 'load
          (directory-files (concat dotfiles-dir "modes/") 't "^[^#].*el$"))
  ))

;; the end
(provide 'jonanin)
