;;; mastodon-timeline.el --- Timeline behavior functions and macros

;; Copyright (C) 2017 Johnson Denen
;; Author: Johnson Denen <johnson.denen@gmail.com>
;; Version: 0.6.2
;; Homepage: https://github.com/jdenen/mastodon.el

;; This file is not part of GNU Emacs.

;; This file is part of mastodon.el.

;; mastodon.el is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; mastodon.el is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with mastodon.el.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; mastodon-timeline.el is a library of functions and macros to
;; help provide timeline-like behavior.

;;; Code:

(require 'mastodon-http)
(require 'mastodon-media)

(defgroup mastodon-timeline nil
  "Timeline-like behavior for Mastodon."
  :prefix "mastodon-timeline-"
  :group  'mastodon)

(defmacro mastodon-timeline--define-get (endpoint name)
  "Define an interactive timeline function to retrieve ENDPOINT data.

Use NAME in definition."
  (let* ((func (intern (format "mastodon-%s--get-timeline" name)))
         (docs (format "Open %s timeline." name)))
    `(defun ,func () ,docs
            (interactive)
            (let* ((url (mastodon-http--api ,endpoint))
                   (buffer (format "*mastodon-%s*" ,name))
                   (json (mastodon-http--get-json url)))
              (with-output-to-temp-buffer buffer
                (switch-to-buffer buffer)
                (mastodon-timeline--display json))
              (mastodon-mode)))))

(defmacro mastodon-timeline--define-display (timeline render)
  "Define a TIMELINE function to call RENDER on data."
  (let* ((func (intern (format "mastodon-%s--display" timeline)))
         (docs (format "Call %s render function on data TOOTS." timeline)))
    `(defun ,func (toots) ,docs
            (mapcar ,render toots)
            (replace-regexp "\n\n\n | " "\n | " nil (point-min) (point-max))
            (mastodon-media--inline-images))))

(provide 'mastodon-timeline)
;;; mastodon-timeline.el ends here
