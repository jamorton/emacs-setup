
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

(setq max-specpdl-size 20000)
(setq max-lisp-eval-depth 50000)
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
(require 'jonanin-lua)

(add-hook 'c-mode-common-hook '(lambda ()
  (make-local-variable 'indent-tabs-mode)
  (set 'indent-tabs-mode nil)
  ))

(custom-set-variables
 '(safe-local-variable-values (quote ((buffer-file-coding-system . utf-8-unix)))))

