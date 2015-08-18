(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#e090d7" "#8cc4ff" "#eeeeec"])
 '(custom-safe-themes
   (quote
    ("08851585c86abcf44bb1232bced2ae13bc9f6323aeda71adfa3791d6e7fea2b6" "51277c9add74612c7624a276e1ee3c7d89b2f38b1609eed6759965f9d4254369" default)))
 '(menu-bar-mode nil)
 '(scroll-bar-mode nil)
 '(tool-bar-mode nil)
 '(tracking-faces-priorities nil)
 '(tracking-frame-behavior t)
 '(tracking-mode t)
 '(weechat-host-default "shodan.foxiepa.ws")
 '(weechat-notification-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Dina" :foundry "unknown" :slant normal :weight normal :height 90 :width normal)))))

;;no splash screen. its annoying.
(setq inhibit-splash-screen t)

;;move backups to a cetral directory
;;maybe turn them off completely later?
(setq
 backup-by-copying t
 backup-directory-alist '(("." . "~/.emacs.d/backups"))
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control t)

;; package repo stuff.
(require 'package)
(push '("marmalade" . "http://marmalade-repo.org/packages/")
        package-archives )
(push '("melpa" . "http://melpa.milkbox.net/packages/")
        package-archives)
(package-initialize)

(require 'diminish)
(require 'evil) ; because otherwise emacs is unusable :V
(require 'evil-leader) 
(require 'evil-surround) ; <33 buttsaver!
(require 'evil-smartparens) ; we want smartparens to work under evil 
(require 'evil-org)  ; we want org mode to be usable under evil
(require 'ibuffer)  ; 
(require 'neotree)  ; we /NEED/ a replacement for NERDTree. 
(require 'gnutls)   ; for weechat and stuff
(require 'gist)     ; we put a lot of stuff on gist.
(require 'weechat)  ; IRC in editor will actually increase my productivity
(require 'smex)     ; we still use M-x, lets make it a little nicer
(require 'elscreen) ; tabs are really nice
(require 'sauron)   ; notifications are important!
(require 'org) 
(require 'flycheck) ; syntax checking and linting 

;; create a toggle for neotree
(global-set-key [f8] 'neotree-toggle)

;; get neotree ready for evil
(add-hook 'neotree-mode-hook
	  (lambda ()
	    (define-key evil-normal-state-local-map (kbd "TAB") 'neotree-enter)
            (define-key evil-normal-state-local-map (kbd "SPC") 'neotree-enter)
            (define-key evil-normal-state-local-map (kbd "q") 'neotree-hide)
            (define-key evil-normal-state-local-map (kbd "RET") 'neotree-enter)))

;; it was dumb... ; (global-linum-mode 1) ; might be dumb but we /really/ like line numbers.

;; init elscreen
(elscreen-start)

;; evil mode related config
(setq evil-shift-width 4)
(global-evil-surround-mode 1) 
(global-evil-leader-mode)

;; evil keys
(define-key evil-normal-state-map [tab] 'indent-for-tab-command)
(define-key evil-visual-state-map [tab] 'align)
(define-key evil-normal-state-map (kbd "C-w t") 'elscreen-create) ;creat tab
(define-key evil-normal-state-map (kbd "C-w x") 'elscreen-kill) ;kill tab
(define-key evil-normal-state-map "gT" 'elscreen-previous) ;previous tab
(define-key evil-normal-state-map "gt" 'elscreen-next) ;next tab
(evil-mode 1)

;; ibuffer
(global-set-key (kbd "C-x C-b") 'ibuffer)
(define-key ibuffer-mode-map (kbd "j") 'next-line)
(define-key ibuffer-mode-map (kbd "k") 'previous-line)

;; themeing related stuff (that isn't custom-set shit)
(load-theme 'molokai)
;; we only want powerline when we are in graphical mode
(when (display-graphic-p)
  (require 'powerline) ; pretty <3
  (require 'airline-themes) ; pretty pretty <3
  (powerline-default-theme)
  (load-theme 'airline-molokai)
  (set-frame-parameter (selected-frame) 'alpha '(85 85)))


;; Use smex instead
(global-set-key (kbd "M-x") 'smex) 

;; org
(setq org-log-done t
      org-agenda-files (list "~/org/tasks.org"
                             "~/org/entropynet.org"
                             "~/org/home.org"
                             "~/org/important.org")
      
      org-enforce-todo-dependencies t)

;; config for sauron
(setq sauron-seperate-frame nil)
(defvar dbus-notification-time 5)
(add-hook 'sauron-event-added-functions
          (lambda (origin prio msg &optional props)           
            (sauron-fx-notify (symbol-name origin) msg  (* dbus-notification-time 1000))))

(sauron-start-hidden)

(setq paradox-github-token "3bcec2427fb74135bc62dadb83c5f3c0ae233df8")

;; perl-mode is rubbish (imo)
(defalias 'perl-mode 'cperl-mode)

;; hooks per major-mode 
;; perl file hooks 
(add-hook 'cperl-mode-hook
          (lambda ()
            (linum-mode)
            (cperl-set-style "PerlStyle")
            (flycheck-mode)))

(add-hook 'racket-mode-hook
          (lambda ()
            (linum-mode)
            (flycheck-mode)))

(add-hook 'c-mode-hook
          (lambda ()
            (linum-mode)
            (flycheck-mode)))


;; haskell is kinda a lot of stuff
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
(add-hook 'haskell-mode-hook
          (lambda ()
            (flycheck-mode)))
(eval-after-load "align"
  '(add-to-list 'align-rules-list
                '(haskell-types
                   (regexp . "\\(\\s-+\\)\\(::\\|∷\\)\\s-+")
                   (modes quote (haskell-mode literate-haskell-mode)))))
(eval-after-load "align"
  '(add-to-list 'align-rules-list
                '(haskell-assignment
                  (regexp . "\\(\\s-+\\)=\\s-+")
                  (modes quote (haskell-mode literate-haskell-mode)))))
(eval-after-load "align"
  '(add-to-list 'align-rules-list
                '(haskell-arrows
                  (regexp . "\\(\\s-+\\)\\(->\\|→\\)\\s-+")
                  (modes quote (haskell-mode literate-haskell-mode)))))
(eval-after-load "align"
  '(add-to-list 'align-rules-list
                '(haskell-left-arrows
                  (regexp . "\\(\\s-+\\)\\(<-\\|←\\)\\s-+")
                  (modes quote (haskell-mode literate-haskell-mode)))))

(setq text-width       4
      standard-indent  4
      indent-tabs-mode t
      c-basic-style    "k&r" ; we use k&r style for the most part. 
      c-basic-offset   4
      )

;; we don't need to see /every/ minor mode.
(add-hook 'auto-fill-mode-hook
          (lambda ()
            (diminish 'auto-fill-function))) ; it is function not mode

(add-hook 'paredit-mode-hook
          (lambda ()
            (diminish 'paredit-mode)))

(diminish 'undo-tree-mode)

;; for weechat.
(add-to-list 'gnutls-trustfiles (expand-file-name "~/.emacs.d/relay.cert"))
(load (find-library-name "weechat-sauron"))
(load (find-library-name "weechat-complete"))
(load (find-library-name "weechat-tracking"))
(when (display-graphic-p)
  (load (find-library-name "weechat-image")))


