;;; GNU Guix manifest to set the development environment
;;;  guix shell -m manifest.scm

(specifications->manifest
 '(;; Compiler and tools
   "sbcl"
   ;; "coreutils"
   ;; "diffutils"
   ;; "findutils"
   ;; "gawk"
   ;; "gcc-toolchain"
   ;; "git"
   ;; "grep"
   ;; "libtool"
   ;; "lzip"
   "make"
   ;; "sed"
   ;; "tar"

   ;; Libraries
   "sbcl-cl-who"
   "sbcl-hunchentoot"))
