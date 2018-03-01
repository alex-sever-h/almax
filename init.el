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

(require 'bind-key)
(require 'use-package)

(use-package auto-compile
  :config (auto-compile-on-load-mode))
(setq load-prefer-newer t)

;; Load secrets
;; I keep slightly more sensitive information in a separate file so that I can easily publish my main configuration.
(load "~/.emacs.secrets" t)

;; Backups
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
(setq delete-old-versions -1)
(setq version-control t)
(setq vc-make-backup-files t)
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))

;; History
(setq savehist-file "~/.emacs.d/savehist")
(savehist-mode 1)
(setq history-length t)
(setq history-delete-duplicates t)
(setq savehist-save-minibuffer-history 1)
(setq savehist-additional-variables
      '(kill-ring
        search-ring
        regexp-search-ring))

; Recent open files
(use-package recentf
  :init
  (recentf-mode)
  :config
  (setq recentf-max-saved-items 200
        recentf-max-menu-items 15)
)

; Winner mode - undo and redo window configuration
(use-package winner
  :defer t)

;; warn when opening files bigger than 100MB
(setq large-file-warning-threshold 100000000)

;; When you start typing and text is selected, replace it with what you are typing, or pasting, or whatever. 65
(delete-selection-mode 1)

(column-number-mode 1)
(display-time-mode 1)
(setq display-time-format "%l:%M%p")

(tool-bar-mode -1)

;; cua-mode (sane keys)
(cua-mode t)
(transient-mark-mode 1) ;; No region when it is not highlighted

;;  When you load modes, most of them show up in the minibuffer.
;; After you read their name a few thousand times, you eventually quite forgetting that you loaded them
;; and need a diminished reminder.
(use-package diminish)

;; Whitespace mode ?????
(require 'whitespace)
(setq whitespace-style '(face tabs empty trailing lines-tail trailing lines tab-mark))
(setq whitespace-line-column 120)
(global-whitespace-mode 1)
(eval-after-load "diminish"
  '(progn
     (eval-after-load "whitespace"
       '(diminish 'global-whitespace-mode "ᗣ"))
     (eval-after-load "whitespace"
       '(diminish 'whitespace-mode ""))))

;; Make it easier to answer questions.
(fset 'yes-or-no-p 'y-or-n-p)
;; It often displays so much information, even temporarily, that it is nice to give it some room to breath. 67
(setq resize-mini-windows t)
(setq max-mini-window-height 0.33)

;; SHIFT-arrow change window
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

;; interpret ANSI colors in compilation
(use-package ansi-color
  :init
  (defun colorize-compilation-buffer ()
    (toggle-read-only)
    (ansi-color-apply-on-region compilation-filter-start (point))
    (toggle-read-only))
  (add-hook 'compilation-filter-hook 'colorize-compilation-buffer)
)
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
    :disabled ; (easier way used)
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
  (set-face-foreground 'rainbow-delimiters-depth-3-face "lime green")
  (set-face-foreground 'rainbow-delimiters-depth-4-face "medium orchid")
  (set-face-foreground 'rainbow-delimiters-depth-5-face "snow")
  (set-face-foreground 'rainbow-delimiters-depth-6-face "chocolate2")

  )

;; Color theme
;(use-package color-theme
;  :ensure t
;  :config
;  (color-theme-initialize)
;  (color-theme-charcoal-black)
;  )

;(use-package powerline
;  :config (powerline-default-theme))

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

(use-package avy)

(use-package key-chord
  :init (key-chord-mode +1)
  :config
  (key-chord-define-global "uu" 'undo-tree-visualize)
    (key-chord-define-global "jr"     'my/goto-random-char-hydra/my/goto-random-char)
    (key-chord-define-global "kk"     'my/org/body)
    (key-chord-define-global "jj"     'avy-goto-word-1)
    ;(key-chord-define-global "yy"    'my/window-movement/body)
    (key-chord-define-global "yy" 'browse-kill-ring)
    (key-chord-define-global "jw"     'switch-window)
    (key-chord-define-global "jl"     'avy-goto-line)
    (key-chord-define-global "jk" 'avy-goto-char)
    (key-chord-define-global "j."     'join-lines/body)
    ;(key-chord-define-global "jZ"     'avy-zap-to-char)
    ;(key-chord-define-global "FF"     'find-file)
    (key-chord-define-global "qq"     'my/quantified-hydra/body)
    (key-chord-define-global "hh"     'my/key-chord-commands/body)
    ;(key-chord-define-global "xx"     'er/expand-region)
    (key-chord-define-global "xx" 'execute-extended-command)
    ;(key-chord-define-global "  "     'my/insert-space-or-expand)
    (key-chord-define-global "JJ" 'crux-switch-to-previous-buffer)
    )

(use-package guide-key
  :defer t
  :diminish guide-key-mode
  :config
  :disabled
  (progn
  (setq guide-key/guide-key-sequence '("C-x" "C-x r" "C-x 4" "C-c"))
  (guide-key-mode 1)))  ; Enable guide-key-mode

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

(use-package rtags
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

(use-package magit
  :init 
  (use-package magit-rockstar)
  (use-package magit-gh-pulls))

(use-package arduino-mode
  :config
  (setq ede-arduino-appdir "/Applications/Arduino.app/Contents/Resources/Java"))



(defun prelude-copy-file-name-to-clipboard ()
  "Copy the current buffer file name to the clipboard."
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                    (buffer-file-name))))
    (when filename
      (kill-new filename)
      (message "Copied buffer file name '%s' to the clipboard." filename))))



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
 '(flycheck-display-errors-function (function flycheck-pos-tip-error-messages))
 '(package-selected-packages
   (quote
    (2048-game magit-filenotify magit-find-file magit-gh-pulls magit rtags avy key-chord guide-key use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(scroll-bar-mode -1)

(load-theme 'manoj-dark)
