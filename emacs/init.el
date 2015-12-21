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

;; Ample Themes
(use-package ample-theme
	     :init (progn (load-theme 'ample t t)
			  (enable-theme 'ample))
	     :ensure t
	     :defer t)

(use-package org
             :ensure org-plus-contrib)

;; Stop emacs from prompting if we load config from symlink.
(setq vc-follow-symlinks t)

;; Load emacs config from org file via babel.
(require 'org)
(org-babel-load-file "~/.emacs.d/emacs.org")

