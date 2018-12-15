;;; private/email/config.el -*- lexical-binding: t; -*-

(def-package! notmuch)

(after! notmuch
  (setq notmuch-search-oldest-first nil))
