(defun css-mode-custom ()
  "css-mode-hook"
  (define-key ac-complete-mode-map "\r" nil))

(add-hook 'css-mode-hook
  '(lambda() (css-mode-custom)))

(provide 'jonanin-css)
