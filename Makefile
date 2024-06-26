.PHONY: test

EMACS ?= emacs

lisp:
	EMACS=$(EMACS) cask install \
	EMACS=$(EMACS) cask build

clean:
	rm -rf .cask

test: lisp
	EMACS=$(EMACS) cask exec ert-runner --reporter ert

package_lint: lisp
	EMACS=$(EMACS) cask emacs \
		-batch \
		-l package-lint \
		--eval "(setq package-lint-batch-fail-on-warnings nil)" \
		-f package-lint-batch-and-exit nix-ts-mode.el