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

;; Hide the menu in X.
(tool-bar-mode -1)

;; Set my font.
(push '(font . "DejaVu Sans Mono-10") default-frame-alist)

;; Configure org-mode
(setq org-log-done t)
