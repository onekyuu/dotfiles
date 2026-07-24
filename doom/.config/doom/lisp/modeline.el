;;; modeline.el -*- lexical-binding: t; -*-

;; Copyright (C) 2026

;; Author: keyuwang
;; Keywords: convenience, mode-line

;;; Commentary:

;; Define a custom Doom modeline using Doom's public modeline API.
;;
;; This rendering module never runs shell commands and never collects system
;; information.  CPU, memory, disk, battery, and time segments only read the
;; cache variables exported by `system-monitor'.

;;; Code:

(require 'cl-lib)
(require 'system-monitor)
(require 'doom-modeline)

;; Doom documents these three symbols as its public modeline API.  Current Doom
;; installations backed by doom-modeline may not materialize the two macro
;; aliases until generated autodefs are loaded, so provide a narrow compatibility
;; bridge only when an API symbol is absent.  The implementation delegates to
;; the current, non-obsolete doom-modeline primitives without modifying package
;; source.
(eval-and-compile
  (unless (fboundp 'def-modeline-segment!)
    (defmacro def-modeline-segment! (name &rest body)
      "Define Doom modeline segment NAME with BODY."
      (declare (indent defun) (doc-string 2))
      `(doom-modeline-def-segment ,name ,@body)))

  (unless (fboundp 'def-modeline-format!)
    (defmacro def-modeline-format! (name left &optional right)
      "Define Doom modeline NAME from LEFT and RIGHT segments."
      (declare (indent defun))
      `(doom-modeline-def-modeline ',name ',left ',right))))

(unless (fboundp 'set-modeline!)
  (defalias 'set-modeline! #'doom-modeline-set-modeline))

(declare-function set-modeline! nil (name &optional default))

(defface my-modeline-normal
  '((t (:inherit doom-modeline-info)))
  "Face for healthy custom modeline metrics."
  :group 'my/modeline)

(defface my-modeline-warning
  '((t (:inherit doom-modeline-warning)))
  "Face for custom modeline metrics that require attention."
  :group 'my/modeline)

(defface my-modeline-error
  '((t (:inherit doom-modeline-urgent)))
  "Face for critical or unavailable custom modeline metrics."
  :group 'my/modeline)

(defconst my/modeline--icon-workspace "󰖲"
  "Nerd Font icon used by the workspace segment.")

(defconst my/modeline--icon-window "󰖯"
  "Nerd Font icon used by the window number segment.")

(defconst my/modeline--icon-cpu "󰾆"
  "Nerd Font icon used by the CPU segment.")

(defconst my/modeline--icon-memory "󰍛"
  "Nerd Font icon used by the memory segment.")

(defconst my/modeline--icon-disk "󰋊"
  "Nerd Font icon used by the disk segment.")

(defconst my/modeline--icon-battery "󰂄"
  "Nerd Font icon used by the battery segment.")

(defconst my/modeline--icon-clock "󰄉"
  "Nerd Font icon used by the clock segment.")

(defun my/modeline--metric-face (value warning error)
  "Choose a face for numeric VALUE using WARNING and ERROR thresholds."
  (cond
   ((not (numberp value)) 'my-modeline-error)
   ((>= value error) 'my-modeline-error)
   ((>= value warning) 'my-modeline-warning)
   (t 'my-modeline-normal)))

(defun my/modeline--battery-face ()
  "Return a face appropriate for cached battery charge."
  (let ((value my/modeline-battery-percent))
    (cond
     ((not (numberp value)) 'my-modeline-error)
     ((<= value 20) 'my-modeline-error)
     ((<= value 35) 'my-modeline-warning)
     (t 'my-modeline-normal))))

(defun my/modeline--render (icon value face &optional help)
  "Render one modeline metric using ICON, VALUE, FACE, and HELP.

This is the only place custom metric segments add text properties."
  (propertize
   ;; Percent characters in a mode-line construct must be doubled; otherwise
   ;; `format-mode-line' consumes them as %-escapes.
   (format " %s %s " icon (string-replace "%" "%%" value))
   'face face
   'help-echo help))

(defun my/modeline--workspace-name ()
  "Return the active Doom workspace name, or nil.

Doom's workspaces module uses persp-mode, which is distinct from the
eyebrowse/tab-bar workspaces handled by doom-modeline's stock segment."
  (cond
   ((and (bound-and-true-p persp-mode)
         (fboundp 'get-current-persp)
         (fboundp 'safe-persp-name))
    (when-let ((perspective (get-current-persp)))
      (safe-persp-name perspective)))
   ((and (fboundp 'tab-bar--current-tab)
         (bound-and-true-p tab-bar-mode))
    (alist-get 'name (tab-bar--current-tab)))
   (t nil)))

(defun my/modeline--selected-window-number ()
  "Return the selected window's one-based number as a string."
  (let* ((windows (window-list nil 'nomini))
         (position (cl-position (selected-window) windows)))
    (number-to-string (1+ (or position 0)))))

(def-modeline-segment! my/workspace
  "Display the active Doom workspace."
  (when-let ((name (my/modeline--workspace-name)))
    (my/modeline--render
     my/modeline--icon-workspace
     name
     'my-modeline-normal
     "Current Doom workspace")))

(def-modeline-segment! my/window-number
  "Display the selected window number."
  (my/modeline--render
   my/modeline--icon-window
   (my/modeline--selected-window-number)
   'my-modeline-normal
   "Selected window number"))

(def-modeline-segment! my/buffer-state
  "Display modified, read-only, or clean buffer state."
  (cond
   (buffer-read-only
    (my/modeline--render "" "RO" 'my-modeline-warning "Read-only buffer"))
   ((buffer-modified-p)
    (my/modeline--render "" "MOD" 'my-modeline-error "Modified buffer"))
   (t
    (my/modeline--render "" "OK" 'my-modeline-normal "Unmodified buffer"))))

(def-modeline-segment! my/cpu
  "Display cached total macOS CPU usage."
  (my/modeline--render
   my/modeline--icon-cpu
   my/modeline-cpu
   (my/modeline--metric-face my/modeline-cpu-percent 75 90)
   "Total CPU usage"))

(def-modeline-segment! my/memory
  "Display cached used physical memory."
  (my/modeline--render
   my/modeline--icon-memory
   my/modeline-memory
   (if (string= my/modeline-memory "--")
       'my-modeline-error
     'my-modeline-normal)
   "Used physical memory"))

(def-modeline-segment! my/disk
  "Display cached root filesystem usage."
  (my/modeline--render
   my/modeline--icon-disk
   my/modeline-disk
   (my/modeline--metric-face my/modeline-disk-percent 80 90)
   (format "Disk usage for %s" my/modeline-disk-path)))

(def-modeline-segment! my/battery
  "Display cached charge from Emacs battery.el."
  (my/modeline--render
   my/modeline--icon-battery
   my/modeline-battery
   (my/modeline--battery-face)
   "Battery charge"))

(def-modeline-segment! my/time
  "Display cached 24-hour local time."
  (my/modeline--render
   my/modeline--icon-clock
   my/modeline-time
   'my-modeline-normal
   "Local time"))

(def-modeline-format! my/main
  (bar
   my/workspace
   my/window-number
   buffer-info
   my/buffer-state
   buffer-position)
  (my/cpu
   my/memory
   my/disk
   my/battery
   vcs
   check
   major-mode
   my/time))

(defun my/modeline-activate ()
  "Activate `my/main' after doom-modeline finishes enabling.

doom-modeline installs its stock `main' format while its global minor mode is
being enabled.  Running this function at the end of
`doom-modeline-mode-hook' ensures that the custom default wins that startup
ordering, then updates ordinary buffers that already existed."
  (when (bound-and-true-p doom-modeline-mode)
    (set-modeline! 'my/main t)
    (dolist (buffer (buffer-list))
      (with-current-buffer buffer
        (when (or (derived-mode-p 'prog-mode 'text-mode)
                  (eq major-mode 'fundamental-mode))
          (set-modeline! 'my/main))))
    (force-mode-line-update t)))

(add-hook 'doom-modeline-mode-hook #'my/modeline-activate 90)

;; When this file is evaluated interactively after startup, the enable hook has
;; already run, so activate immediately as well.
(when (bound-and-true-p doom-modeline-mode)
  (my/modeline-activate))

(my/modeline-monitor-start)

(provide 'my-modeline)
;;; modeline.el ends here
