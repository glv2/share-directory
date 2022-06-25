LISP ?= sbcl

all: share-directory

share-directory: share-directory.asd share-directory.lisp
	$(LISP) \
		--non-interactive \
		--eval '(require :asdf)' \
		--eval '(asdf:load-asd (truename "share-directory.asd"))' \
		--eval '(asdf:make "share-directory")'

clean:
	rm share-directory
