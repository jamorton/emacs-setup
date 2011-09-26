;;
;; Jonanin's Emacs Configuration - jonanin.el
;; Basic stuff
;;

;; Don't put backup files in every directory
(setq backup-directory-alist `(("." . ,(expand-file-name
                                        (concat dotfiles-dir "backups")))))

;; load magit
(require 'magit)

;; the end
(provide 'jonanin)
