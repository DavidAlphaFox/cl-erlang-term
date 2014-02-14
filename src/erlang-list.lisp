(in-package :erlang-term)

;;;;
;;;; Erlang list
;;;;

;;;
;;; Methods
;;;

(defmethod match-p ((a list) (b list))
  (and (alexandria:length= a b)
       (every #'match-p a b)))


;;;
;;; Encode/Decode
;;;

(defmethod encode ((x list) &key &allow-other-keys)
  (if x
      (encode-external-list x)
      (encode-external-nil)))


;; NIL_EXT
;; +-----+
;; |  1  |
;; +-----+
;; | 106 |
;; +-----+
;;

(defun encode-external-nil ()
  (vector +nil-ext+))

(defun decode-external-nil (bytes &optional (pos 0))
  (declare (ignore bytes))
  (values nil pos))


;; LIST_EXT
;; +-----+--------+----------+------+
;; |  1  |    4   |     N    |   M  |
;; +-----+--------+----------+------+
;; | 108 | Length | Elements | Tail |
;; +-----+--------+----------+------+
;;

(defun encode-external-list (list)
  (multiple-value-bind (elements tail length)
      (list-contents-to-bytes list)
    (concatenate 'nibbles:simple-octet-vector
                 (vector +list-ext+)
                 (uint32-to-bytes length)
                 elements
                 tail)))

(defun decode-external-list (bytes &optional (pos 0))
  (decode-list-contents bytes (bytes-to-uint32 bytes pos) (+ 4 pos)))



;;; Helper functions

(defun list-contents-to-bytes (list)
  (loop
     for (element . tail) on list
     for length upfrom 1
     collect (encode element :version-tag nil) into encoded-elements
     finally
       (let ((bytes (apply #'concatenate
                           `(nibbles:simple-octet-vector ,@encoded-elements)))
             (tail-bytes (if (and (null tail)
                                  *lisp-nil-at-tail-is-erlang-empty-list*)
                             (encode-external-nil)
                             (encode tail :version-tag nil))))
         (return (values bytes tail-bytes length))) ))

(defun decode-list-contents (bytes length &optional (pos 0))
  (if (= 0 length)
      (decode bytes :start pos :version-tag nil)
      (multiple-value-bind*
          (((term new-pos) (decode bytes :start pos :version-tag nil))
           ((tail end-pos) (decode-list-contents bytes (1- length) new-pos)))
        (values (cons term tail) end-pos) )))
