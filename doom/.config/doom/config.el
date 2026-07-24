;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;;; Identity

;; Used by GPG, email clients, templates, and snippets when configured.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")


;;; Paths and environment

;; Set before Org loads.
(setq org-directory "~/org/")


;;; Appearance

(setq doom-theme 'doom-tokyo-night
      doom-font (font-spec :family "JetBrainsMono Nerd Font Mono"
                           :size 17
                           :weight 'normal)
      display-line-numbers-type 'relative
      frame-resize-pixelwise t)

(defun my/set-frame-full-workarea (frame)
  "Resize FRAME to its monitor's available work area."
  (with-selected-frame frame
    (pcase-let ((`(,left ,top ,width ,height)
                 (frame-monitor-workarea frame)))
      (set-frame-size frame width height t)
      (set-frame-position frame left top))))

(defun my/set-initial-frame-full-workarea ()
  "Resize the initial frame to its monitor's available work area."
  (my/set-frame-full-workarea (selected-frame)))

(add-hook 'window-setup-hook #'my/set-initial-frame-full-workarea)
(add-hook 'after-make-frame-functions #'my/set-frame-full-workarea)


;;; Editing

(setq evil-escape-key-sequence "jk"
      evil-escape-delay 0.2)

;; Restore point to its last position when revisiting a file.
(save-place-mode 1)


;;; Diagnostics

(after! flycheck
  (map! :leader
        :desc "Copy diagnostic"
        "c y" #'flycheck-copy-errors-as-kill))


;;; File management

(after! dirvish
  (setq dirvish-attributes
        '(vc-state
          subtree-state
          nerd-icons
          collapse
          git-msg
          file-time
          file-size)
        dirvish-default-layout '(0 0.4 0.6)
        ;; Confirm once before recursively deleting a directory tree.
        dired-recursive-deletes 'top
        dired-recursive-copies 'always
        dired-dwim-target t
        dired-mouse-drag-files t)

  (dirvish-peek-mode 1)

  (map! :map dirvish-mode-map
        :n "q"   #'dirvish-quit
        :n "h"   #'dired-up-directory
        :n "l"   #'dired-find-file
        :n "RET" #'dired-find-file
        :n "TAB" #'dirvish-subtree-toggle
        :n "r"   #'dired-do-rename
        :n "c"   #'dired-do-copy
        :n "d"   #'dired-flag-file-deletion
        :n "x"   #'dired-do-flagged-delete
        :n "m"   #'dired-mark
        :n "u"   #'dired-unmark
        :n "U"   #'dired-unmark-all-marks
        :n "H"   #'dired-omit-mode
        :n "a"   #'dirvish-quick-access
        :n "s"   #'dirvish-quicksort
        :n "y"   #'dirvish-yank-menu
        :n "?"   #'dirvish-dispatch))

(map! :leader
      :desc "Open Dirvish" "o d" #'dirvish-dwim
      :desc "Dirvish sidebar" "o e" #'dirvish-side)


;;; Languages

(use-package! markdown-mode
  :mode "\\.md\\'"
  :config
  (setq markdown-command "pandoc")
  (map! :map markdown-mode-map
        :localleader
        :desc "Live preview"
        "p" #'markdown-live-preview-mode))

(after! python
  ;; Reuse the installed Ruff executable for Python formatting.  This avoids
  ;; requiring Black solely to satisfy the default formatter.
  (set-formatter! 'ruff :modes '(python-mode python-ts-mode)))


;;; Org

;; Loading this after Org preserves Doom's lazy startup path.  org-agenda
;; remains deferred until it is opened for the first time.
(after! org
  (load! "lisp/org-review"))


;;; Terminal

(use-package! vterm-toggle
  :config
  (setq vterm-toggle-scope 'project
        vterm-toggle-project-root t
        vterm-toggle-fullscreen-p nil))

(map! :leader
      :desc "Toggle vterm"
      "o t" #'vterm-toggle)

(after! vterm
  (set-popup-rule! "^\\*vterm"
    :side 'right
    :size 0.5
    :select t
    :quit nil))


;;; Modeline and system monitor

;; The sampler uses macOS-specific `top' and APFS conventions.  Other systems
;; retain Doom's default modeline.
(when (eq system-type 'darwin)
  ;; Load the data provider first.  Define segments only after doom-modeline has
  ;; initialized Doom's modeline API.
  (load! "lisp/system-monitor")

  (after! doom-modeline
    (load! "lisp/modeline")))
