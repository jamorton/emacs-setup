;;
;; Jonanin's Emacs Configuration - jonanin-js.el
;; Javascript language-specific stuff
;;

;; js2-mode
(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

;; customizations
(setq js2-pretty-multiline-decl-indentation-p t
      js2-consistent-level-indent-inner-bracket-p t
      js2-enter-indents-newline t
      js2-mirror-mode t
      js2-global-externs '("require" "console" "$" "module" "__dirname" "process"))

(provide 'jonanin-js)