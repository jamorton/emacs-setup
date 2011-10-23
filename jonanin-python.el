;;
;; Jonanin's Emacs Configuration - jonanin-python.el
;; Python language-specific stuff
;;

;; pymacs, ropemacs, ropemod
;;(autoload 'pymacs-apply "pymacs")
;;(autoload 'pymacs-call "pymacs")
;;(autoload 'pymacs-eval "pymacs" nil t)
;;(autoload 'pymacs-exec "pymacs" nil t)
;;(autoload 'pymacs-load "pymacs" nil t)
;;(pymacs-load "ropemacs" "rope-")
;;(setq ropemacs-enable-autoimport t)

;;(add-hook 'python-mode-hook
;;          (lambda ()
;;	    (add-to-list 'ac-sources 'ac-source-ropemacs)))

(add-hook 'python-mode-hook
  (lambda ()
	(local-set-key (kbd "RET") 'newline-and-indent)
	))


;;(when (load "flymake" t)
;;  (defun flymake-pyflakes-init ()
;;    (let* ((temp-file (flymake-init-create-temp-buffer-copy
;;		       'flymake-create-temp-inplace))
;;	   (local-file (file-relative-name
;;			temp-file
;;			(file-name-directory buffer-file-name))))
;;      (list "pyflakes" (list local-file))))
;;  (add-to-list 'flymake-allowed-file-name-masks
;;	       '("\\.py\\'" flymake-pyflakes-init)))
;;(add-hook 'find-file-hook 'flymake-find-file-hook)

(add-to-list 'auto-mode-alist '("wscript$" . python-mode))

(provide 'jonanin-python)