;;; casual-info-utils.el --- Casual Info Utils  -*- lexical-binding: t; -*-

;; Copyright (C) 2024  Charles Choi

;; Author: Charles Choi <kickingvegas@gmail.com>
;; Keywords: tools

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;;

;;; Code:

(require 'transient)
(require 'info)
(require 'casual-info-variables)

(defconst casual-info-unicode-db
  '((:fast-forward . '("⏩️" "Next"))
    (:rewind . '("⏪️" "Previous"))
    (:fast-forward-or-down . '("⏩️⤵️"  "Next/Down"))
    (:rewind-or-up . '("⏪️⤴️" "Previous/Up"))
    (:up . '("⏫️" "Up"))
    (:first . '("⏮️" "First"))
    (:last . '("⏭️" "Last"))
    (:up-arrow . '("↑" "Previous"))
    (:down-arrow . '("↓" "Next"))
    (:paragraph . '(" ¶" "Paragraph"))
    (:link . '(" 🔗" "Link")))
  "Unicode symbol DB to use for Info Transient menus.")

(defun casual-info-unicode-db-get (key &optional db)
  "Lookup Unicode symbol for KEY in DB.

- KEY symbol used to lookup Unicode symbol in DB.
- DB alist containing Unicode symbols used by Info Transient menus.

If DB is nil, then `casual-info-unicode-db' is used by default.

If the value of customizable variable `cchoi-use-unicode-symbols'
is non-nil, then the Unicode symbol is returned, otherwise a
plain ASCII-range string."
  (let* ((db (or db casual-info-unicode-db))
         (unicode casual-info-use-unicode-symbols)
         (item (alist-get key db)))
    (if unicode
        (nth 0 (eval item))
      (nth 1 (eval item)))))

(defun casual-info-browse-backward-paragraph ()
  "Move point backward paragraph such that the first line is highlighted.
\nThis function is intended to be used with `hl-line-mode'."
  (interactive)
  (backward-paragraph 2)
  (forward-line))

(defun casual-info-browse-forward-paragraph ()
  "Move point forward paragraph such that the first line is highlighted.
\nThis function is intended to be used with `hl-line-mode'."
  (interactive)
  (forward-paragraph)
  (forward-line))

;;; Labels
(defun casual-info--variable-to-checkbox (v)
  "Checkbox string representation of variable V.
V is either nil or non-nil."
  (if casual-info-use-unicode-symbols
      (if v "☑︎" "◻︎")
    (if v "[x]" "[ ]")))

(defun casual-info--prefix-label (label prefix)
  "Label constructed with PREFIX and LABEL separated by a space."
  (format "%s %s" prefix label))

(defun casual-info--checkbox-label (v label)
  "Checkbox label using variable V and LABEL."
  (casual-info--prefix-label label (casual-info--variable-to-checkbox v)))

(defun casual-info-format-arrow (buf typeset)
  "If TYPESET is non-nil, then format BUF string to have space."
  (if typeset
      (format " %s" buf)
    buf))

(provide 'casual-info-utils)
;;; casual-info-utils.el ends here
