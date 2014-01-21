
;; Turn off interface stuff right away
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; Setup config paths
(defvar dotfiles-dir (file-name-directory load-file-name))
(add-to-list 'load-path dotfiles-dir)

;; Load Cask (and all third party packages)
(require 'cask "~/.cask/cask.el")
(cask-initialize)

(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

;; Load PATH from shell environment
 (defun print-elements-of-list (list)
       "Print each element of LIST on a line of its own."
       (while list
         (print (car list))
         (setq list (cdr list))))
(print-elements-of-list exec-path)

;; Load core stuff
(require 'jonanin)
(require 'jonanin-interface)
(require 'jonanin-input)
(require 'jonanin-binds)

(provide 'init)
