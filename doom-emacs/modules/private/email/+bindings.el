;;; private/email/+bindings.el -*- lexical-binding: t; -*-

(map!
;;      :n #'notmuch-common-keymap
 (:after notmuch
   (:map notmuch-hello-mode-map :mode normal
     "g?" #'notmuch-hello-versions
     "TAB" #'widget-forward
     "RET" #'widget-button-press
     "S-TAB" #'widget-backward)
   (:map notmuch-show-mode-map :mode normal
    "gd" #'goto-address-at-point
    "A" #'notmuch-show-archive-thread-then-next
    "S" #'notmuch-show-filter-thread
    "K" #'notmuch-tag-jump
    "R" #'notmuch-show-reply
    "X" #'notmuch-show-archive-thread-then-exit
    "Z" #'notmuch-tree-from-show-current-query
    "a" #'notmuch-show-archive-message-then-next-or-next-thread
    "d" #'evil-collection-notmuch-show-toggle-delete
    "H" #'notmuch-show-toggle-visibility-headers
    "gj" #'notmuch-show-next-open-message
    "gk" #'notmuch-show-previous-open-message
    "]" #'notmuch-show-next-message
    "[" #'notmuch-show-previous-message
    "M-j" #'notmuch-show-next-thread-show
    "M-k" #'notmuch-show-previous-thread-show
    "r" #'notmuch-show-reply-sender
    "x" #'notmuch-show-archive-message-then-next-or-exit
    "|" #'notmuch-show-pipe-message
    "*" #'notmuch-show-tag-all
    "-" #'notmuch-show-remove-tag
    "+" #'notmuch-show-add-tag
    "TAB" #'notmuch-show-toggle-message
    "RET" #'notmuch-show-toggle-message
    "." #'notmuch-show-part-map)))
