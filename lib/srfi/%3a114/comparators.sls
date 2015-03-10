;;;
;;;Part of: Vicare Scheme
;;;Contents: implementation of SRFI 114
;;;Date: Sun Mar  8, 2015
;;;
;;;Abstract
;;;
;;;	This library is derived from SRFI 114 reference implementation.
;;;
;;;Copyright (C) John Cowan 2013.  All Rights Reserved.
;;;Modified by Marco Maggi <marco.maggi-ipsu@poste.it>
;;;
;;;Permission is hereby  granted, free of charge,  to any person obtaining  a copy of
;;;this software  and associated documentation  files (the ``Software''), to  deal in
;;;the Software without restriction, including  without limitation the rights to use,
;;;copy, modify,  merge, publish, distribute,  sublicense, and/or sell copies  of the
;;;Software,  and to  permit persons  to whom  the Software  is furnished  to do  so,
;;;subject to the following conditions:
;;;
;;;The above  copyright notice and  this permission notice  shall be included  in all
;;;copies or substantial portions of the Software.
;;;
;;;THE  SOFTWARE IS  PROVIDED ``AS  IS'', WITHOUT  WARRANTY OF  ANY KIND,  EXPRESS OR
;;;IMPLIED, INCLUDING BUT  NOT LIMITED TO THE WARRANTIES  OF MERCHANTABILITY, FITNESS
;;;FOR A  PARTICULAR PURPOSE AND NONINFRINGEMENT.   IN NO EVENT SHALL  THE AUTHORS OR
;;;COPYRIGHT HOLDERS BE LIABLE FOR ANY  CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
;;;AN ACTION OF  CONTRACT, TORT OR OTHERWISE,  ARISING FROM, OUT OF  OR IN CONNECTION
;;;WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
;;


#!r6rs
(library (srfi :114 comparators)
  (export
    ;;
    comparator? comparator-comparison-procedure?
    comparator-hash-function?
    ;;
    boolean-comparator char-comparator char-ci-comparator
    string-comparator string-ci-comparator symbol-comparator
    exact-integer-comparator integer-comparator rational-comparator
    real-comparator complex-comparator number-comparator
    pair-comparator list-comparator vector-comparator
    bytevector-comparator
    ;;
    default-comparator
    ;;
    make-comparator make-inexact-real-comparator make-vector-comparator
    make-bytevector-comparator make-list-comparator
    make-vectorwise-comparator make-listwise-comparator
    make-car-comparator make-cdr-comparator make-pair-comparator
    make-improper-list-comparator make-selecting-comparator
    make-refining-comparator make-reverse-comparator
    make-debug-comparator
    ;;
    eq-comparator eqv-comparator equal-comparator
    ;;
    comparator-type-test-procedure comparator-equality-predicate
    comparator-comparison-procedure comparator-hash-function
    ;;
    comparator-test-type comparator-check-type comparator-equal?
    comparator-compare comparator-hash
    ;;
    make-comparison< make-comparison> make-comparison<=
    make-comparison>= make-comparison=/< make-comparison=/>
    ;;
    if3 if=? if<? if>? if<=? if>=? if-not=?
    ;;
    =? <? >? <=? >=?
    ;;
    make= make<  make> make<= make>=
    ;;
    in-open-interval? in-closed-interval? in-open-closed-interval?
    in-closed-open-interval?
    ;;
    comparator-min comparator-max

    comparator-register-default!)
  (import (vicare))


;;; comparison syntaxes

;; Arithmetic if
(define-syntax if3
  (syntax-rules ()
    ((if3 ?expr ?less ?equal ?greater)
     (let ((rv ?expr))
       (case rv
	 ((-1)	?less)
	 ((0)	?equal)
	 ((+1)	?greater)
	 (else
	  (assertion-violation 'if3
	    "bad return value from comparison expression, expected -1, 0, +1" rv)))))
    ))

;; If equal
(define-syntax if=?
  (syntax-rules ()
    ((if=? ?expr ?equal ?unequal)
     (if3 ?expr ?unequal ?equal ?unequal))
    ((if=? ?expr ?equal)
     (if=? ?expr ?equal (void)))
    ))

;; If less than
(define-syntax if<?
  (syntax-rules ()
    ((if<? ?expr ?less ?notless)
     (if3 ?expr ?less ?notless ?notless))
    ((if<? ?expr ?less)
     (if<? ?expr ?less (void)))
    ))

;; If greater than
(define-syntax if>?
  (syntax-rules ()
    ((if>? ?expr ?greater ?notgreater)
     (if3 ?expr ?notgreater ?notgreater ?greater))
    ((if>? ?expr ?greater)
     (if>? ?expr ?greater (void)))
    ))

;; If not equal
(define-syntax if-not=?
  (syntax-rules ()
    ((if-not=? ?expr ?notequal ?equal)
     (if3 ?expr ?notequal ?equal ?notequal))
    ((if-not=? ?expr ?notequal)
     (if-not=? ?expr ?notequal (void)))
    ))

;; If less than or equal
(define-syntax if<=?
  (syntax-rules ()
    ((if<=? ?expr ?lessequal ?greater)
     (if3 ?expr ?lessequal ?lessequal ?greater))
    ((if<=? ?expr ?lessequal)
     (if>? ?expr ?lessequal (void)))
    ))

;; If greater than or equal
(define-syntax if>=?
  (syntax-rules ()
    ((if>=? ?expr ?greaterequal ?less)
     (if3 ?expr ?less ?greaterequal ?greaterequal))
    ((if>=? ?expr ?greaterequal)
     (if>=? ?expr ?greaterequal (void)))
    ))


;;;; definition of comparator records with accessors and basic comparator

(define-record-type comparator
  (fields (immutable type-test		comparator-type-test-procedure)
	  (immutable equality		comparator-equality-predicate)
	  (immutable comparison		comparator-comparison-procedure)
	  (immutable hash		comparator-hash-function)
	  (immutable comparison?	comparator-comparison-procedure?)
	  (immutable hash?		comparator-hash-function?))
  (protocol
   (lambda (make-record)
     (lambda (type-test equality comparison hash)
       (define cmp
	 (make-record (if (eq? type-test #t)
			  (lambda (x) #t)
			type-test)
		      (if (eq? equality  #t)
			  (lambda (x y)
			    (eqv? (comparison x y) 0))
			equality)
		      (or comparison
			  (lambda (x y)
			    (error 'anonymous-comparator
			      "comparison not supported by this comparator"
			      cmp)))
		      (or hash
			  (lambda (x y)
			    (error 'anonymous-comparator
			      "hashing not supported by this comparator"
			      cmp)))
		      (if comparison #t #f)
		      (if hash       #t #f)))
       cmp)))
  #| end of DEFINE-RECORD-TYPE |# )


;;;; primitive applicators

(define (comparator-test-type comparator obj)
  ;;Invoke the test type.
  ;;
  ((comparator-type-test-procedure comparator) obj))

(define (comparator-check-type comparator obj)
  ;;Invoke the test type and throw an error if it fails.
  ;;
  (if (comparator-test-type comparator obj)
      #t
    (error __who__
      "comparator type check failed" comparator obj)))

(define (comparator-equal? comparator obj1 obj2)
  ;;Invoke the equality predicate.
  ;;
  ((comparator-equality-predicate comparator) obj1 obj2))

(define (comparator-compare comparator obj1 obj2)
  ;;Invoke the comparison procedure.
  ;;
  ((comparator-comparison-procedure comparator) obj1 obj2))

(define (comparator-hash comparator obj)
  ;;Invoke the hash function.
  ;;
  ((comparator-hash-function comparator) obj))


;;;; comparison procedure comparators
;;
;;These construct comparison procedures based on comparison predicates.
;;

(define (make-comparison< <)
  (lambda (a b)
    (cond ((< a b)	-1)
	  ((< b a)	+1)
	  (else		0))))

(define (make-comparison> >)
  (lambda (a b)
    (cond ((> a b)	+1)
	  ((> b a)	-1)
	  (else		0))))

(define (make-comparison<= <=)
  (lambda (a b)
    (if (<= a b)
	(if (<= b a) 0 -1)
      1)))

(define (make-comparison>= >=)
  (lambda (a b)
    (if (>= a b)
	(if (>= b a) 0 1)
      -1)))

(define (make-comparison=/< = <)
  (lambda (a b)
    (cond ((= a b)	0)
	  ((< a b)	-1)
	  (else		+1))))

(define (make-comparison=/> = >)
  (lambda (a b)
    (cond ((= a b)	0)
	  ((> a b)	+1)
	  (else		-1))))


;;;; the default comparator

(module (default-comparator default-hash-function comparator-register-default!)

  (define unknown-object-comparator
    ;;The unknown-object comparator, used as a fallback to everything else
    ;;
    (make-comparator (lambda (obj) #t)
		     (lambda (a b) #t)
		     (lambda (a b) 0)
		     (lambda (obj) 0)))

  ;;Next index for added comparator.
  ;;
  (define first-comparator-index   9)
  (define *next-comparator-index*  9)
  (define *registered-comparators* (list unknown-object-comparator))

  (define (comparator-register-default! comparator)
    ;;Register a new comparator for use by the default comparator.
    ;;
    ;;This is intended for other  sample implementations to register their comparator
    ;;objects so that they will be correctly used by the default comparator.  Because
    ;;the whole  idea of registering  comparators depends  on the particulars  of the
    ;;sample  implementation,  it  is  not   portable  to  other  implementations  of
    ;;comparators.

    ;;When  COMPARATOR-REGISTER-DEFAULT!   is  invoked  with  a  single  argument,  a
    ;;comparator,  the default  comparator  is extended  to  understand objects  that
    ;;satisfy  the type  test of  the  registered comparator,  and to  apply it  when
    ;;comparing two  objects that satisfy that  type test.  Such objects  are said to
    ;;belong to "registered types", whereas all other objects other than the built-in
    ;;R7RS-small types belong to "unregistered  types".  When dealing with objects of
    ;;unregistered types, the default comparator makes them compare equal and hash to
    ;;0, a safe but fairly useless default.
    ;;
    ;;The  effect of  comparing two  objects of  different registered  types is  only
    ;;partly    predictable,   as    it    depends   on    the    order   in    which
    ;;`comparator-register-default!` is  called.  However,  the normal  guarantees of
    ;;the default comparator still apply.  In  addition, every object of a registered
    ;;type compares less than all objects of unregistered types.
    ;;
    (set! *registered-comparators* (cons comparator *registered-comparators*))
    (set! *next-comparator-index*  (+ *next-comparator-index* 1)))

  (define (object-type obj)
    ;;Return ordinal  for object types:  null sorts  before pairs, which  sort before
    ;;booleans, etc.  Implementations can extend this.
    ;;
    ;;People who call COMPARATOR-REGISTER-DEFAULT! effectively do extend it.
    ;;
    (cond ((null?	obj)	0)
	  ((pair?	obj)	1)
	  ((boolean?	obj)	2)
	  ((char?	obj)	3)
	  ((string?	obj)	4)
	  ((symbol?	obj)	5)
	  ((number?	obj)	6)
	  ((vector?	obj)	7)
	  ((bytevector?	obj)	8)
	  ;;Add more here if you want: be sure to update comparator-index variables.
	  (else
	   (registered-index obj))))

  (define (registered-index obj)
    ;;Return the index for the registered type of OBJ.
    ;;
    (let loop ((i        0)
	       (registry *registered-comparators*))
      (cond ((null? registry)
	     (+ first-comparator-index i))
	    ((comparator-test-type (car registry) obj)
	     (+ first-comparator-index i))
	    (else
	     (loop (add1 i) (cdr registry))))))

  (define (registered-comparator i)
    ;;Given an index, retrieve a registered conductor.  Index must be:
    ;;
    ;;   i >= first-comparator-index
    ;;
    (list-ref *registered-comparators* (- i first-comparator-index)))

  (define (dispatch-equality type a b)
    (case type
      ((0) 0)	;all empty lists are equal
      ((1) (fxzero? (pair-comparison       a b)))
      ((2) (fxzero? (boolean-comparison    a b)))
      ((3) (fxzero? (char-comparison       a b)))
      ((4) (fxzero? (string-comparison     a b)))
      ((5) (fxzero? (symbol-comparison     a b)))
      ((6) (fxzero? (complex-comparison    a b)))
      ((7) (fxzero? (vector-comparison     a b)))
      ((8) (fxzero? (bytevector-comparison a b)))
      ;;Add more here.
      (else
       (comparator-equal? (registered-comparator type) a b))))

  (define (dispatch-comparison type a b)
    (case type
      ((0) 0)	;all empty lists are equal
      ((1) (pair-comparison       a b))
      ((2) (boolean-comparison    a b))
      ((3) (char-comparison       a b))
      ((4) (string-comparison     a b))
      ((5) (symbol-comparison     a b))
      ((6) (complex-comparison    a b))
      ((7) (vector-comparison     a b))
      ((8) (bytevector-comparison a b))
      ;;Add more here.
      (else
       (comparator-compare (registered-comparator type) a b))))

  (define (default-hash-function obj)
    (case (object-type obj)
      ((0) 0)
      ((1) (pair-hash       obj))
      ((2) (boolean-hash    obj))
      ((3) (char-hash       obj))
      ((4) (string-hash     obj))
      ((5) (symbol-hash     obj))
      ((6) (number-hash     obj))
      ((7) (vector-hash     obj))
      ((8) (bytevector-hash obj))
      ;;Add more here.
      (else
       (comparator-hash (registered-comparator (object-type obj)) obj))))

  (define (default-comparison a b)
    (let ((a-type (object-type a))
	  (b-type (object-type b)))
      (cond ((< a-type b-type)	-1)
	    ((> a-type b-type)	+1)
	    (else
	     (dispatch-comparison a-type a b)))))

  (define (default-equality a b)
    (let ((a-type (object-type a))
	  (b-type (object-type b)))
      (if (= a-type b-type)
	  (dispatch-equality a-type a b)
	#f)))

  (define default-comparator
    (make-comparator #t
		     default-equality
		     default-comparison
		     default-hash-function))

  #| end of module |# )


;;;; comparison predicate constructors

(define (make= comparator)
  (lambda args (apply =? comparator args)))

(define (make< comparator)
  (lambda args (apply <? comparator args)))

(define (make> comparator)
  (lambda args (apply >? comparator args)))

(define (make<= comparator)
  (lambda args (apply <=? comparator args)))

(define (make>= comparator)
  (lambda args (apply >=? comparator args)))


;;;; interval (ternary) comparison predicates

(define in-open-interval?
  (case-lambda
   ((comparator a b c)
    (and (<? comparator a b)
	 (<? comparator b c)))
   ((a b c)
    (in-open-interval? default-comparator a b c))))

(define in-closed-interval?
  (case-lambda
   ((comparator a b c)
    (and (<=? comparator a b)
	 (<=? comparator b c)))
   ((a b c)
    (in-closed-interval? default-comparator a b c))))

(define in-open-closed-interval?
  (case-lambda
   ((comparator a b c)
    (and (<? comparator a b)
	 (<=? comparator b c)))
   ((a b c)
    (in-open-interval? default-comparator a b c))))

(define in-closed-open-interval?
  (case-lambda
   ((comparator a b c)
    (and (<=? comparator a b)
	 (<? comparator b c)))
   ((a b c)
    (in-open-interval? default-comparator a b c))))


;;;; comparison predicates

(define (=? comparator a b . objs)
  (if (comparator-equal? comparator a b)
      (if (null? objs)
	  #t
	(apply =? comparator b objs))
    #f))

(define (<? comparator a b . objs)
  (if (eqv? (comparator-compare comparator a b) -1)
      (if (null? objs)
	  #t
	(apply <? comparator b objs))
    #f))

(define (>? comparator a b . objs)
  (if (eqv? (comparator-compare comparator a b) 1)
      (if (null? objs)
	  #t
	(apply >? comparator b objs))
    #f))

(define (<=? comparator a b . objs)
  (if (not (eqv? (comparator-compare comparator a b) 1))
      (if (null? objs)
	  #t
	(apply <=? comparator b objs))
    #f))

(define (>=? comparator a b . objs)
  (if (not (eqv? (comparator-compare comparator a b) -1))
      (if (null? objs)
	  #t
	(apply >=? comparator b objs))
    #f))


;;; minimum and maximum comparison predicate

(define comparator-min
  (case-lambda
   ((comparator a)
    a)
   ((comparator a b)
    (if (<? comparator a b) a b))
   ((comparator a b . objs)
    (comparator-min comparator a (apply comparator-min comparator b objs)))))

(define comparator-max
  (case-lambda
   ((comparator a)
    a)
   ((comparator a b)
    (if (>? comparator a b) a b))
   ((comparator a b . objs)
    (comparator-max comparator a (apply comparator-max comparator b objs)))))


;;;; standard comparators and comparator constructors: standard atomic comparators

(define (boolean-comparison a b)
  (cond ((and a b)	0)
	(a		+1)
	(b		-1)
	(else		0)))

(define (boolean-hash obj)
  (if obj 1 0))

(define boolean-comparator
  (make-comparator boolean? boolean=? boolean-comparison boolean-hash))

;;; --------------------------------------------------------------------

(define char-comparison (make-comparison=/< char=? char<?))

(define (char-hash obj)
  (abs (char->integer obj)))

(define char-comparator
  (make-comparator char? char=? char-comparison char-hash))

;;; --------------------------------------------------------------------

(define char-ci-comparison
  (make-comparison=/< char-ci=? char-ci<?))

(define (char-ci-hash obj)
  (abs (char->integer (char-foldcase obj))))

(define char-ci-comparator
  (make-comparator char? char-ci=? char-ci-comparison char-ci-hash))

;;; --------------------------------------------------------------------

(define string-comparison
  (make-comparison=/< string=? string<?))

(define string-ci-comparison
  (make-comparison=/< string-ci=? string-ci<?))

;;; --------------------------------------------------------------------

(define (symbol<? a b)
  (string<? (symbol->string a) (symbol->string b)))

(define symbol-comparison
  (make-comparison=/< symbol=? symbol<?))

;;; --------------------------------------------------------------------

(define (real-comparison a b)
  ;;Comparison procedure for real numbers only.
  ;;
  (cond ((< a b)	-1)
	((> a b)	+1)
	(else		0)))

(define (complex-comparison a b)
  ;;Comparison procedure for non-real numbers.
  ;;
  (let ((real-result (real-comparison (real-part a)
				      (real-part b))))
    (if (= real-result 0)
	(real-comparison (imag-part a)
			 (imag-part b))
      real-result)))

(define (number-hash obj)
  (exact (round (magnitude obj))))

(define number-comparator
  (make-comparator number? = complex-comparison number-hash))

(define complex-comparator
  (make-comparator complex? = complex-comparison number-hash))

(define real-comparator
  (make-comparator real? = real-comparison number-hash))

(define rational-comparator
  (make-comparator rational? = real-comparison number-hash))

(define integer-comparator
  (make-comparator integer? = real-comparison number-hash))

(define exact-integer-comparator
  (make-comparator exact-integer? = real-comparison number-hash))

;;; --------------------------------------------------------------------
;;; inexact real comparator

(define (inexact-real? obj)
  ;;Test procedure for inexact reals.
  ;;
  (and (number?  obj)
       (inexact? obj)
       (real?    obj)))

(define (rounded-to x epsilon rounding)
  ;;Return a number appropriately rounded to EPSILON.
  ;;
  (let ((quo (/ x epsilon)))
    (if (procedure? rounding)
	(rounding x epsilon)
      (case rounding
	((round)	(round    quo))
	((ceiling)	(ceiling  quo))
	((floor)	(floor    quo))
	((truncate)	(truncate quo))
	(else
	 (error __who__
	   "invalid rounding specification" rounding))))))

(define (nan-comparison nan-handling which other)
  ;;Return result of comparing a NaN with a non-NaN.
  ;;
  (if (procedure? nan-handling)
      (nan-handling other)
    (case nan-handling
      ((error)
       (error __who__
	 "attempt to compare NaN with non-NaN" nan-handling which other))
      ((min)
       (if (eq? which 'a-nan) -1 1))
      ((max)
       (if (eq? which 'a-nan) 1 -1))
      (else
       (error __who__
	 "invalid nan-handling specification" nan-handling)))))

(define (make-inexact-real-comparison epsilon rounding nan-handling)
  (lambda (a b)
    (let ((a-nan? (nan? a))
	  (b-nan? (nan? b)))
      (cond ((and a-nan? b-nan?)
	     0)
	    (a-nan?
	     (nan-comparison nan-handling 'a-nan b))
	    (b-nan?
	     (nan-comparison nan-handling 'b-nan a))
	    (else
	     (real-comparison (rounded-to a epsilon rounding)
			      (rounded-to b epsilon rounding)))))))

(define (make-inexact-real-hash epsilon rounding)
  ;;Return 0 for NaN, number-hash otherwise.
  ;;
  (lambda (obj)
    (if (nan? obj)
	0
      (number-hash (rounded-to obj epsilon rounding)))))

(define (make-inexact-real-comparator epsilon rounding nan-handling)
  (make-comparator inexact-real?
		   #t
		   (make-inexact-real-comparison epsilon rounding nan-handling)
		   (make-inexact-real-hash       epsilon rounding)))


;;;; standard comparators and comparator constructors: sequence comparator constructors and comparators
;;
;;The hash functions are  based on djb2, but modulo 2^20 instead of  2^32 in hopes of
;;sticking to fixnums.
;;

(define-constant LIMIT
  (expt 2 20))

;;; --------------------------------------------------------------------

(define (make-listwise-comparison comparison null? car cdr)
  ;;Make a comparison procedure that works listwise.
  ;;
  (letrec ((proc (lambda (a b)
		   (let ((a-null? (null? a))
			 (b-null? (null? b)))
		     (cond ((and a-null? b-null?)	0)
			   (a-null?			-1)
			   (b-null?			+1)
			   (else
			    (let ((result (comparison (car a) (car b))))
			      (if (= result 0)
				  (proc (cdr a) (cdr b))
				result))))))))
    proc))

(define (make-listwise-hash hash null? car cdr)
  ;;Make a hash function that works listwise.
  ;;
  (lambda (obj)
    (let loop ((obj    obj)
	       (result 5381))
      (if (null? obj)
	  0
        (let* ((prod (modulo (* result 33) LIMIT))
               (sum (+ prod (hash (car obj)))))
          (loop (cdr obj) sum))))))

;;; --------------------------------------------------------------------

(define (make-vectorwise-comparison comparison length ref)
  ;;Make a comparison procedure that works vectorwise.
  ;;
  (lambda (a b)
    (let* ((a-length (length a))
           (b-length (length b))
           (last-index (- a-length 1)))
      (cond ((< a-length b-length)	-1)
	    ((> a-length b-length)	+1)
	    (else
	     (call/cc
		 (lambda (return)
		   (let loop ((index 0))
		     (let ((result (comparison (ref a index)
					       (ref b index))))
		       (if (zero? result)
			   (if (= index last-index)
			       0
			     (loop (add1 index)))
			 result))))))))))

(define (make-vectorwise-hash hash length ref)
  ;;Make a hash function that works vectorwise.
  ;;
  (lambda (obj)
    (let loop ((index   (- (length obj) 1))
	       (result  5381))
      (if (= index 0)
	  result
        (let* ((prod (modulo (* result 33)
			     LIMIT))
               (sum  (modulo (+ prod (hash (ref obj index)))
			     LIMIT)))
          (loop (sub1 index) sum))))))

;;; --------------------------------------------------------------------

;;Already defined by R6RS.
;;
;; (define string-hash
;;   (make-vectorwise-hash char-hash string-length string-ref))

(define string-comparator
  (make-comparator string? string=? string-comparison string-hash))

;;Already defined by R6RS.
;;
;; (define (string-ci-hash obj)
;;   (string-hash (string-foldcase obj)))

(define string-ci-comparator
  (make-comparator string? string-ci=? string-ci-comparison string-ci-hash))

;;; --------------------------------------------------------------------

;;Already defined by R6RS.
;;
;; (define (symbol-hash obj)
;;   (string-hash (symbol->string obj)))

(define symbol-comparator
  (make-comparator symbol? symbol=? symbol-comparison symbol-hash))

;;; --------------------------------------------------------------------

(define (make-listwise-comparator test comparator null? car cdr)
  (make-comparator test
		   #t
		   (make-listwise-comparison (comparator-comparison-procedure comparator) null? car cdr)
		   (make-listwise-hash       (comparator-hash-function        comparator) null? car cdr)))

(define (make-vectorwise-comparator test comparator length ref)
  (make-comparator test
		   #t
		   (make-vectorwise-comparison (comparator-comparison-procedure comparator) length ref)
		   (make-vectorwise-hash       (comparator-hash-function        comparator) length ref)))

;;; --------------------------------------------------------------------

(define (make-list-comparator comparator)
  (make-listwise-comparator (lambda (obj)
			      (or (null? obj)
				  (pair? obj)))
			    comparator null? car cdr))

(define list-comparator
  (make-list-comparator default-comparator))

;;; --------------------------------------------------------------------

(define (make-vector-comparator comparator)
  (make-vectorwise-comparator vector? comparator vector-length vector-ref))

(define vector-comparator
  (make-vector-comparator default-comparator))

(define vector-comparison
  (comparator-comparison-procedure vector-comparator))

(define vector-hash
  (comparator-hash-function vector-comparator))

;;; --------------------------------------------------------------------

(define (make-bytevector-comparator comparator)
  (make-vectorwise-comparator bytevector? comparator bytevector-length bytevector-u8-ref))

(define bytevector-comparator
  (make-bytevector-comparator default-comparator))

(define bytevector-comparison
  (comparator-comparison-procedure bytevector-comparator))

;;Already defined by Vicare.
;;
;; (define bytevector-hash
;;   (comparator-hash-function bytevector-comparator))

;;; --------------------------------------------------------------------
;;; pair comparator constructors

(define (make-car-comparator comparator)
  (make-comparator pair?
		   #t
		   (lambda (a b)
		     (comparator-compare comparator (car a) (car b)))
		   (lambda (obj)
		     (comparator-hash-function comparator))))

(define (make-cdr-comparator comparator)
  (make-comparator pair?
		   #t
		   (lambda (a b)
		     (comparator-compare comparator (cdr a) (cdr b)))
		   (lambda (obj)
		     (comparator-hash comparator obj))))

(define (make-pair-comparison car-comparator cdr-comparator)
  (lambda (a b)
    (let ((result (comparator-compare car-comparator (car a) (car b))))
      (if (zero? result)
	  (comparator-compare cdr-comparator (cdr a) (cdr b))
        result))))

(define pair-comparison
  (make-pair-comparison default-comparator default-comparator))

(define (make-pair-hash car-comparator cdr-comparator)
  (lambda (obj)
    (+
     (comparator-hash car-comparator (car obj))
     (comparator-hash cdr-comparator (cdr obj)))))

(define (make-pair-comparator car-comparator cdr-comparator)
  (make-comparator
   pair?
   #t
   (make-pair-comparison car-comparator cdr-comparator)
   (make-pair-hash car-comparator cdr-comparator)))

(define pair-comparator
  (make-pair-comparator default-comparator default-comparator))
(define pair-hash (comparator-hash-function pair-comparator))

;;; --------------------------------------------------------------------

(define (improper-list-type obj)
  ;;Compute type index for inexact list comparisons.
  ;;
  (cond ((null? obj)	0)
	((pair? obj)	1)
	(else		2)))

(define (make-improper-list-comparison comparator)
  (let ((pair-comparison (make-pair-comparison comparator comparator)))
    (lambda (a b)
      (let* ((a-type (improper-list-type a))
	     (b-type (improper-list-type b))
	     (result (real-comparison a-type b-type)))
        (cond ((not (= result 0))
	       result)
	      ((null? a)
	       0)
	      ((pair? a)
	       (pair-comparison a b))
	      (else
	       (comparator-compare comparator a b)))))))

(define (make-improper-list-hash comparator)
  (lambda (obj)
    (cond ((null? obj)
	   0)
	  ((pair? obj)
	   (+ (comparator-hash comparator (car obj))
	      (comparator-hash comparator (cdr obj))))
	  (else
	   (comparator-hash comparator obj)))))

(define (make-improper-list-comparator comparator)
  (make-comparator #t
		   #t
		   (make-improper-list-comparison comparator)
		   (make-improper-list-hash       comparator)))


;;;; wrapped equality predicates
;;
;;These comparators don't have comparison functions.
;;

(define eq-comparator
  (make-comparator #t
		   eq?
		   #f
		   default-hash-function))

(define eqv-comparator
  (make-comparator #t
		   eqv?
		   #f
		   default-hash-function))

(define equal-comparator
  (make-comparator #t
		   equal?
		   #f
		   default-hash-function))


;;;; comparators constructed from other comparators

;;; Selecting comparator: finds the first one that type-tests

(define (matching-comparator obj comparators)
  (cond ((null? comparators)
	 #f)
	((comparator-test-type (car comparators) obj)
	 (car comparators))
	(else
	 (matching-comparator obj (cdr comparators)))))

(define (selected-type-test . comparators)
  (lambda (obj)
    (if (matching-comparator obj comparators) #t #f)))

(define (selected-equality-predicate comparators)
  (lambda (a b)
    (let ((comparator (matching-comparator a comparators)))
      (if comparator
	  (comparator-equal? comparator a b)
        (error __who__ "no comparator can be selected" a b)))))

(define (selected-comparison-procedure comparators)
  (lambda (a b)
    (let ((comparator (matching-comparator a comparators)))
      (if comparator
	  (comparator-compare comparator a b)
        (error __who__ "no comparator can be selected" a b)))))

(define (selected-hash-function comparators)
  (lambda (obj)
    (let ((comparator (matching-comparator obj comparators)))
      (if comparator
	  (comparator-hash comparator obj)
        (error __who__ "no comparator can be selected" obj)))))

(define (make-selecting-comparator . comparators)
  (make-comparator (selected-type-test             comparators)
		   (selected-equality-predicate    comparators)
		   (selected-comparison-procedure  comparators)
		   (selected-hash-function         comparators)))

;;; --------------------------------------------------------------------

;;Refining comparator: uses all type-matching comparators until one is found that can
;;discriminate

(define (refined-equality-predicate comparators)
  (lambda (a b)
    (let loop ((comparator (matching-comparator a comparators))
               (first?     #t))
      (if comparator
	  (if (comparator-equal? comparator a b)
	      (loop (matching-comparator a comparators) #f)
	    #f)
        (if first?
	    (error __who__ "no comparator can be selected" a b)
	  #t)))))

(define (refined-comparison-procedure comparators)
  (lambda (a b)
    (let loop ((comparator (matching-comparator a comparators))
               (first?     #t))
      (if comparator
	  (let ((result (comparator-compare comparator a b)))
	    (if (eqv? result 0)
		(loop (matching-comparator a comparators) #f)
	      result))
        (if first?
	    (error __who__ "no comparator can be selected" a b)
	  0)))))

(define (refined-hash-function comparators)
  (lambda (obj)
    (let loop ((comparators      comparators)
	       (last-comparator  #f))
      (if (null? comparators)
	  (if last-comparator
	      (comparator-hash last-comparator obj)
	    (error __who__ "no comparator can be selected" obj))
	(if (comparator-test-type (car comparators) obj)
	    (loop (cdr comparators)
		  (car comparators))
	  (loop (cdr comparators)
		last-comparator))))))

(define (make-refining-comparator . comparators)
  (make-comparator (selected-type-test           comparators)
		   (refined-equality-predicate   comparators)
		   (refined-comparison-procedure comparators)
		   (refined-hash-function        comparators)))

(define (make-reverse-comparator comparator)
  ;;Reverse the sense of the comparator.
  ;;
  (make-comparator (comparator-type-test-procedure comparator)
		   (comparator-equality-predicate  comparator)
		   (lambda (a b)
		     (- (comparator-compare comparator a b)))
		   (comparator-hash-function comparator)))


;;;; handy debug-assert procedures for debugging comparators

(define (debug-assert bool who what)
  (unless bool
    (error #f
      (string-append (symbol->string what)
		     " failure in "
		     (symbol->string who)))))

(define (debug-deny bool who what)
  (debug-assert (not bool) who what))


;;;; checkers for debugging comparators

(define (check-type-test comparator a)
  (debug-assert (comparator-test-type comparator a) 'type 'validity))

(define (check-reflexive-equality comparator a)
  (debug-assert (comparator-equal? comparator a a) 'equality 'reflexive))

(define (check-reflexive-comparison comparator a)
  (debug-assert (eqv? (comparator-compare comparator a a) 0) 'comparison 'reflexive))

(define (check-symmetric-equality comparator a b)
  (when (comparator-equal? comparator a b)
    (debug-assert (comparator-equal? comparator b a) 'equality 'symmetric))
  (when (not (comparator-equal? comparator a b))
    (debug-deny   (comparator-equal? comparator b a) 'equality 'symmetric)))

(define (check-asymmetric-comparison comparator a b)
  (debug-assert (eqv? (comparator-compare comparator a b)
		      (- (comparator-compare comparator a b)))
		'comparison 'asymmetric))

(define (check-transitive-equality comparator a b c)
  (and (comparator-equal? comparator a b)
       (comparator-equal? comparator b c)
       (debug-assert (comparator-equal? comparator a c) 'equality 'transitive))
  (and (comparator-equal? comparator a b)
       (not (comparator-equal? comparator b c))
       (debug-deny (comparator-equal? comparator a c) 'equality 'transitive))
  (and (not (comparator-equal? comparator a b))
       (comparator-equal? comparator b c)
       (debug-deny (comparator-equal? comparator a c) 'equality 'transitive)))

(define (check-transitive-comparison comparator a b c)
  (define-syntax-rule (<= ?x ?y)
    (<=? comparator ?x ?y))
  (and (<= b a) (<= a c) (debug-assert (<= b c) 'comparison 'transitive))
  (and (<= c a) (<= a b) (debug-assert (<= c b) 'comparison 'transitive))
  (and (<= a b) (<= b c) (debug-assert (<= a c) 'comparison 'transitive))
  (and (<= c b) (<= b a) (debug-assert (<= c a) 'comparison 'transitive))
  (and (<= a c) (<= c b) (debug-assert (<= a b) 'comparison 'transitive))
  (and (<= b c) (<= c a) (debug-assert (<= b a) 'comparison 'transitive)))

(define (check-hash-value value)
  (debug-assert (and (positive? value) (exact-integer? value))
		'validity 'hash-value))

(define (check-all comparator a b c c?)
  (check-type-test comparator a)
  (check-type-test comparator b)
  (if c? (check-type-test comparator c))
  (check-reflexive-equality comparator a)
  (check-reflexive-equality comparator b)
  (if c? (check-reflexive-equality comparator c))
  (check-reflexive-comparison comparator a)
  (check-reflexive-comparison comparator b)
  (if c? (check-reflexive-comparison comparator c))
  (check-symmetric-equality comparator a b)
  (if c? (check-symmetric-equality comparator b c))
  (if c? (check-symmetric-equality comparator a c))
  (check-asymmetric-comparison comparator a b)
  (if c? (check-asymmetric-comparison comparator b c))
  (if c? (check-asymmetric-comparison comparator a c))
  (if c? (check-transitive-equality comparator a b c))
  (if c? (check-transitive-comparison comparator a b c)))

(define (make-debug-comparator comparator)
  (let ((c #f) (c? #f))
    (comparator-comparison-procedure? comparator)
    (make-comparator
     (comparator-type-test-procedure comparator)
     (lambda (a b)
       (check-all comparator a b c c?)
       (when (not c?) (set! c a) (set! c? #t))
       (comparator-equal? comparator a b))
     (if (comparator-comparison-procedure? comparator)
	 (lambda (a b)
	   (check-all comparator a b c c?)
	   (when (not c?) (set! c b) (set! c? #t))
	   (comparator-compare comparator a b))
       #f)
     (if (comparator-hash-function? comparator)
	 (lambda (obj)
	   (let ((value (comparator-hash comparator obj)))
	     (check-hash-value value)
	     value))
       #f))))


;;;; done

#| end of library |# )

;;; end of file
;; Local Variables:
;; mode: vicare
;; coding: utf-8
;; End: