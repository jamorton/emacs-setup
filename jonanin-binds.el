
;; Jump to a definition in the current file.
(global-set-key (kbd "C-x C-i") 'imenu)

;; Magit
(global-set-key (kbd "C-x g") 'magit-status)

;; Insert on each line
(global-set-key (kbd "C-x r a") 'string-insert-rectangle)

(setq compilation-read-command nil)
(setq compilation-ask-about-save nil)
(global-set-key (kbd "C-x c") 'compile)

(provide 'jonanin-binds)
