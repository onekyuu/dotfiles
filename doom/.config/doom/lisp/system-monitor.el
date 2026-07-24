;;; system-monitor.el -*- lexical-binding: t; -*-

;; Copyright (C) 2026

;; Author: keyuwang
;; Keywords: convenience, mode-line, macOS

;;; Commentary:

;; Collect macOS system metrics for the custom Doom modeline.
;;
;; This module is deliberately independent of doom-modeline.  It owns all
;; external processes, timers, parsing, and caches.  Consumers should only read
;; the public `my/modeline-*' cache variables below.
;;
;; A single asynchronous shell is started per CPU/memory refresh.  Apple's
;; `df' is included only when the slower disk cache is due.  Modeline redisplay
;; therefore never starts a process or blocks Emacs.

;;; Code:

(require 'battery)
(require 'subr-x)

(defgroup my/modeline nil
  "System monitoring for the custom Doom modeline."
  :group 'mode-line
  :prefix "my/modeline-")

(defcustom my/modeline-refresh-interval 2.0
  "Seconds between CPU and memory refreshes.

Changing this value while the monitor is active takes effect after calling
`my/modeline-monitor-restart'."
  :type 'number
  :group 'my/modeline)

(defcustom my/modeline-disk-refresh-interval 60.0
  "Seconds between disk usage refreshes.

Disk capacity changes much more slowly than CPU and memory usage.  `df' is
therefore included in the existing sampler process only when this interval has
elapsed."
  :type 'number
  :group 'my/modeline)

(defcustom my/modeline-battery-refresh-interval 60.0
  "Seconds between battery refreshes.

Battery percentage changes slowly, and macOS' implementation of `battery.el'
invokes pmset internally.  Refreshing it less often avoids an extra synchronous
process every second while still using the standard Emacs battery API."
  :type 'number
  :group 'my/modeline)

(defcustom my/modeline-disk-path
  (if (file-directory-p "/System/Volumes/Data")
      "/System/Volumes/Data"
    "/")
  "Filesystem path whose containing volume is reported in the modeline.

On macOS this defaults to the writable APFS Data volume, which most closely
matches the overall usage shown by System Settings.  It falls back to \"/\" on
systems without a separate Data volume."
  :type 'directory
  :group 'my/modeline)

(defvar my/modeline-cpu "--"
  "Cached total CPU usage, including the percent sign, or \"--\".")

(defvar my/modeline-cpu-percent nil
  "Cached numeric total CPU usage, or nil when unavailable.")

(defvar my/modeline-memory "--"
  "Cached used physical memory, such as \"12.6G\", or \"--\".")

(defvar my/modeline-disk "--"
  "Cached used/total disk capacity, such as \"234.8G/245.1G\", or \"--\".")

(defvar my/modeline-disk-percent nil
  "Cached numeric disk usage, or nil when unavailable.")

(defvar my/modeline-battery "--"
  "Cached battery charge, including the percent sign, or \"--\".")

(defvar my/modeline-battery-percent nil
  "Cached numeric battery charge, or nil when unavailable.")

(defvar my/modeline-time "--:--"
  "Cached local time in 24-hour HH:MM format.")

(defvar my/modeline-last-update nil
  "Time at which the external system metrics were last updated successfully.")

(defconst my/modeline--process-buffer-name
  " *my-modeline-system-monitor*"
  "Name of the hidden buffer used by the asynchronous sampler.")

(defconst my/modeline--df-marker "__MY_MODELINE_DF__"
  "Line marker separating `top' output from `df' output.")

(defconst my/modeline--shell-script
  (concat
   "set -e\n"
   "export LC_ALL=C\n"
   "/usr/bin/top -l 1 -n 0 -stats cpu,mem\n"
   "if [ \"$MY_MODELINE_INCLUDE_DISK\" = 1 ]; then\n"
   "  printf '\\n__MY_MODELINE_DF__\\n'\n"
   "  /bin/df -k \"$MY_MODELINE_DISK_PATH\"\n"
   "fi\n")
  "Shell program used for one combined system sample.")

(defvar my/modeline--timer nil
  "Timer responsible for scheduling system metric refreshes.")

(defvar my/modeline--process nil
  "Currently running asynchronous sampler process, or nil.")

(defvar my/modeline--last-battery-update 0.0
  "Float time of the last battery refresh attempt.")

(defvar my/modeline--last-disk-update 0.0
  "Float time of the last successful disk refresh.")

(defun my/modeline--set-system-fallbacks (&optional include-disk)
  "Reset external system metric caches to their fallback values.

Also reset the disk cache when INCLUDE-DISK is non-nil."
  (setq my/modeline-cpu "--"
        my/modeline-cpu-percent nil
        my/modeline-memory "--")
  (when include-disk
    (setq my/modeline-disk "--"
          my/modeline-disk-percent nil)))

(defun my/modeline--parse-cpu-line (line)
  "Return total CPU usage parsed from macOS top LINE.

The result is a number in the inclusive range 0 through 100, or nil."
  (when (string-prefix-p "CPU usage:" line)
    (let ((fields (split-string line "[[:space:],:%]+" t)))
      ;; C locale output:
      ;; CPU usage: 9.21% user, 12.94% sys, 77.83% idle
      (when (>= (length fields) 8)
        (let ((idle (string-to-number (nth 6 fields))))
          (max 0.0 (min 100.0 (- 100.0 idle))))))))

(defun my/modeline--parse-memory-line (line)
  "Return used physical memory parsed from macOS top LINE, or nil."
  (when (string-prefix-p "PhysMem:" line)
    ;; C locale output begins with: PhysMem: 15G used ...
    (nth 1 (split-string line "[[:space:]]+" t))))

(defun my/modeline--parse-disk-line (line)
  "Return (USED-KB TOTAL-KB PERCENT) parsed from macOS df LINE.

For APFS, USED-KB is calculated as total blocks minus available blocks.  This
includes space shared with the system volume and therefore tracks the overall
container usage shown by macOS System Settings more closely than df's per-volume
Used field."
  (let ((fields (split-string line "[[:space:]]+" t)))
    ;; Filesystem, 1024-blocks, Used, Available, Capacity, ...
    (when (>= (length fields) 5)
      (let* ((total-kb (string-to-number (nth 1 fields)))
             (available-kb (string-to-number (nth 3 fields)))
             (used-kb (- total-kb available-kb)))
        (when (> total-kb 0)
          (list used-kb
                total-kb
                (round (* 100.0 (/ used-kb (float total-kb))))))))))

(defun my/modeline--format-disk-gb (kilobytes)
  "Format 1024-byte KILOBYTES as compact decimal gigabytes."
  (format "%.1fG" (/ (* kilobytes 1024.0) 1000000000.0)))

(defun my/modeline--parse-sample (output include-disk)
  "Parse combined top and df OUTPUT and publish all metric caches.

When INCLUDE-DISK is non-nil, require and publish a disk value as well.
Return non-nil only when all requested values were found."
  (let (cpu memory disk in-df)
    (dolist (line (split-string output "\n" t))
      (cond
       ((string= line my/modeline--df-marker)
        (setq in-df t))
       ((not in-df)
        (cond
         ((string-prefix-p "CPU usage:" line)
          (setq cpu (my/modeline--parse-cpu-line line)))
         ((string-prefix-p "PhysMem:" line)
          (setq memory (my/modeline--parse-memory-line line)))))
       ((and in-df
             (not (string-prefix-p "Filesystem" line)))
        (setq disk (my/modeline--parse-disk-line line)))))
    (if (and (numberp cpu)
             (stringp memory)
             (or (not include-disk)
                 (consp disk)))
        (progn
          (setq my/modeline-cpu-percent cpu
                my/modeline-cpu (format "%.0f%%" cpu)
                my/modeline-memory memory
                my/modeline-last-update (current-time))
          (when disk
            (setq my/modeline-disk-percent (nth 2 disk)
                  my/modeline-disk
                  (format "%s/%s"
                          (my/modeline--format-disk-gb (nth 0 disk))
                          (my/modeline--format-disk-gb (nth 1 disk)))
                  my/modeline--last-disk-update (float-time)))
          t)
      (my/modeline--set-system-fallbacks include-disk)
      nil)))

(defun my/modeline--process-sentinel (process _event)
  "Publish sampler PROCESS output after it exits."
  (when (and (eq process my/modeline--process)
             (memq (process-status process) '(exit signal)))
    (let ((include-disk
           (process-get process 'my/modeline-include-disk)))
      (unwind-protect
          (condition-case nil
              (if (and (eq (process-status process) 'exit)
                       (zerop (process-exit-status process))
                       (buffer-live-p (process-buffer process)))
                  (with-current-buffer (process-buffer process)
                    (my/modeline--parse-sample
                     (buffer-substring-no-properties (point-min) (point-max))
                     include-disk))
                (my/modeline--set-system-fallbacks include-disk))
            (error
             (my/modeline--set-system-fallbacks include-disk)))
        (setq my/modeline--process nil)
        ;; Publish CPU, memory, and any requested disk update together.
        (force-mode-line-update t)))))

(defun my/modeline--start-sample ()
  "Start one nonblocking combined top/df sample.

If the previous sample has not finished, skip this refresh.  This guarantees
that slow system commands cannot accumulate processes."
  (unless (processp my/modeline--process)
    (let* ((now (float-time))
           (include-disk
            (>= (- now my/modeline--last-disk-update)
                my/modeline-disk-refresh-interval))
           (buffer (get-buffer-create my/modeline--process-buffer-name))
           (process-environment
            (append
             (list (concat "MY_MODELINE_DISK_PATH="
                           (expand-file-name my/modeline-disk-path))
                   (concat "MY_MODELINE_INCLUDE_DISK="
                           (if include-disk "1" "0")))
             process-environment)))
      (with-current-buffer buffer
        (erase-buffer))
      (condition-case nil
          (let ((process
                 (make-process
                  :name "my-modeline-system-monitor"
                  :buffer buffer
                  :command (list "/bin/sh" "-c" my/modeline--shell-script)
                  :connection-type 'pipe
                  :noquery t
                  :sentinel #'my/modeline--process-sentinel)))
            (process-put process 'my/modeline-include-disk include-disk)
            (setq my/modeline--process process))
        (error
         (setq my/modeline--process nil)
         (my/modeline--set-system-fallbacks include-disk)
         (force-mode-line-update t))))))

(defun my/modeline--refresh-battery (&optional force)
  "Refresh the battery cache through `battery.el'.

With FORCE non-nil, bypass `my/modeline-battery-refresh-interval'.
Return non-nil when the displayed battery value changed."
  (let ((now (float-time)))
    (when (or force
              (>= (- now my/modeline--last-battery-update)
                  my/modeline-battery-refresh-interval))
      (let ((old-value my/modeline-battery))
        (setq my/modeline--last-battery-update now)
        (condition-case nil
            (let* ((data (and battery-status-function
                              (funcall battery-status-function)))
                   (text (and data (battery-format "%p" data))))
              (if (and (stringp text)
                       (string-match-p
                        "\\`[[:digit:]]+\\(?:\\.[[:digit:]]+\\)?\\'"
                        text))
                  (let ((percent
                         (max 0
                              (min 100
                                   (round (string-to-number text))))))
                    (setq my/modeline-battery-percent percent
                          my/modeline-battery (format "%d%%" percent)))
                (setq my/modeline-battery-percent nil
                      my/modeline-battery "--")))
          (error
           (setq my/modeline-battery-percent nil
                 my/modeline-battery "--")))
        (not (equal old-value my/modeline-battery))))))

(defun my/modeline-monitor-refresh ()
  "Refresh slow caches when due, then start one system sample.

This is the function invoked by `my/modeline--timer'."
  (let ((new-time (format-time-string "%H:%M"))
        (battery-changed (my/modeline--refresh-battery)))
    (when (or (not (equal new-time my/modeline-time))
              battery-changed)
      (setq my/modeline-time new-time)
      ;; Time and battery are published immediately only when they changed.
      (force-mode-line-update t)))
  (my/modeline--start-sample)
  nil)

;;;###autoload
(defun my/modeline-monitor-start ()
  "Start the cached system monitor.

This command is idempotent.  Use `my/modeline-monitor-restart' after changing
the refresh interval."
  (interactive)
  (unless (timerp my/modeline--timer)
    (my/modeline--refresh-battery t)
    (setq my/modeline-time (format-time-string "%H:%M")
          my/modeline--last-disk-update 0.0
          my/modeline--timer
          (run-with-timer 0
                          (max 0.5 my/modeline-refresh-interval)
                          #'my/modeline-monitor-refresh))))

;;;###autoload
(defun my/modeline-monitor-stop ()
  "Stop timers and processes owned by the cached system monitor."
  (interactive)
  (when (timerp my/modeline--timer)
    (cancel-timer my/modeline--timer))
  (setq my/modeline--timer nil)
  (when (processp my/modeline--process)
    (set-process-sentinel my/modeline--process nil)
    (when (process-live-p my/modeline--process)
      (delete-process my/modeline--process)))
  (setq my/modeline--process nil)
  (when-let ((buffer (get-buffer my/modeline--process-buffer-name)))
    (kill-buffer buffer)))

;;;###autoload
(defun my/modeline-monitor-restart ()
  "Restart the monitor and apply current customization values."
  (interactive)
  (my/modeline-monitor-stop)
  (my/modeline-monitor-start))

(add-hook 'kill-emacs-hook #'my/modeline-monitor-stop)

(provide 'system-monitor)
;;; system-monitor.el ends here
