;;; casual-info.el --- Transient UI for Info -*- lexical-binding: t; -*-

;; Copyright (C) 2024  Charles Choi

;; Author: Charles Choi <kickingvegas@gmail.com>
;; URL: https://github.com/kickingvegas/casual-info
;; Keywords: tools
;; Version: 1.3.4-rc.1
;; Package-Requires: ((emacs "29.1") (casual-lib "1.1.0"))

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

;; NOTICE
;; This package `casual-info' has been superseded by the package `casual'.
;; Please update to the `casual' package from either MELPA or MELPA stable. Upon
;; installation and upgrade of the `casual' package, this package will be
;; removed.

;; Casual Info is an opinionated Transient-based porcelain for Emacs Info.

;; INSTALLATION
;; (require 'casual-info)
;; (keymap-set Info-mode-map "C-o" #'casual-info-tmenu)

;; Alternately with `use-package':
;; (use-package casual-info
;;   :ensure nil
;;   :bind (:map Info-mode-map ("C-o" . 'casual-info-tmenu)))

;; NOTE: This package requires `casual-lib' which in turn requires an update of
;; the built-in package `transient' ≥ 0.6.0. Please customize the variable
;; `package-install-upgrade-built-in' to t to allow for `transient' to be
;; updated. For further details, consult the INSTALL section of this package's
;; README.

;;; Code:
(require 'transient)
(require 'info)
(require 'casual-lib)
(require 'casual-info-version)
(require 'casual-info-variables)
(require 'casual-info-settings)
(require 'casual-info-utils)

(display-warning
 :warning
 (concat
  "NOTICE: "
  "The package casual-info has been superseded by the package casual. "
  "Please upgrade to casual at your earliest convenience."))

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
     :description (lambda () (casual-info-unicode-get :rewind))
     :transient t)
    ("M-]" "⏩️" Info-history-forward
     :description (lambda () (casual-info-unicode-get :fast-forward))
     :transient t)]

   ["Scroll"
    :pad-keys t
    ("S-SPC" "Scroll Down" Info-scroll-down
           :if display-graphic-p
           :description (lambda ()
                    (casual-info-unicode-get :scroll-down))
           :transient t)

    ("DEL" "Scroll Down" Info-scroll-down
           :if-not display-graphic-p
           :description (lambda ()
                    (casual-info-unicode-get :scroll-down))
           :transient t)

    ("SPC" "Scroll Up" Info-scroll-up
           :description (lambda ()
                    (casual-info-unicode-get :scroll-up))
           :transient t)]]

  ["Navigation"
   ["Link"
    :description (lambda () (casual-info-unicode-get :link))
    ("k" "Previous" Info-prev-reference
     :description (lambda () (casual-info-unicode-get :up-arrow))
     :transient t)
    ("j" "Next" Info-next-reference
     :description (lambda () (casual-info-unicode-get :down-arrow))
     :transient t)]

   ["Paragraph"
    :description (lambda () (casual-info-unicode-get :paragraph))
    ("p" "Previous" casual-info-browse-backward-paragraph
     :description (lambda () (casual-info-unicode-get :up-arrow))
     :transient t)
    ("n" "Next" casual-info-browse-forward-paragraph
     :description (lambda () (casual-info-unicode-get :down-arrow))
     :transient t)]

   ["All Nodes"
    ("[" "⏪️⤴️" Info-backward-node
     :description (lambda ()
                    (casual-info-unicode-get :rewind-or-up))
     :transient t)
    ("]" "⏩️⤵️" Info-forward-node
     :description (lambda ()
                    (casual-info-unicode-get :fast-forward-or-down))
     :transient t)]

   ["Peer Nodes"
    ("h" "⏪️" Info-prev
     :description (lambda () (casual-info-unicode-get :rewind))
     :transient t)
    ("l" "⏩️" Info-next
     :description (lambda () (casual-info-unicode-get :fast-forward))
     :transient t)]

   [""
    ("<" "⏮️" Info-top-node
     :description (lambda () (casual-info-unicode-get :first))
     :transient nil)
    (">" "⏭️" Info-final-node
     :description (lambda () (casual-info-unicode-get :last))
     :transient nil)]

   [""
    :pad-keys t
    ("^" "⏫️"  Info-up
     :description (lambda () (casual-info-unicode-get :up))
     :transient t)
    ("RET" "Open" Info-follow-nearest-node :transient t)
    ]]

  ["Quick"
   [("J" "Jump to bookmark…" bookmark-jump :transient nil)
    ("B" "Set bookmark…" bookmark-set :transient nil)
    ("b" "List buffers" ibuffer :transient nil)]

   [("c" "Copy node name" Info-copy-current-node-name :transient nil)
    ("G" "Open node in web…" Info-goto-node-web :transient nil)]

   [:pad-keys t
              ("C-M-n" "New Info in frame" casual-info-new-info-frame
               :transient nil)
              ("M-n" "Clone buffer" clone-buffer :transient nil)]]

  [:class transient-row
          (casual-lib-quit-one)
          ("," "Settings›" casual-info-settings-tmenu)
          ("q" "Quit Info" quit-window)])

(defun casual-info-new-info-frame ()
  "Create new Info manual instance (buffer) in a new frame.

This command creates a new frame populated by the
`info-display-manual' command."
  (interactive)
  (other-frame-prefix)
  (call-interactively #'info-display-manual))

(provide 'casual-info)
;;; casual-info.el ends here
