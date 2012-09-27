;;
;; Jonanin's Emacs Configuration - jonanin-coffee.el
;; CoffeeScript langauge-specific stuff
;;

(add-hook 'coffee-mode-hook '(lambda ()
  (make-local-variable 'tab-width)
  (make-local-variable 'coffee-tab-width)
  (set 'tab-width 2)
  (set 'coffee-tab-width 2)
  (local-set-key (kbd "RET") 'coffee-newline-and-indent)))

;; coffee-script mode
(require 'coffee-mode)
(add-to-list 'auto-mode-alist '("\\.coffee$" . coffee-mode))
(add-to-list 'auto-mode-alist '("Cakefile" . coffee-mode))
