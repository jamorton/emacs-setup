;;; guess-style.el --- automatic setting of code style variables
;;
;; Copyright (C) 2009 Nikolaj Schumacher
;;
;; Author: Nikolaj Schumacher <bugs * nschum de>
;; Version: 0.1
;; Keywords: c, files, languages
;; URL: http://nschum.de/src/emacs/guess-style/
;; Compatibility: GNU Emacs 22.x, GNU Emacs 23.x
;;
;; This file is NOT part of GNU Emacs.
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 2
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.
;;
;;; Commentary:
;;
;; Add the following to your .emacs file:
;;
;; (add-to-path 'load-path "/path/to/guess-style")
;; (autoload 'guess-style-set-variable "guess-style" nil t)
;; (autoload 'guess-style-guess-variable "guess-style")
;; (autoload 'guess-style-guess-all "guess-style" nil t)
;;
;; To guess variables when a major mode is loaded, add `guess-style-guess-all'
;; to that mode's hook like this:
;; (add-hook 'c-mode-common-hook 'guess-style-guess-all)
;;
;; To (permanently) override values use `guess-style-set-variable'.  To change
;; what variables are guessed, customize `guess-style-guesser-alist'.
;;
;; To show some of the guessed variables in the mode-line, enable
;; guess-style-info-mode.  You can do this by adding this to your .emacs:
;; (global-guess-style-info-mode 1)
;;
;;; Change Log:
;;
;; 2009-03-19 (0.1)
;;    Initial release.
;;
;;; Code:

(eval-when-compile (require 'cl))

(add-to-list 'debug-ignored-errors "^Not enough lines to guess variable$")
(add-to-list 'debug-ignored-errors "^Not certain enough to guess variable$")

(defgroup guess-style nil
  "Automatic setting of code style variables."
  :group 'c
  :group 'files
  :group 'languages)

(defcustom guess-style-override-file
  (if (fboundp 'locate-user-emacs-file)
      (locate-user-emacs-file "guess-style" ".guess-style")
    "~/.guess-style")
  "*File name for storing the manual style settings"
  :group 'guess-style
  :type 'file)

(defcustom guess-style-file-coding-system
  (if (fboundp 'coding-system-priority-list)
      (car (coding-system-priority-list))
    'emacs-mule)
  "*Coding system for `guess-style-override-file'."
  :group 'guess-style
  :type 'coding-system)

(defcustom guess-style-guesser-alist
  '((indent-tabs-mode . guess-style-guess-tabs-mode)
    (tab-width . guess-style-guess-tab-width)
    (c-basic-offset . guess-style-guess-c-basic-offset)
    (nxml-child-indent . guess-style-guess-indent)
    (css-indent-offset . guess-style-guess-indent))
  "*A list of cons containing a variable and a guesser function."
  :group 'guess-style
  :type '(repeat (cons variable function)))

(defvar guess-style-overridden-variable-alist 'not-read
  "List of files and directories with manually overridden guess-style variables.
Use `guess-style-set-variable' to modify this variable")

(defun guess-style-overridden-variables (&optional file)
  "Return a list of FILE's overridden variables and their designated values.
If FILE is nil, `buffer-file-name' is used."
  (setq file (abbreviate-file-name (or file buffer-file-name)))
  (when (eq guess-style-overridden-variable-alist 'not-read)
    (guess-style-read-override-file))
  (let ((alist guess-style-overridden-variable-alist)
        (segments (split-string (abbreviate-file-name file) "/"))
        vars)
    (while alist
      (dolist (pair (cdr (assoc :variables alist)))
        (setcdr (or (assoc (car pair) vars)
                    (car (push pair vars)))
                (cdr pair)))
      (setq alist (cdr (assoc (pop segments) alist))))
    vars))

(defun guess-style-write-override-file ()
  "Write overridden variables to `guess-style-override-file'."
  ;; based on recentf-save-list
  (condition-case error
      (with-temp-buffer
        (let ((standard-output (current-buffer)))
          (set-buffer-file-coding-system guess-style-file-coding-system)
          (insert (format ";;; Generated by `guess-style' on %s\n\n"
                          (current-time-string)))
          (insert (format "(setq %S\n     '%S)\n"
                          'guess-style-overridden-variable-alist
                          guess-style-overridden-variable-alist))
          (insert "\n\n;;; Local Variables:\n"
                  (format ";;; coding: %s\n" buffer-file-coding-system)
                  ";;; End:\n")
          (switch-to-buffer (current-buffer))
          (write-file (expand-file-name guess-style-override-file))))
    (error (warn "guess-style: %s" (error-message-string error)))))

(defun guess-style-read-override-file ()
  "Read overridden variables from `guess-style-override-file'."
  (let ((file (expand-file-name guess-style-override-file)))
    (setq guess-style-overridden-variable-alist nil)
    (when (file-readable-p file)
      (load-file file))))

(defun guess-style-add-to-alist (segments &optional old-alist)
  (if (consp segments)
      (let* ((match (assoc (car segments) old-alist))
             (children (guess-style-add-to-alist (cdr segments) (cdr match))))
        (if match
            (setcdr match children)
          (setq match (cons (car segments) children))
          (push match old-alist))
        old-alist)
    segments))

;;;###autoload
(defun guess-style-set-variable (variable value file)
  "Override VARIABLE's guessed value for future guesses.
If FILE is a directory, the variable will be overridden for the entire
directory, unless single files are later overridden.
If called interactively, the current buffer's file name will be used for FILE.
With a prefix argument a directory name may be entered."
  (interactive (list (intern (completing-read "Variable: "
                                              guess-style-guesser-alist nil t))
                     (read (read-string "Value: "))
                     (read-file-name "File/Directory: " nil buffer-file-name t
                                     (file-name-nondirectory buffer-file-name)))
               )
  ;; abbreviate file name for portability (e.g. different home directories)
  (setq file (abbreviate-file-name file))
  (set (make-local-variable variable) value)
  (when (eq guess-style-overridden-variable-alist 'not-read)
    (guess-style-read-override-file))
  (setq guess-style-overridden-variable-alist
        (guess-style-add-to-alist (append (split-string file "/" t)
                                          (cons :variables
                                                (cons variable value)))))
  (guess-style-write-override-file))

;;;###autoload
(defun guess-style-guess-variable (variable &optional guesser)
  "Guess a value for VARIABLE according to `guess-style-guesser-alist'.
If GUESSER is set, it's used instead of the default."
  (unless guesser
    (setq guesser (cdr (assoc variable guess-style-guesser-alist))))
  (condition-case err
      (let ((overridden-value
             (cdr (assoc variable (guess-style-overridden-variables))))
            (guessed-value (funcall guesser)))
        (set (make-local-variable variable)
             (or overridden-value guessed-value))
        (message "%s variable '%s' (%s)"
                 (if overridden-value "Remembered" "Guessed")
                 variable (symbol-value variable))
        `(lambda () ,(symbol-value variable)))
    (error (message "Could not guess variable '%s' (%s)" variable
                    (error-message-string err))
           `(lambda () (error "%s" (error-message-string ,err))))))

;;;###autoload
(defun guess-style-guess-all ()
  "Guess all variables in `guess-style-guesser-alist'.
Special care is taken so no guesser is called twice."
  (interactive)
  (let (cache match)
    (dolist (pair guess-style-guesser-alist)
      ;; Cache, so we don't call the same guesser twice.
      (if (setq match (assoc (cdr pair) cache))
          (guess-style-guess-variable (car pair) (cdr match))
        (push (cons (cdr pair)
                    (guess-style-guess-variable (car pair) (cdr pair)))
              cache)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defcustom guess-style-maximum-false-spaces 0.3
  "*The percentage of space indents with five or more to keep `tab-width' at 4."
  :type 'number
  :group 'guess-style)

(defcustom guess-style-minimum-line-count 3
  "*The number of significant lines needed to make a guess."
  :type 'number
  :group 'guess-style)

(defcustom guess-style-too-close-to-call .05
  "*Certainty Threshold under which no decision will be made."
  :type 'number
  :group 'guess-style)

(defcustom guess-style-maximum-false-tabs 0.3
  "*The percentage of tab lines allowed to keep `indent-tabs-mode' nil."
  :type 'number
  :group 'guess-style)

(defcustom guess-style-maximum-false-indent 0.1
  "*Percentage of lines indented at a lower value than the default."
  :type 'number
  :group 'guess-style)

(defun guess-style-guess-tabs-mode ()
  "Guess whether tabs are used for indenting in the current buffer."
  (save-restriction
    (widen)
    (let* ((num-tabs (how-many "^\t" (point-min) (point-max)))
           (num-nontabs (how-many "^    " (point-min) (point-max)))
           (total (+ num-tabs num-nontabs)))
      (when (< total guess-style-minimum-line-count)
        (error "Not enough lines to guess variable"))
      (> (/ (float num-tabs) total) guess-style-maximum-false-tabs))))

(defun guess-style-guess-tab-width ()
  "Guess whether \\t in the current buffer is supposed to mean 4 or 8 spaces."
  (save-restriction
    (widen)
    (let ((many-spaces (how-many "^\t+ \\{4,7\\}[^ ]" (point-min) (point-max)))
          (few-spaces (how-many "^\t+  ? ?[^ ]" (point-min) (point-max))))
      (when (< (+ many-spaces few-spaces) guess-style-minimum-line-count)
        (error "Not enough lines to guess variable"))
      (if (> many-spaces
             (* guess-style-maximum-false-spaces few-spaces)) 8 4))))

(defun guess-style-how-many (regexp)
  "A simplified `how-many' that uses `c-syntactic-re-search-forward'."
  (save-excursion
    (goto-char (point-min))
    (let ((count 0) opoint)
      (while (and (< (point) (point-max))
                  (progn (setq opoint (point))
                         (when (fboundp 'c-syntactic-re-search-forward)
                           (c-syntactic-re-search-forward regexp nil t))))
        (if (= opoint (point))
            (forward-char 1)
          (setq count (1+ count))))
      count)))

(defun guess-style-guess-c-basic-offset ()
  (unless (and (boundp 'c-buffer-is-cc-mode) c-buffer-is-cc-mode)
    (error "Not a cc-mode"))
  (let (c-buffer-is-cc-mode)
    (flet ((how-many (regexp) (guess-style-how-many regexp)))
      (guess-style-guess-indent))))

(defun guess-style-guess-indent ()
  (and (boundp 'c-buffer-is-cc-mode)
       c-buffer-is-cc-mode
       (error "This is a cc-mode"))
  (let* ((tab (case tab-width
                (8 "\\(\\( \\{,7\\}\t\\)\\|        \\)")
                (4 "\\(\\( \\{,3\\}\t\\)\\|    \\)")
                (2 "\\(\\( ?\t\\)\\|  \\)")))
         (end "[^[:space:]]")
         (two-exp (case tab-width
                    (8 (concat "^" tab "*   \\{4\\}?" end))
                    (4 (concat "^" tab "*  " end))
                    (2 (concat "^" tab tab "\\{2\\}*" end))))
         (four-exp (case tab-width
                     (8 (concat "^" tab "* \\{4\\}" end))
                     (4 (concat "^" tab tab "\\{2\\}*" end))
                     (2 (concat "^" tab "\\{2\\}" tab "\\{4\\}*" end))))
         (eight-exp (case tab-width
                      (8 (concat "^" tab "+" end))
                      (4 (concat "^" tab "\\{2\\}+" end))
                      (2 (concat "^" tab "\\{4\\}+" end))))
         (two (how-many two-exp))
         (four (how-many four-exp))
         (eight (how-many eight-exp))
         (total (+ two four eight))
         (too-close-to-call (* guess-style-too-close-to-call total)))
    (when (< total guess-style-minimum-line-count)
      (error "Not enough lines to guess variable"))
    (let ((two-four (- two (* guess-style-maximum-false-indent four)))
          (two-eight (- two (* guess-style-maximum-false-indent eight)))
          (four-eight (- four (* guess-style-maximum-false-indent eight))))
      (or (if (> two-four 0)
              (if (> two-eight 0)
                  (unless (< (min two-four two-eight) too-close-to-call) 2)
                (unless (< (min two-four (- two-eight)) too-close-to-call) 8))
            (if (> four-eight 0)
                (unless (< (min (- two-four) four-eight) too-close-to-call) 4)
              (unless (< (- four-eight) too-close-to-call) 8)))
        (error "Not certain enough to guess variable")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defcustom guess-style-lighter-format-func
  'guess-style-lighter-default-format-func
  "*Function used for formatting the lighter in `guess-style-info-mode'.
This has to be a function that takes no arguments and returns a info string
for the current buffer."
  :group 'guess-style
  :type 'function)

(defun guess-style-get-indent ()
  (case major-mode
    (nxml-mode (when (boundp 'nxml-child-indent) nxml-child-indent))
    (css-mode (when (boundp 'css-indent-offset) css-indent-offset))
    (otherwise (and (boundp 'c-buffer-is-cc-mode)
                    c-buffer-is-cc-mode
                    (boundp 'c-basic-offset)
                    c-basic-offset))))

(defun guess-style-lighter-default-format-func ()
  (let ((indent-depth (guess-style-get-indent)))
    (concat (when indent-depth (format " >%d" indent-depth))
            " " (if indent-tabs-mode (format "t%d" tab-width) "spc"))))

(define-minor-mode guess-style-info-mode
  "Minor mode to show guessed variables in the mode-line.
Customize `guess-style-lighter-format-func' to change the variables."
  nil nil nil)

(define-globalized-minor-mode global-guess-style-info-mode
  guess-style-info-mode (lambda () (guess-style-info-mode 1)))

;; providing a lighter in `define-minor-mode' doesn't allow :eval forms
(add-to-list 'minor-mode-alist
             '(guess-style-info-mode
               ((:eval (funcall guess-style-lighter-format-func)))))

(provide 'guess-style)
;;; guess-style.el ends here

