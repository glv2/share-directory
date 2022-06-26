LISP ?= sbcl
DESTDIR ?= /usr/local

all: share-directory

share-directory: share-directory.asd share-directory.lisp
	$(LISP) \
		--non-interactive \
		--eval '(require :asdf)' \
		--eval '(asdf:load-asd (truename "share-directory.asd"))' \
		--eval '(asdf:make "share-directory")'

install: share-directory
	install -D -m 0755 share-directory $(DESTDIR)/bin/share-directory

clean:
	rm share-directory
