;;
;; Jonanin's Emacs Configuration - jonanin-input.el
;;

;; spacing settings

(c-set-offset 'substatement-open 0)
(setq-default indent-tabs-mode t)
(setq-default cua-auto-tabify-rectangles nil)
(setq-default c-basic-offset 4)
(setq-default tab-width 4)
(setq c-backspace-function 'backward-delete-char)
(define-key global-map (kbd "RET") 'newline-and-indent)
(setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80 84 88 92 96 100 104 108 112 116 120))
(define-key text-mode-map (kbd "TAB") 'tab-to-tab-stop)

;; Enable computer clipboard
(setq x-select-enable-clipboard t)

;; autocomplete
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories (concat dotfiles-dir "/extra/ac-dict"))
(ac-config-default)
(global-auto-complete-mode t)

(provide 'jonanin-input)