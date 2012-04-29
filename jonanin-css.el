
;; LESS css
(require 'less-css-mode)

(add-hook 'css-mode-hook
          (lambda ()
            (setq css-indent-offset 2)))

(provide 'jonanin-css)
