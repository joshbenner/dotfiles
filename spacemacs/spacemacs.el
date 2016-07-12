;;;; Do not modify this file by hand.  It was automatically generated
;;;; from `emacs.org` in the same directory. See that file for more
;;;; information.
;;;;

(setq vc-follow-symlinks t)
(setq create-lockfiles nil)
(setq evil-emacs-state-cursor '("chartreuse3" (bar . 2)))
(blink-cursor-mode t)
(setq org-agenda-start-on-weekday 0)
(setq org-agenda-todo-ignore-scheduled t)
(setq org-agenda-todo-ignore-deadlines t)
(setq org-support-shift-select 'always)
;; Hide strikethrough, code inline characters.
(setq org-hide-emphasis-markers t)
;; Use HTML5 elements.
(setq org-html-html5-fancy t)

;; Ignore timestamps and publish when I say!
(setq org-publish-use-timestamps-flag nil)

;; Default publish style to solarized light.
(setq org-html-head "<link rel='stylesheet' type='text/css' href='http://thomasf.github.io/solarized-css/solarized-light.min.css' />")
(setq org-support-shift-select 'always)
(setq org-src-window-setup 'current-window)
(delete-selection-mode 1)
;;; Stefan Monnier <foo at acm.org>. It is the opposite of fill-paragraph    
(defun unfill-paragraph (&optional region)
  "Takes a multi-line paragraph and makes it into a single line of text."
  (interactive (progn (barf-if-buffer-read-only) '(t)))
  (let ((fill-column (point-max)))
    (fill-paragraph nil region)))

(define-key global-map "\M-Q" 'unfill-paragraph)
(global-set-key (kbd "<home>") 'spacemacs/smart-move-beginning-of-line)
;(add-to-list 'dotspacemacs-additional-packages 'ob-http)
;(add-to-list 'dotspacemacs-additional-packages 'ob-elixir)
(defvar my/org-babel-evaluated-languages ())
(defvar my/org-src-lang-modes ())
(defvar my/org-babel-no-confirm-languages ())

(defun my/org-confirm-babel-evaluate (lang body)
  (not (member (intern lang) my/org-babel-no-confirm-languages)))

(let ((language-table (cddr '(("Language" "Alias" "Confirm Evaluation?" "Description") hline ("emacs-lisp" "" "Yes" "Emacs Lisp") ("graphviz-dot" "dot" "No" "Directed and undirected graphs") ("gnuplot" "" "No" "Graphs") ("ditaa" "" "No" "Ascii diagrams") ("plantuml" "" "No" "Flow charts") ("mscgen" "" "No" "Message sequence charts") ("haskell" "" "Yes" "A pure, functional language") ("python" "" "Yes" "A dynamic, all-purpose language") ("ruby" "" "Yes" "A dynamic, all-purpose language") ("sh" "" "Yes" "Shell scripts") ("sql" "" "No" "SQL Queries") ("clojure" "" "Yes" "Clojure")))))
  (mapcar (lambda (lang-pair)
            (let* ((alias (if (not (string= (cadr lang-pair) "")) (cadr lang-pair)))
                   (lang (intern (car lang-pair)))
                   (lang-or-alias (if alias (intern alias) lang))
                   (confirm (not (string= (cl-caddr lang-pair) "No"))))
              (if alias
                  (add-to-list 'my/org-src-lang-modes (cons alias lang)))
              (if (not confirm)
                  (add-to-list 'my/org-babel-no-confirm-languages lang-or-alias))
              (add-to-list 'my/org-babel-evaluated-languages lang-or-alias)
              lang-or-alias))
          language-table))

(mapcar (lambda (alias)
          (add-to-list 'org-src-lang-modes alias))
        my/org-src-lang-modes)

(org-babel-do-load-languages
 'org-babel-load-languages
 (mapcar (lambda (lang)
           (cons lang t))
         my/org-babel-evaluated-languages))

(setq org-confirm-babel-evaluate 'my/org-confirm-babel-evaluate)
(defun my/load-elisp-directory (path)
  (let ((file-pattern "\\.elc?$"))
    (when (file-directory-p path)
      (mapcar (lambda (lisp-file)
                (load-file lisp-file))
              (directory-files (expand-file-name path) t file-pattern)))))

(my/load-elisp-directory "~/.emacs.local.d")

;; Also load work files if they are there.
(my/load-elisp-directory "~/.emacs.work.d")
