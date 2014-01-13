
;; Turn off interface stuff right away
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; Setup config paths
(defvar dotfiles-dir (file-name-directory load-file-name))

(add-to-list 'load-path dotfiles-dir)

(require 'cask "~/.cask/cask.el")
(cask-initialize)


(setq exec-path (split-string (getenv "PATH") ":"))

(dired "~/dev")

;; Load core stuff
(require 'jonanin)
(require 'jonanin-interface)
(require 'jonanin-input)
(require 'jonanin-binds)

(add-hook 'after-init-hook
  (lambda()
    (global-flycheck-mode)
    (load-theme 'zenburn t)
    (mapc 'load
          (directory-files (concat dotfiles-dir "modes/") 't "^[^#].*el$"))
  ))

(provide 'init)
