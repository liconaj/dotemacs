;(server-start)
;(desktop-save-mode t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(vertico marginalia consult ido-vertical-mode counsel ivy orderless all-the-icons-dired treemacs-all-the-icons treemacs maxima pdf-tools multi-compile crux all-the-icons dashboard highlight-indent-guides use-package undo-tree doom-themes company)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;;;; Packages ;;;;

(add-to-list 'load-path "~/.emacs.d/lisp/")

;; Melpa
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(unless package-archive-contents (package-refresh-contents))

;; use-package
(dolist (package '(use-package))
  (unless (package-installed-p package)
    (package-install package)))

(use-package company
  :ensure t
  :hook (after-init . global-company-mode))

(use-package undo-tree
  :ensure t)

(use-package multi-compile
  :ensure t)

(use-package highlight-indent-guides
  :ensure t)

(use-package pdf-tools
  :ensure t
  :pin manual
  :config
  (pdf-tools-install)
  (setq-default pdf-view-display-size 'fit-width)
  (define-key pdf-view-mode-map (kbd "C-s") 'isearch-forward)
  :custom
  (pdf-annot-activate-created-annotations t "automatically annotate highlights"))

(setq TeX-view-program-selection '((output-pdf "PDF Tools"))
      TeX-view-program-list '(("PDF Tools" TeX-pdf-tools-sync-view))
      TeX-source-correlate-start-server t)

(add-hook 'TeX-after-compilation-finished-functions
          #'TeX-revert-document-buffer)


;;;; APARIENCIA ;;;;

;;(load-theme 'doom-plain)

;; Separador de ventanas
(set-face-foreground 'vertical-border "gray75")

;; Fringes
(setq left-fringe-width 20)
(setq right-fringe-width 20)

;; Tipografías
(defvar my-font)
(setq my-font "Victor Mono SemiBold 11")
(set-frame-font my-font nil t)
(add-to-list 'default-frame-alist `(font . ,my-font))

;; (setq font-use-system-font t)
;; (set-face-attribute 'default nil :font "Victor Mono SemiBold"
;; 		    :height 110)
;; (set-face-attribute 'variable-pitch
;; 		    nil
;; 		    :family "Victor Mono")

(set-face-attribute 'font-lock-comment-face nil :slant 'italic)
(set-face-attribute 'font-lock-variable-name-face nil  :slant 'italic)

;; Bordes
(set-face-attribute 'fringe nil
                    :foreground (face-foreground 'default)
                    :background (face-background 'default))

(defun setup-appearance (frame)
  (with-selected-frame frame
    (remove-hook 'after-make-frame-functions 'setup-appearance)

	(when (functionp 'menu-bar-mode) (menu-bar-mode -1))
    (when (functionp 'scroll-bar-mode) (scroll-bar-mode -1))
    (when (functionp 'tool-bar-mode) (tool-bar-mode -1))

	(when (> (window-width) 100)
	  (split-window-right))

    ;; NOTE: This needs to be here, else it doesn't work
    (setq-default system-time-locale "C")))

(if (daemonp)
    (add-hook 'after-make-frame-functions 'setup-appearance)
  (setup-appearance (car (frame-list))))

;; (if (display-graphic-p)
;;     (progn
;;       (setq-default initial-frame-alist
;;                     '((internal-border-width . 15)))
;;       (setq-default default-frame-alist
;;                     '((internal-border-width . 15)))))

;; Herramientas
(menu-bar-mode -1)
(tool-bar-mode -1)
(toggle-scroll-bar -1)

;; Wrapping
(global-visual-line-mode)

;; Guias de indentación
(setq highlight-indent-guides-method 'bitmap)
(defun my-highlighter (level responsive display)
  (if (> 1 level)
      nil
    (highlight-indent-guides--highlighter-default level responsive display)))
(setq highlight-indent-guides-highlighter-function 'my-highlighter)
(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)

;; Pantalla de inicio
(setq inhibit-startup-screen t)
(setq inhibit-startup-message t)
(setq inhibit-startup-echo-area-message t)
(setq initial-scratch-message "")


;;;; PREFERENCIAS ;;;;

;; Autopair
(add-hook 'after-init-hook 'electric-pair-mode 1)

;; Deshacer (C-_) y rehacer (M-_)
(global-undo-tree-mode)

;; Historial
(savehist-mode 1)
(setq history-length 1000)

;; Respaldos
(setq backup-directory-alist `(("." . "~/.emacs.d/saves")))

;; Indentación
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)

(electric-indent-mode 1)
(dolist (command '(yank yank-pop))
  (eval `(defadvice ,command (after indent-region activate)
           (and (not current-prefix-arg)
                (member major-mode '(emacs-lisp-mode
                                     lisp-mode
                                     c-mode
                                     plain-tex-mode
                                     ruby-mode
                                     python-mode
                                     c++-mode
                                     latex-mode))
                (let ((mark-even-if-inactive transient-mark-mode))
                  (indent-region (region-beginning) (region-end) nil))))))


;; Números de línea
;(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; Quitar alarmas
(setq ring-bell-function 'ignore)

;; Resaltar paréntesis
(show-paren-mode t)

;; Habilitar formato de mayúsculas y minúsculas
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

;; Desplazamiento
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
(setq mouse-wheel-progressive-speed nil)
(setq mouse-wheel-follow-mouse 't)
(setq scroll-step 1)
(setq scroll-preserve-screen-position 1)

;; Respuestas
(fset 'yes-or-no-p 'y-or-n-p)

;; Espacios de fin de linea
(add-hook 'before-save-hook 'my-prog-nuke-trailing-whitespace)
;(add-hook 'before-save-hook 'delete-trailing-whitespace)
(defun my-prog-nuke-trailing-whitespace ()
  (when (derived-mode-p 'prog-mode)
    (delete-trailing-whitespace)))

;; Borrado seguro
(setq-default delete-by-moving-to-trash t)

;; Autorefrescar cuando el archivo se ha cambiado
(global-auto-revert-mode t)


;;;; IDO ;;;;
(ido-mode -1)

(setq ido-enable-flex-matching t)
(setq ido-ignore-buffers '("^ " "*Completions*" "*Shell Command Output*" "*Messages*" "Async Shell Command" "KILL"))
(setq ido-file-extensions-order '(".org" ".tex" ".emacs" ".pdf" ".txt"))


;;;; ARCHIVOS RECIENTES ;;;;

(require 'recentf)
(recentf-mode t)

;; enable recent files mode.
(setq recentf-max-saved-items 20)
(setq recentf-max-menu-items 20)

(run-at-time nil (* 2 60) 'recentf-save-list)


(add-to-list 'recentf-exclude (format "%s/\\.emacs\\.d/elpa/.*" (getenv "HOME")))
(add-to-list 'recentf-exclude
             (expand-file-name "~/.emacs.d/recentf"))


;;;; SERVER ;;;;
(defun server-shutdown ()
  "Save buffers, Quit, and Shutdown (kill) server"
  (interactive)
  (save-some-buffers)
  (kill-emacs))

(defun signal-restart-server ()
  "Handler for SIGUSR1 signal, to (re)start an emacs server.

Can be tested from within emacs with:
  (signal-process (emacs-pid) 'sigusr1)

or from the command line with:
$ kill -USR1 <emacs-pid>
$ emacsclient -c
"
  (interactive)
  (server-force-delete)
  (server-start))
(define-key special-event-map [sigusr1] 'signal-restart-server)


;;;; TREEMACS ;;;;
(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))

  :config
  (progn
    (setq treemacs-collapse-dirs                 (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay      0.5
          treemacs-directory-name-transformer    #'identity
          treemacs-display-in-side-window        t
          treemacs-eldoc-display                 t
          treemacs-file-event-delay              5000
          treemacs-file-extension-regex          treemacs-last-period-regex-value
          treemacs-file-follow-delay             0.2
          treemacs-file-name-transformer         #'identity
          treemacs-follow-after-init             t
          treemacs-git-command-pipe              ""
          treemacs-goto-tag-strategy             'refetch-index
          treemacs-indentation                   2
          treemacs-indentation-string            " "
          treemacs-is-never-other-window         nil
          treemacs-max-git-entries               5000
          treemacs-missing-project-action        'ask
          treemacs-move-forward-on-expand        nil
          treemacs-no-png-images                 nil
          treemacs-no-delete-other-windows       t
          treemacs-project-follow-cleanup        nil
          treemacs-persist-file                  (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                      'left
          treemacs-read-string-input             'from-child-frame
          treemacs-recenter-distance             0.1
          treemacs-recenter-after-file-follow    nil
          treemacs-recenter-after-tag-follow     nil
          treemacs-recenter-after-project-jump   'always
          treemacs-recenter-after-project-expand 'on-distance
          treemacs-show-cursor                   nil
          treemacs-show-hidden-files             nil
          treemacs-silent-filewatch              nil
          treemacs-silent-refresh                nil
          treemacs-sorting                       'alphabetic-asc
          treemacs-space-between-root-nodes      nil
          treemacs-tag-follow-cleanup            t
          treemacs-tag-follow-delay              1.5
          treemacs-user-mode-line-format         nil
          treemacs-user-header-line-format       nil
          treemacs-width                         40
          treemacs-workspace-switch-cleanup      nil)

    ;; The default width and height of the icons is 22 pixels. If you are
    (treemacs-resize-icons 16)
    (define-key treemacs-mode-map [mouse-1] #'treemacs-single-click-expand-action)
    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode -1)
    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple))))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))

;;(all-the-icons-install-fonts)
(use-package treemacs-all-the-icons
  :config (treemacs-load-theme "all-the-icons")
  :ensure t)
(use-package all-the-icons-dired
  :init (add-hook 'dired-mode-hook 'all-the-icons-dired-mode)
  :ensure t)
(setq inhibit-compacting-font-caches t)

;;;; BUFFERS ;;;;

(defun only-current-buffer ()
  "Kill other buffers."
  (interactive)
  (mapc 'kill-buffer (cdr (buffer-list (current-buffer)))))

(require 'ibuf-ext)
(add-to-list 'ibuffer-never-show-predicates "^\\*")

(setq ido-ignore-buffers '("\\` " "^\*"))

(defun next-code-buffer ()
  (interactive)
  (let (( bread-crumb (buffer-name) ))
    (next-buffer)
    (while
        (and
         (string-match-p "^\*" (buffer-name))
         (not ( equal bread-crumb (buffer-name) )) )
      (next-buffer))))

(setq ibuffer-formats
      '((mark modified read-only " " filename-and-process)))

(setq ibuffer-display-summary nil)
(defadvice ibuffer-update-title-and-summary (after remove-column-titles)
  (with-current-buffer
      (read-only-mode 0)
    (goto-char 1)
    (search-forward "-\n" nil t)
    (delete-region 1 (point))
    (let ((window-min-height 1))
      ;; save a little screen estate
      (shrink-window-if-larger-than-buffer))
    (read-only-mode)))

(ad-activate 'ibuffer-update-title-and-summary)

(add-hook 'ibuffer-mode-hook
          (lambda ()
            (ibuffer-switch-to-saved-filter-groups "default")))

;; Delete *Completions*
(add-hook 'minibuffer-exit-hook
          '(lambda ()
             (let ((buffer "*Completions*"))
               (and (get-buffer buffer)
                    (kill-buffer buffer)))))

;;;; LENGUAJES ;;;;

;; Chordpro
(setq auto-mode-alist (cons '("\\.pro$" . chordpro-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.cho$" . chordpro-mode) auto-mode-alist))
(autoload 'chordpro-mode "chordpro-mode")


;;;; COMPILE ;;;;

(setq multi-compile-alist '(
                            (chordpro-mode . (("Chordpro compile songbook" .
                                               "chordpro *.cho -o songbook.pdf")
                                              ("Chordpro compile file" .
                                               "chordpro %file-name")))
                            ))

(defun cyco:compile-autoclose (buffer string)
  (cond ((string-match "finished" string)
         (message "Build maybe succesful: clossing window.")
         (run-with-timer 1 nil
                         'delete-window
                         (get-buffer-window buffer t)))
        (
         (message "Compilation exited abnormally: %s" string))))

(setq compilation-finish-functions 'cyco:compile-autoclose)
(global-set-key [f5] 'multi-compile-run)


;;;; TERMINAL ;;;;

(require 'term)

(defun open-external-terminal ()
  (interactive)
  (let ((proc (start-process "bash" nil "gnome-terminal")))
    (set-process-query-on-exit-flag proc nil)))

(defun open-ansi-terminal ()
  (interactive)
  (let ((w (split-window-below 2)))
    (select-window w)
    (if (eq (get-buffer "*ansi-term*") nil)
        (ansi-term "/bin/bash")
      (switch-to-buffer "*ansi-term*"))))

(defun set-no-process-query-on-exit ()

  (let ((proc (get-buffer-process (current-buffer))))
    (when (processp proc)
      (set-process-query-on-exit-flag proc nil))))

(global-set-key (kbd "C-c t") 'open-external-terminal)
(global-set-key (kbd "C-c C-t") 'open-ansi-terminal)

(add-hook 'term-exec-hook 'set-no-process-query-on-exit)
(add-hook 'shell-mode-hook 'set-no-process-query-on-exit)

(define-key term-raw-map (kbd "C-c C-t") 'delete-window)
(define-key term-raw-map (kbd "C-c t") 'kill-buffer-and-window)


;;;; KEYBINDINGS ;;;;

;; Indentar
(global-set-key (kbd "C->") 'indent-rigidly-right-to-tab-stop)
(global-set-key (kbd "C-<") 'indent-rigidly-left-to-tab-stop)

;; Scroll
(global-set-key (kbd "M-n") (kbd "C-u 1 C-v"))
(global-set-key (kbd "M-p ") (kbd "C-u 1 M-v"))

;; Cambiar de buffer
(global-set-key [remap next-buffer] 'next-code-buffer)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "<C-tab>") 'next-code-buffer)

;; Modeline

(define-minor-mode minor-mode-blackout-mode
  "Hides minor modes from the modeline"
  t)
(catch 'done
  (mapc (lambda (x)
          (when (and (consp x)
                     (equal (cadr x) '("" minor-mode-alist)))
            (let ((original (copy-sequence x)))
              (setcar x 'minor-mode-blackout-mode)
              (setcdr x (list "" original)))
            (throw 'done t)))
        mode-line-modes))

(defun my-modeline-padding (right-segments)
  (propertize
   " " 'display
   `((space :align-to (- (+ right right-fringe right-margin)
                         ,(+ 1 (string-width right-segments)))))))

(setq-default mode-line-format
              (list
               "  "
               mode-line-mule-info
               mode-line-modified
               mode-line-frame-identification
               mode-line-buffer-identification
               "  "
               mode-line-position
               '(:eval (my-modeline-padding (format-mode-line
                                             mode-line-modes)))
               mode-line-modes
               ))

(set-face-attribute 'mode-line nil
                    :background "gray85"
                    :foreground "black"
                    :box '(:line-width 2 :color "gray85")
                    :overline nil
                    :underline nil)

(set-face-attribute 'mode-line-inactive nil
                    :background "gray90"
                    :foreground "gray20"
                    :box '(:line-width 2 :color "gray90")
                    :overline nil
                    :underline nil)

(set-face-attribute 'mode-line-highlight nil
                    :box nil
                    :background nil
                    :foreground "gray45")
(setq column-number-mode nil)
(force-mode-line-update t)

;; VERTICO

;; Enable richer annotations using the Marginalia package
(use-package marginalia
  :ensure t
  ;; Either bind `marginalia-cycle` globally or only in the minibuffer
  :bind (("M-A" . marginalia-cycle)
         :map minibuffer-local-map
         ("M-A" . marginalia-cycle))

  ;; The :init configuration is always executed (Not lazy!)
  :init

  ;; Must be in the :init section of use-package such that the mode gets
  ;; enabled right away. Note that this forces loading the package.
  (marginalia-mode))

(use-package vertico
  :ensure t
  :init
  (vertico-mode))

;; A few more useful configurations...
(use-package emacs
  :init
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; Alternatively try `consult-completing-read-multiple'.
  (defun crm-indicator (args)
    (cons (concat "[CRM] " (car args)) (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; Emacs 28: Hide commands in M-x which do not work in the current mode.
  ;; Vertico commands are hidden in normal buffers.
  ;; (setq read-extended-command-predicate
  ;;       #'command-completion-default-include-p)

  ;; Enable recursive minibuffers
  (setq enable-recursive-minibuffers t))

(setq read-file-name-completion-ignore-case t
      read-buffer-completion-ignore-case t
      completion-ignore-case t)

;; Use `consult-completion-in-region' if Vertico is enabled.
;; Otherwise use the default `completion--in-region' function.
(setq completion-in-region-function
      (lambda (&rest args)
        (apply (if vertico-mode
                   #'consult-completion-in-region
                 #'completion--in-region)
               args)))

(use-package consult
  :ensure t
  ;; Replace bindings. Lazily loaded due by `use-package'.
  :bind (;; C-c bindings (mode-specific-map)
         ("C-c C-x h" . consult-history)
         ("C-c C-x m" . consult-mode-command)
         ("C-c C-x b" . consult-bookmark)
         ("C-c C-x k" . consult-kmacro)
         ("C-c C-x r" . consult-recent-file)
         ;; C-x bindings (ctl-x-map)
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ("<help> a" . consult-apropos)            ;; orig. apropos-command
         ;; M-g bindings (goto-map)
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings (search-map)
         ("M-s f" . consult-find)
         ("M-s F" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s m" . consult-multi-occur)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi))           ;; needed by consult-line to detect isearch

  ;; The :init configuration is always executed (Not lazy)
  :init

  ;; Optionally configure the register formatting. This improves the register
  ;; preview for `consult-register', `consult-register-load',
  ;; `consult-register-store' and the Emacs built-ins.
  (setq register-preview-delay 0
        register-preview-function #'consult-register-format)

  ;; Optionally tweak the register preview window.
  ;; This adds thin lines, sorting and hides the mode line of the window.
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Optionally replace `completing-read-multiple' with an enhanced version.
  (advice-add #'completing-read-multiple :override #'consult-completing-read-multiple)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; (kbd "C-+")

  (setq completion-styles '(substring))

  (setq consult-project-root-function
        (lambda ()
          (when-let (project (project-current))
            (car (project-roots project))))))
