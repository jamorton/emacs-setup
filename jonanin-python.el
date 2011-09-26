;;
;; Jonanin's Emacs Configuration - jonanin-python.el
;; Python language-specific stuff
;;

;; pymacs, ropemacs, ropemod
(autoload 'pymacs-apply "pymacs")
(autoload 'pymacs-call "pymacs")
(autoload 'pymacs-eval "pymacs" nil t)
(autoload 'pymacs-exec "pymacs" nil t)
(autoload 'pymacs-load "pymacs" nil t)
(pymacs-load "ropemacs" "rope-")
(setq ropemacs-enable-autoimport t)

(add-hook 'python-mode-hook
          (lambda ()
	    (add-to-list 'ac-sources 'ac-source-ropemacs)))

(provide 'jonanin-python)