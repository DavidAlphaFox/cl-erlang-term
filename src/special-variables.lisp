;;;; Special variables

(in-package :erlang-term)

(defvar *atom-symbol-package* :keyword
  "The package in which atom symbols are interned. Symbols are uninterned if NIL.")

(defvar *lisp-t-is-erlang-true*
  NIL
  "Send the Lisp T to Erlang as 'true' instead of 'T'.")

(defvar *lisp-nil-is-erlang-empty-list*
  T
  "Send the Lisp NIL to Erlang as the empty list instead of as a symbol.")

(defvar *lisp-nil-is-erlang-false*
  NIL
  "Send the Lisp NIL to Erlang as 'false' instead of 'NIL'.")

(defvar *lisp-nil-at-tail-is-erlang-empty-list*
  T
  "Send the Lisp NIL at the tail of a list to Erlang as the empty list instead of as a symbol.")

(defvar *lisp-string-is-erlang-binary*
  NIL
  "Send a Lisp string to Erlang as a binary instead of a list.")

(defvar *erlang-true-is-lisp-t*
  NIL
  "Interpret the Erlang 'true' as T instead of '|true| in Lisp.")

(defvar *erlang-false-is-lisp-nil*
  NIL
  "Interpret the Erlang 'false' as NIL instead of '|false| in Lisp.")

(defvar *erlang-string-is-lisp-string*
  NIL
  "Interpret an Erlang string as Lisp string instead of a Lisp list.")
