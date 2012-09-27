
(autoload 'go-mode "go-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.go$" . go-mode))

(autoload 'gofmt "go-mode" "Pipe the current buffer through gofmt" t nil)
