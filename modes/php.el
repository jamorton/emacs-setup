
(defun unident-closure ()
  (let ((syntax (mapcar 'car c-syntactic-context)))
    (if (and (member 'arglist-cont-nonempty syntax)
             (or
              (member 'statement-block-intro syntax)
              (member 'brace-list-intro syntax)
              (member 'brace-list-close syntax)
              (member 'block-close syntax)))
        (save-excursion
          (beginning-of-line)
          (delete-char (* (count 'arglist-cont-nonempty syntax)
                          c-basic-offset))))))

(add-hook 'php-mode-hook
          (lambda ()
            (add-hook 'c-special-indent-hook 'unident-closure)
            (setq-default indent-tabs-mode nil)
            (setq-default tab-width 4)
            (setq-default c-basic-offset 4)
            ))

(require 'php-mode)
