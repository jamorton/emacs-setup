
;; Turn off interface stuff right away
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; Setup config paths
(setq dotfiles-dir (file-name-directory
                    (or (buffer-file-name) load-file-name)))

(add-to-list 'load-path dotfiles-dir)
(add-to-list 'load-path (concat dotfiles-dir "/extra"))
(add-to-list 'load-path (concat dotfiles-dir "/extra/magit"))
(add-to-list 'load-path (concat dotfiles-dir "/extra/yasnippet"))
(add-to-list 'load-path (concat dotfiles-dir "/extra/rust"))

(byte-recompile-directory dotfiles-dir 0)

;; Load everything
(require 'jonanin)
(require 'jonanin-interface)
(require 'jonanin-input)
(require 'jonanin-binds)
(require 'jonanin-python)
(require 'jonanin-js)
(require 'jonanin-coffee)
(require 'jonanin-css)
(require 'jonanin-go)
(require 'jonanin-snippet)
(require 'jonanin-rust)
(require 'jonanin-ruby)

(add-hook 'c-mode-common-hook '(lambda ()
  (make-local-variable 'indent-tabs-mode)
  (set 'indent-tabs-mode nil)
  ))

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(safe-local-variable-values (quote ((buffer-file-coding-system . utf-8-unix)))))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )
