(autoload 'markdown-mode "markdown-mode.el"
  "major mode for editing markdown files" t)

(setq auto-mode-alist
      (cons '("\\.markdown" . markdown-mode) auto-mode-alist))
