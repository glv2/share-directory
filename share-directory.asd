;;; Small web site to share the files in a directory
;;;
;;; Copyright 2020-2022 Guillaume Le Vaillant
;;;
;;; This program is free software: you can redistribute it and/or modify
;;; it under the terms of the GNU General Public License as published by
;;; the Free Software Foundation, either version 3 of the License, or
;;; (at your option) any later version.
;;;
;;; This program is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

(cl:in-package :asdf-user)

;; Redefine 'program-op' to actvate compression
#+(and sbcl sb-core-compression)
(defmethod perform ((o program-op) (c system))
  (uiop:dump-image (output-file o c) :executable t :compression t))

(defsystem "share-directory"
  :name "share-directory"
  :version "1.0"
  :description "Small web server to share the files in a directory"
  :author "Guillaume Le Vaillant"
  :license "GPL-3"
  :depends-on ("cl-who" "hunchentoot")
  :components ((:file "share-directory"))
  :build-operation program-op
  :build-pathname "share-directory"
  :entry-point "share-directory:main")
