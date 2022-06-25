;;; Small web site to share the files in a directory
;;;
;;; Copyright 2013-2022 Guillaume Le Vaillant
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


(defpackage :share-directory
  (:use :cl)
  (:import-from :cl-who
                #:escape-string
                #:htm
                #:html-mode
                #:str
                #:with-html-output-to-string)
  (:import-from :hunchentoot
                #:*dispatch-table*
                #:*log-lisp-backtraces-p*
                #:create-folder-dispatcher-and-handler
                #:create-prefix-dispatcher
                #:easy-acceptor
                #:url-encode)
  (:export #:main
           #:start
           #:stop))

(in-package :share-directory)


(defvar *web-server* nil)

(defun create-file-list (directory)
  (let* ((directories (uiop:while-collecting (collect)
                        (uiop:collect-sub*directories directory
                                                      (constantly t)
                                                      (constantly t)
                                                      #'collect)))
         (files-and-dirs (mapcan #'uiop:directory-files directories))
         (files (remove-if #'uiop:directory-pathname-p files-and-dirs))
         (directory-name-length (length (namestring directory)))
         (names (mapcar (lambda (file)
                          (subseq (namestring file) directory-name-length))
                        files)))
    (sort names #'string-lessp)))

(defun file-name-to-url (name)
  (concatenate 'string "/d/" (url-encode name)))

(defun make-default-page (file-list)
  (let ((html (with-html-output-to-string (str nil :prologue t)
                (:html
                 (:head
                  (:title "Publika"))
                 (:body
                  (:h1 "Haveblaj dosieroj")
                  (:p
                   (:ul
                    (mapc (lambda (file)
                            (htm
                             (:li
                              (:a
                               :href (escape-string (file-name-to-url file))
                               (str (escape-string file))))))
                          file-list))))))))
    (lambda ()
      html)))

(defun create-dispatch-table (directory)
  (let* ((file-list (create-file-list directory))
         (default-page (make-default-page file-list)))
    (list (create-folder-dispatcher-and-handler "/d/" directory)
          (create-prefix-dispatcher "/" default-page))))

(defun start (directory &optional (port 80))
  "Start the web server to share the files in DIRECTORY and listen on PORT."
  (setf (html-mode) :html5)
  (setf *dispatch-table* (create-dispatch-table directory))
  (setf *web-server* (make-instance 'easy-acceptor :port port))
  (hunchentoot:start *web-server*))

(defun stop ()
  "Stop the web server."
  (hunchentoot:stop *web-server*)
  (setf *web-server* nil)
  (setf *dispatch-table* nil))

(defun main (&optional (args (uiop:command-line-arguments)))
  (destructuring-bind (directory port)
      (case (length args)
        (1
         (list (first args) nil))
        (2
         (list (first args) (parse-integer (second args) :junk-allowed t)))
        (t
         (list nil nil)))
    (unless directory
      (write-line "Usage: share-directory <directory> [port]")
      (uiop:quit 1))
    (setf *log-lisp-backtraces-p* nil)
    (unwind-protect
         (progn
           (if port
               (start (truename directory) port)
               (start (truename directory)))
           (handler-case
               (loop until (eql :eof (read-line *standard-input* nil :eof)))
             (t () (terpri))))
      (stop))
    (uiop:quit 0)))
