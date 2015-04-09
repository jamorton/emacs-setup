
(add-hook 'php-mode-hook
          (lambda ()
            (setq-default indent-tabs-mode nil)
            (setq-default tab-width 4)
            (setq-default c-basic-offset 4)
           ))

(require 'php-mode)
