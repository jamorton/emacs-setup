;;
;; Jonanin's Emacs Configuration - jonanin-coffee.el
;; CoffeeScript langauge-specific stuff
;;

;; custom stuff
(defun coffee-custom ()
  "coffee-mode-hook"
  (make-local-variable 'tab-width)
  (set 'tab-width 2))

(add-hook 'coffee-mode-hook
  '(lambda() (coffee-custom)))

;; coffee-script mode
(require 'coffee-mode)
(add-to-list 'auto-mode-alist '("\\.coffee$" . coffee-mode))
(add-to-list 'auto-mode-alist '("Cakefile" . coffee-mode))

(provide 'jonanin-coffee)