
;; Turn off interface stuff right away
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; Setup config paths
(defvar dotfiles-dir (file-name-directory load-file-name))
(add-to-list 'load-path dotfiles-dir)

;; Load Cask and Pallet (and all third party packages)
(require 'cask "~/.cask/cask.el")
(cask-initialize)
(require 'pallet)
(pallet-mode t)

;; Load PATH from shell environment
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

;; Load every .el file in the modes/ directory
(add-hook 'after-init-hook
 (lambda()
   (mapc 'load
         (directory-files (concat dotfiles-dir "modes/") 't "^[^#].*el$"))))


;; Don't put backup files in every directory
(setq backup-directory-alist `(("." . ,(expand-file-name
                                        (concat dotfiles-dir "backups")))))

;; load magit
(require 'magit)

(add-hook 'after-init-hook
  (lambda()
    (global-flycheck-mode)
    (load-theme 'zenburn t)
  ))

;; create intermediate directories before saving a file
(add-hook 'before-save-hook
          (lambda ()
            (when buffer-file-name
              (let ((dir (file-name-directory buffer-file-name)))
                (when (and (not (file-exists-p dir))
                           (y-or-n-p (format "Directory %s does not exist. Create it?" dir)))
                  (make-directory dir t))))))

;; minimal window, use mouse wheel, turn off cursor blink
(when window-system
  (setq frame-title-format '(buffer-file-name "%f" ("%b")))
  (tooltip-mode -1)
  (mouse-wheel-mode t)
  (blink-cursor-mode -1))

;; no toolbar
(if (functionp 'turn-off-tool-bar)
    (add-hook 'before-make-frame-hook 'turn-off-tool-bar))

;; use utf-8 everywhere
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
  ido-use-filename-at-point nil
  ido-auto-merge-work-directories-length -1
  ido-case-fold t)

;; no splash
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)

;; truncate lines instead of wrapping them
(set-default 'truncate-lines t)

;; set font
(when (display-graphic-p)
  (set-face-attribute 'default nil :font "Source Code Pro")
  (set-face-attribute 'default nil :height 130))

;; spacing settings
(setq-default indent-tabs-mode nil)
(setq-default cua-auto-tabify-rectangles nil)
(setq-default c-basic-offset 4)
(setq-default tab-width 4)
(setq-default c-backspace-function 'backward-delete-char)
(define-key global-map (kbd "RET") 'newline-and-indent)
(setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80 84 88 92 96 100 104 108 112 116 120))
(define-key text-mode-map (kbd "TAB") 'tab-to-tab-stop)

;; Enable computer clipboard
(setq x-select-enable-clipboard t)

;; remove trailing whitespace on save
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; mac keys
(setq mac-command-modifier 'control)

;; make sure there is always a newline at the end of the file
(setq require-final-newline t)

;;; Automatically follow symlinks (don't prompt)
(setq-default vc-follow-symlinks t)

;; Jump to a definition in the current file.
(global-set-key (kbd "C-x C-i") 'imenu)

;; Magit
(global-set-key (kbd "C-x g") 'magit-status)

;; Insert on each line
(global-set-key (kbd "C-x r a") 'string-insert-rectangle)

;; Smex
(require 'smex)
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;; compile from emacs
(setq compilation-read-command nil)
(setq compilation-ask-about-save nil)
(global-set-key (kbd "C-x c") 'compile)

;; start server for emacsclient
(server-start)

(setq-default flycheck-disabled-checkers '(scss c/c++-clang c/c++-gcc))

;; Reload files automatically when they change on the disk
(global-auto-revert-mode t)

;; find files in ~/dev on startup
(dired "~/dev")

(provide 'init)
