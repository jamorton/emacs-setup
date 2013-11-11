
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
(add-to-list 'load-path (concat dotfiles-dir "extra/haskell-mode/"))

;; Byte-compile everything
(setq max-specpdl-size 20000)
(setq max-lisp-eval-depth 50000)
(byte-recompile-directory dotfiles-dir 0)

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

(setq exec-path (cons "/usr/local/bin" exec-path))
(setq exec-path (cons "/usr/local/share/python" exec-path))

(add-hook 'after-init-hook #'global-flycheck-mode)

;; Load core stuff
(require 'jonanin)
(require 'jonanin-interface)
(require 'jonanin-input)
(require 'jonanin-binds)

(add-hook 'after-init-hook
  (lambda ()
    (mapc 'load
          (directory-files (concat dotfiles-dir "modes/") 't "^[^#].*el$"))
  ))

(dired "~/dev")

(provide 'init)
