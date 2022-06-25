;;; GNU Guix manifest to set the development environment
;;;  guix shell -m manifest.scm

(specifications->manifest
 '(;; Compiler and tools
   "sbcl"
   "make"

   ;; Libraries
   "sbcl-cl-who"
   "sbcl-hunchentoot"))
