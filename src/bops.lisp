(in-package :etf-bops)

(defun bytes-to-unsigned-integer (bytes &optional (number-of-bytes nil) (pos 0))
  (loop
     with n = (if number-of-bytes number-of-bytes (length bytes))
     with uint = 0
     for b upfrom pos
     for i from (ash (1- n) 3) downto 0 by 8
     do (setf (ldb (byte 8 i) uint) (aref bytes b))
     finally (return uint)))

(defun bytes-to-uint16 (bytes &optional (pos 0))
  (nibbles:ub16ref/be bytes pos))

(defun bytes-to-uint32 (bytes &optional (pos 0))
  (nibbles:ub32ref/be bytes pos))


(defun read-uint16 (stream)
  (nibbles:read-ub16/be stream))

(defun read-uint32 (stream)
  (nibbles:read-ub32/be stream))


(defun write-uint16 (int stream)
  (nibbles:write-ub16/be int stream)
  t)

(defun write-uint32 (int stream)
  (nibbles:write-ub32/be int stream)
  t)


(defun signed-int32-to-bytes (int)
  (let ((bytes (nibbles:make-octet-vector 4)))
    (setf (nibbles:sb32ref/be bytes 0) int)
    bytes))

(defun bytes-to-signed-int32 (bytes &optional (pos 0))
  (nibbles:sb32ref/be bytes pos))

(defun read-signed-int32 (stream)
  (nibbles:read-sb32/be stream))

(defun write-signed-int32 (int stream)
  (nibbles:write-sb32/be int stream)
  t)


(defun unsigned-integer-to-bytes (uint number-of-bytes)
  (loop
     with bytes = (nibbles:make-octet-vector number-of-bytes)
     for b upfrom 0
     for i from (ash (1- number-of-bytes) 3) downto 0 by 8
     do (setf (aref bytes b) (ldb (byte 8 i) uint))
     finally (return bytes)))

(defun uint16-to-bytes (int)
  (let ((bytes (nibbles:make-octet-vector 2)))
    (setf (nibbles:ub16ref/be bytes 0) int)
    bytes))

(defun uint32-to-bytes (int)
  (let ((bytes (nibbles:make-octet-vector 4)))
    (setf (nibbles:ub32ref/be bytes 0) int)
    bytes))


(defun string-to-bytes (string)
  (map 'simple-vector #'char-code string))

(defun bytes-to-string (bytes &optional length (pos 0))
  (map 'string #'code-char (subseq bytes pos (when length (+ pos length)))))


(defun read-bytes (n stream)
  (let ((bytes (nibbles:make-octet-vector n)))
    (read-sequence bytes stream)
    ;; Does it block until the whole sequence is filled when reading from a socket?
    bytes))

(defun read-string (n stream)
  (let ((str (make-string n)))
    (read-sequence str stream)
    str))


(defun double-float-to-bytes (f)
  (let ((bytes (nibbles:make-octet-vector 8)))
    (setf (nibbles:ub64ref/be bytes 0) (ieee-floats:encode-float64 f))
    bytes))

(defun bytes-to-double-float (bytes)
  (ieee-floats:decode-float64 (nibbles:nibbles:ub64ref/be bytes 0)))
