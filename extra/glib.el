
(defun glib-from-filename ()
  "st-layout-container.c => (\"st\" \"layout\" \"container\")"
  (split-string (file-name-sans-extension (file-name-nondirectory buffer-file-name)) "-"))

(defun glib-initial ()
  "st-layout-container.[ch] => ST_LAYOUT_CONTAINER"
  (if buffer-file-name
      (glib-type)
    "NS_TYPE_NAME"))

(defun glib-fudge-name (name)
  (if name
      (split-string name "_")
    (glib-from-filename)))

(defun glib-type (&optional name)
  " => ST_LAYOUT_CONTAINER"
  (mapconcat 'upcase (glib-fudge-name name) "_"))

(defun glib-class (&optional name)
  " => StLayoutContainer"
  (mapconcat 'capitalize (glib-fudge-name name) ""))

(defun glib-build (name sep)
  " => ST_%(sep)s_LAYOUT_CONTAINER"
  (let ((n (glib-fudge-name name)))
    (format "%s_%s_%s" (car n) sep (mapconcat (lambda (e) e) (cdr n) "_"))))

(defun glib-t (&optional name)
  " => ST_TYPE_LAYOUT_CONTAINER"
  (glib-build name "TYPE"))

(defun glib-no-ns (&optional name)
  " => LAYOUT_CONTAINER"
  (mapconcat (lambda (e) e) (cdr (glib-fudge-name name)) "_"))

(defun glib-is (&optional name)
  " => ST_IS_LAYOUT_CONTAINER"
  (glib-build name "IS"))

(defun glib-header (&optional name)
  "ST_LAYOUT_CONTAINER => st-layout-container.h"
  (format "%s.h"
          (mapconcat 'downcase (glib-fudge-name name) "-")))

(defun glib-inst (&optional name)
  "ST_LAYOUT_CONTAINER => container"
  (downcase (car (last (glib-fudge-name name)))))

(defun glib-fprefix (&optional name)
  "st-layout-container.c => st_layout_container"
  (mapconcat 'downcase (glib-fudge-name name) "_"))

(defun grep-gtype (dir class-name)
  (interactive
   (progn
     (let ((class-name (grep-read-regexp))
           (dir (read-directory-name "Base directory: "
                                     nil default-directory t)))
       (list dir class-name))))

  (let ((command (concat grep-program " -ERHn --color=no "
                         (shell-quote-argument
                          (concat (regexp-quote class-name) "|"
                                  (regexp-quote (glib-fprefix name))))
                         " ."))
        (default-directory (expand-file-name dir)))
    (compilation-start command 'grep-mode)))

(provide 'glib)