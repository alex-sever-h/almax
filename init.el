;;; package --- Summary
;;; Commentary:
;;; Code:
 
(setq inhibit-startup-screen t)

;; mouse-scroll
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse

;; always truncate lines by default
(setq-default truncate-lines t)

;; Add melpa repositories
(require 'package)
(setq package-enable-at-startup nil)
(setq use-package-verbose t)
(setq use-package-always-ensure t)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
;; Bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; warn when opening files bigger than 100MB
(setq large-file-warning-threshold 100000000)

;; cua-mode (sane keys)
(cua-mode t)
(transient-mark-mode 1) ;; No region when it is not highlighted

(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

;; ido-mode
(use-package ido
  :init
  (ido-mode 1)
  (use-package ido-vertical-mode
    :disabled
    :init (ido-vertical-mode 1))
  (use-package flx-ido
    :init (flx-ido-mode 1))
  (use-package smex
    :init (smex-initialize)
    :bind ("M-x" . smex))
  (use-package ido-yes-or-no
    :init (ido-yes-or-no-mode 1))
  :config
  ; disable ido (format "message" format-args)aces to see flx highlights.
  (setq ido-enable-flex-matching t)
  ; disable ido faces to see flx highlights
  (setq ido-use-faces nil)
  )

(use-package ivy :ensure t
  :diminish (ivy-mode . "")
  :bind
  :disabled
  (:map ivy-mode-map
	("C-'" . ivy-avy))
  :init
  (use-package swiper)
  (use-package counsel)
  :config
  (ivy-mode 1)
  ;; add ‘recentf-mode’ and bookmarks to ‘ivy-switch-buffer’.
  (setq ivy-use-virtual-buffers t)
  ;; number of result lines to display
  (setq ivy-height 10)
  ;; does not count candidates
  (setq ivy-count-format "(%d/%d) ")
  ;; no regexp by default
  (setq ivy-initial-inputs-alist nil)
  ;; configure regexp engine.
  (setq ivy-re-builders-alist
	;; allow input not in order
        '((t   . ivy--regex-ignore-order)))
  
  (global-set-key (kbd "C-s") 'swiper)
  (global-set-key (kbd "M-x") 'counsel-M-x)
  (global-set-key (kbd "C-x C-f") 'counsel-find-file)
  (global-set-key (kbd "<f1> f") 'counsel-describe-function)
  (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
  (global-set-key (kbd "<f1> l") 'counsel-find-library)
  (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
  (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
  )

(use-package smartparens
  :init
  (smartparens-global-mode 1)
  (show-smartparens-global-mode +1)
  :bind
  (("M-n" . sp-next-sexp)
         ("M-p" . sp-previous-sexp)
         ("M-f" . sp-forward-sexp)
         ("M-b" . sp-backward-sexp))
  :config
  (setq sp-show-pair-from-inside t))

(use-package rainbow-delimiters
  :init
  (setq frame-background-mode 'dark)
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
  :config
  (set-face-foreground 'rainbow-delimiters-depth-1-face "orange red")
  (set-face-foreground 'rainbow-delimiters-depth-2-face "deep sky blue")

  )

;; Color theme
(use-package color-theme
  :ensure t
  :config
  (color-theme-initialize)
  (color-theme-charcoal-black)
  )
(use-package powerline
  :config (powerline-default-theme))

(use-package yasnippet
  :disabled
  :init
  (yas-global-mode 1)
  (use-package yasnippet-snippets)
  ;(add-hook 'prog-mode-hook #'yas-minor-mode)
  :config ; stuff to do after requiring the package
  (yas-reload-all)
  (eval-after-load 'company
    '(add-to-list 'company-backends 'company-yasnippet))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; iedit ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package iedit
  :ensure t
;  :config (iedit-mode)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; google-style ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package google-c-style
  :ensure t
  :config
  (progn
       (add-hook 'c-mode-common-hook 'google-set-c-style)
       (add-hook 'c-mode-common-hook 'google-make-newline-indent)
    ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; completion ;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package company
  :init
  (use-package company-c-headers)
  (add-hook 'after-init-hook 'global-company-mode)
  :bind
  ("M-/" . company-complete-common)
  :config
  (setq company-idle-delay 0.5)
  (setq company-tooltip-limit 10)
  (setq company-minimum-prefix-length 2)
  ;; invert the navigation direction if the the completion popup-isearch-match
  ;; is displayed on top (happens near the bottom of windows)
  (setq company-tooltip-flip-when-above t)

  (global-company-mode 1)
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; checking ;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package flycheck
  :init
  (global-flycheck-mode 1)
  (use-package flycheck-pos-tip
    :config
    ;; (format "message" format-args)lycheck errors on a tooltip (doesnt work on console)
    (when (display-graphic-p (selected-frame))
      (eval-after-load 'flycheck
	   '(custom-set-variables
	     '(flycheck-display-errors-function #'flycheck-pos-tip-error-messages))))
    )
  :config
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (setq flycheck-standard-error-navigation nil)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; irony ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package irony
  :init
  (use-package company-irony
    :config
    (eval-after-load 'company
      '(add-to-list 'company-backends 'company-irony)))
  (use-package company-irony-c-headers
    :config
    (eval-after-load 'company
      '(add-to-list 'company-backends 'company-irony-c-headers)))
  (use-package flycheck-irony)
  (use-package irony-eldoc)
  :config
  
  (add-hook 'c++-mode-hook 'irony-mode)
  (add-hook 'c-mode-hook 'irony-mode)
  (add-hook 'objc-mode-hook 'irony-mode)

  (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

  ; Load with `irony-mode` as a grouped backend
  (eval-after-load 'flycheck
    '(add-hook 'flycheck-mode-hook #'flycheck-irony-setup))
  )

(use-package eldoc
  :init
  (add-hook 'prog-mode-hook 'turn-on-eldoc-mode)
  )

(semantic-mode 1)
(global-ede-mode t)
(ede-enable-generic-projects)

(use-package ecb
  :defer t
  :init
  (setq stack-trace-on-error t)
  (setq ecb-layout-name "left7")
  (setq ecb-show-sources-in-directories-buffer 'always)
  (setq ecb-compile-window-height 5)
  (setq ecb-windows-width 35)
  )

(use-package crux)


(use-package ws-butler
  :commands ws-butler-mode
  :init (progn
          (add-hook 'c-mode-common-hook 'ws-butler-mode)
          (add-hook 'python-mode-hook 'ws-butler-mode)
          (add-hook 'cython-mode-hook 'ws-butler-mode)))

(use-package undo-tree
  :init
  (progn
    (global-undo-tree-mode)
    (setq undo-tree-visualizer-timestamps t)
    (setq undo-tree-visualizer-diff t)
    ))







;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; CEDET ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;(semantic-mode 1)

;(global-semantic-idle-scheduler-mode 1)
;(global-semantic-idle-summary-mode 1)
;(global-semantic-idle-completions-mode 1)
;(global-semantic-idle-local-symbol-highlight-mode 1)
;(global-semantic-highlight-func-mode 1)
;(global-semantic-highlight-edits-mode 1)
;(global-semantic-mru-bookmark-mode 1)
;(global-semantic-decoration-mode 1)
;(global-semantic-stickyfunc-mode 1)
;(global-semantic-show-unmatched-syntax-mode 1)
;(global-semantic-show-parser-state-mode 1)
;(global-semanticdb-minor-mode 1)

;(defun alseh/cedet-hook ()
;  (local-set-key [(control return)] 'semantic-ia-complete-symbol-menu)
;  (local-set-key "\C-c?" 'semantic-ia-complete-symbol)
;  (local-set-key "\C-c>" 'semantic-comsemantic-ia-complete-symbolplete-analyze-inline)
;  (local-set-key "\C-c=" 'semantic-decoration-include-visit)
;  (local-set-key "\C-cj" 'semantic-ia-fast-jump)
;  (local-set-key "\C-cq" 'semantic-ia-show-doc)
;  (local-set-key "\C-cs" 'semantic-ia-show-summary)
;  (local-set-key "\C-cp" 'semantic-analyze-proto-impl-toggle)
;  (add-to-list 'ac-sources 'ac-source-semantic)
;  )
;(add-hook 'semantic-init-hooks 'alseh/cedet-hook)
;(add-hook 'c-mode-common-hook 'alseh/cedet-hook)
;(add-hook 'lisp-mode-hook 'alseh/cedet-hook)
;(add-hook 'scheme-mode-hook 'alseh/cedet-hook)
;(add-hook 'emacs-lisp-mode-hook 'alseh/cedet-hook)
;(add-hook 'erlang-mode-hook 'alseh/cedet-hook)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ecb-options-version "2.50")
 '(package-selected-packages (quote (use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
