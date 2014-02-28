
;; LESS css mode

(add-hook 'css-mode-hook '(lambda ()
  (make-local-variable 'css-indent-offset)
  (set 'css-indent-offset 2)))
