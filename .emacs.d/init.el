;; Max Masterton's Configuration for the GNU/Emacs elisp interpreter
;;                       __                            
;;   __ _ _ __  _   _   / /__ _ __ ___   __ _  ___ ___ 
;;  / _` | '_ \| | | | / / _ \ '_ ` _ \ / _` |/ __/ __|
;; | (_| | | | | |_| |/ /  __/ | | | | | (_| | (__\__ \
;;  \__, |_| |_|\__,_/_/ \___|_| |_| |_|\__,_|\___|___/
;;  |___/
;;
;; Found at github.com/maxmasterton/emacs

;; Setting up Package.el to work with MELP
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
						 ("org" . "https://orgmode.org/elpa/")
						 ("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Installing and Configuring use-package
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t) ; all use-package statements will include :ensure t by default

;; Setting up auto-package update so that packages are updated automatically
(use-package auto-package-update
  :custom
  (auto-package-update-interval 7) ; Every seven days
  (auto-package-update-prompt-before-update t) ; Ask permission first
  (auto-package-update-hide-results t)
  :config
  (auto-package-update-maybe)
  (auto-package-update-at-time "09:00")) ; At 9:00AM

;; Startup Performace:
;; Garbage Collection
;; Using garbage collection magic hack (gcmh)
(use-package gcmh
  :config
  (gcmh-mode 1))
;; Setting garbage collection threshold
(setq gc-cons-threshold 402653184
	  gc-cons-percentage 0.6)

;; Profile emacs startup
(add-hook 'emacs-startup-hook
		  (lambda ()
			(message "*** Emacs loaded in %s with %d garbage collections."
					 (format "%.2f seconds"
							 (float-time
							  (time-subtract after-init-time before-init-time)))
					 gcs-done)))

;; Silence compiler warnings as they can be pretty disruptive
(if (boundp 'comp-deferred-complation)
	(setq comp-deferred-complation nil
		  native-comp-deferrede-complation nil))
;; In noninteractive situations, prioritze non-byte-compiled source files to prevent the use of stale byte-code
(setq load-prefer-newer noninteractive)

;; Setting some rudimentary settings
(setq-default
 delete-by-moving-to-trash t
 tab-width 4
 window-combination-resize t ; When a new window is created, take space from all existing windows
 x-stretch-cursor t) ; Stretch cursor to cover long characters

(setq undo-limit 80000000 ; Set undo limit to 8MB
	  evil-want-fine-undo t ; Granular changes in insert-mode
	  uniquify-buffer-name-style 'forward ; uniquify buffer names
	  indent-tabs-mode t)

;; Setting up contact details, used by mu4e and magit
(setq user-full-name "Max Masterton"
	  user-mail-address "me@maxmasterton.tech")

;; Disable lockfiles
(setq create-lockfiles nil)

;; Removing useless GUI elements
(scroll-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode -1)

(tool-bar-mode -1)
(menu-bar-mode -1)

;; Enabling usefull modes
(delete-selection-mode 1) ; Delete existing text when inserting text
(global-subword-mode 1)

;; Keeping init.el clean
(setq custom-file (concat user-emacs-directory "/custom.el")) ; Add custom set variables to a seperate file

;; Creating smooth scrolling
(setq scroll-conservativley 1000
	  scroll-margin 4
	  scroll-step 1
	  mouse-wheel-scroll-amount '(6 ((shift) . 1)) ; Use shift for finer scroll
	  mouse-wheel-progressive-speed nil)

(setq redisplay-dont-pause t)
(setq fast-but-imprecise-scrolling nil ; Turn off, always
	  ;jit-lock-defer-time 0.01
	  jit-lock-defer-time 0)

(use-package smooth-scrolling) ; The smooth-scrolling.el works somewhat, have switched it out for sublimity
(smooth-scrolling-mode 1)

;; Defining a function to insert a tab char when tab is pressed
(defun my-insert-tab-char ()
  "Insert a tab char. (ASCII 9, \t)"
  (interactive)
  (insert "\t"))

(global-set-key (kbd "TAB") 'my-insert-tab-char)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit) ; Use ESC to quit prompts
(global-set-key (kbd "<menu>") 'counsel-M-x) ; On UK keyboards, press menu to open Counsel-M-x
;(global-set-key (kbd "C-;") 'counsel-switch-buffer)
(global-set-key (kbd "M-:") 'evil-ex)

;; Put numbers on every buffer, unless specified otherwise in the dolist.
(column-number-mode)
(global-display-line-numbers-mode 1)
(dolist (mode '(org-mode-hook
				term-mode-hook
				treemacs-mode-hook
				;elfeed-search-mode-hook
				elfeed-show-mode-hook
				eww-mode-hook
				eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0)))) ; Turn off line numbers

;; Truncated lines on by default
(global-visual-line-mode t)

;; Defining some fonts
(set-face-attribute 'default nil
					:font "JetBrains Mono 10" ; Monospaced coding font
					:weight 'medium)
(set-face-attribute 'variable-pitch nil ; Non tech font
					:font "Cantarell"
					:height 110)
(set-face-attribute 'fixed-pitch nil
					:font "JetBrains Mono 10"
					:weight 'medium)

;; Extra font settings
(setq-default line-spacing 0.03)
(add-to-list 'default-frame-alist '(font . "JetBrains Mono-10")) ; Emacsclient does not accept fonts by default
(setq global-prettify-symbols-mode t) ; Glyph support

;; Keybindings for scaling text (although hydra function exists)
(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)

(global-set-key (kbd "<C-wheel-up>") 'text-scale-increase)
(global-set-key (kbd "<C-wheel-down>") 'text-scale-decrease)

;; Setting a colour scheme using doom themes
(use-package doom-themes
  :config
  ; Enable italics and bold
  (setq doom-themes-enable-bold t
		doom-themes-enable-italic t)
  (load-theme 'doom-dracula t)) ;; Setting the colour scheme itself

;; Setting Transparency
(set-frame-parameter (selected-frame) 'alpha '(90 . 90))
(add-to-list 'default-frame-alist '(alpha . (90 . 90)))

;; Overriding theme-set font attributes, comments should be italic and keywords shoult not be bold.
(set-face-attribute 'font-lock-comment-face nil
					:slant 'italic)
(set-face-attribute 'font-lock-keyword-face nil
					:weight 'medium)

;; Adding upport for emojis and icons
(use-package all-the-icons)
(use-package emojify
  :hook (after-init . global-emojify-mode))

;; Installing ivy
;; Ivy is an autocompletion engine for Emacs, ivy-rich allows suggestions to have descriptions
(use-package ivy
  :defer 0.1
  :bind (("C-c C-r" . ivy-resume)
		 ("C-x B" . ivy-switch-buffer-other-window))
  :custom
  (setq ivy-count-format "(%d/%d) "
		ivy-use-virtual-buffers t
		enable-recursive-minibuffers t)
  :config
  (ivy-mode))
(use-package ivy-rich
  :after ivy
  :custom
  (ivy-virutal-abbreviate 'full)
  (ivy-rich-switch-buffer-align-virtual-buffer t)
  (ivy-rich-path-style 'abbrev)
  :config
  (ivy-set-display-transformer 'ivy-switch-buffer
							   'ivy-rich-switch-buffer-transformer)
  (ivy-rich-mode 1))

;; Remove annoying initial inputs (e.g. ^) when starting an M-x request
(setq ivy-initial-inputs-alist nil)

;; Smex is a package remembers M-x history.
(use-package smex)
(smex-initialize) ; It must be initialized to work

;; Installing counsel and swiper, ivy extentions.
(use-package counsel
  :after ivy
  :config (counsel-mode))
(use-package swiper
  :after ivy
  :bind (("C-s" . swiper))) ; C-s to launch swiper

;; Using posframe to show ivy's candidate menu
(use-package ivy-posframe
  :init
  (setq ivy-posframe-dispplay-functions-alist
		'((swiper			. ivy-posframe-display-at-window-center) ; Center of a selected window
		  (complete-symbol	. ivy-posframe-display-at-point)
		  (counsel-M-x		. ivy-posframe-display-at-frame-center) ; Center of the frame (emacs instance)
		  (dmenu			. ivy-posframe-display-at-frame-center) ; %
		  (t				. ivy-posframe-display)) ; Everything else
		ivy-posframe-height-alist ; Setting different dimentions, it is useful to be able to see more options
		'((swiper . 20)
		  (dmenu . 20)
		  (t . 10)))
  :config
  (ivy-posframe-mode 1))

;; Using Winum to label open windows
(use-package winum
  :config (winum-mode))

;; Installing telephone-line, an implentation of powerline.
;; Configuration is basic, close to default.
(use-package telephone-line
  :config
  (setq telephone-line-lhs
		'((evil		. (telephone-line-evil-tag-segment))
		  (accent	. (telephone-line-vc-segment
					   telephone-line-erc-modified-channels-segment
					   telephone-line-process-segment))
		  (nil		. (telephone-line-buffer-segment))))
  (setq telephone-line-rhs
		'((nil		. (telephone-line-misc-info-segment))
		  (accent	. (telephone-line-major-mode-segment)) ; Minor mode segment is not here.
		  (evil		. (telephone-line-airline-position-segment))))

  (setq telephone-line-primary-right-seperator 'telephone-line-abs-left
		telephone-line-secondary-right-seperator 'telephone-line-abs-hollow-left)
  (setq telephone-line-evil-use-short-tag t
		telephone-line-height 20)) ; If height is not mentioned, many components will be of different heights

(setq display-time-day-and-date t)
(display-time-mode 1) ; Display time on n the modeline
(telephone-line-mode 1)

;; Use syntax highlighting to match pairs of delimiters ({} or [] or ()).
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; Electric Pair Mode
(electric-pair-mode 1)
(setq electric-pair-preserve-balance nil)

;; Better commenting of lines
;; M-; does comment by standard but the behaviour isn't exactly what you might expect
(use-package evil-nerd-commenter
  :bind ("M-/" . evilnc-comment-or-uncomment-lines))

;; Enabling which-key to help with long key strings.
(use-package which-key
  :init
  (setq which-key-sort-order #'which-key-key-order-alpha ; order alphabetically
		which-key-sort-uppercase-first nil
		which-key-add-column-adding 1
		which-key-min-display-lines 4
		which-key-idle-delay 0.3 ; wait 0.3 seconds before showing suggestions
		which-key-allow-imprecise-window-fit nil
		which-key-seperator " -> ")) ; Seperator selection
(which-key-mode)

;; Using general.el to bind keys. Keys are documented with which key argument to show there purpose
(use-package general
  :config
  (general-evil-setup t))

;; Buffer keybindings:
(nvmap :prefix "C-SPC"
	   "b b" '(ibuffer :which-key "Open ibuffer")
	   "b k" '(kill-current-buffer :which-key "Kill buffer")
	   "b c" '(hydra-cycle-buffers/body :which-key "Cycle Buffers"))

;; File keybindings:
(nvmap :states '(normal visual) :keymaps 'override :prefix "C-SPC"
	   "f f" '(find-file :which-key "Find file")
	   "f r" '(counsel-recentf :which-key "Recent files")
	   "f s" '(save-buffer :which-key "Save file")
	   "f u" '(sudo-edit :which-key "Sudo edit file")
	   "f R" '(rename-file :which-ke "Rename file")

	   ;; Elisp interpretation keybindings:
	   "e b" '(eval-buffer :which-key "Evaluate elisp in buffer")
	   "e d" '(eval-expression :which-key "Evaliate elisp expression")
	   "e r" '(eval-reigon :which-key "Evaluate highlighted reigon"))

; Dependencies for file keybindings:
(use-package recentf
  :config
  (recentf-mode))
(use-package sudo-edit)

; Standard keybindings:
(nvmap :keymaps 'override :prefix "C-SPC"
	   "C-SPC"	'(counsel-M-x :which-key "M-x")
	   "RET"	'(bookmark-jump :which-key "Bookmarks")
	   "c"	'(compile :which-key "Compile")
	   "C"	'(recompile :which-key "Recompile")
	   "l"	'((lambda () (interactive) (load-file "~/.emacs.d/init.el")) :which-key "Reload config")
	   "t"	'(toggle-truncate-lines :which-key "Toggle truncated lines")
	   "g"	'(counsel-projectile-rg :which-key "Ripgrep across project")
	   "s"	'(hydra-text-scale/body :which-key "Scale text")
	   ;"S"	'(swiper :which-key "Search using swiper") ; I don't find this binding worth using.
	   "r"	'(writeroom-mode :which-key "Writeroom mode")
	   "."	'(counsel-find-file :which-key "Find file"))

; Dependencies for standard keybindings:
(use-package writeroom-mode)

;; Window control keybindings:
(nvmap :prefix "C-SPC"
	   ;; Window Splits
	   "w c" '(evil-window-delete :which-key "Close window")
	   "w n" '(evil-window-new :which-key "New window")
	   "w s" '(evil-window-split :which-key "Split window")
	   "w v" '(evil-window-vsplit :which-key "Vsplit window")
	   ;; Window selection
	   "w h" '(evil-window-left :which-key "Window left")
	   "w j" '(evil-window-down :which-key "Window down")
	   "w k" '(evil-window-up :which-key "Window up")
	   "w l" '(evil-window-right :which-key "Window right")
	   ;; Window movement
	   "w H" '(evil-window-move-far-left :which-key "Window move left")
	   "w J" '(evil-window-move-very-bottom :which-key "Window move down")
	   "w K" '(evil-window-move-very-top :which-key "Window move up")
	   "w L" '(evil-window-move-far-right :which-key "Window move right"))

;; Setting up EVIL
;; Vim emulation within emacs. Limited functionality within EXWM.
(use-package evil
  :init
  (setq evil-want-keybinding nil)
  (setq evil-vsplit-window-right t ; when v-splitting a window select right window
		evil-split-window-below t) ; when h-splitting a window select bottom window
  :config
  (evil-mode))
(use-package evil-collection ; Evil collection adds support for non-text edditing applications of EVIL
  :after evil
  :config
  (setq evil-collection-mode-list '(dired ibuffer)) ;; e.g. ibuffer and dired
  (evil-collection-init))

;; Hydra allows for good keybindings for repetitive tasks
(use-package hydra)
(defhydra hydra-text-scale (:timeout 4) ; Change the size of text
  "scale text"
  ("j" text-scale-increase "inc")
  ("k" text-scale-decrease "dec")
  ("q" nil "finished" :exit t))

(defhydra hydra-cycle-buffers (:timeout 4) ; Cycle through buffers, killing uneccessary ones
  "cycle buffers"
  ("j" next-buffer "next")
  ("k" previous-buffer "prev")
  ("SPC" kill-current-buffer "kill")
  ("q" nil "quit" :exit t))

;; Setting up projectile, emacs project managment tool.
;; Mainly used to ripgrep through projects
(use-package projectile
  :config (projectile-mode)
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/Projects/Code")
	(setq projectile-project-search-path '("~/Projects/Code")))
  (setq projectile-switch-project-action #'projectile-dired))

;; Counsel intergration with projectile, for counsel-projectile-ripgrep
(use-package counsel-projectile
  :after projectile
  :config (counsel-projectile-mode))

(use-package magit
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;; Project sidebar tool for emacs
(use-package treemacs
  :defer t
  :init
  (with-eval-after-load 'winum ; Load after winum
	(define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
	(setq treemacs-collpase-dirs (if treemacs-python-executable 3 0)
		  treemacs-show-cursor nil
		  treemacs-show-hidden-files t
		  treemacs-width 35)
	(treemacs-follow-mode t)
	(treemacs-filewatch-mode t)
	(treemacs-fringe-indicator-mode 'always)
	(treemacs-git-mode 'simple))
  :bind
  (:map global-map
		("C-x t t" . treemacs) ;; Keybindings for treemacs
		("C-x t B" . treemacs-bookmark)))

;; Must be installed if evil is used otherwise treemacs will not work correctly
(use-package treemacs-evil
  :after (treemacs evil))

;; Treemacs theme for all-the-icons, nicer, github icons.
(use-package treemacs-all-the-icons
  :after (treemacs all-the-icons)
  :config
  (treemacs-load-theme "all-the-icons"))

;; File manager for emacs, incuded package within emacs 27
(use-package dired
  :ensure nil
  :commands (dired dired-jumo)
  :bind (("C-x C-j" . dired-jump))
  :custom
  ((dired-listing-switched "=-agho --group-directories-first"))
  :config
  (evil-collection-define-key 'normal 'dired-mode-map ; VIM keybindings for navigating directories
	"h" 'dired-up-directory
	"l" 'dired-find-file))

;; Dired Extentions: (dired plus is no longer maintained)
(use-package dired-single)
(use-package dired-open)
(use-package peep-dired)

;; Dired general.el keymaps, also opened through open keybindings
(nvmap :states '(normal visual) :keymaps 'override :prefix "C-SPC"
  "d d" '(dired :which-key "Open dired")
  "d j" '(dired-jump :which-key "Dired jump to current")
  "d p" '(peep-dired :which-key "Peep dired"))

;; Further vim keybindings
(with-eval-after-load 'dired
  (evil-define-key 'normal peep-dired-mode-map (kbd "j") 'peep-dired-next-file)
  (evil-define-key 'normal peep-dired-mode-map (kbd "k") 'peep-dired-prev-file))

(add-hook 'peep-dired-hook 'evil-normalize-keymaps) ; Evil normalize keymap
(setq dired-open-extentions '(("gif" . "sxiv") ;; When a gif is selected, it must be opened within sxiv.
							  ("jpg" . "sxiv")
							  ("png" . "sxiv")
							  ("mkv" . "vlc")
							  ("mp4" . "vlc")))

;; Dired will have all-the-icons, same as in treemacs
(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))

;; Term mode is less functional yet less resource intensive than vterm.
(use-package term
  :config
  (setq explicit-shell-file-name "bash")) ; "powershell.exe" for windows

(use-package eterm-256color
  :hook (term-mode . eterm-256color-mode))

(nvmap :prefix "C-SPC" ; Eshell general.el keybindings
  "E h" '(counsel-esh-history :which-key "Eshell history")
  "E s" '(eshell :which-key "Eshell"))

;; Function to configure eshell when an instance of it is brought into existance
(defun configure-eshell ()
  (add-hook 'eshell-pre-command-hook 'eshell-save-some-history) 
  (add-to-list 'eshell-output-filter-functions 'eshell-truncate-buffer)

  (evil-define-key '(normal insert visual) eshell-mode-map (kbd "C-r") 'counsel-esh-history)
  (evil-define-key '(normal insert visual) eshell-mode-map (kbd "<home>") 'eshell-bol)
  (evil-normalize-keymaps)

  (setq eshell-history-size 5000
		eshell-buffer-maxiumum-lines 5000
		eshell-scrollto-bottom-on-input t))

; Eshell has a git prompt, showing git infomation when in a git initialized directory
(use-package eshell-git-prompt)
(use-package eshell
  :hook (eshell-first-time-mode . configure-eshell)
  :config
  (eshell-git-prompt-use-theme 'powerline)) ; Powerline theme selected

(setq eshell-destroy-buffer-when-process-dies t
	  eshell-visual-commands '("bash" "htop" "pftech"))

;; Vterm provides the best terminal emulation within emacs
(use-package vterm
  :commands vterm
  :config
  (setq shell-file-name "/bin/bash" ; Bash by default
		vterm-max-scrollback 5000))

; Elfeed, RSS Newsreader for emacs
(use-package elfeed
  :config
  (setq elfeed-search-feed-face ":foreground #fff :weight bold"
		elfeed-feeds (quote
					  (("https://www.reddit.com/r/linux.rss" reddit linux)
					   ("https://www.reddit.com/r/emacs.rss" reddit emacs)
					   ("https://opensource.com/feed" opensource linux)
					   ("https://linux.softpedia.com/backend.xml" softpedia linux)
					   ("https://www.computerword.com/index.rss" computerworld linux)
					   ("https://www.networkworld.com/category/linux/index.rss" networkworld linux)
					   ("https://betanews.com/feed" betanews linux)
					   ("https://distrowatch.com/news/dwd.xml" distrowatch linux)))))

(use-package elfeed-goodies ; Additional features for elfeed
  :init
  (elfeed-goodies/setup)
  :config (setq elfeed-goodies/entry-pane-size 0.5))

(add-hook 'elfeed-search-mode-hook 'toggle-truncate-lines) ; Article names often reach past 1 length/

;; Vim keybindings for elfeed
(evil-define-key 'normal elfeed-show-mode-map
  (kbd "J") 'elfeed-goodies/split-show-next
  (kbd "K") 'elfeed-goodies/split-show-prev)
(evil-define-key 'normal elfeed-search-mode-map
  (kbd "J") 'elfeed-goodies/split-show-next
  (kbd "K") 'elfeed-goodies/split-show-prev)

;; Configuring EWW, emacs web wowser
(setq
 browser-url-browser-function 'eww-browser-url
 shr-use-fonts nil
 shr-use-colors nil
 shr-indentation 2
 shr-width 70
 eww-search-prefix "https://wiby.me/?q=") ; Wiby.me as the default search engine

;; General.el keybindings for opening applications
(nvmap :prefix "C-SPC"
  "o e" '(elfeed :which-key "Open elfeed")
  "o v" '(vterm :which-key "Open vterm")
  "o s" '(eshell :which-key "Open eshell")
  "o t" '(term :which-key "Open term")
  "o d" '(dired-jump :which-key "Open dired")
  "o a" '(org-agenda :which-key "Open org-agenda")
  "o w" '(eww :which-key "Open eww")
  "o p" '(treemacs :which-key "Open project sidebar"))

;;; LSP-Mode
;; Initial Configuration
(use-package lsp-mode
  :hook (lsp-mode . maxm/lsp-mode-setup)
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l"))

;; Breader Headcrumb
(defun maxm/lsp-mode-setup ()
  (setq lsp-headline-breadcrumb-segmments '(path-up-to-project file symbols))
  (lsp-headline-breadcrumb-mode))

;; Better completions with company-mode
(use-package company
  :after lsp-mode
  :hook (prog-mode . company-mode)
  :bind
  (:map company-active-map
		("<tab>" . company-complete-selection))
  (:map lsp-mode-map
		("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

;; Cleaner Aesthetic with Company-box
(use-package company-box
  :hook (company-mode . company-box-mode))

;; More UI Enhancements with lsp-ui-mode
(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode))
(setq lsp-ui-doc-position 'bottom)

;; Slideline
(setq lsp-ui-slideline-enable nil)
(setq lspui-sliddeline-show-hover nil)

;; LSP-mode intergration with treemacs
(use-package lsp-treemacs
  :after lsp)

;; Quicker symbol searching with lsp-ivy
(use-package lsp-ivy)

;; Debugging with Dap-Mode
(use-package dap-mode)

;;; Languages
;; Python
(use-package python-mode
  :ensure t
  :custom
  (python-shell-interpreter "python3")
  (dap-python-executable "python3")
  (dap-python-debugger 'debugpy)
  :config
  (require 'dap-python))

(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda ()
						 (require 'lsp-pyright)
						 (lsp-deferred))))

(use-package pyvenv
  :config
  (pyvenv-mode 1))

;; Python keybindings
(nvmap :prefix "C-SPC"
  "p p" '(run-python :which-key "Run python")
  "p r" '(python-shell-send-reigon :which-key "Interpret Reigon") ; Selected Reigon
  "p b" '(python-shell-send-buffer :which-key "Interpret Buffer"))

;; Rust
(use-package rust-mode
  :hook (rust-mode . lsp-deferred)
  :config
  (add-hook 'rust-mode-hook
			(lambda () (setq indent-tabs-mode nil)))
  (define-key rust-mode-map (kbd "C-c C-c" 'rust-run))
  (add-hook 'before-save-hook (lambda () (when (eq 'rust-mode major-mode)
										   (lsp-format-buffer)))))
;; C
(add-hook 'c-mode-hook 'lsp)
(add-hook 'c++-mode-hook 'lsp)

;; Go
(use-package go-mode
  :hook (go-mode . lsp-deferred))

;;; Org Mode
(defun org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (auto-fill-mode 0)
  (visual-line-mode 1)
  (setq evil-auto-indent nil))

(use-package org
  :hook (org-mode . org-mode-setup)
  :config
  (setq org-ellipsis " ▼ "
		org-hide-emphasis-markers t))

(setq org-directory "~/org/"
	  org-agenda-files '("~/org/agenda.org") ; NOTE: This is a list, more files can be added later
	  org-default-notes-file (expand-file-name "notes.org" org-directory))

;; This overides GNU default
(setq org-link-abbrev-alist
	  '(("google" . "https://www.google.com/search?q=")
		("arch-wiki" . "https://wiki.archlinux.org/index.php")
		("freebsd-forum" . "https://forums.freebsd.org") ; I don't know if this one works.
		("duckduckgo" . "https://duckduckgo.com/?q=")
		("wiby" . "https://wiby.me/?q=")
		("wikipedia" . "https://en.wikipedia.org/wiki")
		("reddit" . "https://old.reddit.com/r/")))

(setq org-todo-keywords
	  '((sequence
		 "TODO(t)"
		 "BOOK(b)"
		 "SESSION(s)"
		 "PROJ(p)"
		 "HOWEWORK(h)"
		 "WAIT(w)"
		 "|"
		 "DONE(d)"
		 "CANCELLED(c)" )))

(use-package org-tempo
  :ensure nil)

;; Make sure that babel code blocks evaluate code correctly
(setq org-src-fontify-natively t
	  org-src-tab-acts-natively t
	  org-confirm-babel-evaluate nil
	  org-edit-src-content-indentation 0)

(setq org-blank-before-new-entry (quote ((heading . nil)
										 (plain-list-item . nil))))

;; Make sure that python code can be executed inside a babel code block
(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)))

;; Use cooler and more diffrenciated bullets
(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode))

;; Configuration of Font faces and sizes within org documents
(with-eval-after-load 'org-faces ; Must be wrapped in =with-eval-after-load=
  ;; Diffrenciate headers based on size
  (dolist (face '((org-level-1 . 1.2)
				  (org-level-2 . 1.1)
				  (org-level-3 . 1.05)
				  (org-level-4 . 1.0)
				  (org-level-5 . 1.1) ; Back to normal
				  (org-level-6 . 1.1)
				  (org-level-7 . 1.1)
				  (org-level-8 . 1.1)))
	(set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))

  ;; Choosing what elements of an org-document should be represented in what font face.
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil :inherit '(shadow fixed-pitch))
  ;(set-face-attribute 'org-indent nil :inherit '(org-hide fixed-pitched-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch))

;; Center org-mode documents in the center of the screen
(defun org-mode-visual-fill ()
  ; Proportions:
  (setq visual-fill-column-width 75
		visual-fill-column-center-text t)
  (visual-fill-column-mode 1)) ; Activate

;; The centering of documents depends on the following package:
(use-package visual-fill-column
  :hook (org-mode . org-mode-visual-fill))

;; Org keybindings
(nvmap :keymaps 'override :prefix "C-SPC"
  "m m" '(org-mode :which-key "Restart org mode")
  "m h" '(org-toggle-heading :which-key "Toggle heading")
  "m i" '(org-toggle-item :which-key "Toggle item")
  "m ." '(counsel-org-goto :which-key "Counsel-org goto")
  "m b" '(org-babel-tangle :which-key "Org babel tangle")
  "m t" '(counsel-org-tag :which-key "Counsel org-tag")
  "m T" '(org-tags-view :which-key "Org tags view")
  "m w" '(org-todo-list :which-key "Org todo list"))

;; EXWM Functions:
(defun max/exwm-update-class ()
  (exwm-workspace-rename-buffer exwm-class-name))

(defun max/exwm-init-hook ()
  (exwm-workspace-switch-create 1)) ; Start on workspace 1, not 0

(defhydra exwm-window-resize (:timeout 4)
  ("h" (exwm-layout-shrink-window-horizontally 10) "shrink h")
  ("l" (exwm-layout-enlarge-window-horizontally 10) "enlarge h")
  ("k" (exwm-layout-shrink-window 10) "shrink v")
  ("j" (exwm-layout-enlarge-window 10) "enlarge v")
  ("q" nil "quit" :exit t))

;; EXWM: Emacs Xorg Window Manager
(use-package dmenu)
(use-package exwm
  :config
  ;; Set the default number of workspaces
  (setq exwm-workspace-number 10)

  ;; When window "class" updates, use it to set the buffer name
  (add-hook 'exwm-update-class-hook #'max/exwm-update-class)

  ;; When EXWM finishes initialization, do some extra setup:
  (add-hook 'exwm-init-hook #'max/exwm-init-hook)

  ;; These keys should always pass through to Emacs
  (setq exwm-input-prefix-keys
    '(?\C-x
      ?\C-u
      ?\C-h
      ?\M-x
      ?\M-`
      ?\M-&
      ?\M-:
      ?\C-\ ))  ;; Ctrl+Space

  ;; Ctrl+Q will enable the next key to be sent directly
  (define-key exwm-mode-map [?\C-q] 'exwm-input-send-next-key)

  ;; Set up global key bindings.  These always work, no matter the input state!
  ;; Keep in mind that changing this list after EXWM initializes has no effect.
  (setq exwm-input-global-keys
        `(
          ;; Reset to line-mode (C-c C-k switches to char-mode via exwm-input-release-keyboard)
          ([?\s-r] . exwm-window-resize/body)

		  ;; Toggle floating windows
		  ([?\s-t] . exwm-floating-toggle-floating)

		  ;; Toggle fullscreen
		  ([?\s-f] . exwm-layout-toggle-fullscreen)

		  ;; Toggle modeline
		  ([?\s-m] . exwm-layout-toggle-mode-line)
		  
          ;; Move between windows
          ([?\s-h] . windmove-left)
          ([?\s-l] . windmove-right)
          ([?\s-k] . windmove-up)
          ([?\s-j] . windmove-down)

          ;; Launch applications via shell command
		  ([?\s-d] . dmenu)
		  
          ;; Switch workspace
          ([?\s-w] . exwm-workspace-switch)
          ([?\s-`] . (lambda () (interactive) (exwm-workspace-switch-create 0)))
		  
          ;; 's-N': Switch to certain workspace with Super (Win) plus a number key (0 - 9)
          ,@(mapcar (lambda (i)
                      `(,(kbd (format "s-%d" i)) .
                        (lambda ()
                          (interactive)
                          (exwm-workspace-switch-create ,i))))
                    (number-sequence 0 9))))

  (exwm-enable))

;; The desktop environment package allows for control of brightness and volume
(use-package desktop-environment
  :after exwm
  :config (desktop-environment-mode)
  :custom
  (desktop-environment-brightness-small-increment "2%+")
  (desktop-environment-brightness-small-decrement "2%-")

  (desktop-environment-brightness-normal-increment "5%+")
  (desktop-environment-brightness-normal-decrement "5%-"))

;; This hydra function allows for control of volume
(defhydra hydra-volume-up (:timeout 4)
  "Configure Volume"
  ("j" desktop-environment-volume-normal-increment "up")
  ("k" desktop-environment-volume-normal-decrement "down")
  ("q" nil "quit" :exit t))

;; This hydra function allows for control of brightness
(defhydra hydra-brightness-up (:timeout 4)
  "Configure Brightness"
  ("j" desktop-environment-brightness-increment "up")
  ("k" desktop-environment-brightness-decrement "down")
  ("q" nil "quit" :exit t))

;; Keybindings for deskop-environment.el
(nvmap :prefix "C-SPC"
  "SPC v" '(hydra-volume-up/body :which-key "Change volume")
  "SPC b" '(hydra-brightness-up/body :which-key "Change brightness")
  "SPC m" '(desktop-environment-toggle-mute :which-key "Toggle mute")
  "SPC M" '(desktop-environment-toggle-microphone-mute :which-key "Toggle microphone")
  "SPC s" '(desktop-environment-screenshot :which-key "Take screenshot"))

;; Emacs Mail
;(use-package mu4e
;  :ensure nil
;  :load-path /usr/share/emacs/site-lisp/mu4e/
;  :defer 20
;  :config
;  (setq mu4e-change-filenames-when-moving t) ; Refresh mail using isync every 10 minutes
;
;  ;; Refresh mail using isync every 10 mins
;  (setq mu4e-update-interval (* 10 60)
;		mu4e-get-mail-command "mbsync 0a"
;		mu4e-maildir "~/Mail")
;  
;  (setq mu4e-drafts-folder "/[Gmail]/Drafts"
;		mu4e-sent-folder "/[Gmail]/Sent Mail"
;		mu4e-refile-folder "/[Gmail]/All Mail"
;		mu4e-trash-folder "/[Gmail]/Trash")
;
;  ;; Quick Access to the following folders:
;  (setq mu4e-maildir-shortcuts
;		'((:maildir "/Inbox"				:key ?i)
;		  (:maildir "/[Gmail]/Sent Mail"	:key ?s)
;		  (:maildir "/[Gmail]/Trash"		:key ?t)
;		  (:maildir "/[Gmail]/Drafts"		:key ?d)
;		  (:maildir "/[Gmail]/All Mail"		:key ?a)))
;
;  ;; You can create bookmarked queries:
;  (setq mu4e-bookmarks
;		'((:name "Unread messages" :query "flag:unread AND NOT flag:trashed" :key ?i)
;		  (:name "Today's messages" :query "date:today..now" :key ?t)
;		  (:name "Last 7 days" :query "date:6d..now" :hide-unread t :key ?w)
;		  (:name "Messages with images" :query "mime:image/*" :key ?p)))
;
;  (mu4e t))
