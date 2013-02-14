
;; make h files use C++-mode
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.hpp$" . c++-mode))

(add-hook 'c-mode-common-hook (lambda ()
  (make-local-variable 'indent-tabs-mode)
  (set 'indent-tabs-mode nil)
  (c-set-offset 'innamespace 0)
  (c-set-offset 'substatement-open 0)
  (c-set-offset 'arglist-intro '+)
  (c-set-offset 'arglist-cont-nonempty '+)
  (c-set-offset 'arglist-close 0)))
