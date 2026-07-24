;;; org-review.el --- Spaced review scheduling for Org -*- lexical-binding: t; -*-

;;; Commentary:

;; Create a scheduled follow-up task when a review task transitions to DONE.
;; Add the following properties to an Org heading:
;;
;;   :REVIEW: t
;;   :STABILITY: 1
;;   :DIFFICULTY: 5
;;
;; This library is loaded from `config.el' only after Org itself is available.
;; Agenda integration remains deferred until `org-agenda' is loaded.

;;; Code:

(require 'org)

(defgroup my/org-review nil
  "Spaced review scheduling for Org tasks."
  :group 'org
  :prefix "my/org-review-")

(defcustom my/org-review-default-stability 1.0
  "Default memory stability for a review task."
  :type 'float
  :group 'my/org-review)

(defcustom my/org-review-default-difficulty 5.0
  "Default difficulty for a review task."
  :type 'float
  :group 'my/org-review)

(defun my/org-review--get-number (property default)
  "Return numeric Org PROPERTY at point, or DEFAULT when it is absent."
  (if-let ((value (org-entry-get nil property t)))
      (string-to-number value)
    default))

(defun my/org-review--calculate-days (rating stability)
  "Return the next review interval from RATING and STABILITY.

RATING must be 1 (again), 2 (hard), 3 (good), or 4 (easy)."
  (max 1
       (round
        (* stability
           (pcase rating
             (1 1.0)
             (2 1.5)
             (3 2.5)
             (4 4.0)
             (_ (user-error "Invalid review rating: %S" rating)))))))

(defun my/org-review--update-memory (rating)
  "Return updated (STABILITY DIFFICULTY) values for RATING."
  (let* ((stability
          (my/org-review--get-number
           "STABILITY"
           my/org-review-default-stability))
         (difficulty
          (my/org-review--get-number
           "DIFFICULTY"
           my/org-review-default-difficulty))
         (new-stability
          (* stability
             (pcase rating
               (1 0.5)
               (2 1.2)
               (3 2.5)
               (4 4.0)
               (_ 1.0))))
         (new-difficulty
          (+ difficulty
             (pcase rating
               (1 1.0)
               (2 0.3)
               (3 0.0)
               (4 -0.3)
               (_ 0.0)))))
    (list (max 1.0 new-stability)
          (max 1.0 new-difficulty))))

(defun my/org-review--ask-rating ()
  "Prompt for and return a review rating from 1 through 4."
  (- (read-char-choice
      "Review result: [1] Again  [2] Hard  [3] Good  [4] Easy: "
      '(?1 ?2 ?3 ?4))
     ?0))

(defun my/org-review--create-next-review (rating)
  "Create a scheduled follow-up review task using RATING."
  (let* ((title (org-get-heading t t t t))
         (memory (my/org-review--update-memory rating))
         (stability (car memory))
         (difficulty (cadr memory))
         (days (my/org-review--calculate-days rating stability))
         (date (format-time-string
                "%Y-%m-%d"
                (time-add (current-time) (days-to-time days))))
         (level (or (org-current-level) 1)))
    (save-excursion
      (org-end-of-subtree t t)
      (insert "\n\n"
              (make-string level ?*)
              " TODO Review: " title
              "\nSCHEDULED: <" date ">"
              "\n:PROPERTIES:"
              "\n:REVIEW: t"
              "\n:STABILITY: " (number-to-string stability)
              "\n:DIFFICULTY: " (number-to-string difficulty)
              "\n:END:\n"))))

(defun my/org-review-after-done ()
  "Create the next review when a REVIEW task transitions to DONE."
  (when (and (equal org-state "DONE")
             (equal (org-entry-get nil "REVIEW" t) "t"))
    (my/org-review--create-next-review
     (my/org-review--ask-rating))))

(add-hook 'org-after-todo-state-change-hook
          #'my/org-review-after-done)

(with-eval-after-load 'org-agenda
  (add-to-list
   'org-agenda-custom-commands
   '("r" "Review tasks" tags-todo "+REVIEW=\"t\"")))

(provide 'org-review)
;;; org-review.el ends here
