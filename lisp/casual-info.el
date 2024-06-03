;;; casual-info.el --- A Transient UI for Info -*- lexical-binding: t; -*-

;; Copyright (C) 2024  Charles Choi

;; Author: Charles Choi <kickingvegas@gmail.com>
;; URL: https://github.com/kickingvegas/casual-info
;; Keywords: tools
;; Version: 1.0.1
;; Package-Requires: ((emacs "29.1"))

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

;; Casual Info is an opinionated Transient-based porcelain for Emacs Info.

;; INSTALLATION
;; (require 'casual-info)
;; (define-key info-mode-map (kbd "C-o") #'casual-info-tmenu)

;;; Code:
(require 'transient)
(require 'info)
(require 'casual-info-version)
(require 'casual-info-variables)
(require 'casual-info-settings)
(require 'casual-info-utils)

;;; Menus
;;;###autoload (autoload 'casual-info-tmenu "casual-info" nil t)

(transient-define-prefix casual-info-tmenu ()
  "CC Info Transient menu."

  [["Overview"
    ("d" "Directory" Info-directory :transient nil)
    ("t" "Top" Info-top-node)
    ("T" "ToC" Info-toc :transient nil)]

   ["Goto"
    ("m" "Menu…" Info-menu)
    ("g" "Node…" Info-goto-node)
    ("i" "Index…" Info-index)
    ("I" "V-index…" Info-virtual-index)]

   ["Search"
    :pad-keys t
    ("C-s" "I-search…" isearch-forward)
    ("s" "Search…" Info-search)
    ("S" "Case sensitive…" Info-search-case-sensitively)]

   ["History"
    :pad-keys t
    ("L" "History" Info-history :transient nil)
    ("M-[" "⏪️" Info-history-back
     :description (lambda () (casual-info-unicode-db-get :rewind))
     :transient t)
    ("M-]" "⏩️" Info-history-forward
     :description (lambda () (casual-info-unicode-db-get :fast-forward))
     :transient t)]]

  ["Navigation"
   ["Link"
    :description (lambda () (casual-info-unicode-db-get :link))
    ("k" "Previous" Info-prev-reference
     :description (lambda () (casual-info-unicode-db-get :up-arrow))
     :transient t)
    ("j" "Next" Info-next-reference
     :description (lambda () (casual-info-unicode-db-get :down-arrow))
     :transient t)]

   ["Paragraph"
    :description (lambda () (casual-info-unicode-db-get :paragraph))
    ("p" "Previous" casual-info-browse-backward-paragraph
     :description (lambda () (casual-info-unicode-db-get :up-arrow))
     :transient t)
    ("n" "Next" casual-info-browse-forward-paragraph
     :description (lambda () (casual-info-unicode-db-get :down-arrow))
     :transient t)]

   ["All Nodes"
    ("[" "⏪️⤴️" Info-backward-node
     :description (lambda ()
                    (casual-info-unicode-db-get :rewind-or-up))
     :transient t)
    ("]" "⏩️⤵️" Info-forward-node
     :description (lambda ()
                    (casual-info-unicode-db-get :fast-forward-or-down))
     :transient t)]

   ["Peer Nodes"
    ("h" "⏪️" Info-prev
     :description (lambda () (casual-info-unicode-db-get :rewind))
     :transient t)
    ("l" "⏩️" Info-next
     :description (lambda () (casual-info-unicode-db-get :fast-forward))
     :transient t)]

   [""
    ("<" "⏮️" Info-top-node
     :description (lambda () (casual-info-unicode-db-get :first))
     :transient nil)
    (">" "⏭️" Info-final-node
     :description (lambda () (casual-info-unicode-db-get :last))
     :transient nil)]

   [""
    ("^" "⏫️"  Info-up
     :description (lambda () (casual-info-unicode-db-get :up))
     :transient t)]]

  ["Quick"
   [("J" "Jump to bookmark…" bookmark-jump :transient nil)
    ("B" "Set bookmark…" bookmark-set :transient nil)
    ("b" "List buffers" ibuffer :transient nil)]

   [("c" "Copy node name" Info-copy-current-node-name :transient nil)
    ("G" "Open node in web…" Info-goto-node-web :transient nil)]

   [:pad-keys t
              ("C-M-n" "New frame" casual-info-clone-frame
               :transient nil)
              ("M-n" "Clone buffer" clone-buffer :transient nil)]]

  [:class transient-row
          ("<return>" "Open" Info-follow-nearest-node :transient t)
          ("<space>" "⏩️⤵️" Info-scroll-up
           :description (lambda ()
                    (casual-info-unicode-db-get :fast-forward-or-down))
           :transient t)
          ("," "Settings›" casual-info-settings-tmenu)
          ("q" "Dismiss" ignore :transient transient--do-exit)])


(defun casual-info-clone-frame ()
  "Clone frame."
  (interactive)
  (clone-frame nil t))


(provide 'casual-info)
;;; casual-info.el ends here
