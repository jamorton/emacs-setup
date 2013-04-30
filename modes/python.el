;;
;; Jonanin's Emacs Configuration - jonanin-python.el
;; Python language-specific stuff
;;

(require 'cython-mode)
(require 'python)

(add-hook 'python-mode-hook
  (lambda ()
	(local-set-key (kbd "RET") 'newline-and-indent)
	(setq indent-tabs-mode t)
	(setq python-indent-offset 4)
	(setq tab-width 4)
	))

(add-to-list 'auto-mode-alist '("wscript$" . python-mode))
