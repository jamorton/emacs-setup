
(add-hook 'ruby-mode-hook
  (lambda ()
	(set-local-key (kbd "RET") 'newline-and-indent)
	))
