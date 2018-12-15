;; -*- no-byte-compile: t; -*-
;;; config/default/packages.el

(when (featurep! +snippets)
  (package! emacs-snippets
    :recipe (:fetcher github
             :repo "hlissner/emacs-snippets"
             :files ("*"))))

;; (package! lsp-javascript-flow
;;	  :recipe (:fetcher github
;;			    :repo "emacs-lsp/lsp-javascript"
;;			    :files ("lsp-javascript-flow.el")))

(package! evil-magit)

(package! ag)
