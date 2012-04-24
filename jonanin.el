;;
;; Jonanin's Emacs Configuration - jonanin.el
;; Basic stuff
;;

;; Don't put backup files in every directory
(setq backup-directory-alist `(("." . ,(expand-file-name
                                        (concat dotfiles-dir "backups")))))

;; load magit
(require 'magit)

;; glsl
(autoload 'glsl-mode "glsl-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.vert\\'" . glsl-mode))
(add-to-list 'auto-mode-alist '("\\.frag\\'" . glsl-mode))

;; use nxml-mode for html
(fset 'html-mode 'nxml-mode)
(setq-default rng-nxml-auto-validate-flag nil)

;; the end
(provide 'jonanin)
