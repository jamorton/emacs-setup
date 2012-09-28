
;; Turn off interface stuff right away
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; Setup config paths
(setq dotfiles-dir (file-name-directory load-file-name))

(add-to-list 'load-path dotfiles-dir)
(add-to-list 'load-path (concat dotfiles-dir "extra/"))
(add-to-list 'load-path (concat dotfiles-dir "extra/magit/"))
(add-to-list 'load-path (concat dotfiles-dir "extra/rust/"))

;; Byte-compile everything
(setq max-specpdl-size 20000)
(setq max-lisp-eval-depth 50000)
(byte-recompile-directory dotfiles-dir 0)

;; Load core stuff
(require 'jonanin)
(require 'jonanin-interface)
(require 'jonanin-input)
(require 'jonanin-binds)

;; Load mode configs
(mapc 'load
      (directory-files (concat dotfiles-dir "modes/") 't "^[^#].*el$"))
