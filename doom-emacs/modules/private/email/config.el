;;; private/email/config.el -*- lexical-binding: t; -*-

(def-package! notmuch)

(load! +bindings)

(after! notmuch
  (setq notmuch-search-oldest-first nil))

