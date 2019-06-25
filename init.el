;;;;
;; Packages
;;;;


;; Load and activate emacs packages. Do this first so that the
;; packages are loaded before you start trying to modify them.
;; This also sets the load path.
(package-initialize)


;; Define package repositories
(require 'package)
(add-to-list 'package-archives
             '("tromey" . "http://tromey.com/elpa/") t)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/") t)

(add-to-list 'package-pinned-packages '(cider . "melpa-stable") t)
(add-to-list 'package-pinned-packages '(magit . "melpa-stable") t)

(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/") t)

(add-to-list 'package-pinned-packages '(cider . "melpa-stable") t)


;; Download the ELPA archive description if needed.
;; This informs Emacs about the latest versions of all packages, and
;; makes them available for download.
(when (not package-archive-contents)
  (package-refresh-contents))

;; Define he following variables to remove the compile-log warnings
;; when defining ido-ubiquitous
;; (defvar ido-cur-item nil)
;; (defvar ido-default-item nil)
;; (defvar ido-cur-list nil)
;; (defvar predicate nil)
;; (defvar inherit-input-method nil)

;; The packages you want installed. You can also install these
;; manually with M-x package-install
;; Add in your own as you wish:
(setq my-packages
   '(auto-complete
    ;; integration with a Clojure REPL
    ;; https://github.com/clojure-emacs/cider
    cider
    ;; key bindings and code colorization for Clojure
    ;; https://github.com/clojure-emacs/clojure-mode
    clojure-mode
    ;; extra syntax highlighting for clojure
    clojure-mode-extra-font-locking
    helm
    helm-grepint
    ;; allow ido usage in as many contexts as possible. see
    ;; customizations/navigation.el line 23 for a description
    ;; of ido
    ido-completing-read+
    ;manipulate color hue saturation and brighness (use with rainbow-mode
    kurecolor
    ;; git integration
    magit
    ;monokai theme
    monokai-theme
    ;; makes handling lisp expressions much, much easier
    ; Cheatsheet: http://www.emacswiki.org/emacs/PareditCheatsheet
    paredit
    ;; project navigation
    projectile
    ;; colorful parenthesis matching
    rainbow-delimiters
    ;show visual representation of hex colors
    rainbow-mode
    sass-mode
    sesman
    ;; Enhances M-x to allow easier execution of commands. Provides
    ;; a filterable list of possible commands in the minibuffer
    ;; http://www.emacswiki.org/emacs/Smex
    smex
    ;; edit html tags like sexps
    tagedit
    ;tree view for files
    ztree))

;; On OS X, an Emacs instance started from the graphical user
;; interface will have a different environment than a shell in a
;; terminal window, because OS X does not run a shell during the
;; login. Obviously this will lead to unexpected results when
;; calling external utilities like make from Emacs.
;; This library works around this problem by copying important
;; environment variables from the user's shell.
;; https://github.com/purcell/exec-path-from-shell
(if (eq system-type 'darwin)
    (add-to-list 'my-packages 'exec-path-from-shell))

(dolist (p my-packages)
  (unless (package-installed-p p)
    (package-install p)))


;; Place downloaded elisp files in ~/.emacs.d/vendor. You'll then be able
;; to load them.
;;
;; For example, if you download yaml-mode.el to ~/.emacs.d/vendor,
;; then you can add the following code to this file:
;;
;; (require 'yaml-mode)
;; (add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
;; 
;; Adding this code will make Emacs enter yaml mode whenever you open
;; a .yml file
(add-to-list 'load-path "~/.emacs.d/vendor")



;; Add a directory to our load path so that when you `load` things
;; below, Emacs knows where to look for the corresponding file.
(add-to-list 'load-path "~/.emacs.d/customizations")

;; Sets up exec-path-from-shell so that Emacs will use the correct
;; environment variables
(load "shell-integration.el")

;; These customizations make it easier for you to navigate files,
;; switch buffers, and choose options from the minibuffer.
(load "navigation.el")

;; These customizations change the way emacs looks and disable/enable
;; some user interface elements
(load "ui.el")

;; These customizations make editing a bit nicer.
(load "editing.el")

;; Hard-to-categorize customizations
(load "misc.el")

;; For editing lisps
(load "elisp-editing.el")

;; Langauage-specific
(load "setup-clojure.el")
(load "setup-js.el")

;;;;
;; Customization
;;;;
(global-visual-line-mode 1)
(load-theme 'monokai)

(global-hl-line-mode 0)
(require 'use-package)
(use-package rainbow-mode
  :hook (prog-mode . rainbow-mode))

(require 'helm-config)

(global-set-key (kbd "C-x b") 'helm-buffers-list)
(global-set-key (kbd "C-x r b") 'helm-bookmars)
(global-set-key (kbd "C-x m") 'helm-M-x)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)

(global-set-key (kbd "C-c C-r") 'cider-eval-region)


(define-key projectile-mode-map (kbd "M-p") 'projectile-command-map)

(require 'helm-grepint)
(helm-grepint-set-default-config-latest)
(global-set-key (kbd "C-c g") #'helm-grepint-grep)
(global-set-key (kbd "C-c G") #'helm-grepint-grep-root)

(global-set-key (kbd "C-c j") #'cider-repl-clear-buffer)
(global-set-key (kbd "C-c f") #'projectile-find-file)
(global-set-key (kbd "C-c c") #'projectile-switch-project)

(ac-config-default)
