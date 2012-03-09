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

(require 'cython-mode)

(add-hook 'python-mode-hook
  (lambda ()
	(local-set-key (kbd "RET") 'newline-and-indent)
	(setq indent-tabs-mode t)
	(setq python-indent 4)
	(setq tab-width 4)
	))

(defadvice python-calculate-indentation (around outdent-closing-brackets)
  "Handle lines beginning with a closing bracket and indent them so that
  they line up with the line containing the corresponding opening bracket."
(save-excursion
  (beginning-of-line)
  (let ((syntax (syntax-ppss)))
    (if (and (not (eq 'string (syntax-ppss-context syntax)))
             (python-continuation-line-p)
             (cadr syntax)
             (skip-syntax-forward "-")
             (looking-at "\\s)"))
        (progn
          (forward-char 1)
          (ignore-errors (backward-sexp))
          (setq ad-return-value (current-indentation)))
      ad-do-it))))

(ad-activate 'python-calculate-indentation)

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