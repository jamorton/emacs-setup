;;
;; Jonanin's Emacs Configuration - jonanin-interface.el
;;

;; Interface stuff from starter-kit
(when window-system
  (setq frame-title-format '(buffer-file-name "%f" ("%b")))
  (tooltip-mode -1)
  (mouse-wheel-mode t)
  (blink-cursor-mode -1))

(add-hook 'before-make-frame-hook 'turn-off-tool-bar)

(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(ansi-color-for-comint-mode-on)

;; Paren matching
(show-paren-mode 1)
(setq-default show-paren-style 'expression)
(setq-default show-paren-delay 0)

;; Column numbers
(column-number-mode 1)

;; unique names
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

;; Ido-mode
(ido-mode t)
(ido-everywhere 1)
(flx-ido-mode 1)
(setq-default
  ido-use-faces nil
  ido-create-new-buffer 'always
  ido-use-filename-at-point nil)

;; no splash
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)

;; truncate lines instead of wrapping them
(set-default 'truncate-lines t)

;; set font
(set-face-attribute 'default nil :font "Source Code Pro")
(set-face-attribute 'default nil :height 120)

(provide 'jonanin-interface)
