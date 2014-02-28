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

(add-hook 'after-init-hook
  (lambda()
    (global-flycheck-mode)
    (load-theme 'zenburn t)
  ))

;; the end
(provide 'jonanin)
