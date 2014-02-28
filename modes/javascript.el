;;
;; Jonanin's Emacs Configuration - jonanin-js.el
;; Javascript language-specific stuff
;;

;; js2-mode

(add-to-list 'auto-mode-alist (cons (rx ".js" eos) 'js2-mode))

(message "FUCK YOU")

;; customizations
(add-hook 'js2-mode-hook
 '(lambda ()
    (setq js2-pretty-multiline-decl-indentation-p t
          js2-consistent-level-indent-inner-bracket-p t
          js2-enter-indents-newline t
          js2-mirror-mode t
          js2-cleanup-whitespace t
          js2-global-externs '("require" "console" "$" "exports"
                               "module" "__dirname" "process"
                               "clearInterval" "setInterval" "setTimeout"
                               "Backbone" "_"))
    ))
