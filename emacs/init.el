(require 'package)
(package-initialize)

(add-to-list 'package-archives
	     '("org" . "http://orgmode.org/elpa/") t)
(add-to-list 'package-archives

	     '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives
	     '("marmalade" . "http://marmalade-repo.org/packages/") t)

(unless (package-installed-p 'use-package)
  (progn
    (package-refresh-contents)
    (package-install 'use-package)
    (package-initialize)))

(eval-and-compile
  (defvar use-package-verbose t)
  (require 'use-package))

;; (defun set-my-theme (package)
;;   (setq theme (make-symbol (substring (symbol-name package) 0 -6)))
;;   (use-package package
;;     :init (progn (load-theme theme t t)
;; 		 (enable-theme theme))
;;     :ensure t
;;     :defer t)
;; )

;; (set-my-theme 'material-theme)

;; (use-package material-theme
;;   :init (progn (load-theme 'material t t)
;; 	       (enable-theme 'material))
;;   :ensure t
;;   :defer t)

; Ample Themes
;; (use-package ample-theme
;; 	     :init (progn (load-theme 'ample t t)
;; 			  (enable-theme 'ample))
;; 	     :ensure t
;; 	     :defer t)

(use-package monokai-theme
  :init (load-theme 'monokai t)
  :ensure t)

;(use-package base16-theme
;  :init (progn (load-theme 'base16-twilight-dark t))
;  :ensure t)

;; (use-package tangotango-theme
;;   :init (progn (load-theme 'tangotango t)
;; 	       (enable-theme 'tangotango))
;;   :ensure t
;;   :defer t)

(use-package org
             :ensure org-plus-contrib)

;; Stop emacs from prompting if we load config from symlink.
(setq vc-follow-symlinks t)

;; Load emacs config from org file via babel.
(require 'org)
(org-babel-load-file "~/.emacs.d/emacs.org")
