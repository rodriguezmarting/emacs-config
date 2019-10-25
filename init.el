;;;;
;; Packages
;;;;

(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl
    (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))))
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
   '(ag
     auto-complete
    ;; integration with a Clojure REPL
    ;; https://github.com/clojure-emacs/cider
    cider
    ;; key bindings and code colorization for Clojure
    ;; https://github.com/clojure-emacs/clojure-mode
    clojure-mode
    ;; extra syntax highlighting for clojure
    clojure-mode-extra-font-locking
    ;; remove whitespaces automatically
    ethan-wspace
    exec-path-from-shell
    ;; sintax linting
    flycheck
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
    ;solarized theme
    solarized-theme
    ;; edit html tags like sexps
    tagedit
    use-package
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
(global-ethan-wspace-mode 1)
;(load-theme 'monokai)
;(load-theme 'solarized-dark t)
(load-theme 'doom-spacegrey)
(setq clojure-align-forms-automatically t)

(require 'use-package)

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

(global-hl-line-mode 0)
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

(global-set-key (kbd "C-c c") #'cider-repl-clear-buffer)
(global-set-key (kbd "C-c f") #'projectile-find-file)
(global-set-key (kbd "C-c p") #'projectile-switch-project)
(global-set-key (quote [f5]) #'helm-imenu-in-all-buffers)

(setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))

(ac-config-default)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(coffee-tab-width 2)
 '(custom-safe-themes
   (quote
    ("d6f04b6c269500d8a38f3fabadc1caa3c8fdf46e7e63ee15605af75a09d5441e" default)))
 '(package-selected-packages
   (quote
    (doom-themes clj-refactor feature-mode ethan-wspace flycheck ag ztree yasnippet-snippets which-key use-package tagedit status smex sass-mode rainbow-mode rainbow-delimiters projectile paredit magit kurecolor javap-mode ido-completing-read+ highlight-parentheses helm-grepint exec-path-from-shell company clojure-mode-extra-font-locking cider auto-complete)))
 '(safe-local-variable-values
   (quote
    ((css-indent-offset . 2)
     (scss-mode
      (css-indent-offset . 2))
     (cider-figwheel-main-default-options . ":dev")
     (cider-default-cljs-repl . figwheel-main)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
