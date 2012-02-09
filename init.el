
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
