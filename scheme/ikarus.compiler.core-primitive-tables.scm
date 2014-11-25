;;; -*- coding: utf-8-unix -*-
;;;
;;;Part of: Vicare Scheme
;;;Contents: tables of core primitive properties
;;;Date: Sat Sep 20, 2014
;;;
;;;Abstract
;;;
;;;   This file  contains a  table of  core primitive  properties for  both primitive
;;;   functions and primitive operations.
;;;
;;;
;;;Core type signatures
;;;--------------------
;;;
;;;Used by  the compiler  passes "core type  inference", "introduce  unsafe primitive
;;;references" and "specify representation" to:
;;;
;;;*  Validate the  input  code, detecting  operands  of invalid  core  type in  core
;;;primitive  applications.
;;;
;;;*  Substitute  the  application  of   safe  primitives  with  application  of  the
;;;corresponding unsafe  primitives, whenever  it is known  at compile-time  that the
;;;operands are of the correct type.
;;;
;;;*  Generate  optimised  integrated  code  to implement  the  application  of  core
;;;primitive operations.
;;;
;;;Core  type  signatures  are   specified  via  the  ?CORE-SIGNATURES-SPEC  symbolic
;;;expression:
;;;
;;;   ?core-signatures-spec  = (signatures ?sign-spec ...)
;;;   ?sign-spec             = (?arguments-spec => ?return-values-spec)
;;;   ?arguments-spec        = (?core-type-tag ... . ())
;;;                          | (?core-type-tag ... . ?core-type-tag)
;;;   ?return-values-spec    = (?core-type-tag ... . ())
;;;                          | (?core-type-tag ... . ?core-type-tag)
;;;
;;;where SIGNATURES is an auxiliary syntax and ?CORE-TYPE-TAG is an identifier among:
;;;"T:object", "T:fixnum", ..., with "_" acting as wildcard equivalent to "T:object".
;;;
;;;Whenever a  core type signature  is examined by  the compiler: the  ?SIGN-SPEC are
;;;considered in the order  in which they appear in the  declaration (left to right),
;;;stopping at the first that matches the operands.
;;;
;;;Example:
;;;
;;;   (signatures
;;;	((T:fixnum)	=> (T:true))
;;;	((_)		=> (T:boolean)))
;;;
;;;this ?CORE-SIGNATURES-SPEC specifies that:
;;;
;;;* When the core primitive is applied  to a single operand of type "T:fixnum" there
;;;is a single return value of type "T:true".
;;;
;;;* When the core primitive is applied  to a single operand of unspecified type (but
;;;not "T:fixnum") there is a single return value of type "T:boolean".
;;;
;;;
;;;Core primitive attributes
;;;-------------------------
;;;
;;;Used  by  the  source  optimiser  to  precompute  the  result  of  core  primitive
;;;applications.   A tuple  of  attributes  can be  specified  for  a core  primitive
;;;invocation with  selected number  of operands;  if a primitive  can be  applied to
;;;different  numbers  of  operands,  each  arity  can  have  a  different  tuple  of
;;;attributes.
;;;
;;;Attributes are specified via the ?ATTRIBUTES-SPEC symbolic expression:
;;;
;;;   ?attributes-spec  = (attributes ?attr-spec)
;;;   ?attr-spec        = (?attr-signature . ?attr-tuple)
;;;   ?attr-signature   = (?operand-spec ... . ?operand-spec)
;;;   ?operand-spec     = _ | 0 | #f | ()
;;;   ?attr-tuple       = (?attr-symbol ...)
;;;   ?attr-symbol      = effect-free | foldable | result-true | result-false
;;;
;;;where ATTRIBUTES is an auxiliary syntax and the attributes are the symbols:
;;;
;;;   effect-free -  The application produces no side effects.
;;;
;;;   foldable -     The application can be precomputed at compile time.
;;;
;;;   result-true -  The application always has non-#f result.
;;;
;;;   result-false - The application always has #f result.
;;;
;;;The ?OPERAND-SPEC can be the symbol "_"  to represent any operand or one among: 0,
;;;#f, () to represent an operand that is known at compile-time to be such datum.
;;;
;;;Example:
;;;
;;;   (attributes
;;;     (()		foldable)
;;;     ((_)		effect-free)
;;;     ((_ _)		result-true)
;;;     ((_ _ _ . _)    result-false))
;;;
;;;this ?ATTRIBUTES-SPEC specifies that:
;;;
;;;* The core primitive can be applied to 0, 1, 2, 3 or more operands.
;;;
;;;* When the number of operands is 0: the application is foldable.
;;;
;;;* When the number of operands is 1: the application has no side effects.
;;;
;;;* When the number of operands is 2: the application always returns non-false.
;;;
;;;* When the number of operands is 3 or more: the application always returns false.
;;;
;;;
;;;Copyright (C) 2014 Marco Maggi <marco.maggi-ipsu@poste.it>
;;;
;;;This program is free software: you can  redistribute it and/or modify it under the
;;;terms  of  the GNU  General  Public  License as  published  by  the Free  Software
;;;Foundation,  either version  3  of the  License,  or (at  your  option) any  later
;;;version.
;;;
;;;This program is  distributed in the hope  that it will be useful,  but WITHOUT ANY
;;;WARRANTY; without  even the implied warranty  of MERCHANTABILITY or FITNESS  FOR A
;;;PARTICULAR PURPOSE.  See the GNU General Public License for more details.
;;;
;;;You should have received a copy of  the GNU General Public License along with this
;;;program.  If not, see <http://www.gnu.org/licenses/>.
;;;


;;;; syntax helpers

(define-syntax /section
  (syntax-rules ()))

(define-syntax section
  ;;By enclosing code in:
  ;;
  ;;   (section ?body ... /section)
  ;;
  ;;we can comment out a section by just commenting out the form:
  ;;
  ;;   #;(section ?body ... /section)
  ;;
  ;;This is sometimes useful when debugging.
  ;;
  (syntax-rules (/section)
    ((section ?body ... /section)
     (begin ?body ...))))


;;;; syntax helpers: predicates

(define-syntax declare-type-predicate
  ;;Usage examples:
  ;;
  ;;   (declare-type-predicate fixnum? T:fixnum)
  ;;   (declare-type-predicate vector? T:vector)
  ;;
  (syntax-rules ()
    ((_ ?who)
     (declare-core-primitive ?who
	 (safe)
       (signatures
	((_)		=> (T:boolean)))
       (attributes
	((_)		foldable effect-free))))
    ((_ ?who ?obj-tag)
     (declare-core-primitive ?who
	 (safe)
       (signatures
	((?obj-tag)	=> (T:true))
	((_)		=> (T:boolean)))
       (attributes
	((_)		foldable effect-free))))
    ))

;;; --------------------------------------------------------------------

(module (define-object-predicate-declarer)

  (define-syntax define-object-predicate-declarer
    ;;Usage examples:
    ;;
    ;;   (define-object-predicate-declarer declare-number-predicate T:number)
    ;;   (declare-number-predicate zero?)
    ;;   (declare-number-predicate positive?)
    ;;   (declare-number-predicate negative?)
    ;;
    (syntax-rules ()
      ((_ ?declarer ?obj-tag)
       (define-syntax ?declarer
	 (syntax-rules (safe unsafe replacements)
	   ((_ ?who)						(%define-predicate ?who ?obj-tag safe   (replacements)))
	   ((_ ?who safe)					(%define-predicate ?who ?obj-tag safe   (replacements)))
	   ((_ ?who unsafe)					(%define-predicate ?who ?obj-tag unsafe (replacements)))

	   ((_ ?who		(replacements . ?replacements))	(%define-predicate ?who ?obj-tag safe   (replacements . ?replacements)))
	   ((_ ?who safe	(replacements . ?replacements))	(%define-predicate ?who ?obj-tag safe   (replacements . ?replacements)))
	   ((_ ?who unsafe	(replacements . ?replacements))	(%define-predicate ?who ?obj-tag unsafe (replacements . ?replacements)))
	   )))
      ))

  (define-syntax %define-predicate
    (syntax-rules (replacements)
      ((_ ?who ?obj-tag ?safety (replacements . ?replacements))
       (declare-core-primitive ?who
	   (?safety)
	 (signatures
	  ((?obj-tag)		=> (T:boolean)))
	 (attributes
	  ((_)			foldable effect-free))
	 (replacements . ?replacements)))
      ))

  #| end of module: DEFINE-OBJECT-PREDICATE-DECLARER |# )

(define-object-predicate-declarer declare-object-predicate T:object)
(define-object-predicate-declarer declare-number-predicate T:number)
(define-object-predicate-declarer declare-fixnum-predicate T:fixnum)
(define-object-predicate-declarer declare-ratnum-predicate T:ratnum)
(define-object-predicate-declarer declare-bignum-predicate T:bignum)
(define-object-predicate-declarer declare-flonum-predicate T:flonum)
(define-object-predicate-declarer declare-char-predicate T:char)
(define-object-predicate-declarer declare-string-predicate T:string)
(define-object-predicate-declarer declare-keyword-predicate T:keyword)
(define-object-predicate-declarer declare-vector-predicate T:vector)


;;;; syntax helpers: comparison functions

(module (define-object-binary-comparison-declarer)

  (define-syntax define-object-binary-comparison-declarer
    ;;Usage examples:
    ;;
    ;;   (define-object-binary-comparison-declarer declare-object-binary-comparison _)
    ;;   (declare-object-binary-comparison eq?)
    ;;   (declare-object-binary-comparison eqv?)
    ;;   (declare-object-binary-comparison equal?)
    ;;
    (syntax-rules (safe unsafe replacements)
      ((_ ?declarer ?type-tag)
       (define-syntax ?declarer
	 (syntax-rules (safe unsafe replacements)
	   ((_ ?who)						(%define-declarer ?who ?type-tag safe   (replacements)))
	   ((_ ?who safe)					(%define-declarer ?who ?type-tag safe   (replacements)))
	   ((_ ?who unsafe)					(%define-declarer ?who ?type-tag unsafe (replacements)))

	   ((_ ?who        (replacements . ?replacements))	(%define-declarer ?who ?type-tag safe   (replacements . ?replacements)))
	   ((_ ?who safe   (replacements . ?replacements))	(%define-declarer ?who ?type-tag safe   (replacements . ?replacements)))
	   ((_ ?who unsafe (replacements . ?replacements))	(%define-declarer ?who ?type-tag unsafe (replacements . ?replacements)))
	   )))
      ))

  (define-syntax %define-declarer
    (syntax-rules (replacements)
      ((_ ?who ?type-tag ?safety (replacements . ?replacements))
       (declare-core-primitive ?who
	   (?safety)
	 (signatures
	  ((?type-tag ?type-tag)	=> (T:boolean)))
	 (attributes
	  ((_ _)			foldable effect-free))))
      ))

  #| end of module: DEFINE-OBJECT-BINARY-COMPARISON-DECLARER |# )

(define-object-binary-comparison-declarer declare-object-binary-comparison T:object)
(define-object-binary-comparison-declarer declare-fixnum-binary-comparison T:fixnum)
(define-object-binary-comparison-declarer declare-flonum-binary-comparison T:flonum)
(define-object-binary-comparison-declarer declare-number-binary-comparison T:number)
(define-object-binary-comparison-declarer declare-pointer-binary-comparison T:pointer)
(define-object-binary-comparison-declarer declare-char-binary-comparison T:char)
(define-object-binary-comparison-declarer declare-string-binary-comparison T:string)
(define-object-binary-comparison-declarer declare-keyword-binary-comparison T:keyword)

;;; --------------------------------------------------------------------

(module (define-object-unary/multi-comparison-declarer)

  (define-syntax define-object-unary/multi-comparison-declarer
    ;;Usage examples:
    ;;
    ;;   (define-object-unary/multi-comparison-declarer declare-flonum-unary/multi-comparison T:flonum)
    ;;   (declare-flonum-unary/multi-comparison fl=?)
    ;;   (declare-flonum-unary/multi-comparison fl<?)
    ;;   (declare-flonum-unary/multi-comparison fl>?)
    ;;
    (syntax-rules (safe unsafe replacements)
      ((_ ?declarer ?type-tag)
       (define-syntax ?declarer
	 (syntax-rules (safe unsafe replacements)
	   ((_ ?who)						(%define-declarer ?who ?type-tag safe   (replacements)))
	   ((_ ?who safe)					(%define-declarer ?who ?type-tag safe   (replacements)))
	   ((_ ?who unsafe)					(%define-declarer ?who ?type-tag unsafe (replacements)))

	   ((_ ?who        (replacements . ?replacements))	(%define-declarer ?who ?type-tag safe   (replacements . ?replacements)))
	   ((_ ?who safe   (replacements . ?replacements))	(%define-declarer ?who ?type-tag safe   (replacements . ?replacements)))
	   ((_ ?who unsafe (replacements . ?replacements))	(%define-declarer ?who ?type-tag unsafe (replacements . ?replacements)))
	   )))
      ))

  (define-syntax %define-declarer
    (syntax-rules (replacements)
      ((_ ?who ?type-tag ?safety (replacements . ?replacements))
       (declare-core-primitive ?who
	   (?safety)
	 (signatures
	  ((?type-tag)				=> (T:boolean))
	  ((?type-tag ?type-tag)		=> (T:boolean))
	  ((?type-tag ?type-tag . ?type-tag)	=> (T:boolean)))
	 (attributes
	  ((_)				foldable effect-free)
	  ((_ _)			foldable effect-free)
	  ((_ _ . _)			foldable effect-free))))
      ))

  #| end of module: DEFINE-OBJECT-UNARY/MULTI-COMPARISON-DECLARER |# )

(define-object-unary/multi-comparison-declarer declare-number-unary/multi-comparison T:number)
(define-object-unary/multi-comparison-declarer declare-fixnum-unary/multi-comparison T:fixnum)
(define-object-unary/multi-comparison-declarer declare-flonum-unary/multi-comparison T:flonum)
(define-object-unary/multi-comparison-declarer declare-string-unary/multi-comparison T:string)

;;; --------------------------------------------------------------------

(module (define-object-binary/multi-comparison-declarer)

  (define-syntax define-object-binary/multi-comparison-declarer
    ;;Usage examples:
    ;;
    ;;   (define-object-binary/multi-comparison-declarer declare-char-binary/multi-comparison T:char)
    ;;   (declare-char-binary/multi-comparison char=?)
    ;;   (declare-char-binary/multi-comparison char<?)
    ;;   (declare-char-binary/multi-comparison char>?)
    ;;
    (syntax-rules (safe unsafe replacements)
      ((_ ?declarer ?type-tag)
       (define-syntax ?declarer
	 (syntax-rules (safe unsafe replacements)
	   ((_ ?who)						(%define-declarer ?who ?type-tag safe   (replacements)))
	   ((_ ?who safe)					(%define-declarer ?who ?type-tag safe   (replacements)))
	   ((_ ?who unsafe)					(%define-declarer ?who ?type-tag unsafe (replacements)))

	   ((_ ?who        (replacements . ?replacements))	(%define-declarer ?who ?type-tag safe   (replacements . ?replacements)))
	   ((_ ?who safe   (replacements . ?replacements))	(%define-declarer ?who ?type-tag safe   (replacements . ?replacements)))
	   ((_ ?who unsafe (replacements . ?replacements))	(%define-declarer ?who ?type-tag unsafe (replacements . ?replacements)))
	   )))
      ))

  (define-syntax %define-declarer
    (syntax-rules (replacements)
      ((_ ?who ?type-tag ?safety (replacements . ?replacements))
       (declare-core-primitive ?who
	   (?safety)
	 (signatures
	  ((?type-tag ?type-tag)		=> (T:boolean))
	  ((?type-tag ?type-tag . ?type-tag)	=> (T:boolean)))
	 (attributes
	  ((_ _)			foldable effect-free)
	  ((_ _ . _)			foldable effect-free))))
      ))

  #| end of module: DEFINE-OBJECT-BINARY/MULTI-COMPARISON-DECLARER |# )

(define-object-binary/multi-comparison-declarer declare-number-binary/multi-comparison T:number)
(define-object-binary/multi-comparison-declarer declare-char-binary/multi-comparison T:char)
(define-object-binary/multi-comparison-declarer declare-string-binary/multi-comparison T:string)


;;;; syntax helpers: math operations

(module (define-object-unary-operation-declarer)

  (define-syntax (define-object-unary-operation-declarer stx)
    ;;Usage example:
    ;;
    ;;   (define-object-unary-operation-declarer declare-flonum-unary T:flonum)
    ;;   (declare-flonum-unary flsin)
    ;;   (declare-flonum-unary flcos)
    ;;   (declare-flonum-unary fltan)
    ;;
    (syntax-case stx ()
      ((_ ?declarer ?type-tag)
       (all-identifiers? #'(?declarer ?type-tag))
       #'(define-syntax ?declarer
	   (syntax-rules (safe unsafe replacements)
	     ((_ ?who)						(%define-declarer ?who ?type-tag safe   (replacements)))
	     ((_ ?who safe)					(%define-declarer ?who ?type-tag safe   (replacements)))
	     ((_ ?who unsafe)					(%define-declarer ?who ?type-tag unsafe (replacements)))

	     ((_ ?who        (replacements . ?replacements))	(%define-declarer ?who ?type-tag safe   (replacements . ?replacements)))
	     ((_ ?who safe   (replacements . ?replacements))	(%define-declarer ?who ?type-tag safe   (replacements . ?replacements)))
	     ((_ ?who unsafe (replacements . ?replacements))	(%define-declarer ?who ?type-tag unsafe (replacements . ?replacements)))
	     )))
      ))

  (define-syntax %define-declarer
    (syntax-rules (replacements)
      ((_ ?who ?type-tag ?safety (replacements . ?replacements))
       (declare-core-primitive ?who
	   (?safety)
	 (signatures
	  ((?type-tag)	=> (?type-tag)))
	 (attributes
	  ((_)		foldable effect-free result-true))
	 (replacements . ?replacements)))
      ))

  #| end of module: DEFINE-OBJECT-UNARY-OPERATION-DECLARER |# )

(define-object-unary-operation-declarer declare-number-unary T:number)
(define-object-unary-operation-declarer declare-fixnum-unary T:fixnum)
(define-object-unary-operation-declarer declare-flonum-unary T:flonum)
(define-object-unary-operation-declarer declare-exact-integer-unary T:exact-integer)
(define-object-unary-operation-declarer declare-char-unary T:char)
(define-object-unary-operation-declarer declare-string-unary T:string)

;;; --------------------------------------------------------------------

(module (define-object-binary-operation-declarer)

  (define-syntax (define-object-binary-operation-declarer stx)
    ;;Usage examples:
    ;;
    ;;   (define-object-binary-operation-declarer declare-flonum-binary T:flonum)
    ;;   (declare-flonum-binary flexpt)
    ;;
    (syntax-case stx ()
      ((_ ?declarer ?type-tag)
       (all-identifiers? #'(?declarer ?type-tag))
       #'(define-syntax ?declarer
	   (syntax-rules (safe unsafe replacements)
	     ((_ ?who)						(%define-declarer ?who ?type-tag safe   (replacements)))
	     ((_ ?who safe)					(%define-declarer ?who ?type-tag safe   (replacements)))
	     ((_ ?who unsafe)					(%define-declarer ?who ?type-tag unsafe (replacements)))

	     ((_ ?who        (replacements . ?replacements))	(%define-declarer ?who ?type-tag safe   (replacements . ?replacements)))
	     ((_ ?who safe   (replacements . ?replacements))	(%define-declarer ?who ?type-tag safe   (replacements . ?replacements)))
	     ((_ ?who unsafe (replacements . ?replacements))	(%define-declarer ?who ?type-tag unsafe (replacements . ?replacements)))
	     )))
      ))

  (define-syntax %define-declarer
    (syntax-rules (replacements)
      ((_ ?who ?type-tag ?safety (replacements . ?replacements))
       (declare-core-primitive ?who
	   (?safety)
	 (signatures
	  ((?type-tag ?type-tag)	=> (?type-tag)))
	 (attributes
	  ((_ _)			foldable effect-free result-true))
	 (replacements . ?replacements)))
      ))

  #| end of module: DEFINE-OBJECT-BINARY-OPERATION-DECLARER |# )

(define-object-binary-operation-declarer declare-number-binary T:number)
(define-object-binary-operation-declarer declare-fixnum-binary T:fixnum)
(define-object-binary-operation-declarer declare-flonum-binary T:flonum)
(define-object-binary-operation-declarer declare-string-binary T:string)

;;; --------------------------------------------------------------------

(module (define-object-unary/binary-operation-declarer)

  (define-syntax (define-object-unary/binary-operation-declarer stx)
    ;;Usage examples:
    ;;
    ;;   (define-object-unary/binary-operation-declarer declare-flonum-unary/binary T:flonum)
    ;;   (declare-flonum-unary/binary fllog)
    ;;
    (syntax-case stx ()
      ((_ ?declarer ?type-tag)
       (all-identifiers? #'(?declarer ?type-tag))
       #'(define-syntax ?declarer
	   (syntax-rules (safe unsafe replacements)
	     ((_ ?who)						(%define-declarer ?who ?type-tag safe   (replacements)))
	     ((_ ?who safe)					(%define-declarer ?who ?type-tag safe   (replacements)))
	     ((_ ?who unsafe)					(%define-declarer ?who ?type-tag unsafe (replacements)))

	     ((_ ?who        (replacements . ?replacements))	(%define-declarer ?who ?type-tag safe   (replacements . ?replacements)))
	     ((_ ?who safe   (replacements . ?replacements))	(%define-declarer ?who ?type-tag safe   (replacements . ?replacements)))
	     ((_ ?who unsafe (replacements . ?replacements))	(%define-declarer ?who ?type-tag unsafe (replacements . ?replacements)))
	     )))
      ))

  (define-syntax %define-declarer
    (syntax-rules (replacements)
      ((_ ?who ?type-tag ?safety (replacements . ?replacements))
       (declare-core-primitive ?who
	   (?safety)
	 (signatures
	  ((?type-tag)			=> (?type-tag))
	  ((?type-tag ?type-tag)	=> (?type-tag)))
	 (attributes
	  ((_)			foldable effect-free result-true)
	  ((_ _)		foldable effect-free result-true))
	 (replacements . ?replacements)))
      ))

  #| end of module: DEFINE-OBJECT-UNARY/BINARY-OPERATION-DECLARER |# )

(define-object-unary/binary-operation-declarer declare-number-unary/binary T:number)
(define-object-unary/binary-operation-declarer declare-fixnum-unary/binary T:fixnum)
(define-object-unary/binary-operation-declarer declare-flonum-unary/binary T:flonum)
(define-object-unary/binary-operation-declarer declare-string-unary/binary T:string)

;;; --------------------------------------------------------------------

(module (define-object-unary/multi-operation-declarer)

  (define-syntax (define-object-unary/multi-operation-declarer stx)
    ;;Usage examples:
    ;;
    ;;   (define-object-unary/multi-operation-declarer declare-flonum-unary/multi T:flonum)
    ;;   (declare-flonum-unary/multi fl+)
    ;;   (declare-flonum-unary/multi fl-)
    ;;   (declare-flonum-unary/multi fl*)
    ;;   (declare-flonum-unary/multi fl/)
    ;;
    (syntax-case stx ()
      ((_ ?declarer ?type-tag)
       (all-identifiers? #'(?declarer ?type-tag))
       #'(define-syntax ?declarer
	   (syntax-rules (safe unsafe replacements)
	     ((_ ?who)						(%define-declarer ?who ?type-tag safe   (replacements)))
	     ((_ ?who safe)					(%define-declarer ?who ?type-tag safe   (replacements)))
	     ((_ ?who unsafe)					(%define-declarer ?who ?type-tag unsafe (replacements)))

	     ((_ ?who        (replacements . ?replacements))	(%define-declarer ?who ?type-tag safe   (replacements . ?replacements)))
	     ((_ ?who safe   (replacements . ?replacements))	(%define-declarer ?who ?type-tag safe   (replacements . ?replacements)))
	     ((_ ?who unsafe (replacements . ?replacements))	(%define-declarer ?who ?type-tag unsafe (replacements . ?replacements)))
	     )))
      ))

  (define-syntax %define-declarer
    (syntax-rules (replacements)
      ((_ ?who ?type-tag ?safety (replacements . ?replacements))
       (declare-core-primitive ?who
	   (?safety)
	 (signatures
	  ((?type-tag)			=> (?type-tag))
	  ((?type-tag . ?type-tag)	=> (?type-tag)))
	 (attributes
	  ((_)				foldable effect-free result-true)
	  ((_ . _)			foldable effect-free result-true))
	 (replacements . ?replacements)))
      ))

  #| end of module: DEFINE-OBJECT-UNARY/MULTI-OPERATION-DECLARER |# )

(define-object-unary/multi-operation-declarer declare-number-unary/multi T:number)
(define-object-unary/multi-operation-declarer declare-fixnum-unary/multi T:fixnum)
(define-object-unary/multi-operation-declarer declare-flonum-unary/multi T:flonum)
(define-object-unary/multi-operation-declarer declare-string-unary/multi T:string)

;;; --------------------------------------------------------------------

(module (define-object-multi-operation-declarer)

  (define-syntax (define-object-multi-operation-declarer stx)
    ;;Usage examples:
    ;;
    ;;   (define-object-multi-operation-declarer declare-fixnum-multi T:fixnum)
    ;;   (declare-fixnum-multi fxior)
    ;;
    (syntax-case stx ()
      ((_ ?declarer ?type-tag)
       (all-identifiers? #'(?declarer ?type-tag))
       #'(define-syntax ?declarer
	   (syntax-rules (safe unsafe replacements)
	     ((_ ?who)						(%define-declarer ?who ?type-tag safe   (replacements)))
	     ((_ ?who safe)					(%define-declarer ?who ?type-tag safe   (replacements)))
	     ((_ ?who unsafe)					(%define-declarer ?who ?type-tag unsafe (replacements)))

	     ((_ ?who        (replacements . ?replacements))	(%define-declarer ?who ?type-tag safe   (replacements . ?replacements)))
	     ((_ ?who safe   (replacements . ?replacements))	(%define-declarer ?who ?type-tag safe   (replacements . ?replacements)))
	     ((_ ?who unsafe (replacements . ?replacements))	(%define-declarer ?who ?type-tag unsafe (replacements . ?replacements)))
	     )))
      ))

  (define-syntax %define-declarer
    (syntax-rules (replacements)
      ((_ ?who ?type-tag ?safety (replacements . ?replacements))
       (declare-core-primitive ?who
	   (?safety)
	 (signatures
	  (()			=> (?type-tag))
	  (?type-tag		=> (?type-tag)))
	 (attributes
	  (()			foldable effect-free result-true)
	  ((_ . _)		foldable effect-free result-true))
	 (replacements . ?replacements)))
      ))

  #| end of module: DEFINE-OBJECT-MULTI-OPERATION-DECLARER |# )

(define-object-multi-operation-declarer declare-number-multi T:number)
(define-object-multi-operation-declarer declare-fixnum-multi T:fixnum)
(define-object-multi-operation-declarer declare-flonum-multi T:flonum)
(define-object-multi-operation-declarer declare-string-multi T:string)

;;; --------------------------------------------------------------------

(define-syntax declare-unsafe-unary-operation
  ;;Usage examples:
  ;;
  ;;   (declare-unsafe-unary-operation $neg-fixnum T:fixnum T:exact-integer)
  ;;
  (syntax-rules ()
    ((_ ?who ?operand-tag ?result-tag)
     (declare-core-primitive ?who
	 (unsafe)
       (signatures
	((?operand-tag)		=> (?result-tag)))
       (attributes
	((_)			foldable effect-free result-true))))
    ))

(define-syntax declare-unsafe-unary-operation/2rv
  ;;Usage examples:
  ;;
  ;;   (declare-unsafe-unary-operation/2rv $exact-integer-sqrt-fixnum T:fixnum T:exact-integer T:exact-integer)
  ;;
  (syntax-rules ()
    ((_ ?who ?operand-tag ?result1-tag ?result2-tag)
     (declare-core-primitive ?who
	 (unsafe)
       (signatures
	((?operand-tag)		=> (?result1-tag ?result2-tag)))
       (attributes
	((_)			foldable effect-free result-true))))
    ))

(define-syntax declare-unsafe-binary-operation
  ;;Usage examples:
  ;;
  ;;   (declare-unsafe-binary-operation $add-fixnum-fixnum T:fixnum T:fixnum T:exact-integer)
  ;;
  (syntax-rules ()
    ((_ ?who ?operand1-tag ?operand2-tag ?result-tag)
     (declare-core-primitive ?who
	 (unsafe)
       (signatures
	((?operand1-tag ?operand2-tag)	=> (?result-tag)))
       (attributes
	((_ _)				foldable effect-free result-true))))
    ))

(define-syntax declare-unsafe-binary-operation/2rv
  ;;Usage examples:
  ;;
  ;;   (declare-unsafe-binary-operation $quotient+remainder-fixnum-fixnum T:fixnum T:fixnum T:exact-integer T:fixnum)
  ;;
  (syntax-rules ()
    ((_ ?who ?operand1-tag ?operand2-tag ?result1-tag ?result2-tag)
     (declare-core-primitive ?who
	 (unsafe)
       (signatures
	((?operand1-tag ?operand2-tag)	=> (?result1-tag ?result2-tag)))
       (attributes
	((_ _)				foldable effect-free result-true))))
    ))


;;;; syntax helpers: pairs, lists, alists

(module (declare-pair-accessor)

  (define-syntax declare-pair-accessor
    ;;This is for: CAR, CDR, CAAR, CADR, ...
    ;;
    (syntax-rules (safe unsafe replacements)
      ((_ ?who)						(%declare-pair-accessor ?who safe   (replacements)))
      ((_ ?who safe)					(%declare-pair-accessor ?who safe   (replacements)))
      ((_ ?who unsafe)					(%declare-pair-accessor ?who unsafe (replacements)))
      ((_ ?who        (replacements . ?replacements))	(%declare-pair-accessor ?who safe   (replacements . ?replacements)))
      ((_ ?who safe   (replacements . ?replacements))	(%declare-pair-accessor ?who safe   (replacements . ?replacements)))
      ((_ ?who unsafe (replacements . ?replacements))	(%declare-pair-accessor ?who unsafe (replacements . ?replacements)))
      ))

  (define-syntax %declare-pair-accessor
    (syntax-rules (replacements)
      ((_ ?who ?safety (replacements . ?replacements))
       (declare-core-primitive ?who
	   (?safety)
	 (signatures
	  ((T:pair)		=> (_)))
	 (attributes
	  ((_)			foldable effect-free))
	 (replacements . ?replacements)))
      ))

  #| end of module |# )

;;; --------------------------------------------------------------------

(module (declare-pair-mutator)

  (define-syntax declare-pair-mutator
    ;;This is for: SET-CAR!, SET-CDR!, ...
    ;;
    (syntax-rules (safe unsafe replacements)
      ((_ ?who)						(%declare-pair-mutator ?who safe   (replacements)))
      ((_ ?who safe)					(%declare-pair-mutator ?who safe   (replacements)))
      ((_ ?who unsafe)					(%declare-pair-mutator ?who unsafe (replacements)))
      ((_ ?who        (replacements . ?replacements))	(%declare-pair-mutator ?who safe   (replacements . ?replacements)))
      ((_ ?who safe   (replacements . ?replacements))	(%declare-pair-mutator ?who safe   (replacements . ?replacements)))
      ((_ ?who unsafe (replacements . ?replacements))	(%declare-pair-mutator ?who unsafe (replacements . ?replacements)))
      ))

  (define-syntax %declare-pair-mutator
    (syntax-rules (replacements)
      ((_ ?who ?safety (replacements . ?replacements))
       (declare-core-primitive ?who
	   (?safety)
	 (signatures
	  ((T:pair _)		=> (T:void)))
	 (attributes
	  ((_ _)		result-true))
	 (replacements . ?replacements)))
      ))

  #| end of module: DECLARE-PAIR-MUTATOR |# )

;;; --------------------------------------------------------------------

(module (declare-alist-accessor)

  (define-syntax declare-alist-accessor
    ;;This is for: ASSQ, ASSV, ...
    ;;
    (syntax-rules (safe unsafe replacements)
      ((_ ?who ?obj-tag)					(%declare-alist-accessor ?who ?obj-tag safe   (replacements)))
      ((_ ?who ?obj-tag safe)					(%declare-alist-accessor ?who ?obj-tag safe   (replacements)))
      ((_ ?who ?obj-tag unsafe)					(%declare-alist-accessor ?who ?obj-tag unsafe (replacements)))
      ((_ ?who ?obj-tag        (replacements . ?replacements))	(%declare-alist-accessor ?who ?obj-tag safe   (replacements . ?replacements)))
      ((_ ?who ?obj-tag safe   (replacements . ?replacements))	(%declare-alist-accessor ?who ?obj-tag safe   (replacements . ?replacements)))
      ((_ ?who ?obj-tag unsafe (replacements . ?replacements))	(%declare-alist-accessor ?who ?obj-tag unsafe (replacements . ?replacements)))
      ))

  (define-syntax %declare-alist-accessor
    (syntax-rules (replacements)
      ((_ ?who ?obj-tag ?safety (replacements . ?replacements))
       (declare-core-primitive ?who
	   (?safety)
	 (signatures
	  ((?obj-tag T:proper-list)	=> (_)))
	 (attributes
	  ((_ _)			foldable effect-free))
	 (replacements . ?replacements)))
      ))

  #| end of module: DECLARE-ALIST-ACCESSOR |# )

;;; --------------------------------------------------------------------

(define-syntax declare-list-finder
  ;;This is for: MEMQ, MEMV, ...
  ;;
  (syntax-rules ()
    ((_ ?who ?obj-tag)
     (declare-list-finder ?who ?obj-tag safe))
    ((_ ?who ?obj-tag ?safety)
     (declare-core-primitive ?who
	 (?safety)
       (signatures
	((?obj-tag T:null)			=> (T:false))
	((?obj-tag T:non-empty-proper-list)	=> (_)))
       (attributes
	((_ ())			foldable effect-free result-false)
	((_ _)			foldable effect-free))))
    ))


;;;; misc functions

(declare-object-binary-comparison eq?)
(declare-object-binary-comparison neq?)
(declare-object-binary-comparison eqv?)
(declare-object-binary-comparison equal?)

(declare-object-predicate not)

(declare-core-primitive void
    (safe)
  (signatures
   (()				=> (T:void)))
  (attributes
   (()				foldable effect-free result-true)))


;;;; pairs and lists, safe functions

;;; predicates

(declare-core-primitive null?
    (safe)
  (signatures
   ((T:null)		=> (T:true))
   ((T:pair)		=> (T:false))
   ((_)			=> (T:boolean)))
  (attributes
   ((())		foldable effect-free result-true)
   ((_)			foldable effect-free)))

(declare-core-primitive pair?
    (safe)
  (signatures
   ((T:null)		=> (T:false))
   ((T:pair)		=> (T:true))
   ((_)			=> (T:boolean)))
  (attributes
   ((_)			foldable effect-free)))

(declare-core-primitive list?
    (safe)
  (signatures
   ((T:proper-list)	=> (T:true))
   ((T:pair)		=> (T:boolean))
   ((_)			=> (T:false)))
  (attributes
   ((())		foldable effect-free result-true)
   ((_)			foldable effect-free)))

;;; --------------------------------------------------------------------
;;; constructors

(declare-core-primitive cons
    (safe)
  (signatures
   ((_ _)		=> (T:pair)))
  (attributes
   ;;This is not foldable because it must return a newly allocated pair every time.
   ((_ _)		effect-free result-true)))

(declare-core-primitive cons*
    (safe)
  (signatures
   ((_)			=> (_))
   ((_ _ . _)		=> (T:pair)))
  (attributes
   ;;This will return the operand itself, so it is foldable.
   ((_)			foldable effect-free)
   ;;This is not foldable because it must return a newly allocated list every time.
   ((_ _ . _)		effect-free result-true)))

(declare-core-primitive list
    (safe)
  (signatures
   (()			=> (T:null))
   ((_ . _)		=> (T:non-empty-proper-list)))
  (attributes
   ;;Foldable because it returns null.
   (()			foldable effect-free result-true)
   ;;Not foldable because it must return a newly allocated list every time.
   ((_ . _)		effect-free result-true)))

(declare-core-primitive make-list
    (safe)
  (signatures
   ((T:non-negative-fixnum)		=> (T:proper-list))
   ((T:non-negative-fixnum T:object)	=> (T:proper-list)))
  (attributes
   ;;Foldable because it returns null.
   ((0)				foldable effect-free result-true)
   ((0 _)			foldable effect-free result-true)
   ;;Not foldable because it must return a newly allocated list every time.
   ((_)				effect-free result-true)
   ((_ _)			effect-free result-true)))

(declare-core-primitive reverse
    (safe)
  (signatures
   ((T:null)			=> (T:null))
   ((T:non-empty-proper-list)	=> (T:non-empty-proper-list)))
  (attributes
   ;;This is foldable because it returns null itself.
   ((())		foldable effect-free result-true)
   ;;Not foldable because it must return a newly allocated list every time.
   ((_)			effect-free result-true)))

(declare-core-primitive append
    (safe)
  (signatures
   (()				=> (T:null))
   ((T:object . T:object)	=> (T:improper-list)))
  (attributes
   ;;This is foldable because it returns null itself.
   (()				foldable effect-free result-true)
   ;;Not foldable because it must return a newly allocated improper list every time.
   ((_ . _)			effect-free result-true)))

;;; --------------------------------------------------------------------
;;; inspection

(declare-core-primitive length
    (safe)
  (signatures
   ((T:null)			=> (T:zero))
   ((T:non-empty-proper-list)	=> (_)))
  (attributes
   ((_)				foldable effect-free result-true)))

;;;

(declare-list-finder memq T:object)
(declare-list-finder memv T:object)
(declare-list-finder member T:object)

(declare-core-primitive memp
    (safe)
  (signatures
   ((T:procedure T:null)			=> (T:false))
   ((T:procedure T:non-empty-proper-list)	=> (_)))
  (attributes
   ;;In the  general case: neither  foldable nor  effect-free, because it  applies an
   ;;unknown function.
   ((_ ())				foldable effect-free result-false)))

;;;

(declare-core-primitive remp
    (safe)
  (signatures
   ((T:procedure T:null)			=> (T:null))
   ((T:procedure T:non-empty-proper-list)	=> (T:proper-list)))
  (attributes
   ;;In the  general case: neither  foldable nor  effect-free, because it  applies an
   ;;unknown function.
   ((_ ())				foldable effect-free result-true)
   ((_ _)				result-true)))

(declare-core-primitive remq
    (safe)
  (signatures
   ((T:object T:null)			=> (T:null))
   ((T:object T:non-empty-proper-list)	=> (T:proper-list)))
  (attributes
   ((_ ())				foldable effect-free result-true)
   ((_ _)				foldable effect-free result-true)))

(declare-core-primitive remv
    (safe)
  (signatures
   ((T:object T:null)			=> (T:null))
   ((T:object T:non-empty-proper-list)	=> (T:proper-list)))
  (attributes
   ((_ ())				foldable effect-free result-true)
   ((_ _)				foldable effect-free result-true)))

(declare-core-primitive remove
    (safe)
  (signatures
   ((T:object T:null)			=> (T:null))
   ((T:object T:non-empty-proper-list)	=> (T:proper-list)))
  (attributes
   ((_ ())				foldable effect-free result-true)
   ((_ _)				foldable effect-free result-true)))

;;;

(declare-core-primitive last-pair
    (safe)
  (signatures
   ((T:non-empty-proper-list)		=> (T:pair))
   ((T:standalone-pair)			=> (T:standalone-pair)))
  (attributes
   ((_ _)				foldable effect-free result-true)))

(declare-core-primitive list-tail
    (safe)
  (signatures
   ((T:non-empty-proper-list T:exact-integer)	=> (T:proper-list)))
  (attributes
   ((_ _)				foldable effect-free result-true)))

(declare-core-primitive list-ref
    (safe)
  (signatures
   ((T:non-empty-proper-list T:exact-integer)	=> (T:object)))
  (attributes
   ((_ _)				foldable effect-free)))

;;;

(declare-core-primitive map
    (safe)
  (signatures
   ((T:procedure T:null . T:null)					=> (T:null))
   ((T:procedure T:non-empty-proper-list . T:non-empty-proper-list)	=> (T:non-empty-proper-list)))
  (attributes
   ;;In the  general case:  neither foldable  nor effect-free, because it  applies an
   ;;unknown function.
   ((_ () . ())				foldable effect-free result-true)
   ((_ _ . _)				result-true)))

(declare-core-primitive for-each
    (safe)
  (signatures
   ((T:procedure T:null . T:null)					=> (T:void))
   ((T:procedure T:non-empty-proper-list . T:non-empty-proper-list)	=> (T:void)))
  (attributes
   ;;In the  general case: neither  foldable nor  effect-free, because it  applies an
   ;;unknown function.
   ((_ () . ())				foldable effect-free result-true)
   ((_ _ . _)				result-true)))

;;;

(declare-core-primitive find
    (safe)
  (signatures
   ((T:procedure T:null)			=> (T:false))
   ((T:procedure T:non-empty-proper-list)	=> (T:object)))
  (attributes
   ;;In the  general case:  neither foldable  nor effect-free, because it  applies an
   ;;unknown function.
   ((_ ())				foldable effect-free result-false)))

(declare-core-primitive exists
    (safe)
  (signatures
   ((T:procedure T:null . T:null)					=> (T:false))
   ((T:procedure T:non-empty-proper-list . T:non-empty-proper-list)	=> (T:object)))
  (attributes
   ;;In the  general case:  neither foldable  nor effect-free, because it  applies an
   ;;unknown function.
   ((_ () . ())				foldable effect-free result-false)))

(declare-core-primitive for-all
    (safe)
  (signatures
   ((T:procedure T:null . T:null)					=> (T:true))
   ((T:procedure T:non-empty-proper-list . T:non-empty-proper-list)	=> (T:object)))
  (attributes
   ;;In the  general case:  neither foldable  nor effect-free, because it  applies an
   ;;unknown function.
   ((_ () . ())				foldable effect-free result-true)))

(declare-core-primitive filter
    (safe)
  (signatures
   ((T:procedure T:null)			=> (T:null))
   ((T:procedure T:non-empty-proper-list)	=> (T:proper-list)))
  (attributes
   ;;In the  general case:  neither foldable  nor effect-free, because it  applies an
   ;;unknown function.
   ((_ ())				foldable effect-free result-true)))

(declare-core-primitive partition
    (safe)
  (signatures
   ((T:procedure T:null)			=> (T:null T:null))
   ((T:procedure T:non-empty-proper-list)	=> (T:proper-list T:proper-list)))
  (attributes
   ;;In the  general case:  neither foldable  nor effect-free, because it  applies an
   ;;unknown function.
   ((_ ())				foldable effect-free)))

(declare-core-primitive fold-left
    (safe)
  (signatures
   ((T:procedure T:object T:proper-list . T:proper-list)	=> (T:object)))
  (attributes
   ;;In the  general case:  neither foldable  nor effect-free, because it  applies an
   ;;unknown function.
   ((_ _ () . ())			foldable effect-free)))

(declare-core-primitive fold-right
    (safe)
  (signatures
   ((T:procedure T:object T:proper-list . T:proper-list)	=> (T:object)))
  (attributes
   ;;In the  general case:  neither foldable  nor effect-free, because it  applies an
   ;;unknown function.
   ((_ _ () . ())			foldable effect-free)))

(declare-core-primitive andmap
    (safe)
  (signatures
   ((T:procedure T:null)						=> (T:true))
   ((T:procedure T:non-empty-proper-list)				=> (T:object))
   ((T:procedure T:null T:null)						=> (T:true))
   ((T:procedure T:non-empty-proper-list T:non-empty-proper-list)	=> (T:object)))
  (attributes
   ;;In the  general case:  neither foldable  nor effect-free, because it  applies an
   ;;unknown function.
   ((_ ())				foldable effect-free result-true)
   ((_ () ())				foldable effect-free result-true)))

(declare-core-primitive ormap
    (safe)
  (signatures
   ((T:procedure T:null)			=> (T:false))
   ((T:procedure T:non-empty-proper-list)	=> (T:object)))
  (attributes
   ;;In the  general case: neither  foldable nor  effect-free, because it  applies an
   ;;unknown function.
   ((_ ())				foldable effect-free result-false)))

;;; --------------------------------------------------------------------
;;; accessors

(declare-pair-accessor car
  (replacements $car))

(declare-pair-accessor cdr
  (replacements $cdr))

(declare-pair-accessor caar)
(declare-pair-accessor cadr)
(declare-pair-accessor cdar)
(declare-pair-accessor cddr)
(declare-pair-accessor caaar)
(declare-pair-accessor caadr)
(declare-pair-accessor cadar)
(declare-pair-accessor caddr)
(declare-pair-accessor cdaar)
(declare-pair-accessor cdadr)
(declare-pair-accessor cddar)
(declare-pair-accessor cdddr)
(declare-pair-accessor caaaar)
(declare-pair-accessor caaadr)
(declare-pair-accessor caadar)
(declare-pair-accessor caaddr)
(declare-pair-accessor cadaar)
(declare-pair-accessor cadadr)
(declare-pair-accessor caddar)
(declare-pair-accessor cadddr)
(declare-pair-accessor cdaaar)
(declare-pair-accessor cdaadr)
(declare-pair-accessor cdadar)
(declare-pair-accessor cdaddr)
(declare-pair-accessor cddaar)
(declare-pair-accessor cddadr)
(declare-pair-accessor cdddar)
(declare-pair-accessor cddddr)

;;; --------------------------------------------------------------------
;;; mutators

(declare-pair-mutator set-car!
  (replacements $set-car!))

(declare-pair-mutator set-cdr!
  (replacements $set-cdr!))

;;; --------------------------------------------------------------------
;;; associative lists

(declare-alist-accessor assq T:object)
(declare-alist-accessor assv T:object)
(declare-alist-accessor assoc T:object)

(declare-core-primitive assp
    (safe)
  (signatures
   ((T:procedure T:null)			=> (T:false))
   ((T:procedure T:non-empty-proper-list)	=> (_)))
  (attributes
   ;;In the  general case: neither  foldable nor  effect-free, because it  applies an
   ;;unknown function.
   ((_ ())				foldable effect-free)))

;;; --------------------------------------------------------------------
;;; weak pairs

(declare-core-primitive weak-cons
    (safe)
  (signatures
   ((_ _)		=> (T:pair)))
  (attributes
   ;;This is not foldable because it must return a newly allocated pair every time.
   ((_ _)		effect-free result-true)))

(declare-core-primitive weak-pair?
    (safe)
  (signatures
   ((T:null)		=> (T:false))
   ((T:pair)		=> (T:boolean))
   ((_)			=> (T:boolean)))
  (attributes
   ((_)			effect-free)))

;;; --------------------------------------------------------------------
;;; conversion

(declare-core-primitive list->string
    (safe)
  (signatures
   ((T:proper-list)		=> (T:string)))
  (attributes
   ;;Not foldable because it must return a new string every time.
   ((_)				effect-free result-true)))

(declare-core-primitive list->vector
    (safe)
  (signatures
   ((T:proper-list)		=> (T:vector)))
  (attributes
   ;;Not foldable because it must return a new vector every time.
   ((_)				effect-free result-true)))

;;; --------------------------------------------------------------------
;;; miscellaneous

(declare-core-primitive make-queue-procs
    (safe)
  (signatures
   (()				=> (T:procedure T:procedure T:procedure))
   ((T:proper-list)		=> (T:procedure T:procedure T:procedure)))
  (attributes
   (()				effect-free)
   ((_)				effect-free)))


;;;; pairs and lists, unsafe functions

(declare-pair-accessor $car unsafe)
(declare-pair-accessor $cdr unsafe)

(declare-pair-mutator $set-car! unsafe)
(declare-pair-mutator $set-cdr! unsafe)


;;;; fixnums safe operations

(declare-core-primitive greatest-fixnum
    (unsafe)
  (signatures
   (()				=> (T:positive-fixnum)))
  (attributes
   (()				foldable effect-free result-true)))

(declare-core-primitive least-fixnum
    (unsafe)
  (signatures
   (()				=> (T:negative-fixnum)))
  (attributes
   (()				foldable effect-free result-true)))

(declare-core-primitive fixnum-width
    (unsafe)
  (signatures
   (()				=> (T:positive-fixnum)))
  (attributes
   (()				foldable effect-free result-true)))

;;; --------------------------------------------------------------------
;;; predicates

(declare-type-predicate fixnum? T:fixnum)

(declare-fixnum-predicate fxzero?		(replacements $fxzero?))
(declare-fixnum-predicate fxpositive?		(replacements $fxpositive?))
(declare-fixnum-predicate fxnegative?		(replacements $fxnegative?))
(declare-fixnum-predicate fxnonpositive?	(replacements $fxnonpositive?))
(declare-fixnum-predicate fxnonnegative?	(replacements $fxnonnegative?))
(declare-fixnum-predicate fxeven?		(replacements $fxeven?))
(declare-fixnum-predicate fxodd?		(replacements $fxodd?))

(declare-fixnum-predicate fixnum-in-character-range?)

;;; --------------------------------------------------------------------
;;; arithmetics

(declare-fixnum-binary fx+)
(declare-fixnum-unary/binary fx-)
(declare-fixnum-binary fx*)
(declare-fixnum-binary fxdiv)
(declare-fixnum-binary fxmod)
(declare-fixnum-binary fxdiv0)
(declare-fixnum-binary fxmod0)
(declare-fixnum-unary fxadd1)
(declare-fixnum-unary fxsub1)

(declare-fixnum-unary fxabs)
(declare-fixnum-unary fxsign)
(declare-fixnum-binary fxremainder)
(declare-fixnum-binary fxquotient)
(declare-fixnum-binary fxmodulo)

(declare-core-primitive fx+/carry
    (safe)
  (signatures
   ((T:fixnum T:fixnum T:fixnum) => (T:fixnum T:fixnum)))
  (attributes
   ((_ _ _)			foldable effect-free result-true)))

(declare-core-primitive fx-/carry
    (safe)
  (signatures
   ((T:fixnum T:fixnum T:fixnum) => (T:fixnum T:fixnum)))
  (attributes
   ((_ _ _)			foldable effect-free result-true)))

(declare-core-primitive fx*/carry
    (safe)
  (signatures
   ((T:fixnum T:fixnum T:fixnum) => (T:fixnum T:fixnum)))
  (attributes
   ((_ _ _)			foldable effect-free result-true)))

(declare-core-primitive fxdiv-and-mod
    (safe)
  (signatures
   ((T:fixnum T:fixnum)		=> (T:fixnum T:fixnum)))
  (attributes
   ((_ _)			effect-free)))

(declare-core-primitive fxdiv0-and-mod0
    (safe)
  (signatures
   ((T:fixnum T:fixnum)		=> (T:fixnum T:fixnum)))
  (attributes
   ((_ _)			effect-free)))

;;; --------------------------------------------------------------------
;;; bitwise operations

(declare-fixnum-unary fxnot		(replacements $fxlognot))
(declare-fixnum-multi fxand		(replacements $fxlogand))
(declare-fixnum-multi fxior		(replacements $fxlogor))
(declare-fixnum-multi fxxor		(replacements $fxlogxor))
(declare-fixnum-unary fxlognot		(replacements $fxlognot))
(declare-fixnum-multi fxlogor		(replacements $fxlogor))
(declare-fixnum-multi fxlogand		(replacements $fxlogand))
(declare-fixnum-multi fxlogxor		(replacements $fxlogxor))

(declare-fixnum-unary fxlength)
(declare-fixnum-binary fxsll)
(declare-fixnum-binary fxsra)
(declare-fixnum-binary fxarithmetic-shift-left)
(declare-fixnum-binary fxarithmetic-shift-right)
(declare-fixnum-binary fxarithmetic-shift)

(declare-fixnum-unary fxbit-count)

(declare-core-primitive fxbit-field
    (safe)
  (signatures
   ((T:fixnum T:fixnum T:fixnum)	=> (T:fixnum)))
  (attributes
   ((_ _ _)				foldable effect-free result-true)))

(declare-core-primitive fxbit-set?
    (safe)
  (signatures
   ((T:fixnum T:fixnum)			=> (T:boolean)))
  (attributes
   ((_ _)				foldable effect-free result-true)))

(declare-core-primitive fxreverse-bit-field
    (safe)
  (signatures
   ((T:fixnum T:fixnum T:fixnum)	=> (T:fixnum)))
  (attributes
   ((_ _ _)				foldable effect-free result-true)))

(declare-core-primitive fxcopy-bit
    (safe)
  (signatures
   ((T:fixnum T:fixnum T:fixnum)	=> (T:fixnum)))
  (attributes
   ((_ _ _)				foldable effect-free result-true)))

(declare-core-primitive fxcopy-bit-field
    (safe)
  (signatures
   ((T:fixnum T:fixnum T:fixnum T:fixnum)	=> (T:fixnum)))
  (attributes
   ((_ _ _ _)					foldable effect-free result-true)))

(declare-core-primitive fxrotate-bit-field
    (safe)
  (signatures
   ((T:fixnum T:fixnum T:fixnum T:fixnum)	=> (T:fixnum)))
  (attributes
   ((_ _ _ _)				foldable effect-free result-true)))

(declare-core-primitive fxif
    (safe)
  (signatures
   ((T:fixnum T:fixnum T:fixnum)	=> (T:fixnum)))
  (attributes
   ((_ _ _)				foldable effect-free result-true)))

(declare-fixnum-unary fxfirst-bit-set)

;;; --------------------------------------------------------------------
;;; comparison

(declare-fixnum-unary/multi-comparison fx=?	(replacements $fx=))
(declare-fixnum-unary/multi-comparison fx!=?	(replacements $fx!=))
(declare-fixnum-unary/multi-comparison fx<?	(replacements $fx<))
(declare-fixnum-unary/multi-comparison fx>?	(replacements $fx>))
(declare-fixnum-unary/multi-comparison fx<=?	(replacements $fx<=))
(declare-fixnum-unary/multi-comparison fx>=?	(replacements $fx>=))

;;;

(declare-fixnum-unary/multi-comparison fx=	(replacements $fx=))
(declare-fixnum-unary/multi-comparison fx!=	(replacements $fx!=))
(declare-fixnum-unary/multi-comparison fx<	(replacements $fx<))
(declare-fixnum-unary/multi-comparison fx>	(replacements $fx>))
(declare-fixnum-unary/multi-comparison fx<=	(replacements $fx<=))
(declare-fixnum-unary/multi-comparison fx>=	(replacements $fx>=))

(declare-fixnum-unary/multi-comparison fxmax	(replacements $fxmax))
(declare-fixnum-unary/multi-comparison fxmin	(replacements $fxmin))

;;; --------------------------------------------------------------------
;;; conversion

(declare-core-primitive fixnum->flonum
    (safe)
  (signatures
   ((T:fixnum)		=> (T:flonum)))
  (attributes
   ((_)			foldable effect-free result-true)))

(declare-core-primitive fixnum->string
    (safe)
  (signatures
   ((T:fixnum)		=> (T:string))
   ((T:fixnum T:fixnum)	=> (T:string)))
  (attributes
   ((_)			foldable effect-free result-true)
   ((_ _)		foldable effect-free result-true)))


;;;; fixnums unsafe operations

;;; predicates

(declare-fixnum-predicate $fxzero? unsafe)
(declare-fixnum-predicate $fxpositive? unsafe)
(declare-fixnum-predicate $fxnegative? unsafe)
(declare-fixnum-predicate $fxnonpositive? unsafe)
(declare-fixnum-predicate $fxnonnegative? unsafe)
(declare-fixnum-predicate $fxeven? unsafe)
(declare-fixnum-predicate $fxodd? unsafe)

;;; --------------------------------------------------------------------
;;; arithmetics

(declare-fixnum-binary $fx+ unsafe)
(declare-fixnum-unary/binary $fx- unsafe)
(declare-fixnum-binary $fx* unsafe)
(declare-fixnum-binary $fxdiv unsafe)
(declare-fixnum-binary $fxmod unsafe)
(declare-fixnum-binary $fxdiv0 unsafe)
(declare-fixnum-binary $fxmod0 unsafe)

(declare-core-primitive $fxdiv-and-mod
    (unsafe)
  (signatures
   ((T:fixnum T:fixnum)		=> (T:fixnum T:fixnum)))
  (attributes
   ((_ _)			effect-free)))

(declare-core-primitive $fxdiv0-and-mod0
    (unsafe)
  (signatures
   ((T:fixnum T:fixnum)		=> (T:fixnum T:fixnum)))
  (attributes
   ((_ _)			effect-free)))

(declare-fixnum-unary $fxadd1 unsafe)
(declare-fixnum-unary $fxsub1 unsafe)
(declare-fixnum-unary $fxabs unsafe)
(declare-fixnum-unary $fxsign unsafe)
(declare-fixnum-binary $fxremainder unsafe)
(declare-fixnum-binary $fxquotient unsafe)
(declare-fixnum-binary $fxmodulo unsafe)

(declare-fixnum-binary $int-quotient unsafe)
(declare-fixnum-binary $int-remainder unsafe)

;;; --------------------------------------------------------------------
;;; bitwise operations

(declare-fixnum-binary $fxlogor unsafe)
(declare-fixnum-binary $fxlogand unsafe)
(declare-fixnum-binary $fxlogxor unsafe)
(declare-fixnum-unary $fxnot unsafe)
(declare-fixnum-binary $fxsll unsafe)
(declare-fixnum-binary $fxsra unsafe)

(declare-core-primitive $fxcopy-bit
    (unsafe)
  (signatures
   ((T:fixnum T:fixnum T:fixnum)	=> (T:fixnum)))
  (attributes
   ((_ _ _)				foldable effect-free result-true)))

(declare-core-primitive $fxcopy-bit-field
    (unsafe)
  (signatures
   ((T:fixnum T:fixnum T:fixnum T:fixnum)	=> (T:fixnum)))
  (attributes
   ((_ _ _ _)					foldable effect-free result-true)))

(declare-core-primitive $fxrotate-bit-field
    (unsafe)
  (signatures
   ((T:fixnum T:fixnum T:fixnum T:fixnum)	=> (T:fixnum)))
  (attributes
   ((_ _ _ _)					foldable effect-free result-true)))

(declare-core-primitive $fxbit-field
    (unsafe)
  (signatures
   ((T:fixnum T:fixnum T:fixnum)	=> (T:fixnum)))
  (attributes
   ((_ _ _)				foldable effect-free result-true)))

;;; --------------------------------------------------------------------
;;; comparison

(declare-fixnum-binary-comparison $fx= unsafe)
(declare-fixnum-binary-comparison $fx!= unsafe)
(declare-fixnum-binary-comparison $fx< unsafe)
(declare-fixnum-binary-comparison $fx> unsafe)
(declare-fixnum-binary-comparison $fx<= unsafe)
(declare-fixnum-binary-comparison $fx>= unsafe)

(declare-fixnum-binary-comparison $fxmax unsafe)
(declare-fixnum-binary-comparison $fxmin unsafe)

;;; --------------------------------------------------------------------
;;; conversion

(declare-core-primitive $fixnum->flonum
    (unsafe)
  (signatures
   ((T:fixnum)			=> (T:flonum)))
  (attributes
   ((_)				foldable effect-free result-true)))

(declare-core-primitive $fixnum->char
    (unsafe)
  (signatures
   ((T:fixnum)			=> (T:char)))
  (attributes
   ((_)				foldable effect-free result-true)))

(declare-core-primitive $fixnum->string
    (unsafe)
  (signatures
   ((T:fixnum)			=> (T:string))
   ((T:fixnum T:fixnum)		=> (T:string)))
  (attributes
   ((_)				foldable effect-free result-true)
   ((_ _)			foldable effect-free result-true)))

;;; --------------------------------------------------------------------
;;; miscellaneous

(declare-core-primitive $fxinthash
    (unsafe)
  (signatures
   ((T:fixnum)			=> (T:fixnum)))
  (attributes
   ((_)				foldable effect-free result-true)))


;;;; bignums, safe operations

(declare-core-primitive least-positive-bignum
    (safe)
  (signatures
   (()				=> (T:bignum)))
  (attributes
   (()				foldable effect-free result-true)))

(declare-core-primitive greatest-negative-bignum
    (safe)
  (signatures
   (()				=> (T:bignum)))
  (attributes
   (()				foldable effect-free result-true)))

;;; --------------------------------------------------------------------
;;; predicates

(declare-type-predicate bignum? T:bignum)

(declare-bignum-predicate bignum-positive?	(replacements $bignum-positive?))
(declare-bignum-predicate bignum-negative?	(replacements $bignum-negative?))
(declare-bignum-predicate bignum-non-positive?	(replacements $bignum-non-positive?))
(declare-bignum-predicate bignum-non-negative?	(replacements $bignum-non-negative?))

(declare-bignum-predicate bignum-even?		(replacements $bignum-even?))
(declare-bignum-predicate bignum-odd?		(replacements $bignum-odd?))


;;;; bignums, unsafe operations

;;; predicates

(declare-bignum-predicate $bignum-positive? unsafe)
(declare-bignum-predicate $bignum-negative? unsafe)
(declare-bignum-predicate $bignum-non-positive? unsafe)
(declare-bignum-predicate $bignum-non-negative? unsafe)

(declare-bignum-predicate $bignum-even? unsafe)
(declare-bignum-predicate $bignum-odd? unsafe)

;;; --------------------------------------------------------------------
;;; inspection

(declare-core-primitive $bignum-byte-ref
    (unsafe)
  (signatures
   ((T:bignum T:fixnum)		=> (T:fixnum)))
  (attributes
   ((_ _)			foldable effect-free result-true)))

(declare-core-primitive $bignum-size
    (unsafe)
  (signatures
   ((T:bignum)			=> (T:fixnum)))
  (attributes
   ((_)				foldable effect-free result-true)))

;;; --------------------------------------------------------------------
;;; conversion

(declare-core-primitive $bignum->flonum
    (unsafe)
  (signatures
   ((T:bignum)			=> (T:flonum)))
  (attributes
   ((_)				foldable effect-free result-true)))


;;;; ratnums, safe operations

(declare-type-predicate ratnum? T:ratnum)


;;;; ratnums, unsafe operations

(declare-core-primitive $make-ratnum
    (unsafe)
  (signatures
   ((T:exact-integer T:exact-integer)		=> (T:ratnum)))
  (attributes
   ((_ _)					foldable effect-free result-true)))

;;; --------------------------------------------------------------------
;;; accessors

(declare-core-primitive $ratnum-n
    (unsafe)
  (signatures
   ((T:ratnum)					=> (T:exact-integer)))
  (attributes
   ((_)						foldable effect-free result-true)))

(declare-core-primitive $ratnum-d
    (unsafe)
  (signatures
   ((T:ratnum)					=> (T:exact-integer)))
  (attributes
   ((_)						foldable effect-free result-true)))

(declare-core-primitive $ratnum-num
    (unsafe)
  (signatures
   ((T:ratnum)					=> (T:exact-integer)))
  (attributes
   ((_)						foldable effect-free result-true)))

(declare-core-primitive $ratnum-den
    (unsafe)
  (signatures
   ((T:ratnum)					=> (T:exact-integer)))
  (attributes
   ((_)						foldable effect-free result-true)))

;;; --------------------------------------------------------------------

(declare-ratnum-predicate $ratnum-positive? unsafe)
(declare-ratnum-predicate $ratnum-negative? unsafe)
(declare-ratnum-predicate $ratnum-non-positive? unsafe)
(declare-ratnum-predicate $ratnum-non-negative? unsafe)

;;; --------------------------------------------------------------------

(declare-core-primitive $ratnum->flonum
    (unsafe)
  (signatures
   ((T:ratnum)			=> (T:flonum)))
  (attributes
   ((_)				foldable effect-free result-true)))


;;;; flonums, safe functions

(section

;;; predicates

 (declare-type-predicate flonum? T:flonum)

 (declare-flonum-predicate flzero?		(replacements $flzero?))
 (declare-flonum-predicate flzero?/negative	(replacements $flzero?/negative))
 (declare-flonum-predicate flzero?/positive	(replacements $flzero?/positive))
 (declare-flonum-predicate flpositive?		(replacements $flpositive?))
 (declare-flonum-predicate flnegative?		(replacements $flnegative?))
 (declare-flonum-predicate flnonpositive?	(replacements $flnonpositive?))
 (declare-flonum-predicate flnonnegative?	(replacements $flnonnegative?))
 (declare-flonum-predicate fleven?		(replacements $fleven?))
 (declare-flonum-predicate flodd?		(replacements $flodd?))

 (declare-core-primitive flinteger?
     (safe)
   (signatures
    ((T:flonum-integer)		=> (T:true))
    ((T:flonum-fractional)	=> (T:false))
    ((T:flonum-infinite)	=> (T:false))
    ((T:flonum-nan)		=> (T:false))
    ((T:flonum)			=> (T:boolean)))
   (attributes
    ((_)			foldable effect-free))
   (replacements $flonum-integer?))

 (declare-core-primitive flfinite?
     (safe)
   (signatures
    ((T:flonum-integer)		=> (T:true))
    ((T:flonum-fractional)	=> (T:true))
    ((T:flonum-infinite)	=> (T:false))
    ((T:flonum-nan)		=> (T:false))
    ((T:flonum)			=> (T:boolean)))
   (attributes
    ((_)			foldable effect-free))
   (replacements $flonum-rational?))

 (declare-core-primitive flinfinite?
     (safe)
   (signatures
    ((T:flonum-integer)		=> (T:false))
    ((T:flonum-fractional)	=> (T:false))
    ((T:flonum-infinite)	=> (T:true))
    ((T:flonum-nan)		=> (T:false))
    ((T:flonum)			=> (T:boolean)))
   (attributes
    ((_)			foldable effect-free))
   (replacements $flinfinite?))

 (declare-core-primitive flnan?
     (safe)
   (signatures
    ((T:flonum-integer)		=> (T:false))
    ((T:flonum-fractional)	=> (T:false))
    ((T:flonum-infinite)	=> (T:false))
    ((T:flonum-nan)		=> (T:true))
    ((T:flonum)			=> (T:boolean)))
   (attributes
    ((_)			foldable effect-free))
   (replacements $flnan?))

;;; --------------------------------------------------------------------
;;; rounding

 (let-syntax
     ((declare-flonum-rounding (syntax-rules ()
				 ((_ ?who ?replacement)
				  (declare-core-primitive ?who
				      (safe)
				    (signatures
				     ((T:flonum)	=> (T:flonum-integer)))
				    (attributes
				     ((_)		foldable effect-free result-true))
				    (replacements ?replacement))))))
   (declare-flonum-rounding flround	 $flround)
   (declare-flonum-rounding flfloor	 $flfloor)
   (declare-flonum-rounding flceiling	 $flceiling)
   (declare-flonum-rounding fltruncate	 $fltruncate)
   #| end of LET-SYNTAX |# )

;;; --------------------------------------------------------------------
;;; parts

 (declare-flonum-unary flnumerator	(replacements $flnumerator))
 (declare-flonum-unary fldenominator	(replacements $fldenominator))
 (declare-flonum-unary flabs		(replacements $flabs))

 (declare-core-primitive flonum-bytes
     (safe)
   (signatures
    ((T:flonum)				=> (T:flonum T:flonum T:flonum T:flonum
						     T:flonum T:flonum T:flonum T:flonum)))
   (attributes
    ((_)				effect-free)))

 (declare-core-primitive flonum-parts
     (safe)
   (signatures
    ((T:flonum)				=> (T:boolean T:fixnum T:exact-integer)))
   (attributes
    ((_)				effect-free)))

;;; --------------------------------------------------------------------
;;; trigonometric

 (declare-flonum-unary flsin		(replacements $flsin))
 (declare-flonum-unary flcos		(replacements $flcos))
 (declare-flonum-unary fltan		(replacements $fltan))
 (declare-flonum-unary flasin		(replacements $flasin))
 (declare-flonum-unary flacos		(replacements $flacos))

 (declare-core-primitive flatan
     (safe)
   (signatures
    ((T:flonum)			=> (T:flonum))
    ((T:flonum T:flonum)	=> (T:flonum)))
   (attributes
    ((_)			foldable effect-free result-true)
    ((_ _)			foldable effect-free result-true))
   (replacements $flatan $flatan2))

;;; --------------------------------------------------------------------
;;; hyperbolic

 (declare-flonum-unary flsinh		(replacements $flsinh))
 (declare-flonum-unary flcosh		(replacements $flcosh))
 (declare-flonum-unary fltanh		(replacements $fltanh))
 (declare-flonum-unary flasinh		(replacements $flasinh))
 (declare-flonum-unary flacosh		(replacements $flacosh))
 (declare-flonum-unary flatanh		(replacements $flatanh))

;;; --------------------------------------------------------------------
;;; exponentiation, exponentials, logarithms

 (declare-flonum-unary flexp		(replacements $flexp))
 (declare-flonum-unary/binary fllog	(replacements $fllog $fllog2))
 (declare-flonum-unary flexpm1		(replacements $flexpm1))
 (declare-flonum-unary fllog1p		(replacements $fllog1p))
 (declare-flonum-binary flexpt		(replacements $flexpt))
 (declare-flonum-unary flsqrt		(replacements $flsqrt))
 (declare-flonum-unary flsquare		(replacements $flsquare))
 (declare-flonum-unary flcube		(replacements $flcube))
 (declare-flonum-unary flcbrt		(replacements $flcbrt))
 (declare-flonum-binary flhypot		(replacements $flhypot))

;;; --------------------------------------------------------------------
;;; comparison

 (declare-flonum-unary/multi-comparison fl=?	(replacements $fl=))
 (declare-flonum-unary/multi-comparison fl!=?	(replacements $fl!=))
 (declare-flonum-unary/multi-comparison fl<?	(replacements $fl<))
 (declare-flonum-unary/multi-comparison fl>?	(replacements $fl>))
 (declare-flonum-unary/multi-comparison fl<=?	(replacements $fl<=))
 (declare-flonum-unary/multi-comparison fl>=?	(replacements $fl>=))

;;; --------------------------------------------------------------------
;;; arithmetics

 (declare-flonum-unary/multi fl+		(replacements $fl+))
 (declare-flonum-unary/multi fl-		(replacements $fl-))
 (declare-flonum-unary/multi fl*		(replacements $fl*))
 (declare-flonum-unary/multi fl/		(replacements $fl/))

 (declare-flonum-unary/multi flmin	(replacements $flmin))
 (declare-flonum-unary/multi flmax	(replacements $flmax))

 (declare-flonum-binary fldiv		(replacements $fldiv))
 (declare-flonum-binary fldiv0		(replacements $fldiv0))
 (declare-flonum-binary flmod		(replacements $flmod))
 (declare-flonum-binary flmod0		(replacements $flmod0))

 (declare-core-primitive fldiv-and-mod
     (safe)
   (signatures
    ((T:flonum T:flonum)		=> (T:flonum T:flonum)))
   (attributes
    ((_ _)				effect-free)))

 (declare-core-primitive fldiv0-and-mod0
     (safe)
   (signatures
    ((T:flonum T:flonum)		=> (T:flonum T:flonum)))
   (attributes
    ((_ _)				effect-free)))

;;; --------------------------------------------------------------------
;;; conversion

 (declare-core-primitive flonum->string
     (safe)
   (signatures
    ((T:flonum)		=> (T:string)))
   (attributes
    ((_)			foldable effect-free result-true)))

 (declare-core-primitive real->flonum
     (safe)
   (signatures
    ((T:real)		=> (T:flonum)))
   (attributes
    ((_)			foldable effect-free result-true)))

 /section)


;;;; flonums, unsafe functions

(section

 (declare-core-primitive $make-flonum
     (unsafe)
   (signatures
    (()				=> (T:flonum)))
   ;;Not foldable because $MAKE-FLONUM must return a new flonum every time.
   (attributes
    (()				effect-free result-true)))

 (declare-core-primitive $flonum->exact
     (unsafe)
   (signatures
    ((T:flonum)			=> (T:exact-real)))
   (attributes
    ((_)			foldable effect-free result-true)))

;;; --------------------------------------------------------------------
;;; predicates

 (declare-flonum-predicate $flzero? unsafe)
 (declare-flonum-predicate $flzero?/positive unsafe)
 (declare-flonum-predicate $flzero?/negative unsafe)
 (declare-flonum-predicate $flpositive? unsafe)
 (declare-flonum-predicate $flnegative? unsafe)
 (declare-flonum-predicate $flnonpositive? unsafe)
 (declare-flonum-predicate $flnonnegative? unsafe)

 (declare-flonum-predicate $fleven? unsafe)
 (declare-flonum-predicate $flodd? unsafe)

 (declare-core-primitive $flonum-integer?
     (unsafe)
   (signatures
    ((T:flonum-integer)		=> (T:true))
    ((T:flonum-fractional)	=> (T:false))
    ((T:flonum-infinite)	=> (T:false))
    ((T:flonum-nan)		=> (T:false))
    ((T:flonum)			=> (T:boolean)))
   (attributes
    ((_)			foldable effect-free)))

 (declare-core-primitive $flonum-rational?
     (unsafe)
   (signatures
    ((T:flonum-integer)		=> (T:true))
    ((T:flonum-fractional)	=> (T:true))
    ((T:flonum-infinite)	=> (T:false))
    ((T:flonum-nan)		=> (T:false))
    ((T:flonum)			=> (T:boolean)))
   (attributes
    ((_)			foldable effect-free)))

 (declare-core-primitive $flinfinite?
     (unsafe)
   (signatures
    ((T:flonum-integer)		=> (T:false))
    ((T:flonum-fractional)	=> (T:false))
    ((T:flonum-infinite)	=> (T:true))
    ((T:flonum-nan)		=> (T:false))
    ((T:flonum)			=> (T:boolean)))
   (attributes
    ((_)			foldable effect-free)))

 (declare-core-primitive $flnan?
     (unsafe)
   (signatures
    ((T:flonum-integer)		=> (T:false))
    ((T:flonum-fractional)	=> (T:false))
    ((T:flonum-infinite)	=> (T:false))
    ((T:flonum-nan)		=> (T:true))
    ((T:flonum)			=> (T:boolean)))
   (attributes
    ((_)			foldable effect-free)))

;;; --------------------------------------------------------------------
;;; rounding

 (let-syntax
     ((declare-flonum-rounding (syntax-rules ()
				 ((_ ?who)
				  (declare-core-primitive ?who
				      (unsafe)
				    (signatures
				     ((T:flonum)	=> (T:flonum-integer)))
				    (attributes
				     ((_)		foldable effect-free result-true)))))))
   (declare-flonum-rounding $flround)
   (declare-flonum-rounding $flfloor)
   (declare-flonum-rounding $flceiling)
   (declare-flonum-rounding $fltruncate)
   #| end of LET-SYNTAX |# )

;;; --------------------------------------------------------------------
;;; parts

 (declare-flonum-unary $flnumerator unsafe)
 (declare-flonum-unary $fldenominator unsafe)
 (declare-flonum-unary $flabs unsafe)

 (declare-core-primitive $flonum-u8-ref
     (unsafe)
   (signatures
    ((T:flonum T:fixnum)		=> (T:fixnum)))
   (attributes
    ((_ _)			effect-free result-true)))

 (declare-core-primitive $flonum-sbe
     (unsafe)
   (signatures
    ((T:flonum)			=> (T:fixnum)))
   (attributes
    ((_)				effect-free result-true)))

 (declare-core-primitive $flonum-set!
     (unsafe)
   (signatures
    ((T:flonum T:fixnum T:fixnum)	=> (T:void)))
   (attributes
    ((_ _ _)				result-true)))

;;; --------------------------------------------------------------------
;;; trigonometric

 (declare-flonum-unary $flsin unsafe)
 (declare-flonum-unary $flcos unsafe)
 (declare-flonum-unary $fltan unsafe)
 (declare-flonum-unary $flasin unsafe)
 (declare-flonum-unary $flacos unsafe)
 (declare-flonum-unary $flatan unsafe)
 (declare-flonum-binary $flatan2 unsafe)

;;; --------------------------------------------------------------------
;;; hyperbolic

 (declare-flonum-unary $flsinh unsafe)
 (declare-flonum-unary $flcosh unsafe)
 (declare-flonum-unary $fltanh unsafe)
 (declare-flonum-unary $flasinh unsafe)
 (declare-flonum-unary $flacosh unsafe)
 (declare-flonum-unary $flatanh unsafe)

;;; --------------------------------------------------------------------
;;; exponentiation, exponentials, logarithms

 (declare-flonum-unary $flexp unsafe)
 (declare-flonum-unary $fllog unsafe)
 (declare-flonum-binary $fllog2 unsafe)
 (declare-flonum-unary $flexpm1 unsafe)
 (declare-flonum-unary $fllog1p unsafe)
 (declare-flonum-binary $flexpt unsafe)
 (declare-flonum-unary $flsqrt unsafe)
 (declare-flonum-unary $flsquare unsafe)
 (declare-flonum-unary $flcube unsafe)
 (declare-flonum-unary $flcbrt unsafe)
 (declare-flonum-binary $flhypot unsafe)

;;; --------------------------------------------------------------------
;;; comparison

 (declare-flonum-binary-comparison $fl=  unsafe)
 (declare-flonum-binary-comparison $fl!= unsafe)
 (declare-flonum-binary-comparison $fl<  unsafe)
 (declare-flonum-binary-comparison $fl>  unsafe)
 (declare-flonum-binary-comparison $fl<= unsafe)
 (declare-flonum-binary-comparison $fl>= unsafe)

;;; --------------------------------------------------------------------
;;; arithmetics

 (declare-flonum-binary $fl+ unsafe)
 (declare-flonum-unary/binary $fl- unsafe)
 (declare-flonum-binary $fl* unsafe)
 (declare-flonum-binary $fl/ unsafe)

 (declare-flonum-binary $fldiv unsafe)
 (declare-flonum-binary $flmod unsafe)
 (declare-flonum-binary $fldiv0 unsafe)
 (declare-flonum-binary $flmod0 unsafe)

 (declare-flonum-binary $flmax unsafe)
 (declare-flonum-binary $flmin unsafe)

 (declare-core-primitive $fldiv-and-mod
     (unsafe)
   (signatures
    ((T:flonum T:flonum)	=> (T:flonum T:flonum)))
   (attributes
    ((_ _)			effect-free)))

 (declare-core-primitive $fldiv0-and-mod0
     (unsafe)
   (signatures
    ((T:flonum T:flonum)	=> (T:flonum T:flonum)))
   (attributes
    ((_ _)			effect-free)))

 /section)


;;;; cflonums, safe functions

(declare-type-predicate cflonum? T:cflonum)



;;;; cflonums, unsafe functions

;;; constructors

(declare-core-primitive $make-cflonum
    (unsafe)
  (signatures
   ((T:real T:real)		=> (T:cflonum)))
  (attributes
   ((_ _)			foldable effect-free result-true)))

;;; --------------------------------------------------------------------
;;; accessors

(declare-core-primitive $cflonum-real
    (unsafe)
  (signatures
   ((T:cflonum)			=> (T:flonum)))
  (attributes
   ((_)				foldable effect-free result-true)))

(declare-core-primitive $cflonum-imag
    (unsafe)
  (signatures
   ((T:cflonum)			=> (T:flonum)))
  (attributes
   ((_)				foldable effect-free result-true)))


;;;; compnums, safe functions

(declare-type-predicate compnum? T:compnum)


;;;; compnums, unsafe functions

;;; constructors

(declare-core-primitive $make-compnum
    (unsafe)
  (signatures
   ((T:real T:real)		=> (T:compnum)))
  (attributes
   ((_ _)			foldable effect-free result-true)))

(declare-core-primitive $make-rectangular
    (unsafe)
  (signatures
   ((T:real T:real)		=> (T:complex)))
  (attributes
   ((_ _)			foldable effect-free result-true)))

;;; --------------------------------------------------------------------
;;; accessors

(declare-core-primitive $compnum-real
    (unsafe)
  (signatures
   ((T:compnum)			=> (T:real)))
  (attributes
   ((_)				foldable effect-free result-true)))

(declare-core-primitive $compnum-imag
    (unsafe)
  (signatures
   ((T:compnum)			=> (T:real)))
  (attributes
   ((_)				foldable effect-free result-true)))

;;; --------------------------------------------------------------------
;;; conversion

(declare-core-primitive $compnum->cflonum
    (unsafe)
  (signatures
   ((T:compnum)			=> (T:cflonum)))
  (attributes
   ((_)				foldable effect-free result-true)))


;;;; symbols, safe primitives

(declare-type-predicate symbol? T:symbol)

(declare-core-primitive symbol->string
    (safe)
  (signatures
   ((T:symbol)			=> (T:string)))
  (attributes
   ((_)				foldable effect-free result-true)))

(declare-core-primitive symbol=?
    (safe)
  (signatures
   ((T:symbol T:symbol)		=> (T:boolean)))
  (attributes
   ((_ _)			foldable effect-free result-true)))

;;; --------------------------------------------------------------------
;;; gensyms

(declare-type-predicate gensym?)

(declare-core-primitive gensym
    (safe)
  (signatures
   (()				=> (T:symbol))
   ((T:symbol)			=> (T:symbol))
   ((T:string)			=> (T:symbol)))
  (attributes
   ;;It must return a new gensym every time.
   (()				effect-free result-true)
   ((_)				effect-free result-true)))

(declare-core-primitive gensym->unique-string
    (safe)
  (signatures
   ((T:symbol)			=> (T:string)))
  (attributes
   ;;Once a  gensym has been  created, its unique  string is determined  forever.  So
   ;;this is foldable.
   ((_)				foldable effect-free result-true)))

;;; --------------------------------------------------------------------

(declare-core-primitive symbol-bound?
    (safe)
  (signatures
   ((T:symbol)			=> (T:boolean)))
  (attributes
   ;;Being bound or not is a run-time property; this is *not* foldable.
   ((_)				effect-free)))

(declare-core-primitive top-level-value
    (safe)
  (signatures
   ((T:symbol)			=> (T:object)))
  (attributes
   ((_)				effect-free)))

(declare-core-primitive reset-symbol-proc!
    (safe)
  (signatures
   ((T:symbol)			=> (T:void)))
  (attributes
   ((_)				result-true)))

(declare-core-primitive set-symbol-value!
    (safe)
  (signatures
   ((T:symbol T:object)		=> (T:void)))
  (attributes
   ((_ _)			result-true)))

;;; --------------------------------------------------------------------

(declare-core-primitive symbol-value
    (safe)
  (signatures
   ((T:symbol)			=> (T:object)))
  (attributes
   ((_)				effect-free)))

(declare-core-primitive system-value
    (safe)
  (signatures
   ((T:symbol)			=> (T:object)))
  (attributes
   ((_)				effect-free)))

(declare-core-primitive system-label
    (safe)
  (signatures
   ((T:symbol)			=> (T:object)))
  (attributes
   ((_)				effect-free)))

(declare-core-primitive system-id
    (safe)
  (signatures
   ((T:symbol)			=> (T:object)))
  (attributes
   ((_)				effect-free)))

;;FIXME These  are variable  bindings.  We  should convert  them into  functions, for
;;uniformity of syntax.  (Marco Maggi; Thu Nov 20, 2014)
;;
;; (declare-core-primitive system-value-gensym
;;     (safe)
;;   (signatures
;;    (()				=> (T:symbol)))
;;   (attributes
;;    (()				effect-free result-true)))
;;
;; (declare-core-primitive system-label-gensym
;;     (safe)
;;   (signatures
;;    (()				=> (T:symbol)))
;;   (attributes
;;    (()				effect-free result-true)))
;;
;; (declare-core-primitive system-id-gensym
;;     (safe)
;;   (signatures
;;    (()				=> (T:symbol)))
;;   (attributes
;;    (()				effect-free result-true)))

;;; --------------------------------------------------------------------
;;; property lists

(declare-core-primitive putprop
    (safe)
  (signatures
   ((T:symbol T:symbol _) => (_)))
  (attributes
   ((_ _ _)		result-true))
  (replacements $putprop))

(declare-core-primitive getprop
    (safe)
  (signatures
   ((T:symbol T:symbol) => (T:void)))
  (attributes
   ((_ _)		effect-free))
  (replacements $getprop))

(declare-core-primitive remprop
    (safe)
  (signatures
   ((T:symbol T:symbol) => (T:void)))
  (attributes
   ((_ _)		result-true))
  (replacements $remprop))

(declare-core-primitive property-list
    (safe)
  ;;The return value can be null or a pair.
  (signatures
   ((T:symbol) => (_)))
  (attributes
   ((_)			effect-free result-true))
  (replacements $property-list))

;;; --------------------------------------------------------------------
;;; printing gensyms

(declare-core-primitive print-gensym
    (safe)
  (signatures
   (()				=> (T:object))
   ((T:object)			=> (T:void))
   ((T:object T:object)		=> (T:void)))
  (attributes
   (()				effect-free)
   ((_)				result-true)
   ((_ _)			result-true)))

(declare-core-primitive gensym-count
    (safe)
  (signatures
   (()				=> (T:exact-integer))
   ((T:exact-integer)		=> (T:void))
   ((T:exact-integer T:object)	=> (T:void)))
  (attributes
   (()				effect-free result-true)
   ((_)				result-true)
   ((_ _)			result-true)))

(declare-core-primitive gensym-prefix
    (safe)
  (signatures
   (()				=> (T:string))
   ((T:string)			=> (T:void))
   ((T:string T:object)		=> (T:void)))
  (attributes
   (()				effect-free result-true)
   ((_)				result-true)
   ((_ _)			result-true)))


;;;; symbols, unsafe primitives

(declare-core-primitive $make-symbol
    (unsafe)
  (signatures
   ((T:false)			=> (T:symbol))
   ((T:string)			=> (T:symbol)))
  (attributes
   ((_)				effect-free result-true)))

;;; --------------------------------------------------------------------
;;; components

(let-syntax
    ((declare-symbol-accessor (syntax-rules ()
				((_ ?who ?rv-tag)
				 (declare-core-primitive ?who
				     (unsafe)
				   (signatures
				    ((T:symbol)		=> (?rv-tag)))
				   (attributes
				    ((_)		effect-free))))
				)))
  (declare-symbol-accessor $symbol-plist		T:proper-list)
  (declare-symbol-accessor $symbol-proc			T:object)
  (declare-symbol-accessor $symbol-string		T:string)
  (declare-symbol-accessor $symbol-unique-string	T:string)
  (declare-symbol-accessor $symbol-value		T:object)
  #| end of LET-SYNTAX |# )

(let-syntax
    ((declare-symbol-mutator (syntax-rules ()
			       ((_ ?who ?obj-tag)
				(declare-core-primitive ?who
				    (unsafe)
				  (signatures
				   ((T:symbol ?obj-tag)	=> (T:void)))))
			       )))
  (declare-symbol-mutator $set-symbol-value!		T:object)
  (declare-symbol-mutator $set-symbol-proc!		T:object)
  (declare-symbol-mutator $set-symbol-string!		T:string)
  (declare-symbol-mutator $set-symbol-unique-string!	T:string/false)
  (declare-symbol-mutator $set-symbol-plist!		T:proper-list)
  #| end of LET-SYNTAX |# )

;;; --------------------------------------------------------------------
;;; property lists

(declare-core-primitive $putprop
    (unsafe)
  (signatures
   ((T:symbol T:symbol _) => (T:void)))
  (attributes
   ((_ _ _)		result-true)))

(declare-core-primitive $getprop
    (unsafe)
  (signatures
   ((T:symbol T:symbol) => (T:void)))
  (attributes
   ((_ _)		effect-free)))

(declare-core-primitive $remprop
    (unsafe)
  (signatures
   ((T:symbol T:symbol) => (T:void)))
  (attributes
   ((_ _)		result-true)))

(declare-core-primitive $property-list
    (unsafe)
  (signatures
   ((T:symbol) => (_)))
  (attributes
   ((_)			effect-free	result-true)))

;;; --------------------------------------------------------------------
;;; conversion

(declare-core-primitive $symbol->string
    (unsafe)
  (signatures
   ((T:symbol)			=> (T:string)))
  (attributes
   ((_)				foldable effect-free result-true)))


;;;; keywords, safe functions

(declare-type-predicate keyword? T:keyword)

;;; --------------------------------------------------------------------
;;; constructors

(declare-core-primitive symbol->keyword
    (safe)
  (signatures
   ((T:symbol)			=> (T:keyword)))
  (attributes
   ((_)				effect-free result-true)))

;;; --------------------------------------------------------------------
;;; comparison

(declare-keyword-binary-comparison keyword=?)

;;; --------------------------------------------------------------------
;;; conversion

(declare-core-primitive keyword->symbol
    (safe)
  (signatures
   ((T:keyword)			=> (T:symbol)))
  (attributes
   ((_)				effect-free result-true)))

(declare-core-primitive keyword->string
    (safe)
  (signatures
   ((T:keyword)			=> (T:string)))
  (attributes
   ((_)				effect-free result-true)))

;;; --------------------------------------------------------------------
;;; miscellaneous

(declare-core-primitive keyword-hash
    (safe)
  (signatures
   ((T:keyword)			=> (T:exact-integer)))
  (attributes
   ((_)				effect-free result-true)))



;;;; keywords, unsafe functions

;;; constructors

(declare-core-primitive $symbol->keyword
    (unsafe)
  (signatures
   ((T:symbol)			=> (T:keyword)))
  (attributes
   ((_)				effect-free result-true)))

;;; --------------------------------------------------------------------
;;; comparison

(declare-keyword-binary-comparison $keyword=? unsafe)

;;; --------------------------------------------------------------------
;;; conversion

(declare-core-primitive $keyword->symbol
    (unsafe)
  (signatures
   ((T:keyword)			=> (T:symbol)))
  (attributes
   ((_)				effect-free result-true)))

(declare-core-primitive $keyword->string
    (unsafe)
  (signatures
   ((T:keyword)			=> (T:string)))
  (attributes
   ((_)				effect-free result-true)))

;;; --------------------------------------------------------------------
;;; miscellaneous

(declare-core-primitive $keyword-hash
    (unsafe)
  (signatures
   ((T:keyword)			=> (T:exact-integer)))
  (attributes
   ((_)				effect-free result-true)))


;;;; characters safe operations

;;; predicates

(declare-type-predicate char? T:char)

(declare-char-predicate char-in-ascii-range?)
(declare-char-predicate char-alphabetic?)
(declare-char-predicate char-lower-case?)
(declare-char-predicate char-numeric?)
(declare-char-predicate char-title-case?)
(declare-char-predicate char-upper-case?)
(declare-char-predicate char-whitespace?)
(declare-char-predicate unicode-printable-char?)

;;; --------------------------------------------------------------------
;;; comparison

(declare-char-binary/multi-comparison char=?		(replacements $char=))
(declare-char-binary/multi-comparison char!=?		(replacements $char!=))
(declare-char-binary/multi-comparison char<?		(replacements $char<))
(declare-char-binary/multi-comparison char>?		(replacements $char>))
(declare-char-binary/multi-comparison char<=?		(replacements $char<=))
(declare-char-binary/multi-comparison char>=?		(replacements $char>=))

(declare-char-binary/multi-comparison char-ci=?)
(declare-char-binary/multi-comparison char-ci!=?)
(declare-char-binary/multi-comparison char-ci<?)
(declare-char-binary/multi-comparison char-ci>?)
(declare-char-binary/multi-comparison char-ci<=?)
(declare-char-binary/multi-comparison char-ci>=?)

;;; --------------------------------------------------------------------
;;; transformations

(declare-char-unary char-downcase)
(declare-char-unary char-foldcase)
(declare-char-unary char-titlecase)
(declare-char-unary char-upcase)
(declare-char-unary char-general-category)

;;; --------------------------------------------------------------------
;;; conversion

(declare-core-primitive char->integer
    (safe)
  (signatures
   ((T:char)			=> (T:fixnum)))
  (attributes
   ((_)				foldable effect-free result-true)))


;;;; characters unsafe operations

;;; --------------------------------------------------------------------
;;; comparison

(declare-char-binary-comparison $char=		unsafe)
(declare-char-binary-comparison $char!=		unsafe)
(declare-char-binary-comparison $char>		unsafe)
(declare-char-binary-comparison $char<		unsafe)
(declare-char-binary-comparison $char>=		unsafe)
(declare-char-binary-comparison $char<=		unsafe)

;;; --------------------------------------------------------------------
;;; conversion

(declare-core-primitive $char->fixnum
    (unsafe)
  (signatures
   ((T:char)			=> (T:fixnum)))
  (attributes
   ((_)				foldable effect-free result-true)))


;;;; pointers, safe functions

(declare-type-predicate pointer? T:pointer)

;;; --------------------------------------------------------------------

(declare-core-primitive pointer-null?
    (safe)
  (signatures
   ((T:pointer)			=> (T:boolean)))
  (attributes
   ((_)				effect-free)))

(declare-core-primitive null-pointer
    (safe)
  (signatures
   (()				=> (T:pointer)))
  (attributes
   (()				effect-free result-true)))

(declare-core-primitive set-pointer-null!
    (safe)
  (signatures
   ((T:pointer)			=> (T:void)))
  (attributes
   ((_)				result-true)))

;;; --------------------------------------------------------------------

(declare-core-primitive pointer-clone
    (safe)
  (signatures
   ((T:pointer)			=> (T:pointer)))
  (attributes
   ((_)				effect-free result-true)))

(declare-core-primitive pointer-diff
    (safe)
  (signatures
   ((T:pointer T:pointer)	=> (T:exact-integer)))
  (attributes
   ((_ _)			effect-free result-true)))

(declare-core-primitive pointer-add
    (safe)
  (signatures
   ((T:pointer T:exact-integer)	=> (T:pointer)))
  (attributes
   ((_ _)			effect-free result-true)))

(declare-core-primitive pointer-and-offset?
    (safe)
  (signatures
   ((T:pointer T:exact-integer)	=> (T:boolean)))
  (attributes
   ((_ _)			effect-free)))

;;; --------------------------------------------------------------------

(declare-pointer-binary-comparison pointer=?)
(declare-pointer-binary-comparison pointer!=?)
(declare-pointer-binary-comparison pointer<?)
(declare-pointer-binary-comparison pointer>?)
(declare-pointer-binary-comparison pointer<=?)
(declare-pointer-binary-comparison pointer>=?)

;;; --------------------------------------------------------------------

(declare-core-primitive pointer->integer
    (safe)
  (signatures
   ((T:pointer)			=> (T:exact-integer)))
  (attributes
   ((_)				foldable effect-free result-true)))

(declare-core-primitive integer->pointer
    (safe)
  (signatures
   ((T:exact-integer)		=> (T:pointer)))
  (attributes
   ((_)				foldable effect-free result-true)))


;;;; pointers, unsafe functions

(declare-pointer-binary-comparison $pointer= unsafe)


;;;; strings, safe functions
;;
;;According to R6RS:  STRING and MAKE-STRING must return a  newly allocated string at
;;every invocation;  if we want the  same string we  just use the double  quotes.  So
;;STRING and MAKE-STRING are not FOLDABLE.
;;

;;; predicates

(declare-type-predicate string? T:string)

(declare-string-predicate string-empty?)

;;; --------------------------------------------------------------------
;;; constructors

(declare-core-primitive string
    (safe)
  (signatures
   (()			=> (T:string))
   (T:char		=> (T:string)))
  ;;Not  foldable because  it must  return a  newly allocated  string, even  when the
  ;;return value is an empty string.
  (attributes
   (()			effect-free result-true)
   (_			effect-free result-true)))

(declare-core-primitive make-string
    (safe)
  (signatures
   ((T:fixnum)		=> (T:string))
   ((T:fixnum T:char)	=> (T:string)))
  ;;Not  foldable because  it must  return a  newly allocated  string, even  when the
  ;;return value is an empty string.
  (attributes
   ((0)			effect-free result-true)
   ((0 . _)		effect-free result-true)
   (_			effect-free result-true)))

(declare-core-primitive substring
    (safe)
  (signatures
   ((T:string T:fixnum T:fixnum)	=> (T:string)))
  ;;Not  foldable because  it must  return a  newly allocated  string, even  when the
  ;;return value is an empty string.
  (attributes
   ((_ _ _)				effect-free result-true)))

(declare-core-primitive string-copy
    (safe)
  (signatures
   ((T:string)		=> (T:void)))
  (attributes
   ((_)			effect-free result-true)))

(declare-core-primitive string-copy!
    (safe)
  (signatures
   ((T:string T:fixnum T:string T:fixnum T:fixnum)	=> (T:void)))
  (attributes
   ((_ _)		result-true)))

(declare-core-primitive string-append
    (safe)
  (signatures
   (T:string			=> (T:string)))
  (attributes
   (_				effect-free result-true)))

(declare-core-primitive string-reverse-and-concatenate
    (safe)
  (signatures
   ((T:proper-list)		=> (T:string)))
  (attributes
   ((_)				effect-free result-true)))

;;; --------------------------------------------------------------------
;;; inspection

(declare-core-primitive string-length
    (safe)
  (signatures
   ((T:string)		=> (T:fixnum)))
  (attributes
   ((_)			foldable effect-free result-true))
  (replacements $string-length))

(declare-core-primitive string-for-each
    (safe)
  (signatures
   ((T:procedure T:string . T:string)		=> (T:void)))
  (attributes
   ;;Not foldable and not effect-free because it applies an unknown procedure.
   ((_ _ . _)					result-true)))

;;; --------------------------------------------------------------------
;;; accessors and mutators

;;FIXME  This cannot  have $STRING-REF  as  replacement because  there is  no way  to
;;validate the index with respect to the string.  But in future another primitive can
;;be added that does not validate the  types, but validates the range.  (Marco Maggi;
;;Mon Nov 10, 2014)
(declare-core-primitive string-ref
    (safe)
  (signatures
   ((T:string T:fixnum)	=> (T:char)))
  (attributes
   ((_ _)		foldable effect-free result-true)))

;;FIXME This  cannot have  $STRING-SET!  as  replacement because there  is no  way to
;;validate the index with respect to the string.  But in future another primitive can
;;be added that does not validate the  types, but validates the range.  (Marco Maggi;
;;Mon Nov 10, 2014)
(declare-core-primitive string-set!
    (safe)
  (signatures
   ((T:string T:fixnum T:char)	=> (T:void)))
  (attributes
   ((_ _ _)		result-true)))

(declare-core-primitive string-fill!
    (safe)
  (signatures
   ((T:string T:char)	=> (T:void)))
  (attributes
   ((_ _)		result-true)))

;;; --------------------------------------------------------------------
;;; comparison

(declare-string-binary/multi-comparison string<=?)
(declare-string-binary/multi-comparison string<?)
(declare-string-binary/multi-comparison string=?)
(declare-string-binary/multi-comparison string>=?)
(declare-string-binary/multi-comparison string>?)

(declare-string-binary/multi-comparison string-ci<=?)
(declare-string-binary/multi-comparison string-ci<?)
(declare-string-binary/multi-comparison string-ci=?)
(declare-string-binary/multi-comparison string-ci>=?)
(declare-string-binary/multi-comparison string-ci>?)

;;; --------------------------------------------------------------------
;;; transformation

(declare-string-unary string-titlecase)
(declare-string-unary string-upcase)
(declare-string-unary string-downcase)
(declare-string-unary string-foldcase)

(declare-string-unary string-normalize-nfc)
(declare-string-unary string-normalize-nfd)
(declare-string-unary string-normalize-nfkc)
(declare-string-unary string-normalize-nfkd)

;;; --------------------------------------------------------------------
;;; conversion

(declare-core-primitive string->flonum
    (safe)
  (signatures
   ((T:string)		=> (T:flonum)))
  (attributes
   ((_)			foldable effect-free result-true)))

(declare-core-primitive string->number
    (safe)
  (signatures
   ((T:string)		=> (T:number/false))
   ((T:string T:fixnum)	=> (T:number/false)))
  (attributes
   ((_)			foldable effect-free)
   ((_ _)		foldable effect-free)))

(declare-core-primitive string->utf8
    (safe)
  (signatures
   ((T:string)			=> (T:bytevector)))
  (attributes
   ;;Not foldable because it must return a new bytevector at every application.
   ((_)				effect-free result-true)))

(declare-core-primitive string->utf16
    (safe)
  (signatures
   ((T:string)			=> (T:bytevector))
   ((T:string T:symbol)		=> (T:bytevector)))
  (attributes
   ;;Not foldable because it must return a new bytevector at every application.
   ((_ _)			effect-free result-true)))

(declare-core-primitive string->utf16be
    (safe)
  (signatures
   ((T:string)			=> (T:bytevector)))
  (attributes
   ;;Not foldable because it must return a new bytevector at every application.
   ((_)				effect-free result-true)))

(declare-core-primitive string->utf16le
    (safe)
  (signatures
   ((T:string)			=> (T:bytevector)))
  (attributes
   ;;Not foldable because it must return a new bytevector at every application.
   ((_)				effect-free result-true)))

(declare-core-primitive string->utf16n
    (safe)
  (signatures
   ((T:string)			=> (T:bytevector)))
  (attributes
   ;;Not foldable because it must return a new bytevector at every application.
   ((_)				effect-free result-true)))

(declare-core-primitive string->utf32
    (safe)
  (signatures
   ((T:string)			=> (T:bytevector)))
  (attributes
   ;;Not foldable because it must return a new bytevector at every application.
   ((_)				effect-free result-true)))

(declare-core-primitive string->ascii
    (safe)
  (signatures
   ((T:string)			=> (T:bytevector)))
  (attributes
   ;;Not foldable because it must return a new bytevector at every application.
   ((_)				effect-free result-true)))

(declare-core-primitive string->latin1
    (safe)
  (signatures
   ((T:string)			=> (T:bytevector)))
  (attributes
   ;;Not foldable because it must return a new bytevector at every application.
   ((_)				effect-free result-true)))

(declare-core-primitive string->bytevector
    (safe)
  (signatures
   ((T:string T:transcoder)	=> (T:bytevector)))
  (attributes
   ;;Not foldable because it must return a new bytevector at every application.
   ((_ _)			effect-free result-true)))

(declare-core-primitive string->symbol
    (safe)
  (signatures
   ((T:string)			=> (T:symbol)))
  (attributes
   ((_)				foldable effect-free result-true)))

(declare-core-primitive string-or-symbol->string
    (safe)
  (signatures
   ((T:string)			=> (T:string))
   ((T:symbol)			=> (T:string)))
  (attributes
   ;;Not foldable because it must return a new string at every application.
   ((_)				effect-free result-true)))

(declare-core-primitive string-or-symbol->symbol
    (safe)
  (signatures
   ((T:string)			=> (T:symbol))
   ((T:symbol)			=> (T:symbol)))
  (attributes
   ((_)				foldable effect-free result-true)))

(declare-core-primitive string->keyword
    (safe)
  (signatures
   ((T:string)			=> (T:other-object)))
  (attributes
   ;;Not foldable because keywords cannot be serialised in fasl files.
   ((_)				effect-free result-true)))

(declare-core-primitive string->list
    (safe)
  (signatures
   ((T:string)			=> (T:proper-list)))
  (attributes
   ;;Not foldable because it must return a new list at every application.
   ((_)				effect-free result-true)))


;;;; strings, unsafe functions

;;; predicates

(declare-string-predicate $string-empty?)
(declare-string-predicate $octets-encoded-string?)
(declare-string-predicate $ascii-encoded-string?)
(declare-string-predicate $latin1-encoded-string?)
(declare-string-predicate $uri-encoded-string?)
(declare-string-predicate $percent-encoded-string?)

;;; --------------------------------------------------------------------
;;; constructors

(declare-core-primitive $make-string
    (unsafe)
  (signatures
   ((T:fixnum)		=> (T:string)))
  (attributes
   ;;Not foldable because it must return a new string every time.
   ((_)			effect-free result-true)))

(declare-core-primitive $string
    (unsafe)
  (signatures
   (T:char		=> (T:string)))
  (attributes
   ;;Not foldable because it must return a new string every time.
   (_			effect-free result-true)))

(declare-core-primitive $string-concatenate
    (unsafe)
  (signatures
   ((T:exact-integer T:proper-list)	=> (T:string)))
  (attributes
   ((_ ())			foldable effect-free result-true)
   ;;Not foldable because it must return a new string every time.
   ((_ _)			effect-free result-true)))

(declare-core-primitive $string-reverse-and-concatenate
    (unsafe)
  (signatures
   ((T:exact-integer T:proper-list)	=> (T:string)))
  (attributes
   ((_ ())			foldable effect-free result-true)
   ;;Not foldable because it must return a new string every time.
   ((_ _)			effect-free result-true)))

;;; --------------------------------------------------------------------
;;; inspection

(declare-core-primitive $string-length
    (unsafe)
  (signatures
   ((T:string)		=> (T:fixnum)))
  (attributes
   ((_)			foldable effect-free result-true)))

(declare-core-primitive $string-total-length
    (unsafe)
  (signatures
   ((T:exact-integer T:proper-list)	=> (T:exact-integer)))
  (attributes
   ((_)				foldable effect-free result-true)))

;;; --------------------------------------------------------------------
;;; accessors and mutators

(declare-core-primitive $string-ref
    (unsafe)
  (signatures
   ((T:string T:fixnum)	=> (T:char)))
  (attributes
   ((_ _)		foldable effect-free result-true)))

(declare-core-primitive $string-set!
    (unsafe)
  (signatures
   ((T:string T:fixnum T:char)	=> (T:void)))
  (attributes
   ((_ _ _)		result-true)))

;;; --------------------------------------------------------------------
;;; comparison

(declare-string-binary-comparison $string=)

;;; --------------------------------------------------------------------
;;; conversion

(declare-core-primitive $string->ascii
    (unsafe)
  (signatures
   ((T:string)		=> (T:bytevector)))
  (attributes
   ;;Not foldable because it must return a new bytevector every time.
   ((_)			effect-free result-true)))

(declare-core-primitive $string->octets
    (unsafe)
  (signatures
   ((T:string)		=> (T:bytevector)))
  (attributes
   ;;Not foldable because it must return a new bytevector every time.
   ((_)			effect-free result-true)))

(declare-core-primitive $string->latin1
    (unsafe)
  (signatures
   ((T:string)		=> (T:bytevector)))
  (attributes
   ;;Not foldable because it must return a new bytevector every time.
   ((_)			effect-free result-true)))

(declare-core-primitive $string-base64->bytevector
    (unsafe)
  (signatures
   ((T:string)		=> (T:bytevector)))
  (attributes
   ;;Not foldable because it must return a new bytevector every time.
   ((_)			effect-free result-true)))

(declare-core-primitive $string->symbol
    (unsafe)
  (signatures
   ((T:string)		=> (T:symbol)))
  (attributes
   ((_)			foldable effect-free result-true)))

;;; --------------------------------------------------------------------
;;; miscellaneous

(declare-core-primitive $interned-strings
    (unsafe)
  (signatures
   (()			=> (T:vector)))
  (attributes
   ((_)			effect-free result-true)))


;;;; vectors, safe functions
;;
;;According to R6RS:  VECTOR and MAKE-VECTOR must return a  newly allocated string at
;;every invocation; so they are not foldable.
;;

;;; predicates

(declare-type-predicate vector? T:vector)

(declare-vector-predicate vector-empty?)

;;; --------------------------------------------------------------------
;;; constructors

(declare-core-primitive vector
    (safe)
  (signatures
   (()				=> (T:vector))
   (_				=> (T:vector)))
  ;;Not foldable because it must return a newly allocated vector.
  (attributes
   (()				effect-free result-true)
   (_				effect-free result-true)))

(declare-core-primitive subvector
    (safe)
  (signatures
   ((T:vector T:non-negative-fixnum T:non-negative-fixnum)	=> (T:vector)))
  ;;Not foldable because it must return a newly allocated vector.
  (attributes
   ((_ _ _)			effect-free result-true)))

(declare-core-primitive make-vector
    (safe)
  (signatures
   ((T:fixnum)			=> (T:vector))
   ((T:fixnum _)		=> (T:vector)))
  ;;Not foldable because it must return a newly allocated vector.
  (attributes
   ((0)				effect-free result-true)
   ((0 _)			effect-free result-true)
   ((_ _)			effect-free result-true)))

(declare-core-primitive vector-resize
    (safe)
  (signatures
   ((T:vector T:non-negative-fixnum)		=> (T:vector))
   ((T:vector T:non-negative-fixnum T:object)	=> (T:vector)))
  ;;Not foldable because it must return a newly allocated vector.
  (attributes
   ((_ _)			effect-free result-true)
   ((_ _ _)			effect-free result-true)))

(declare-core-primitive vector-append
    (safe)
  (signatures
   (T:vector			=> (T:vector)))
  ;;Not foldable because it must return a newly allocated vector.
  (attributes
   (_				effect-free result-true)))

(declare-core-primitive vector-copy
    (safe)
  (signatures
   ((T:vector)			=> (T:vector)))
  ;;Not foldable because it must return a newly allocated vector.
  (attributes
   ((_)				effect-free result-true)))

;;; --------------------------------------------------------------------
;;; inspection

(declare-core-primitive vector-length
    (safe)
  (signatures
   ((T:vector)			=> (T:fixnum)))
  (attributes
   ((_)				foldable effect-free result-true))
  (replacements
   $vector-length))

;;; --------------------------------------------------------------------
;;; accessors and mutators

;;FIXME  This cannot  have $VECTOR-REF  as  replacement because  there is  no way  to
;;validate the index with respect to the vector.  But in future another primitive can
;;be added that does not validate the  types, but validates the range.  (Marco Maggi;
;;Mon Nov 10, 2014)
(declare-core-primitive vector-ref
    (safe)
  (signatures
   ((T:vector T:fixnum)	=> (T:char)))
  (attributes
   ((_ _)		foldable effect-free)))

;;FIXME This  cannot have  $VECTOR-SET!  as  replacement because there  is no  way to
;;validate the index with respect to the vector.  But in future another primitive can
;;be added that does not validate the  types, but validates the range.  (Marco Maggi;
;;Mon Nov 10, 2014)
(declare-core-primitive vector-set!
    (safe)
  (signatures
   ((T:vector T:fixnum _)	=> (T:void)))
  (attributes
   ((_ _ _)			result-true)))

(declare-core-primitive vector-copy!
    (safe)
  (signatures
   ((T:vector T:non-negative-fixnum T:vector T:non-negative-fixnum T:non-negative-fixnum)	=> (T:void)))
  ;;Not foldable  because it must return  a newly allocated vector.   Not effect free
  ;;because it mutates the operand.
  (attributes
   ((_ _ _ _ _)			result-true)))

(declare-core-primitive vector-fill!
    (safe)
  (signatures
   ((T:vector T:object)		=> (T:void)))
  ;;Not effect free because it mutates the operand.
  (attributes
   ((_ _)			foldable result-true)))

;;; --------------------------------------------------------------------
;;; sorting

(declare-core-primitive vector-sort
    (safe)
  (signatures
   ((T:procedure T:vector)	=> (T:vector)))
  (attributes
   ;;Not  foldable because  it must  return  a new  list at  every application.   Not
   ;;effect-free because it invokes an unknown procedure.
   ((_ _)			result-true)))

(declare-core-primitive vector-sort!
    (safe)
  (signatures
   ((T:procedure T:vector)	=> (T:void)))
  (attributes
   ;;Not  foldable because  it must  return  a new  list at  every application.   Not
   ;;effect-free because it invokes an unknown procedure and it mutates the operand.
   ((_ _)			result-true)))

;;; --------------------------------------------------------------------
;;; iterations

(declare-core-primitive vector-for-each
    (safe)
  (signatures
   ((T:procedure T:vector . T:vector)		=> (T:void)))
  (attributes
   ;;Not  foldable because  it must  return  a new  list at  every application.   Not
   ;;effect-free becuse it invokes an unknown procedure.
   ((_ _ . _)			result-true)))

(declare-core-primitive vector-map
    (safe)
  (signatures
   ((T:procedure T:vector . T:vector)		=> (T:vector)))
  (attributes
   ;;Not  foldable because  it must  return  a new  list at  every application.   Not
   ;;effect-free becuse it invokes an unknown procedure.
   ((_ _ . _)			result-true)))

(declare-core-primitive vector-for-all
    (safe)
  (signatures
   ((T:procedure T:vector . T:vector)		=> (T:void)))
  (attributes
   ;;Not  foldable because  it must  return  a new  list at  every application.   Not
   ;;effect-free becuse it invokes an unknown procedure.
   ((_ _ . _)			result-true)))

(declare-core-primitive vector-exists
    (safe)
  (signatures
   ((T:procedure T:vector . T:vector)		=> (T:void)))
  (attributes
   ;;Not  foldable because  it must  return  a new  list at  every application.   Not
   ;;effect-free becuse it invokes an unknown procedure.
   ((_ _ . _)			result-true)))

;;; --------------------------------------------------------------------
;;; conversion

(declare-core-primitive vector->list
    (safe)
  (signatures
   ((T:vector)			=> (T:proper-list)))
  (attributes
   ;;Not foldable because it must return a new list at every application.
   ((_)				effect-free result-true)))


;;;; vectors, unsafe functions

;;; constructors

(declare-core-primitive $make-vector
    (unsafe)
  (signatures
   ((T:fixnum)			=> (T:vector)))
  ;;Not foldable because it must return a newly allocated bytevector.
  (attributes
   ((_)				effect-free result-true)))

;;; --------------------------------------------------------------------
;;; predicates

(declare-vector-predicate $vector-empty? unsafe)

;;; --------------------------------------------------------------------
;;; inspection

(declare-core-primitive $vector-length
    (unsafe)
  (signatures
   ((T:vector)			=> (T:fixnum)))
  (attributes
   ((_)				foldable effect-free result-true)))

;;; --------------------------------------------------------------------
;;; accessors and mutators

(declare-core-primitive $vector-ref
    (unsafe)
  (signatures
   ((T:vector T:fixnum)		=> (T:char)))
  (attributes
   ((_ _)			foldable effect-free)))

(declare-core-primitive $vector-set!
    (unsafe)
  (signatures
   ((T:vector T:fixnum _)	=> (T:void)))
  (attributes
   ((_ _ _)			result-true)))

;;; --------------------------------------------------------------------
;;; iterations

(declare-core-primitive $vector-map1
    (unsafe)
  (signatures
   ((T:procedure T:vector)	=> (T:vector)))
  (attributes
   ((_ _)			result-true)))

(declare-core-primitive $vector-for-each1
    (unsafe)
  (signatures
   ((T:procedure T:vector)	=> (T:void)))
  (attributes
   ((_ _)			result-true)))

(declare-core-primitive $vector-for-all1
    (unsafe)
  (signatures
   ((T:procedure T:vector)	=> (T:object))))

(declare-core-primitive $vector-exists1
    (unsafe)
  (signatures
   ((T:procedure T:vector)	=> (T:vector))))


;;;; bytevectors, safe functions
;;
;;According to  R6RS: MAKE-BYTEVECTOR must return  a newly allocated string  at every
;;invocation; so it is not foldable.
;;

(declare-core-primitive make-bytevector
    (safe)
  (signatures
   ((T:fixnum)		=> (T:bytevector))
   ((T:fixnum T:fixnum)	=> (T:bytevector)))
  ;;Not foldable because it must return a newly allocated bytevector.
  (attributes
   ((0)				effect-free result-true)
   ((0 _)			effect-free result-true)
   ((_ _)			effect-free result-true)))

;;; --------------------------------------------------------------------

(declare-core-primitive bytevector-length
    (safe)
  (signatures
   ((T:bytevector)	=> (T:fixnum)))
  (attributes
   ((_)			foldable effect-free result-true)))

;;; --------------------------------------------------------------------

(declare-core-primitive bytevector-u8-ref
    (safe)
  (signatures
   ((T:bytevector T:fixnum)	=> (T:fixnum)))
  (attributes
   ((_ _)			foldable effect-free result-true)))

(declare-core-primitive bytevector-s8-ref
    (safe)
  (signatures
   ((T:bytevector T:fixnum)	=> (T:fixnum)))
  (attributes
   ((_ _)			foldable effect-free result-true)))


;;;; bytevectors, unsafe functions

(declare-core-primitive $make-bytevector
    (safe)
  (signatures
   ((T:fixnum)		=> (T:bytevector))
   ((T:fixnum T:fixnum)	=> (T:bytevector)))
  ;;Not foldable because it must return a newly allocated bytevector.
  (attributes
   ((0)				effect-free result-true)
   ((0 _)			effect-free result-true)
   ((_ _)			effect-free result-true)))

;;; --------------------------------------------------------------------

(declare-core-primitive $bytevector-length
    (safe)
  (signatures
   ((T:bytevector)		=> (T:fixnum)))
  (attributes
   ((_)			foldable effect-free result-true)))

;;; --------------------------------------------------------------------

(declare-core-primitive $bytevector-u8-ref
    (safe)
  (signatures
   ((T:bytevector T:fixnum)	=> (T:fixnum)))
  (attributes
   ((_ _)			foldable effect-free result-true)))

(declare-core-primitive $bytevector-s8-ref
    (safe)
  (signatures
   ((T:bytevector T:fixnum)	=> (T:fixnum)))
  (attributes
   ((_ _)			foldable effect-free result-true)))


;;;; structs, safe primitives

(declare-core-primitive struct?
    (unsafe)
  (signatures
   ((T:struct)				=> (T:true))
   ((_)					=> (T:boolean))
   ((T:struct T:struct-type-descriptor)	=> (T:boolean)))
  (attributes
   ((_)					foldable effect-free)
   ((_ _)				foldable effect-free)))

(declare-type-predicate struct-type-descriptor? T:struct-type-descriptor)



;;;; structs, unsafe primitives

;;; constructors

;;The base struct type descriptor is a constant created at process boot time.
(declare-core-primitive base-rtd
    (unsafe)
  (signatures
   (()					=> (T:struct-type-descriptor)))
  (attributes
   (()					effect-free result-true)))

(declare-core-primitive $struct
    (unsafe)
  (signatures
   ((T:struct-type-descriptor . _)	=> (T:struct)))
  (attributes
   ;;It must return a new struct every time.
   ((_ . _)				effect-free result-true)))

;;; --------------------------------------------------------------------
;;; predicates

(declare-core-primitive $struct/rtd?
    (unsafe)
  (signatures
   ((_ T:struct-type-descriptor)	=> (T:boolean)))
  (attributes
   ((_ _)				foldable effect-free)))

;;; --------------------------------------------------------------------

(declare-core-primitive $struct-ref
    (unsafe)
  (signatures
   ((T:struct T:fixnum)		=> (_)))
  (attributes
   ((_ _)			foldable effect-free)))

(declare-core-primitive $struct-set!
    (unsafe)
  (signatures
   ((T:struct T:fixnum _)	=> (T:void)))
  (attributes
   ((_ _)			foldable result-true)))



;;;; annotations

(declare-core-primitive annotation?
    (safe)
  (signatures
   ((T:other-struct)		=> (T:boolean)))
  (attributes
   ((#f)			foldable effect-free result-false)
   ((_)				foldable effect-free)))

;;; --------------------------------------------------------------------

(declare-core-primitive get-annotated-datum
    (safe)
  (signatures
   ((T:input-port)		=> (_))))

(declare-core-primitive annotation-expression
    (safe)
  (signatures
   ((T:other-struct)		=> (_))))

(declare-core-primitive annotation-stripped
    (safe)
  (signatures
   ((T:other-struct)		=> (_)))
  (attributes
   ((#f)			foldable effect-free result-false)))

(declare-core-primitive annotation-textual-position
    (safe)
  (signatures
   ((T:other-struct)		=> (_))))

(declare-core-primitive annotation-source
    (safe)
  (signatures
   ((T:other-struct)		=> (_))))


;;;; R6RS records

(declare-type-predicate record? T:record)

;;; --------------------------------------------------------------------

(declare-core-primitive record-constructor
    (safe)
  (signatures
   ((_)				=> (T:procedure)))
  (attributes
   ((_)				effect-free result-false)))

(declare-core-primitive record-predicate
    (safe)
  (signatures
   ((_)				=> (T:procedure)))
  (attributes
   ((_)				effect-free result-false)))

(declare-core-primitive record-accessor
    (safe)
  (signatures
   ((_ T:fixnum)		=> (T:procedure))
   ((_ T:fixnum T:false)	=> (T:procedure))
   ((_ T:fixnum T:symbol)	=> (T:procedure))
   ((_ T:symbol)		=> (T:procedure))
   ((_ T:symbol T:false)	=> (T:procedure))
   ((_ T:symbol T:symbol)	=> (T:procedure)))
  (attributes
   ((_ _)			effect-free result-false)
   ((_ _ _)			effect-free result-false)))

(declare-core-primitive record-mutator
    (safe)
  (signatures
   ((_ T:fixnum)		=> (T:procedure))
   ((_ T:fixnum T:false)	=> (T:procedure))
   ((_ T:fixnum T:symbol)	=> (T:procedure))
   ((_ T:symbol)		=> (T:procedure))
   ((_ T:symbol T:false)	=> (T:procedure))
   ((_ T:symbol T:symbol)	=> (T:procedure)))
  (attributes
   ((_ _)			effect-free result-false)
   ((_ _ _)			effect-free result-false)))


;;;; hashtables, safe procedures

;;; predicates

(declare-type-predicate hashtable? T:hashtable)

;;; --------------------------------------------------------------------
;;; constructors

(declare-core-primitive make-hashtable
    (safe)
  (signatures
   ((T:procedure T:procedure)			=> (T:hashtable))
   ((T:procedure T:procedure T:exact-integer)	=> (T:hashtable)))
  (attributes
   ((_ _)				effect-free result-true)
   ((_ _ _)				effect-free result-true)))

(declare-core-primitive make-eq-hashtable
    (safe)
  (signatures
   (()					=> (T:hashtable))
   ((T:exact-integer)			=> (T:hashtable)))
  (attributes
   (()				effect-free result-true)
   ((_)				effect-free result-true)))

(declare-core-primitive make-eqv-hashtable
    (safe)
  (signatures
   (()					=> (T:hashtable))
   ((T:exact-integer)			=> (T:hashtable)))
  (attributes
   (()				effect-free result-true)
   ((_)				effect-free result-true)))

(declare-core-primitive hashtable-copy
    (safe)
  (signatures
   ((T:hashtable)			=> (T:hashtable))
   ((T:hashtable T:object)		=> (T:hashtable)))
  (attributes
   ((_)				effect-free result-true)
   ((_ _)			effect-free result-true)))

;;; --------------------------------------------------------------------
;;; accessors and mutators

(declare-core-primitive hashtable-ref
    (safe)
  (signatures
   ((T:hashtable T:object T:object)	=> (T:object)))
  (attributes
   ((_ _ _)			effect-free)))

(declare-core-primitive hashtable-set!
    (safe)
  (signatures
   ((T:hashtable T:object T:object)	=> (T:void)))
  (attributes
   ((_ _ _)				result-true)))

(declare-core-primitive hashtable-delete!
    (safe)
  (signatures
   ((T:hashtable T:object)		=> (T:void)))
  (attributes
   ((_ _) 				result-true)))

(declare-core-primitive hashtable-clear!
    (safe)
  (signatures
   ((T:hashtable)			=> (T:void))
   ((T:hashtable T:exact-integer)	=> (T:void)))
  (attributes
   ((_)					result-true)
   ((_ _)				result-true)))

(declare-core-primitive hashtable-update!
    (safe)
  (signatures
   ((T:hashtable T:object T:procedure T:object)	=> (T:void)))
  (attributes
   ((_ _ _ _)				result-true)))

;;; --------------------------------------------------------------------
;;; inspection

(declare-core-primitive hashtable-contains?
    (safe)
  (signatures
   ((T:hashtable T:object)	=> (T:boolean)))
  (attributes
   ((_ _)			effect-free)))


(declare-core-primitive hashtable-entries
    (safe)
  (signatures
   ((T:hashtable)		=> (T:vector T:vector)))
  (attributes
   ((_)				effect-free)))

(declare-core-primitive hashtable-keys
    (safe)
  (signatures
   ((T:hashtable)		=> (T:vector)))
  (attributes
   ((_)				effect-free)))

(declare-core-primitive hashtable-mutable?
    (safe)
  (signatures
   ((T:hashtable)		=> (T:boolean)))
  (attributes
   ((_)				effect-free)))

(declare-core-primitive hashtable-size
    (safe)
  (signatures
   ((T:hashtable)		=> (T:exact-integer)))
  (attributes
   ((_)				effect-free result-true)))

(declare-core-primitive hashtable-hash-function
    (safe)
  (signatures
   ((T:hashtable)		=> (T:object)))
  (attributes
   ;;This returns false for EQ? and EQV? hashtables!!!
   ((_)				effect-free)))

(declare-core-primitive hashtable-equivalence-function
    (safe)
  (signatures
   ((T:hashtable)		=> (T:procedure)))
  (attributes
   ((_)				effect-free result-true)))

;;; --------------------------------------------------------------------
;;; hash functions

(let-syntax
    ((declare-hash-function (syntax-rules ()
			      ((_ ?who ?obj-tag . ?replacements)
			       (declare-core-primitive ?who
				   (safe)
				 (signatures
				  ((?obj-tag)		=> (T:fixnum)))
				 (attributes
				  ((_)			foldable effect-free result-true))
				 . ?replacements))
			      )))
  (declare-hash-function equal-hash		T:object)
  (declare-hash-function string-hash		T:string	(replacements $string-hash))
  (declare-hash-function string-ci-hash		T:string	(replacements $string-ci-hash))
  (declare-hash-function symbol-hash		T:symbol	(replacements $symbol-hash))
  (declare-hash-function bytevector-hash	T:bytevector	(replacements $bytevector-hash))
  (declare-hash-function port-hash		T:port)
  #| end of LET-SYNTAX |# )


;;;; hashtables, unsafe procedures

;;; hash functions

(let-syntax
    ((declare-hash-function (syntax-rules ()
			      ((_ ?who ?obj-tag)
			       (declare-core-primitive ?who
				   (unsafe)
				 (signatures
				  ((?obj-tag)		=> (T:fixnum)))
				 (attributes
				  ((_)			foldable effect-free result-true))))
			      )))
  (declare-hash-function $string-hash		T:string)
  (declare-hash-function $string-ci-hash	T:string)
  (declare-hash-function $symbol-hash		T:symbol)
  (declare-hash-function $bytevector-hash	T:bytevector)
  #| end of LET-SYNTAX |# )


;;;; input/output, safe primitives

(declare-core-primitive current-input-port
    (safe)
  (signatures
   (()					=> (T:textual-input-port))
   ((T:textual-input-port)		=> (T:void))
   ((T:textual-input-port T:boolean)	=> (T:void)))
  (attributes
   (()				effect-free result-true)
   ((_)				result-true)
   ((_ _)			result-true)))

(declare-core-primitive current-output-port
    (safe)
  (signatures
   (()					=> (T:textual-output-port))
   ((T:textual-output-port)		=> (T:void))
   ((T:textual-output-port T:boolean)	=> (T:void)))
  (attributes
   (()				effect-free result-true)
   ((_)				result-true)
   ((_ _)			result-true)))

(declare-core-primitive current-error-port
    (safe)
  (signatures
   (()					=> (T:textual-output-port))
   ((T:textual-output-port)		=> (T:void))
   ((T:textual-output-port T:boolean)	=> (T:void)))
  (attributes
   (()				effect-free result-true)
   ((_)				result-true)
   ((_ _)			result-true)))

;;; --------------------------------------------------------------------

(declare-core-primitive standard-input-port
    (safe)
  (signatures
   (()				=> (T:binary-input-port)))
  (attributes
   (()				effect-free result-true)))

(declare-core-primitive standard-output-port
    (safe)
  (signatures
   (()				=> (T:binary-output-port)))
  (attributes
   (()				effect-free result-true)))

(declare-core-primitive standard-error-port
    (safe)
  (signatures
   (()				=> (T:binary-output-port)))
  (attributes
   (()				effect-free result-true)))

;;; --------------------------------------------------------------------

(declare-core-primitive console-input-port
    (safe)
  (signatures
   (()				=> (T:textual-input-port)))
  (attributes
   (()				effect-free result-true)))

(declare-core-primitive console-output-port
    (safe)
  (signatures
   (()				=> (T:textual-output-port)))
  (attributes
   (()				effect-free result-true)))

(declare-core-primitive console-error-port
    (safe)
  (signatures
   (()				=> (T:textual-output-port)))
  (attributes
   (()				effect-free result-true)))


;;;; input/output, safe primitives

;;; transcoders

(declare-core-primitive $data->transcoder
    (unsafe)
  (signatures
   ((T:fixnum)			=> (T:transcoder)))
  (attributes
   ((_)				effect-free result-true)))

(declare-core-primitive $transcoder->data
    (unsafe)
  (signatures
   ((T:transcoder)		=> (T:fixnum)))
  (attributes
   ((_)				effect-free result-true)))


;;;; generic functions

(declare-type-predicate procedure? T:procedure)

;;; --------------------------------------------------------------------

(declare-core-primitive eof-object
    (safe)
  (signatures
   (()				=> (T:object)))
  (attributes
   (()				foldable effect-free result-true)))

(declare-core-primitive eof-object?
    (safe)
  (signatures
   ((_)				=> (T:boolean)))
  (attributes
   ((_)				foldable effect-free)))

;;; --------------------------------------------------------------------

(declare-core-primitive bwp-object
    (safe)
  (signatures
   (()				=> (T:object)))
  (attributes
   ((_)				foldable effect-free result-true)))

(declare-core-primitive bwp-object?
    (safe)
  (signatures
   ((_)				=> (T:boolean)))
  (attributes
   ((_)				foldable effect-free)))

;;; --------------------------------------------------------------------

(declare-core-primitive unbound-object
    (safe)
  (signatures
   (()				=> (T:object)))
  (attributes
   ((_)				foldable effect-free result-true)))

(declare-core-primitive unbound-object?
    (safe)
  (signatures
   ((_)				=> (T:boolean)))
  (attributes
   ((_)				foldable effect-free)))

(declare-core-primitive $unbound-object?
    (safe)
  (signatures
   ((_)				=> (T:boolean)))
  (attributes
   ((_)				foldable effect-free)))

;;; --------------------------------------------------------------------

(declare-core-primitive interrupt-handler
    (safe)
  (signatures
   (()				=> (T:procedure))
   ((T:procedure)		=> (T:void))
   ((T:procedure T:boolean)	=> (T:void))))

(declare-core-primitive engine-handler
    (safe)
  (signatures
   (()				=> (T:procedure))
   ((T:procedure)		=> (T:void))
   ((T:procedure T:boolean)	=> (T:void))))

;;; --------------------------------------------------------------------

(declare-core-primitive make-guardian
    (safe)
  (signatures
   (()				=> (T:procedure)))
  (attributes
   (()				effect-free result-true)))

(declare-core-primitive make-parameter
    (safe)
  (signatures
   ((T:object)			=> (T:procedure))
   ((T:object T:procedure)	=> (T:procedure)))
  (attributes
   ((_)				effect-free result-true)
   ((_ _)			effect-free result-true)))

;;; --------------------------------------------------------------------

(declare-core-primitive always-true
    (safe)
  (signatures
   (_				=> (T:true)))
  (attributes
   (_				foldable effect-free result-true)))

(declare-core-primitive always-false
    (safe)
  (signatures
   (_				=> (T:false)))
  (attributes
   (_				foldable effect-free result-false)))

;;; --------------------------------------------------------------------

(declare-core-primitive uuid
    (safe)
  (signatures
   (()				=> (T:string)))
  (attributes
   (()				effect-free result-false)))


;;;; invocation and termination procedures

(declare-core-primitive command-line
    (safe)
  (signatures
   (()				=> (T:non-empty-proper-list)))
  (attributes
   (()				effect-free result-true)))

(declare-core-primitive exit
    (safe)
  (signatures
   (()				=> (T:void))
   ((T:fixnum)			=> (T:void))))

(declare-core-primitive exit-hooks
    (safe)
  (signatures
   (()				=> (T:proper-list))
   ((T:proper-list)		=> (T:void))
   ((T:proper-list T:object)	=> (T:void)))
  (attributes
   (()				effect-free result-true)
   ((_)				result-true)
   ((_ _)			result-true)))


;;;; numerics, safe functions
;;
;;The order of  unsafe replacements *does* matter:  replacements accepting "T:number"
;;operands must come *after* the ones accepting more specific operand types.
;;

#|

 error@fx+
 error@fxarithmetic-shift-left
 error@fxarithmetic-shift-right
 error@fx*
 error@fx-
 error@add1
 error@sub1
 error@fxadd1
 error@fxsub1

|#

;;; predicates

(declare-type-predicate number?			T:number)
(declare-type-predicate complex?		T:number)

(declare-core-primitive real?
    (safe)
  (signatures
   ((T:real)			=> (T:true))
   ((T:compnum)			=> (T:false))
   ((T:cflonum)			=> (T:false))
   ((T:number)			=> (T:boolean)))
  (attributes
   ((_)				foldable effect-free)))

(declare-core-primitive rational?
    (safe)
  (signatures
   ((T:fixnum)			=> (T:true))
   ((T:bignum)			=> (T:true))
   ((T:ratnum)			=> (T:true))
   ((T:flonum-finite)		=> (T:true))
   ((T:flonum-infinite)		=> (T:false))
   ((T:flonum-nan)		=> (T:false))
   ((T:compnum)			=> (T:false))
   ((T:cflonum)			=> (T:false))
   ((T:number)			=> (T:boolean)))
  (attributes
   ((_)				foldable effect-free)))

(declare-type-predicate rational?)
(declare-type-predicate integer?)

(declare-type-predicate exact-integer?		T:exact-integer)

(declare-type-predicate real-valued?)
(declare-type-predicate rational-valued?)
(declare-type-predicate integer-valued?)

(declare-number-predicate odd?)
(declare-number-predicate even?)

;;;

(declare-core-primitive zero?
    (safe)
  (signatures
   ((T:positive-fixnum)		=> (T:false))
   ((T:negative-fixnum)		=> (T:false))
   ((T:ratnum)			=> (T:false))
   ((T:bignum)			=> (T:false))
   ((T:number)			=> (T:boolean)))
  (attributes
   ((0)				foldable effect-free result-true)
   ((_)				foldable effect-free)))

(declare-core-primitive positive?
    (safe)
  (signatures
   ((T:positive-fixnum)		=> (T:true))
   ((T:negative-fixnum)		=> (T:false))
   ((T:positive-bignum)		=> (T:true))
   ((T:negative-bignum)		=> (T:false))
   ((T:real)			=> (T:boolean)))
  (attributes
   ((0)				foldable effect-free result-false)
   ((_)				foldable effect-free)))

(declare-core-primitive negative?
    (safe)
  (signatures
   ((T:positive-fixnum)		=> (T:false))
   ((T:negative-fixnum)		=> (T:true))
   ((T:positive-bignum)		=> (T:false))
   ((T:negative-bignum)		=> (T:true))
   ((T:real)			=> (T:boolean)))
  (attributes
   ((0)				foldable effect-free result-false)
   ((_)				foldable effect-free)))

(declare-core-primitive non-negative?
    (safe)
  (signatures
   ((T:negative-fixnum)		=> (T:false))
   ((T:non-negative-fixnum)	=> (T:true))
   ((T:positive-bignum)		=> (T:true))
   ((T:negative-bignum)		=> (T:false))
   ((T:real)			=> (T:boolean)))
  (attributes
   ((0)				foldable effect-free result-true)
   ((_)				foldable effect-free)))

(declare-core-primitive non-positive?
    (safe)
  (signatures
   ((T:positive-fixnum)		=> (T:false))
   ((T:non-positive-fixnum)	=> (T:true))
   ((T:positive-bignum)		=> (T:false))
   ((T:negative-bignum)		=> (T:true))
   ((T:real)			=> (T:boolean)))
  (attributes
   ((0)				foldable effect-free result-true)
   ((_)				foldable effect-free)))

;;;

(declare-core-primitive zero-exact-integer?
    (safe)
  (signatures
   ((T:object)		=> (T:boolean)))
  (attributes
   ((0)			foldable effect-free result-true)
   ((_)			foldable effect-free)))

(declare-core-primitive positive-exact-integer?
    (safe)
  (signatures
   ((T:positive-fixnum)	=> (T:true))
   ((T:positive-bignum)	=> (T:true))
   ((T:negative)	=> (T:false))
   ((T:object)		=> (T:boolean)))
  (attributes
   ((_)			foldable effect-free)))

(declare-core-primitive negative-exact-integer?
    (safe)
  (signatures
   ((T:negative-fixnum)	=> (T:true))
   ((T:negative-bignum)	=> (T:true))
   ((T:positive)	=> (T:false))
   ((T:object)		=> (T:boolean)))
  (attributes
   ((_)			foldable effect-free)))

(declare-core-primitive non-negative-exact-integer?
    (safe)
  (signatures
   ((T:non-negative-fixnum)	=> (T:true))
   ((T:positive-bignum)		=> (T:true))
   ((T:negative)		=> (T:false))
   ((T:object)			=> (T:boolean)))
  (attributes
   ((_)				foldable effect-free)))

(declare-core-primitive non-positive-exact-integer?
    (safe)
  (signatures
   ((T:non-positive-fixnum)	=> (T:true))
   ((T:negative-bignum)		=> (T:true))
   ((T:positive)		=> (T:false))
   ((T:object)			=> (T:boolean)))
  (attributes
   ((_)				foldable effect-free)))

;;;

(declare-core-primitive exact?
    (safe)
  (signatures
   ((T:exact)			=> (T:true))
   ((T:inexact)			=> (T:false))
   ((T:number)			=> (T:boolean)))
  (attributes
   ((_)				foldable effect-free)))

(declare-core-primitive inexact?
    (safe)
  (signatures
   ((T:exact)			=> (T:false))
   ((T:inexact)			=> (T:true))
   ((T:number)			=> (T:boolean)))
  (attributes
   ((_)				foldable effect-free)))

;;;

(declare-core-primitive finite?
    (safe)
  (signatures
   ((T:flonum-finite)		=> (T:true))
   ((T:flonum-infinite)		=> (T:false))
   ((T:flonum-nan)		=> (T:false))
   ((T:fixnum)			=> (T:true))
   ((T:bignum)			=> (T:true))
   ((T:ratnum)			=> (T:true))
   ((T:number)			=> (T:boolean)))
  (attributes
   ((_)				foldable effect-free)))

(declare-core-primitive infinite?
    (safe)
  (signatures
   ((T:flonum-finite)		=> (T:false))
   ((T:flonum-infinite)		=> (T:true))
   ((T:flonum-nan)		=> (T:false))
   ((T:fixnum)			=> (T:false))
   ((T:bignum)			=> (T:false))
   ((T:ratnum)			=> (T:false))
   ((T:number)			=> (T:boolean)))
  (attributes
   ((_)				foldable effect-free)))

(declare-core-primitive nan?
    (safe)
  (signatures
   ((T:flonum-nan)		=> (T:false))
   ((T:flonum-infinite)		=> (T:false))
   ((T:flonum-nan)		=> (T:true))
   ((T:fixnum)			=> (T:false))
   ((T:bignum)			=> (T:false))
   ((T:ratnum)			=> (T:false))
   ((T:number)			=> (T:boolean)))
  (attributes
   ((_)				foldable effect-free)))

;;; --------------------------------------------------------------------
;;; comparison

(declare-core-primitive =
    (safe)
  (signatures
   ((T:positive     T:non-positive . T:number)		=> (T:false))
   ((T:non-positive T:positive     . T:number)		=> (T:false))
   ((T:negative     T:non-negative . T:number)		=> (T:false))
   ((T:non-negative T:negative     . T:number)		=> (T:false))
   ((T:number       T:number       . T:number)		=> (T:boolean)))
  (attributes
   ((_ _ . _)			foldable effect-free)))

(declare-core-primitive !=
    (safe)
  (signatures
   ((T:positive     T:non-positive . T:number)		=> (T:true))
   ((T:non-positive T:positive     . T:number)		=> (T:true))
   ((T:negative     T:non-negative . T:number)		=> (T:true))
   ((T:non-negative T:negative     . T:number)		=> (T:true))
   ((T:number       T:number       . T:number)		=> (T:boolean)))
  (attributes
   ((_ _ . _)			foldable effect-free)))

(declare-core-primitive <
    (safe)
  (signatures
   ((T:positive     T:non-positive)	=> (T:false))
   ((T:non-negative T:negative)		=> (T:false))

   ((T:non-positive T:positive)		=> (T:true))
   ((T:negative     T:non-negative)	=> (T:true))

   ((T:number T:number . T:number)	=> (T:boolean)))
  (attributes
   ((_ _ . _)			foldable effect-free)))

(declare-core-primitive >
    (safe)
  (signatures
   ((T:positive     T:non-positive)	=> (T:true))
   ((T:non-negative T:negative)		=> (T:true))

   ((T:non-positive T:positive)		=> (T:false))
   ((T:negative     T:non-negative)	=> (T:false))

   ((T:number T:number . T:number)	=> (T:boolean)))
  (attributes
   ((_ _ . _)			foldable effect-free)))

(declare-core-primitive <=
    (safe)
  (signatures
   ((T:positive T:negative)		=> (T:false))
   ((T:negative T:positive)		=> (T:true))

   ((T:number T:number . T:number)	=> (T:boolean)))
  (attributes
   ((_ _ . _)			foldable effect-free)))

(declare-core-primitive >=
    (safe)
  (signatures
   ((T:positive T:negative)		=> (T:true))
   ((T:negative T:positive)		=> (T:false))

   ((T:number T:number . T:number)	=> (T:boolean)))
  (attributes
   ((_ _ . _)			foldable effect-free)))

;;;

(declare-core-primitive max
    (safe)
  (signatures
   ((T:real . T:real)		=> (T:real)))
  (attributes
   ((_ _)			foldable effect-free result-true))
  (replacements
   $max-fixnum-fixnum $max-fixnum-bignum $max-fixnum-flonum $max-fixnum-ratnum
   $max-bignum-fixnum $max-bignum-bignum $max-bignum-flonum $max-bignum-ratnum
   $max-flonum-fixnum $max-flonum-bignum $max-flonum-flonum $max-flonum-ratnum
   $max-ratnum-fixnum $max-ratnum-bignum $max-ratnum-flonum $max-ratnum-ratnum
   $max-fixnum-number $max-bignum-number $max-flonum-number $max-ratnum-number
   $max-number-fixnum $max-number-bignum $max-number-flonum $max-number-ratnum))

(declare-core-primitive min
    (safe)
  (signatures
   ((T:real . T:real)		=> (T:real)))
  (attributes
   ((_ _)			foldable effect-free result-true))
  (replacements
   $min-fixnum-fixnum $min-fixnum-bignum $min-fixnum-flonum $min-fixnum-ratnum
   $min-bignum-fixnum $min-bignum-bignum $min-bignum-flonum $min-bignum-ratnum
   $min-flonum-fixnum $min-flonum-bignum $min-flonum-flonum $min-flonum-ratnum
   $min-ratnum-fixnum $min-ratnum-bignum $min-ratnum-flonum $min-ratnum-ratnum
   $min-fixnum-number $min-bignum-number $min-flonum-number $min-ratnum-number
   $min-number-fixnum $min-number-bignum $min-number-flonum $min-number-ratnum))

;;; --------------------------------------------------------------------
;;; arithmetics

(declare-core-primitive +
    (safe)
  (signatures
   (T:number		=> (T:number)))
  (attributes
   (_			foldable effect-free result-true))
  (replacements
   $add-fixnum-fixnum		$add-fixnum-bignum	$add-fixnum-flonum
   $add-fixnum-ratnum		$add-fixnum-compnum	$add-fixnum-cflonum

   $add-bignum-fixnum		$add-bignum-bignum	$add-bignum-flonum
   $add-bignum-ratnum		$add-bignum-compnum	$add-bignum-cflonum

   $add-flonum-fixnum		$add-flonum-bignum	$add-flonum-flonum
   $add-flonum-ratnum		$add-flonum-compnum	$add-flonum-cflonum

   $add-ratnum-fixnum		$add-ratnum-bignum	$add-ratnum-flonum
   $add-ratnum-ratnum		$add-ratnum-compnum	$add-ratnum-cflonum

   $add-compnum-fixnum		$add-compnum-bignum	$add-compnum-ratnum
   $add-compnum-compnum		$add-compnum-flonum	$add-compnum-cflonum

   $add-cflonum-fixnum		$add-cflonum-bignum	$add-cflonum-ratnum
   $add-cflonum-flonum		$add-cflonum-compnum	$add-cflonum-cflonum

   $add-fixnum-number		$add-bignum-number	$add-flonum-number
   $add-ratnum-number		$add-compnum-number	$add-cflonum-number

   $add-number-fixnum		$add-number-bignum	$add-number-flonum
   $add-number-ratnum		$add-number-compnum	$add-number-cflonum

   $add-number-number))

(declare-core-primitive -
    (safe)
  (signatures
   ((T:number . T:number)	=> (T:number)))
  (attributes
   ((_ . _)			foldable effect-free result-true))
  (replacements
   $sub-fixnum-fixnum		$sub-fixnum-bignum	$sub-fixnum-flonum
   $sub-fixnum-ratnum		$sub-fixnum-compnum	$sub-fixnum-cflonum

   $sub-bignum-fixnum		$sub-bignum-bignum	$sub-bignum-flonum
   $sub-bignum-ratnum		$sub-bignum-compnum	$sub-bignum-cflonum

   $sub-flonum-fixnum		$sub-flonum-bignum	$sub-flonum-flonum
   $sub-flonum-ratnum		$sub-flonum-compnum	$sub-flonum-cflonum

   $sub-ratnum-fixnum		$sub-ratnum-bignum	$sub-ratnum-flonum
   $sub-ratnum-ratnum		$sub-ratnum-compnum	$sub-ratnum-cflonum

   $sub-compnum-fixnum		$sub-compnum-bignum	$sub-compnum-ratnum
   $sub-compnum-compnum		$sub-compnum-flonum	$sub-compnum-cflonum

   $sub-cflonum-fixnum		$sub-cflonum-bignum	$sub-cflonum-ratnum
   $sub-cflonum-flonum		$sub-cflonum-compnum	$sub-cflonum-cflonum

   $sub-fixnum-number		$sub-bignum-number	$sub-flonum-number
   $sub-ratnum-number		$sub-compnum-number	$sub-cflonum-number

   $sub-number-fixnum		$sub-number-bignum	$sub-number-flonum
   $sub-number-ratnum		$sub-number-compnum	$sub-number-cflonum

   $sub-number-number))

(declare-core-primitive *
    (safe)
  (signatures
   (T:number		=> (T:number)))
  (attributes
   (_			foldable effect-free result-true))
  (replacements
   $mul-fixnum-fixnum		$mul-fixnum-bignum	$mul-fixnum-flonum
   $mul-fixnum-ratnum		$mul-fixnum-compnum	$mul-fixnum-cflonum

   $mul-bignum-fixnum		$mul-bignum-bignum	$mul-bignum-flonum
   $mul-bignum-ratnum		$mul-bignum-compnum	$mul-bignum-cflonum

   $mul-flonum-fixnum		$mul-flonum-bignum	$mul-flonum-flonum
   $mul-flonum-ratnum		$mul-flonum-compnum	$mul-flonum-cflonum

   $mul-ratnum-fixnum		$mul-ratnum-bignum	$mul-ratnum-flonum
   $mul-ratnum-ratnum		$mul-ratnum-compnum	$mul-ratnum-cflonum

   $mul-compnum-fixnum		$mul-compnum-bignum	$mul-compnum-ratnum
   $mul-compnum-compnum		$mul-compnum-flonum	$mul-compnum-cflonum

   $mul-cflonum-fixnum		$mul-cflonum-bignum	$mul-cflonum-ratnum
   $mul-cflonum-flonum		$mul-cflonum-compnum	$mul-cflonum-cflonum

   $mul-fixnum-number		$mul-bignum-number	$mul-flonum-number
   $mul-ratnum-number		$mul-compnum-number	$mul-cflonum-number

   $mul-number-fixnum		$mul-number-bignum	$mul-number-flonum
   $mul-number-ratnum		$mul-number-compnum	$mul-number-cflonum

   $mul-number-number))

(declare-core-primitive /
    (safe)
  (signatures
   ((T:number . T:number)	=> (T:number)))
  (attributes
   ((_ . _)			foldable effect-free result-true))
  (replacements
   $div-fixnum-fixnum		$div-fixnum-bignum	$div-fixnum-flonum
   $div-fixnum-ratnum		$div-fixnum-compnum	$div-fixnum-cflonum

   $div-bignum-fixnum		$div-bignum-bignum	$div-bignum-flonum
   $div-bignum-ratnum		$div-bignum-compnum	$div-bignum-cflonum

   $div-flonum-fixnum		$div-flonum-bignum	$div-flonum-flonum
   $div-flonum-ratnum		$div-flonum-compnum	$div-flonum-cflonum

   $div-ratnum-fixnum		$div-ratnum-bignum	$div-ratnum-flonum
   $div-ratnum-ratnum		$div-ratnum-compnum	$div-ratnum-cflonum

   $div-compnum-fixnum		$div-compnum-bignum	$div-compnum-ratnum
   $div-compnum-compnum		$div-compnum-flonum	$div-compnum-cflonum

   $div-cflonum-fixnum		$div-cflonum-bignum	$div-cflonum-ratnum
   $div-cflonum-flonum		$div-cflonum-compnum	$div-cflonum-cflonum

   $div-fixnum-number		$div-bignum-number	$div-flonum-number
   $div-ratnum-number		$div-compnum-number	$div-cflonum-number

   $div-number-fixnum		$div-number-bignum	$div-number-flonum
   $div-number-ratnum		$div-number-compnum	$div-number-cflonum

   $div-number-number))

(declare-core-primitive add1
    (safe)
  (signatures
   ((T:number)			=> (T:number)))
  (attributes
   ((_)				foldable effect-free result-true))
  (replacements
   $add1-fixnum
   $add1-bignum
   $add1-integer))

(declare-core-primitive sub1
    (safe)
  (signatures
   ((T:number)			=> (T:number)))
  (attributes
   ((_)				foldable effect-free result-true))
  (replacements
   $sub1-fixnum
   $sub1-bignum
   $sub1-integer))

;;; --------------------------------------------------------------------

(declare-core-primitive div
    (safe)
  (signatures
   ((T:fixnum T:fixnum)			=> (T:fixnum))
   ((T:exact-integer T:exact-integer)	=> (T:exact-integer))
   ((T:real T:real)			=> (T:real)))
  (attributes
   ((_)				foldable effect-free result-true)))

(declare-core-primitive mod
    (safe)
  (signatures
   ((T:fixnum T:fixnum)			=> (T:fixnum))
   ((T:exact-integer T:exact-integer)	=> (T:exact-integer))
   ((T:real T:real)			=> (T:real)))
  (attributes
   ((_)				foldable effect-free result-true)))

(declare-core-primitive div0
    (safe)
  (signatures
   ((T:fixnum T:fixnum)			=> (T:fixnum))
   ((T:exact-integer T:exact-integer)	=> (T:exact-integer))
   ((T:real T:real)			=> (T:real)))
  (attributes
   ((_)				foldable effect-free result-true)))

(declare-core-primitive mod0
    (safe)
  (signatures
   ((T:fixnum T:fixnum)			=> (T:fixnum))
   ((T:exact-integer T:exact-integer)	=> (T:exact-integer))
   ((T:real T:real)			=> (T:real)))
  (attributes
   ((_)				foldable effect-free result-true)))

(declare-core-primitive modulo
    (safe)
  (signatures
   ((T:fixnum T:fixnum)			=> (T:fixnum))
   ((T:exact-integer T:exact-integer)	=> (T:exact-integer))
   ((T:integer T:integer)		=> (T:integer)))
  (attributes
   ((_)				foldable effect-free result-true)))

(declare-core-primitive remainder
    (safe)
  (signatures
   ((T:fixnum T:fixnum)			=> (T:fixnum))
   ((T:exact-integer T:exact-integer)	=> (T:exact-integer))
   ((T:integer T:integer)		=> (T:integer)))
  (attributes
   ((_)				foldable effect-free result-true)))

(declare-core-primitive quotient
    (safe)
  (signatures
   ((T:fixnum T:fixnum)			=> (T:fixnum))
   ((T:exact-integer T:exact-integer)	=> (T:exact-integer))
   ((T:integer T:integer)		=> (T:integer)))
  (attributes
   ((_)				foldable effect-free result-true)))

(declare-core-primitive div-and-mod
    (safe)
  (signatures
   ((T:fixnum T:fixnum)			=> (T:fixnum T:fixnum))
   ((T:exact-integer T:exact-integer)	=> (T:exact-integer T:exact-integer))
   ((T:real T:real)			=> (T:real T:real)))
  (attributes
   ((_ _)			effect-free)))

(declare-core-primitive div0-and-mod0
    (safe)
  (signatures
   ((T:fixnum T:fixnum)			=> (T:fixnum T:fixnum))
   ((T:exact-integer T:exact-integer)	=> (T:exact-integer T:exact-integer))
   ((T:real T:real)			=> (T:real T:real)))
  (attributes
   ((_ _)			effect-free)))

;;;

(declare-core-primitive gcd
    (safe)
  (signatures
   (()					=> (T:fixnum))

   ((T:fixnum)				=> (T:fixnum))
   ((T:bignum)				=> (T:bignum))
   ((T:flonum)				=> (T:flonum))
   ((T:exact-integer)			=> (T:exact-integer))
   ((T:real)				=> (T:real))

   ((T:fixnum T:fixnum)			=> (T:exact-integer))
   ((T:fixnum T:bignum)			=> (T:exact-integer))
   ((T:fixnum T:flonum)			=> (T:flonum))

   ((T:bignum T:fixnum)			=> (T:exact-integer))
   ((T:bignum T:bignum)			=> (T:exact-integer))
   ((T:bignum T:flonum)			=> (T:flonum))

   ((T:flonum T:fixnum)			=> (T:flonum))
   ((T:flonum T:bignum)			=> (T:flonum))
   ((T:flonum T:flonum)			=> (T:flonum))

   ((T:exact-integer T:exact-integer)	=> (T:exact-integer))
   ((T:real T:real)			=> (T:real))

   ((T:real T:real T:real . T:real)	=> (T:real)))
  (attributes
   (()					foldable effect-free result-true)
   ((_)					foldable effect-free result-true)
   ((_ _)				foldable effect-free result-true)
   ((_ _ _ . _)				foldable effect-free result-true))
  (replacements
   $gcd-fixnum-fixnum $gcd-fixnum-bignum $gcd-fixnum-flonum
   $gcd-bignum-fixnum $gcd-bignum-bignum $gcd-bignum-flonum
   $gcd-flonum-fixnum $gcd-flonum-bignum $gcd-flonum-flonum
   $gcd-fixnum-number $gcd-bignum-number $gcd-flonum-number
   $gcd-number-fixnum $gcd-number-bignum $gcd-number-flonum
   $gcd-number-number))

(declare-core-primitive lcm
    (safe)
  (signatures
   (()					=> (T:fixnum))

   ((T:fixnum)				=> (T:fixnum))
   ((T:bignum)				=> (T:bignum))
   ((T:flonum)				=> (T:flonum))
   ((T:exact-integer)			=> (T:exact-integer))
   ((T:real)				=> (T:real))

   ((T:fixnum T:fixnum)			=> (T:exact-integer))
   ((T:fixnum T:bignum)			=> (T:exact-integer))
   ((T:fixnum T:flonum)			=> (T:flonum))

   ((T:bignum T:fixnum)			=> (T:exact-integer))
   ((T:bignum T:bignum)			=> (T:exact-integer))
   ((T:bignum T:flonum)			=> (T:flonum))

   ((T:flonum T:fixnum)			=> (T:flonum))
   ((T:flonum T:bignum)			=> (T:flonum))
   ((T:flonum T:flonum)			=> (T:flonum))

   ((T:exact-integer T:exact-integer)	=> (T:exact-integer))
   ((T:real T:real)			=> (T:real))

   ((T:real T:real T:real . T:real)	=> (T:real)))
  (attributes
   (()					foldable effect-free result-true)
   ((_)					foldable effect-free result-true)
   ((_ _)				foldable effect-free result-true)
   ((_ _ _ . _)				foldable effect-free result-true))
  (replacements
   $lcm-fixnum-fixnum $lcm-fixnum-bignum $lcm-fixnum-flonum
   $lcm-bignum-fixnum $lcm-bignum-bignum $lcm-bignum-flonum
   $lcm-flonum-fixnum $lcm-flonum-bignum $lcm-flonum-flonum
   $lcm-fixnum-number $lcm-bignum-number $lcm-flonum-number
   $lcm-number-fixnum $lcm-number-bignum $lcm-number-flonum
   $lcm-number-number))

;;; --------------------------------------------------------------------
;;; exactness

(declare-core-primitive exact
    (safe)
  (signatures
   ((T:fixnum)		=> (T:fixnum))
   ((T:bignum)		=> (T:bignum))
   ((T:flonum)		=> (T:exact-integer))
   ((T:ratnum)		=> (T:ratnum))
   ((T:compnum)		=> (T:exact-compnum))
   ((T:cflonum)		=> (T:exact-compnum))
   ((T:real)		=> (T:exact-integer))
   ((T:number)		=> (T:exact)))
  (attributes
   ((_)			foldable effect-free result-true))
  (replacements
   $exact-fixnum $exact-bignum $exact-flonum $exact-ratnum $exact-compnum $exact-cflonum))

(declare-core-primitive inexact
    (safe)
  (signatures
   ((T:fixnum)		=> (T:flonum))
   ((T:bignum)		=> (T:flonum))
   ((T:flonum)		=> (T:flonum))
   ((T:ratnum)		=> (T:flonum))
   ((T:compnum)		=> (T:cflonum))
   ((T:cflonum)		=> (T:cflonum))
   ((T:real)		=> (T:flonum))
   ((T:number)		=> (T:inexact)))
  (attributes
   ((_)			foldable effect-free result-true))
  (replacements
   $inexact-fixnum $inexact-bignum $inexact-flonum $inexact-ratnum $inexact-compnum $inexact-cflonum))

(declare-core-primitive inexact->exact
    (safe)
  (signatures
   ((T:fixnum)		=> (T:fixnum))
   ((T:bignum)		=> (T:bignum))
   ((T:flonum)		=> (T:exact-integer))
   ((T:ratnum)		=> (T:ratnum))
   ((T:compnum)		=> (T:exact-compnum))
   ((T:cflonum)		=> (T:exact-compnum))
   ((T:real)		=> (T:exact-integer))
   ((T:number)		=> (T:exact)))
  (attributes
   ((_)			foldable effect-free result-true))
  (replacements
   $exact-fixnum $exact-bignum $exact-flonum $exact-ratnum $exact-compnum $exact-cflonum))

(declare-core-primitive exact->inexact
    (safe)
  (signatures
   ((T:fixnum)		=> (T:flonum))
   ((T:bignum)		=> (T:flonum))
   ((T:flonum)		=> (T:flonum))
   ((T:ratnum)		=> (T:flonum))
   ((T:compnum)		=> (T:cflonum))
   ((T:cflonum)		=> (T:cflonum))
   ((T:real)		=> (T:flonum))
   ((T:number)		=> (T:inexact)))
  (attributes
   ((_)			foldable effect-free result-true))
  (replacements
   $inexact-fixnum $inexact-bignum $inexact-flonum $inexact-ratnum $inexact-compnum $inexact-cflonum))

;;; --------------------------------------------------------------------
;;; parts

(declare-core-primitive numerator
    (safe)
  (signatures
   ((T:fixnum)			=> (T:fixnum))
   ((T:bignum)			=> (T:bignum))
   ((T:flonum)			=> (T:flonum))
   ((T:ratnum)			=> (T:exact-integer))
   ((T:real)			=> (T:real)))
  (attributes
   ((_)				foldable effect-free result-true))
  (replacements $numerator-fixnum $numerator-bignum $numerator-flonum $numerator-ratnum))

(declare-core-primitive denominator
    (safe)
  (signatures
   ((T:fixnum)			=> (T:fixnum))
   ((T:bignum)			=> (T:bignum))
   ((T:flonum)			=> (T:flonum))
   ((T:ratnum)			=> (T:exact-integer))
   ((T:real)			=> (T:real)))
  (attributes
   ((_)				foldable effect-free result-true))
  (replacements $denominator-fixnum $denominator-bignum $denominator-flonum $denominator-ratnum))

(declare-core-primitive rationalize
    (safe)
  (signatures
   ((T:real T:real)		=> (T:real)))
  (attributes
   ((_ _)			foldable effect-free result-true)))

(declare-core-primitive make-rectangular
    (safe)
  (signatures
   ((T:real T:real)		=> (T:complex)))
  (attributes
   ((_ _)			foldable effect-free result-true)))

(declare-core-primitive make-polar
    (safe)
  (signatures
   ((T:real T:real)		=> (T:complex)))
  (attributes
   ((_ _)			foldable effect-free result-true)))

(declare-number-unary real-part		(replacements $compnum-real $cflonum-real))
(declare-number-unary imag-part		(replacements $compnum-imag $cflonum-imag))

(declare-core-primitive abs
    (safe)
  (signatures
   ((T:fixnum)			=> (T:exact-integer))
   ((T:bignum)			=> (T:exact-integer))
   ((T:ratnum)			=> (T:ratnum))
   ((T:flonum)			=> (T:flonum)))
  (attributes
   ((_)				foldable effect-free result-true))
  (replacements $abs-fixnum $abs-bignum $abs-flonum $abs-ratnum))

(declare-core-primitive sign
    (safe)
  (signatures
   ((T:fixnum)			=> (T:fixnum))
   ((T:bignum)			=> (T:fixnum))
   ((T:ratnum)			=> (T:fixnum))
   ((T:flonum)			=> (T:flonum)))
  (attributes
   ((_)				foldable effect-free result-true))
  (replacements $sign-fixnum $sign-bignum $sign-flonum $sign-ratnum))

(declare-core-primitive angle
    (safe)
  (signatures
   ((T:fixnum)			=> (T:fixnum))
   ((T:bignum)			=> (T:fixnum))
   ((T:flonum)			=> (T:flonum))
   ((T:ratnum)			=> (T:fixnum))
   ((T:compnum)			=> (T:real))
   ((T:cflonum)			=> (T:flonum)))
  (attributes
   ((_)				foldable effect-free result-true))
  (replacements $angle-fixnum $angle-bignum $angle-ratnum $angle-flonum $angle-compnum $angle-cflonum))

(declare-core-primitive magnitude
    (safe)
  (signatures
   ((T:fixnum)			=> (T:exact-integer))
   ((T:bignum)			=> (T:exact-integer))
   ((T:ratnum)			=> (T:ratnum))
   ((T:flonum)			=> (T:flonum))
   ((T:compnum)			=> (T:real))
   ((T:cflonum)			=> (T:flonum)))
  (attributes
   ((_)				foldable effect-free result-true))
  (replacements $magnitude-fixnum $magnitude-bignum $magnitude-ratnum $magnitude-flonum $magnitude-compnum $magnitude-cflonum))

(declare-core-primitive complex-conjugate
    (safe)
  (signatures
   ((T:fixnum)			=> (T:fixnum))
   ((T:bignum)			=> (T:bignum))
   ((T:ratnum)			=> (T:ratnum))
   ((T:flonum)			=> (T:flonum))
   ((T:compnum)			=> (T:compnum))
   ((T:cflonum)			=> (T:cflonum)))
  (attributes
   ((_)				foldable effect-free result-true))
  (replacements $complex-conjugate-compnum $complex-conjugate-cflonum))

;;; --------------------------------------------------------------------
;;; rounding

(let-syntax
    ((declare-safe-rounding-primitive
      (syntax-rules ()
	((_ ?who . ?replacements)
	 (declare-core-primitive ?who
	     (unsafe)
	   (signatures
	    ((T:fixnum)			=> (T:fixnum))
	    ((T:bignum)			=> (T:bignum))
	    ((T:flonum)			=> (T:flonum))
	    ((T:ratnum)			=> (T:ratnum))
	    ((T:real)			=> (T:real)))
	   (attributes
	    ((_)			foldable effect-free result-true))
	   (replacements . ?replacements))))))
  (declare-safe-rounding-primitive floor	   $floor-fixnum    $floor-bignum    $floor-ratnum    $floor-flonum)
  (declare-safe-rounding-primitive ceiling	 $ceiling-fixnum  $ceiling-bignum  $ceiling-ratnum  $ceiling-flonum)
  (declare-safe-rounding-primitive truncate	$truncate-fixnum $truncate-bignum $truncate-ratnum $truncate-flonum)
  (declare-safe-rounding-primitive round	   $round-fixnum    $round-bignum    $round-ratnum    $round-flonum)
  #| end of LET-SYNTAX |# )

;;; --------------------------------------------------------------------
;;; comparison

(let-syntax
    ((declare-real-comparison-unary/multi (syntax-rules ()
					    ((_ ?who)
					     (declare-core-primitive ?who
						 (safe)
					       (signatures
						((T:real . T:real)	=> (T:boolean)))
					       (attributes
						((_ . _)		foldable effect-free)))))))
  (declare-real-comparison-unary/multi =)
  (declare-real-comparison-unary/multi !=)
  (declare-real-comparison-unary/multi <)
  (declare-real-comparison-unary/multi >=)
  (declare-real-comparison-unary/multi <)
  (declare-real-comparison-unary/multi >=)
  #| end of LET-SYNTAX |# )

;;; --------------------------------------------------------------------
;;; exponentiation, exponentials and logarithms

(declare-number-binary expt
  (replacements
   $expt-fixnum-negative-fixnum $expt-bignum-negative-fixnum $expt-flonum-negative-fixnum $expt-ratnum-negative-fixnum
   $expt-compnum-negative-fixnum $expt-cflonum-negative-fixnum
   $expt-fixnum-positive-fixnum $expt-bignum-positive-fixnum $expt-flonum-positive-fixnum $expt-ratnum-positive-fixnum
   $expt-compnum-positive-fixnum $expt-cflonum-positive-fixnum
   $expt-fixnum-fixnum $expt-bignum-fixnum $expt-flonum-fixnum $expt-ratnum-fixnum $expt-compnum-fixnum $expt-cflonum-fixnum
   $expt-fixnum-bignum $expt-bignum-bignum $expt-flonum-bignum $expt-ratnum-bignum $expt-compnum-bignum $expt-cflonum-bignum
   $expt-fixnum-flonum $expt-bignum-flonum $expt-flonum-flonum $expt-ratnum-flonum $expt-compnum-flonum $expt-cflonum-flonum
   $expt-fixnum-ratnum $expt-bignum-ratnum $expt-flonum-ratnum $expt-ratnum-ratnum $expt-compnum-ratnum $expt-cflonum-ratnum
   $expt-fixnum-cflonum $expt-bignum-cflonum $expt-flonum-cflonum $expt-ratnum-cflonum $expt-compnum-cflonum $expt-cflonum-cflonum
   $expt-fixnum-compnum $expt-bignum-compnum $expt-flonum-compnum $expt-ratnum-compnum $expt-compnum-compnum $expt-cflonum-compnum
   $expt-number-negative-fixnum $expt-number-positive-fixnum
   $expt-number-fixnum $expt-number-bignum $expt-number-flonum $expt-number-ratnum $expt-number-compnum $expt-number-cflonum))

(declare-core-primitive square
    (safe)
  (signatures
   ((T:fixnum)			=> (T:exact-integer))
   ((T:bignum)			=> (T:exact-integer))
   ((T:flonum)			=> (T:flonum))
   ((T:ratnum)			=> (T:exact-real))
   ((T:compnum)			=> (T:number))
   ((T:cflonum)			=> (T:cflonum)))
  (attributes
   ((_)				foldable effect-free result-true))
  (replacements $square-fixnum $square-bignum $square-flonum $square-ratnum $square-compnum $square-cflonum))

(declare-core-primitive cube
    (safe)
  (signatures
   ((T:fixnum)			=> (T:exact-integer))
   ((T:bignum)			=> (T:exact-integer))
   ((T:flonum)			=> (T:flonum))
   ((T:ratnum)			=> (T:exact-real))
   ((T:compnum)			=> (T:number))
   ((T:cflonum)			=> (T:cflonum)))
  (attributes
   ((_)				foldable effect-free result-true))
  (replacements $cube-fixnum $cube-bignum $cube-flonum $cube-ratnum $cube-compnum $cube-cflonum))

(declare-core-primitive sqrt
    (safe)
  (signatures
   ((T:fixnum)			=> (T:number))
   ((T:bignum)			=> (T:number))
   ((T:flonum)			=> (T:inexact))
   ((T:ratnum)			=> (T:number))
   ((T:compnum)			=> (T:number))
   ((T:cflonum)			=> (T:cflonum)))
  (attributes
   ((_)				foldable effect-free result-true))
  (replacements $sqrt-fixnum $sqrt-bignum $sqrt-flonum $sqrt-ratnum $sqrt-compnum $sqrt-cflonum))

(declare-core-primitive cbrt
    (safe)
  (signatures
   ((T:fixnum)			=> (T:number))
   ((T:bignum)			=> (T:number))
   ((T:flonum)			=> (T:inexact))
   ((T:ratnum)			=> (T:number))
   ((T:compnum)			=> (T:number))
   ((T:cflonum)			=> (T:cflonum)))
  (attributes
   ((_)				foldable effect-free result-true))
  (replacements $cbrt-fixnum $cbrt-bignum $cbrt-flonum $cbrt-ratnum $cbrt-compnum $cbrt-cflonum))

(declare-core-primitive exact-integer-sqrt
    (safe)
  (signatures
   ((T:fixnum)			=> (T:positive-fixnum T:positive-fixnum))
   ((T:bignum)			=> (T:exact-integer T:exact-integer))
   ((T:exact-integer)		=> (T:exact-integer T:exact-integer)))
  (attributes
   ((_)				effect-free))
  (replacements $exact-integer-sqrt-fixnum $exact-integer-sqrt-bignum))

(declare-core-primitive exp
    (safe)
  (signatures
   ((T:fixnum)			=> (T:real))
   ((T:bignum)			=> (T:flonum))
   ((T:flonum)			=> (T:flonum))
   ((T:ratnum)			=> (T:flonum))
   ((T:compnum)			=> (T:cflonum))
   ((T:cflonum)			=> (T:cflonum)))
  (attributes
   ((_)				foldable effect-free result-true))
  (replacements $exp-fixnum $exp-bignum $exp-flonum $exp-ratnum $exp-compnum $exp-cflonum))

(declare-core-primitive log
    (safe)
  (signatures
   ((T:fixnum)			=> (T:number))
   ((T:bignum)			=> (T:inexact))
   ((T:flonum)			=> (T:inexact))
   ((T:ratnum)			=> (T:inexact))
   ((T:compnum)			=> (T:inexact))
   ((T:cflonum)			=> (T:cflonum))
   ((T:number T:number)		=> (T:number)))
  (attributes
   ((_)				foldable effect-free result-true)
   ((_ _)			foldable effect-free result-true))
  (replacements $log-fixnum $log-bignum $log-flonum $log-ratnum $log-compnum $log-cflonum))

;;; --------------------------------------------------------------------
;;; bitwise

(declare-core-primitive bitwise-and
    (safe)
  (signatures
   (()				=> (T:fixnum))
   ((T:fixnum)			=> (T:fixnum))
   ((T:bignum)			=> (T:bignum))
   ((T:fixnum T:fixnum)		=> (T:fixnum))
   ((T:bignum T:bignum)		=> (T:bignum))
   ((T:fixnum T:bignum)		=> (T:bignum))
   ((T:bignum T:fixnum)		=> (T:bignum))
   (T:exact-integer		=> (T:exact-integer)))
  (attributes
   ((_ _)			foldable effect-free result-true))
  (replacements
   $bitwise-and-fixnum-fixnum $bitwise-and-fixnum-bignum
   $bitwise-and-bignum-fixnum $bitwise-and-bignum-bignum
   $bitwise-and-fixnum-number $bitwise-and-bignum-number))

(declare-core-primitive bitwise-ior
    (safe)
  (signatures
   (()				=> (T:fixnum))
   ((T:fixnum)			=> (T:fixnum))
   ((T:bignum)			=> (T:bignum))
   ((T:fixnum T:fixnum)		=> (T:fixnum))
   ((T:bignum T:bignum)		=> (T:bignum))
   ((T:fixnum T:bignum)		=> (T:bignum))
   ((T:bignum T:fixnum)		=> (T:bignum))
   (T:exact-integer		=> (T:exact-integer)))
  (attributes
   ((_ _)			foldable effect-free result-true))
  (replacements
   $bitwise-ior-fixnum-fixnum $bitwise-ior-fixnum-bignum
   $bitwise-ior-bignum-fixnum $bitwise-ior-bignum-bignum
   $bitwise-ior-fixnum-number $bitwise-ior-bignum-number))

(declare-core-primitive bitwise-xor
    (safe)
  (signatures
   (()				=> (T:fixnum))
   ((T:fixnum)			=> (T:fixnum))
   ((T:bignum)			=> (T:bignum))
   ((T:fixnum T:fixnum)		=> (T:fixnum))
   ((T:bignum T:bignum)		=> (T:bignum))
   ((T:fixnum T:bignum)		=> (T:bignum))
   ((T:bignum T:fixnum)		=> (T:bignum))
   (T:exact-integer		=> (T:exact-integer)))
  (attributes
   ((_ _)			foldable effect-free result-true))
  (replacements
   $bitwise-xor-fixnum-fixnum $bitwise-xor-fixnum-bignum
   $bitwise-xor-bignum-fixnum $bitwise-xor-bignum-bignum
   $bitwise-xor-fixnum-number $bitwise-xor-bignum-number))

(declare-core-primitive bitwise-not
    (safe)
  (signatures
   ((T:fixnum)			=> (T:fixnum))
   ((T:bignum)			=> (T:bignum)))
  (attributes
   ((_ _)			foldable effect-free result-true))
  (replacements $bitwise-not-fixnum $bitwise-not-bignum))

(declare-core-primitive bitwise-arithmetic-shift
    (safe)
  (signatures
   ((T:exact-integer T:fixnum)	=> (T:exact-integer)))
  (attributes
   ((_ _)			foldable effect-free result-true)))

(declare-core-primitive bitwise-arithmetic-shift-left
    (safe)
  (signatures
   ((T:exact-integer T:fixnum)	=> (T:exact-integer)))
  (attributes
   ((_ _)			foldable effect-free result-true)))

(declare-core-primitive bitwise-arithmetic-shift-right
    (safe)
  (signatures
   ((T:exact-integer T:fixnum)	=> (T:exact-integer)))
  (attributes
   ((_ _)			foldable effect-free result-true)))

(declare-core-primitive bitwise-bit-count
    (safe)
  (signatures
   ((T:exact-integer)		=> (T:exact-integer)))
  (attributes
   ((_)				foldable effect-free result-true)))

(declare-core-primitive bitwise-bit-field
    (safe)
  (signatures
   ((T:exact-integer T:exact-integer T:exact-integer)	=> (T:exact-integer)))
  (attributes
   ((_ _ _)			foldable effect-free result-true)))

(declare-core-primitive bitwise-bit-set?
    (safe)
  (signatures
   ((T:exact-integer T:exact-integer)	=> (T:boolean)))
  (attributes
   ((_ _)			foldable effect-free)))

(declare-core-primitive bitwise-copy-bit
    (safe)
  (signatures
   ((T:exact-integer T:exact-integer T:exact-integer)	=> (T:exact-integer)))
  (attributes
   ((_ _ _)			foldable effect-free result-true)))

(declare-core-primitive bitwise-copy-bit-field
    (safe)
  (signatures
   ((T:exact-integer T:exact-integer T:exact-integer T:exact-integer)	=> (T:exact-integer)))
  (attributes
   ((_ _ _ _)			foldable effect-free result-true)))

(declare-core-primitive bitwise-first-bit-set
    (safe)
  (signatures
   ((T:exact-integer)	=> (T:exact-integer)))
  (attributes
   ((_)			foldable effect-free result-true)))

(declare-core-primitive bitwise-if
    (safe)
  (signatures
   ((T:exact-integer T:exact-integer T:exact-integer)	=> (T:exact-integer)))
  (attributes
   ((_ _ _)			foldable effect-free result-true)))

(declare-core-primitive bitwise-length
    (safe)
  (signatures
   ((T:exact-integer)	=> (T:exact-integer)))
  (attributes
   ((_)			foldable effect-free result-true)))

(declare-core-primitive bitwise-reverse-bit-field
    (safe)
  (signatures
   ((T:exact-integer T:exact-integer T:exact-integer)	=> (T:exact-integer)))
  (attributes
   ((_ _ _)			foldable effect-free result-true)))

(declare-core-primitive bitwise-rotate-bit-field
    (safe)
  (signatures
   ((T:exact-integer T:exact-integer T:exact-integer T:exact-integer)	=> (T:exact-integer)))
  (attributes
   ((_ _ _ _)			foldable effect-free result-true)))

;;; --------------------------------------------------------------------

(declare-core-primitive sll
    (safe)
  (signatures
   ((T:fixnum T:fixnum)		=> (T:exact-integer))
   ((T:bignum T:fixnum)		=> (T:exact-integer)))
  (attributes
   ((_ _)			foldable effect-free result-true)))

(declare-core-primitive sra
    (safe)
  (signatures
   ((T:fixnum T:fixnum)		=> (T:exact-integer))
   ((T:bignum T:fixnum)		=> (T:exact-integer)))
  (attributes
   ((_ _)			foldable effect-free result-true)))

;;; --------------------------------------------------------------------
;;; trigonometric

(declare-number-unary sin	(replacements $sin-fixnum $sin-bignum $sin-flonum $sin-ratnum $sin-compnum $sin-cflonum))
(declare-number-unary cos	(replacements $cos-fixnum $cos-bignum $cos-flonum $cos-ratnum $cos-compnum $cos-cflonum))
(declare-number-unary tan	(replacements $tan-fixnum $tan-bignum $tan-flonum $tan-ratnum $tan-compnum $tan-cflonum))
(declare-number-unary asin	(replacements $asin-fixnum $asin-bignum $asin-flonum $asin-ratnum $asin-compnum $asin-cflonum))
(declare-number-unary acos	(replacements $acos-fixnum $acos-bignum $acos-flonum $acos-ratnum $acos-compnum $acos-cflonum))
(declare-number-unary/binary atan (replacements $atan-fixnum $atan-bignum $atan-flonum $atan-ratnum $atan-compnum $atan-cflonum))

;;; --------------------------------------------------------------------
;;; hyperbolic

(declare-number-unary sinh	(replacements $sinh-fixnum $sinh-bignum $sinh-flonum $sinh-ratnum $sinh-compnum $sinh-cflonum))
(declare-number-unary cosh	(replacements $cosh-fixnum $cosh-bignum $cosh-flonum $cosh-ratnum $cosh-compnum $cosh-cflonum))
(declare-number-unary tanh	(replacements $tanh-fixnum $tanh-bignum $tanh-flonum $tanh-ratnum $tanh-compnum $tanh-cflonum))
(declare-number-unary asinh	(replacements $asinh-fixnum $asinh-bignum $asinh-flonum $asinh-ratnum $asinh-compnum $asinh-cflonum))
(declare-number-unary acosh	(replacements $acosh-fixnum $acosh-bignum $acosh-flonum $acosh-ratnum $acosh-compnum $acosh-cflonum))
(declare-number-unary atanh	(replacements $atanh-fixnum $atanh-bignum $atanh-flonum $atanh-ratnum $atanh-compnum $atanh-cflonum))

;;; --------------------------------------------------------------------
;;; conversion

(declare-core-primitive integer->char
    (safe)
  (signatures
   ((T:fixnum)		=> (T:char)))
  (attributes
   ((_)			foldable effect-free result-true)))

(declare-core-primitive number->string
    (safe)
  (signatures
   ((T:number)				=> (T:string))
   ((T:number T:positive-fixnum)	=> (T:string))
   ((T:number T:positive-fixnum)	=> (T:string)))
  (attributes
   ((_)			foldable effect-free result-true)
   ((_ _)		foldable effect-free result-true)
   ((_ _ _)		foldable effect-free result-true)))


;;;; numerics, unsafe functions

(declare-unsafe-unary-operation $neg-number	T:number	T:number)
(declare-unsafe-unary-operation $neg-fixnum	T:fixnum	T:exact-integer)
(declare-unsafe-unary-operation $neg-bignum	T:bignum	T:exact-integer)
(declare-unsafe-unary-operation $neg-flonum	T:flonum	T:flonum)
(declare-unsafe-unary-operation $neg-ratnum	T:ratnum	T:ratnum)
(declare-unsafe-unary-operation $neg-compnum	T:compnum	T:compnum)
(declare-unsafe-unary-operation $neg-cflonum	T:cflonum	T:cflonum)

;;; --------------------------------------------------------------------

(declare-unsafe-unary-operation $inv-number	T:number	T:number)
(declare-unsafe-unary-operation $inv-fixnum	T:fixnum	T:exact-real)
(declare-unsafe-unary-operation $inv-bignum	T:bignum	T:ratnum)
(declare-unsafe-unary-operation $inv-flonum	T:flonum	T:flonum)
(declare-unsafe-unary-operation $inv-ratnum	T:ratnum	T:exact-real)
(declare-unsafe-unary-operation $inv-compnum	T:compnum	T:complex)
(declare-unsafe-unary-operation $inv-cflonum	T:cflonum	T:cflonum)

;;; --------------------------------------------------------------------

(declare-unsafe-unary-operation $add1-integer	T:exact-integer	T:exact-integer)

(declare-core-primitive $add1-fixnum
    (unsafe)
  (signatures
   ((T:non-positive-fixnum)	=> (T:fixnum))
   ((T:fixnum)			=> (T:exact-integer)))
  (attributes
   ((_)				foldable effect-free result-true)))

(declare-core-primitive $add1-bignum
    (unsafe)
  (signatures
   ((T:positive-bignum)		=> (T:bignum))
   ((T:bignum)			=> (T:exact-integer)))
  (attributes
   ((_)				foldable effect-free result-true)))

;;; --------------------------------------------------------------------

(declare-unsafe-unary-operation $sub1-integer	T:exact-integer	T:exact-integer)

(declare-core-primitive $sub1-fixnum
    (unsafe)
  (signatures
   ((T:non-negative-fixnum)	=> (T:fixnum))
   ((T:fixnum)			=> (T:exact-integer)))
  (attributes
   ((_)				foldable effect-free result-true)))

(declare-core-primitive $sub1-bignum
    (unsafe)
  (signatures
   ((T:negative-bignum)		=> (T:bignum))
   ((T:bignum)			=> (T:exact-integer)))
  (attributes
   ((_)				foldable effect-free result-true)))

;;; --------------------------------------------------------------------

(declare-unsafe-binary-operation $add-number-number	T:number	T:number	T:number)

(declare-unsafe-binary-operation $add-fixnum-number	T:fixnum	T:number	T:number)
(declare-unsafe-binary-operation $add-bignum-number	T:bignum	T:number	T:number)
(declare-unsafe-binary-operation $add-flonum-number	T:flonum	T:number	T:number)
(declare-unsafe-binary-operation $add-ratnum-number	T:ratnum	T:number	T:number)
(declare-unsafe-binary-operation $add-compnum-number	T:compnum	T:number	T:number)
(declare-unsafe-binary-operation $add-cflonum-number	T:cflonum	T:number	T:number)

(declare-unsafe-binary-operation $add-number-fixnum	T:number	T:fixnum	T:number)
(declare-unsafe-binary-operation $add-number-bignum	T:number	T:bignum	T:number)
(declare-unsafe-binary-operation $add-number-flonum	T:number	T:flonum	T:number)
(declare-unsafe-binary-operation $add-number-ratnum	T:number	T:ratnum	T:number)
(declare-unsafe-binary-operation $add-number-compnum	T:number	T:compnum	T:number)
(declare-unsafe-binary-operation $add-number-cflonum	T:number	T:cflonum	T:number)

(declare-unsafe-binary-operation $add-fixnum-fixnum	T:fixnum	T:fixnum	T:exact-integer)
(declare-unsafe-binary-operation $add-fixnum-bignum	T:fixnum	T:bignum	T:exact-integer)
(declare-unsafe-binary-operation $add-fixnum-flonum	T:fixnum	T:flonum	T:flonum)
(declare-unsafe-binary-operation $add-fixnum-ratnum	T:fixnum	T:ratnum	T:exact-real)
(declare-unsafe-binary-operation $add-fixnum-compnum	T:fixnum	T:compnum	T:compnum)
(declare-unsafe-binary-operation $add-fixnum-cflonum	T:fixnum	T:cflonum	T:cflonum)

(declare-unsafe-binary-operation $add-bignum-fixnum	T:bignum	T:fixnum	T:exact-integer)
(declare-unsafe-binary-operation $add-bignum-bignum	T:bignum	T:bignum	T:exact-integer)
(declare-unsafe-binary-operation $add-bignum-flonum	T:bignum	T:flonum	T:flonum)
(declare-unsafe-binary-operation $add-bignum-ratnum	T:bignum	T:ratnum	T:exact-real)
(declare-unsafe-binary-operation $add-bignum-compnum	T:bignum	T:compnum	T:compnum)
(declare-unsafe-binary-operation $add-bignum-cflonum	T:bignum	T:cflonum	T:cflonum)

(declare-unsafe-binary-operation $add-flonum-fixnum	T:flonum	T:fixnum	T:flonum)
(declare-unsafe-binary-operation $add-flonum-bignum	T:flonum	T:bignum	T:flonum)
(declare-unsafe-binary-operation $add-flonum-flonum	T:flonum	T:flonum	T:flonum)
(declare-unsafe-binary-operation $add-flonum-ratnum	T:flonum	T:ratnum	T:flonum)
(declare-unsafe-binary-operation $add-flonum-compnum	T:flonum	T:compnum	T:compnum)
(declare-unsafe-binary-operation $add-flonum-cflonum	T:flonum	T:cflonum	T:cflonum)

(declare-unsafe-binary-operation $add-ratnum-fixnum	T:ratnum	T:fixnum	T:exact-real)
(declare-unsafe-binary-operation $add-ratnum-bignum	T:ratnum	T:bignum	T:exact-real)
(declare-unsafe-binary-operation $add-ratnum-flonum	T:ratnum	T:flonum	T:flonum)
(declare-unsafe-binary-operation $add-ratnum-ratnum	T:ratnum	T:ratnum	T:exact-real)
(declare-unsafe-binary-operation $add-ratnum-compnum	T:ratnum	T:compnum	T:compnum)
(declare-unsafe-binary-operation $add-ratnum-cflonum	T:ratnum	T:cflonum	T:cflonum)

(declare-unsafe-binary-operation $add-compnum-fixnum	T:compnum	T:fixnum	T:compnum)
(declare-unsafe-binary-operation $add-compnum-bignum	T:compnum	T:bignum	T:compnum)
(declare-unsafe-binary-operation $add-compnum-flonum	T:compnum	T:flonum	T:complex)
(declare-unsafe-binary-operation $add-compnum-ratnum	T:compnum	T:ratnum	T:compnum)
(declare-unsafe-binary-operation $add-compnum-compnum	T:compnum	T:compnum	T:number)
(declare-unsafe-binary-operation $add-compnum-cflonum	T:compnum	T:cflonum	T:cflonum)

(declare-unsafe-binary-operation $add-cflonum-fixnum	T:cflonum	T:fixnum	T:cflonum)
(declare-unsafe-binary-operation $add-cflonum-bignum	T:cflonum	T:bignum	T:cflonum)
(declare-unsafe-binary-operation $add-cflonum-ratnum	T:cflonum	T:flonum	T:cflonum)
(declare-unsafe-binary-operation $add-cflonum-flonum	T:cflonum	T:ratnum	T:cflonum)
(declare-unsafe-binary-operation $add-cflonum-compnum	T:cflonum	T:compnum	T:cflonum)
(declare-unsafe-binary-operation $add-cflonum-cflonum	T:cflonum	T:cflonum	T:cflonum)

;;; --------------------------------------------------------------------

(declare-unsafe-binary-operation $sub-number-number	T:number	T:number	T:number)

(declare-unsafe-binary-operation $sub-fixnum-number	T:fixnum	T:number	T:number)
(declare-unsafe-binary-operation $sub-bignum-number	T:bignum	T:number	T:number)
(declare-unsafe-binary-operation $sub-flonum-number	T:flonum	T:number	T:number)
(declare-unsafe-binary-operation $sub-ratnum-number	T:ratnum	T:number	T:number)
(declare-unsafe-binary-operation $sub-compnum-number	T:compnum	T:number	T:number)
(declare-unsafe-binary-operation $sub-cflonum-number	T:cflonum	T:number	T:number)

(declare-unsafe-binary-operation $sub-number-fixnum	T:number	T:fixnum	T:number)
(declare-unsafe-binary-operation $sub-number-bignum	T:number	T:bignum	T:number)
(declare-unsafe-binary-operation $sub-number-flonum	T:number	T:flonum	T:number)
(declare-unsafe-binary-operation $sub-number-ratnum	T:number	T:ratnum	T:number)
(declare-unsafe-binary-operation $sub-number-compnum	T:number	T:compnum	T:number)
(declare-unsafe-binary-operation $sub-number-cflonum	T:number	T:cflonum	T:number)

(declare-unsafe-binary-operation $sub-fixnum-fixnum	T:fixnum	T:fixnum	T:exact-integer)
(declare-unsafe-binary-operation $sub-fixnum-bignum	T:fixnum	T:bignum	T:exact-integer)
(declare-unsafe-binary-operation $sub-fixnum-flonum	T:fixnum	T:flonum	T:flonum)
(declare-unsafe-binary-operation $sub-fixnum-ratnum	T:fixnum	T:ratnum	T:exact-real)
(declare-unsafe-binary-operation $sub-fixnum-compnum	T:fixnum	T:compnum	T:compnum)
(declare-unsafe-binary-operation $sub-fixnum-cflonum	T:fixnum	T:cflonum	T:cflonum)

(declare-unsafe-binary-operation $sub-bignum-fixnum	T:bignum	T:fixnum	T:exact-integer)
(declare-unsafe-binary-operation $sub-bignum-bignum	T:bignum	T:bignum	T:exact-integer)
(declare-unsafe-binary-operation $sub-bignum-flonum	T:bignum	T:flonum	T:flonum)
(declare-unsafe-binary-operation $sub-bignum-ratnum	T:bignum	T:ratnum	T:exact-real)
(declare-unsafe-binary-operation $sub-bignum-compnum	T:bignum	T:compnum	T:compnum)
(declare-unsafe-binary-operation $sub-bignum-cflonum	T:bignum	T:cflonum	T:cflonum)

(declare-unsafe-binary-operation $sub-flonum-fixnum	T:flonum	T:fixnum	T:flonum)
(declare-unsafe-binary-operation $sub-flonum-bignum	T:flonum	T:bignum	T:flonum)
(declare-unsafe-binary-operation $sub-flonum-flonum	T:flonum	T:flonum	T:flonum)
(declare-unsafe-binary-operation $sub-flonum-ratnum	T:flonum	T:ratnum	T:flonum)
(declare-unsafe-binary-operation $sub-flonum-compnum	T:flonum	T:compnum	T:complex)
(declare-unsafe-binary-operation $sub-flonum-cflonum	T:flonum	T:cflonum	T:cflonum)

(declare-unsafe-binary-operation $sub-ratnum-fixnum	T:ratnum	T:fixnum	T:exact-real)
(declare-unsafe-binary-operation $sub-ratnum-bignum	T:ratnum	T:bignum	T:exact-real)
(declare-unsafe-binary-operation $sub-ratnum-flonum	T:ratnum	T:flonum	T:flonum)
(declare-unsafe-binary-operation $sub-ratnum-ratnum	T:ratnum	T:ratnum	T:exact-real)
(declare-unsafe-binary-operation $sub-ratnum-compnum	T:ratnum	T:compnum	T:compnum)
(declare-unsafe-binary-operation $sub-ratnum-cflonum	T:ratnum	T:cflonum	T:cflonum)

(declare-unsafe-binary-operation $sub-compnum-fixnum	T:compnum	T:fixnum	T:compnum)
(declare-unsafe-binary-operation $sub-compnum-bignum	T:compnum	T:bignum	T:compnum)
(declare-unsafe-binary-operation $sub-compnum-flonum	T:compnum	T:flonum	T:complex)
(declare-unsafe-binary-operation $sub-compnum-ratnum	T:compnum	T:ratnum	T:compnum)
(declare-unsafe-binary-operation $sub-compnum-compnum	T:compnum	T:compnum	T:number)
(declare-unsafe-binary-operation $sub-compnum-cflonum	T:compnum	T:cflonum	T:cflonum)

(declare-unsafe-binary-operation $sub-cflonum-fixnum	T:cflonum	T:fixnum	T:cflonum)
(declare-unsafe-binary-operation $sub-cflonum-bignum	T:cflonum	T:bignum	T:cflonum)
(declare-unsafe-binary-operation $sub-cflonum-flonum	T:cflonum	T:flonum	T:cflonum)
(declare-unsafe-binary-operation $sub-cflonum-ratnum	T:cflonum	T:ratnum	T:cflonum)
(declare-unsafe-binary-operation $sub-cflonum-compnum	T:cflonum	T:compnum	T:cflonum)
(declare-unsafe-binary-operation $sub-cflonum-cflonum	T:cflonum	T:cflonum	T:cflonum)

;;; --------------------------------------------------------------------

(declare-unsafe-binary-operation $mul-number-number	T:number	T:number	T:number)

(declare-unsafe-binary-operation $mul-fixnum-number	T:fixnum	T:number	T:number)
(declare-unsafe-binary-operation $mul-bignum-number	T:bignum	T:number	T:number)
(declare-unsafe-binary-operation $mul-flonum-number	T:flonum	T:number	T:number)
(declare-unsafe-binary-operation $mul-ratnum-number	T:ratnum	T:number	T:number)
(declare-unsafe-binary-operation $mul-compnum-number	T:compnum	T:number	T:number)
(declare-unsafe-binary-operation $mul-cflonum-number	T:cflonum	T:number	T:cflonum)

(declare-unsafe-binary-operation $mul-number-fixnum	T:number	T:fixnum	T:number)
(declare-unsafe-binary-operation $mul-number-bignum	T:number	T:bignum	T:number)
(declare-unsafe-binary-operation $mul-number-flonum	T:number	T:flonum	T:number)
(declare-unsafe-binary-operation $mul-number-ratnum	T:number	T:ratnum	T:number)
(declare-unsafe-binary-operation $mul-number-compnum	T:number	T:compnum	T:number)
(declare-unsafe-binary-operation $mul-number-cflonum	T:number	T:cflonum	T:cflonum)

(declare-unsafe-binary-operation $mul-fixnum-fixnum	T:fixnum	T:fixnum	T:exact-integer)
(declare-unsafe-binary-operation $mul-fixnum-bignum	T:fixnum	T:bignum	T:exact-integer)
(declare-unsafe-binary-operation $mul-fixnum-flonum	T:fixnum	T:flonum	T:flonum)
(declare-unsafe-binary-operation $mul-fixnum-ratnum	T:fixnum	T:ratnum	T:exact-real)
(declare-unsafe-binary-operation $mul-fixnum-compnum	T:fixnum	T:compnum	T:compnum)
(declare-unsafe-binary-operation $mul-fixnum-cflonum	T:fixnum	T:cflonum	T:cflonum)

(declare-unsafe-binary-operation $mul-bignum-fixnum	T:bignum	T:fixnum	T:exact-integer)
(declare-unsafe-binary-operation $mul-bignum-bignum	T:bignum	T:bignum	T:exact-integer)
(declare-unsafe-binary-operation $mul-bignum-flonum	T:bignum	T:flonum	T:flonum)
(declare-unsafe-binary-operation $mul-bignum-ratnum	T:bignum	T:ratnum	T:exact-real)
(declare-unsafe-binary-operation $mul-bignum-compnum	T:bignum	T:compnum	T:compnum)
(declare-unsafe-binary-operation $mul-bignum-cflonum	T:bignum	T:cflonum	T:cflonum)

(declare-unsafe-binary-operation $mul-flonum-fixnum	T:flonum	T:fixnum	T:flonum)
(declare-unsafe-binary-operation $mul-flonum-bignum	T:flonum	T:bignum	T:flonum)
(declare-unsafe-binary-operation $mul-flonum-flonum	T:flonum	T:flonum	T:flonum)
(declare-unsafe-binary-operation $mul-flonum-ratnum	T:flonum	T:ratnum	T:flonum)
(declare-unsafe-binary-operation $mul-flonum-compnum	T:flonum	T:compnum	T:cflonum)
(declare-unsafe-binary-operation $mul-flonum-cflonum	T:flonum	T:cflonum	T:cflonum)

(declare-unsafe-binary-operation $mul-ratnum-fixnum	T:ratnum	T:fixnum	T:exact-real)
(declare-unsafe-binary-operation $mul-ratnum-bignum	T:ratnum	T:bignum	T:exact-real)
(declare-unsafe-binary-operation $mul-ratnum-flonum	T:ratnum	T:flonum	T:flonum)
(declare-unsafe-binary-operation $mul-ratnum-ratnum	T:ratnum	T:ratnum	T:exact-real)
(declare-unsafe-binary-operation $mul-ratnum-compnum	T:ratnum	T:compnum	T:compnum)
(declare-unsafe-binary-operation $mul-ratnum-cflonum	T:ratnum	T:cflonum	T:cflonum)

(declare-unsafe-binary-operation $mul-compnum-fixnum	T:compnum	T:fixnum	T:compnum)
(declare-unsafe-binary-operation $mul-compnum-bignum	T:compnum	T:bignum	T:compnum)
(declare-unsafe-binary-operation $mul-compnum-flonum	T:compnum	T:flonum	T:cflonum)
(declare-unsafe-binary-operation $mul-compnum-ratnum	T:compnum	T:ratnum	T:compnum)
(declare-unsafe-binary-operation $mul-compnum-compnum	T:compnum	T:compnum	T:number)
(declare-unsafe-binary-operation $mul-compnum-cflonum	T:compnum	T:cflonum	T:cflonum)

(declare-unsafe-binary-operation $mul-cflonum-fixnum	T:cflonum	T:fixnum	T:cflonum)
(declare-unsafe-binary-operation $mul-cflonum-bignum	T:cflonum	T:bignum	T:cflonum)
(declare-unsafe-binary-operation $mul-cflonum-flonum	T:cflonum	T:flonum	T:cflonum)
(declare-unsafe-binary-operation $mul-cflonum-ratnum	T:cflonum	T:ratnum	T:cflonum)
(declare-unsafe-binary-operation $mul-cflonum-compnum	T:cflonum	T:compnum	T:cflonum)
(declare-unsafe-binary-operation $mul-cflonum-cflonum	T:cflonum	T:cflonum	T:cflonum)

;;; --------------------------------------------------------------------

(declare-unsafe-binary-operation $div-number-number	T:number	T:number	T:number)

(declare-unsafe-binary-operation $div-fixnum-number	T:fixnum	T:number	T:number)
(declare-unsafe-binary-operation $div-bignum-number	T:bignum	T:number	T:number)
(declare-unsafe-binary-operation $div-flonum-number	T:flonum	T:number	T:number)
(declare-unsafe-binary-operation $div-ratnum-number	T:ratnum	T:number	T:number)
(declare-unsafe-binary-operation $div-compnum-number	T:compnum	T:number	T:number)
(declare-unsafe-binary-operation $div-cflonum-number	T:cflonum	T:number	T:number)

(declare-unsafe-binary-operation $div-number-fixnum	T:number	T:fixnum	T:number)
(declare-unsafe-binary-operation $div-number-bignum	T:number	T:bignum	T:number)
(declare-unsafe-binary-operation $div-number-flonum	T:number	T:flonum	T:number)
(declare-unsafe-binary-operation $div-number-ratnum	T:number	T:ratnum	T:number)
(declare-unsafe-binary-operation $div-number-compnum	T:number	T:compnum	T:number)
(declare-unsafe-binary-operation $div-number-cflonum	T:number	T:cflonum	T:number)

(declare-unsafe-binary-operation $div-fixnum-fixnum	T:fixnum	T:fixnum	T:exact-real)
(declare-unsafe-binary-operation $div-fixnum-bignum	T:fixnum	T:bignum	T:exact-real)
(declare-unsafe-binary-operation $div-fixnum-flonum	T:fixnum	T:flonum	T:flonum)
(declare-unsafe-binary-operation $div-fixnum-ratnum	T:fixnum	T:ratnum	T:exact-real)
(declare-unsafe-binary-operation $div-fixnum-compnum	T:fixnum	T:compnum	T:number)
(declare-unsafe-binary-operation $div-fixnum-cflonum	T:fixnum	T:cflonum	T:cflonum)

(declare-unsafe-binary-operation $div-bignum-fixnum	T:bignum	T:fixnum	T:exact-real)
(declare-unsafe-binary-operation $div-bignum-bignum	T:bignum	T:bignum	T:exact-real)
(declare-unsafe-binary-operation $div-bignum-flonum	T:bignum	T:flonum	T:flonum)
(declare-unsafe-binary-operation $div-bignum-ratnum	T:bignum	T:ratnum	T:exact-real)
(declare-unsafe-binary-operation $div-bignum-compnum	T:bignum	T:compnum	T:number)
(declare-unsafe-binary-operation $div-bignum-cflonum	T:bignum	T:cflonum	T:cflonum)

(declare-unsafe-binary-operation $div-ratnum-fixnum	T:ratnum	T:fixnum	T:exact-real)
(declare-unsafe-binary-operation $div-ratnum-bignum	T:ratnum	T:bignum	T:exact-real)
(declare-unsafe-binary-operation $div-ratnum-flonum	T:ratnum	T:flonum	T:flonum)
(declare-unsafe-binary-operation $div-ratnum-ratnum	T:ratnum	T:ratnum	T:exact-real)
(declare-unsafe-binary-operation $div-ratnum-compnum	T:ratnum	T:compnum	T:number)
(declare-unsafe-binary-operation $div-ratnum-cflonum	T:ratnum	T:cflonum	T:cflonum)

(declare-unsafe-binary-operation $div-flonum-fixnum	T:flonum	T:fixnum	T:flonum)
(declare-unsafe-binary-operation $div-flonum-bignum	T:flonum	T:bignum	T:flonum)
(declare-unsafe-binary-operation $div-flonum-flonum	T:flonum	T:flonum	T:flonum)
(declare-unsafe-binary-operation $div-flonum-ratnum	T:flonum	T:ratnum	T:flonum)
(declare-unsafe-binary-operation $div-flonum-compnum	T:flonum	T:compnum	T:cflonum)
(declare-unsafe-binary-operation $div-flonum-cflonum	T:flonum	T:cflonum	T:cflonum)

(declare-unsafe-binary-operation $div-compnum-fixnum	T:compnum	T:fixnum	T:number)
(declare-unsafe-binary-operation $div-compnum-bignum	T:compnum	T:bignum	T:number)
(declare-unsafe-binary-operation $div-compnum-flonum	T:compnum	T:flonum	T:cflonum)
(declare-unsafe-binary-operation $div-compnum-ratnum	T:compnum	T:ratnum	T:number)
(declare-unsafe-binary-operation $div-compnum-compnum	T:compnum	T:compnum	T:number)
(declare-unsafe-binary-operation $div-compnum-cflonum	T:compnum	T:cflonum	T:cflonum)

(declare-unsafe-binary-operation $div-cflonum-fixnum	T:cflonum	T:fixnum	T:cflonum)
(declare-unsafe-binary-operation $div-cflonum-bignum	T:cflonum	T:bignum	T:cflonum)
(declare-unsafe-binary-operation $div-cflonum-flonum	T:cflonum	T:flonum	T:cflonum)
(declare-unsafe-binary-operation $div-cflonum-ratnum	T:cflonum	T:ratnum	T:cflonum)
(declare-unsafe-binary-operation $div-cflonum-compnum	T:cflonum	T:compnum	T:cflonum)
(declare-unsafe-binary-operation $div-cflonum-cflonum	T:cflonum	T:cflonum	T:cflonum)

;;; --------------------------------------------------------------------

(declare-unsafe-unary-operation $square-fixnum		T:fixnum	T:exact-integer)
(declare-unsafe-unary-operation $square-bignum		T:bignum	T:exact-integer)
(declare-unsafe-unary-operation $square-ratnum		T:ratnum	T:exact-real)
(declare-unsafe-unary-operation $square-compnum		T:compnum	T:number)
(declare-unsafe-unary-operation $square-cflonum		T:cflonum	T:cflonum)

;;; --------------------------------------------------------------------

(declare-unsafe-unary-operation $cube-fixnum		T:fixnum	T:exact-integer)
(declare-unsafe-unary-operation $cube-bignum		T:bignum	T:exact-integer)
(declare-unsafe-unary-operation $cube-ratnum		T:ratnum	T:exact-real)
(declare-unsafe-unary-operation $cube-compnum		T:compnum	T:number)
(declare-unsafe-unary-operation $cube-cflonum		T:cflonum	T:cflonum)

;;; --------------------------------------------------------------------

(declare-unsafe-unary-operation $gcd-number		T:number	T:number)

(declare-unsafe-binary-operation $gcd-number-number	T:number	T:number	T:number)

(declare-unsafe-binary-operation $gcd-fixnum-number	T:fixnum	T:number	T:number)
(declare-unsafe-binary-operation $gcd-bignum-number	T:bignum	T:number	T:number)
(declare-unsafe-binary-operation $gcd-flonum-number	T:flonum	T:number	T:number)

(declare-unsafe-binary-operation $gcd-number-fixnum	T:number	T:fixnum	T:number)
(declare-unsafe-binary-operation $gcd-number-bignum	T:number	T:bignum	T:number)
(declare-unsafe-binary-operation $gcd-number-flonum	T:number	T:flonum	T:number)

(declare-unsafe-binary-operation $gcd-fixnum-fixnum	T:fixnum	T:fixnum	T:exact-integer)
(declare-unsafe-binary-operation $gcd-fixnum-bignum	T:fixnum	T:bignum	T:exact-integer)
(declare-unsafe-binary-operation $gcd-fixnum-flonum	T:fixnum	T:flonum	T:flonum)

(declare-unsafe-binary-operation $gcd-bignum-fixnum	T:bignum	T:fixnum	T:exact-integer)
(declare-unsafe-binary-operation $gcd-bignum-bignum	T:bignum	T:bignum	T:exact-integer)
(declare-unsafe-binary-operation $gcd-bignum-flonum	T:bignum	T:flonum	T:flonum)

(declare-unsafe-binary-operation $gcd-flonum-fixnum	T:flonum	T:fixnum	T:flonum)
(declare-unsafe-binary-operation $gcd-flonum-bignum	T:flonum	T:bignum	T:flonum)
(declare-unsafe-binary-operation $gcd-flonum-flonum	T:flonum	T:flonum	T:flonum)

;;; --------------------------------------------------------------------

(declare-unsafe-unary-operation $lcm-number		T:number	T:number)

(declare-unsafe-binary-operation $lcm-number-number	T:number	T:number	T:number)

(declare-unsafe-binary-operation $lcm-fixnum-number	T:fixnum	T:number	T:number)
(declare-unsafe-binary-operation $lcm-bignum-number	T:bignum	T:number	T:number)
(declare-unsafe-binary-operation $lcm-flonum-number	T:flonum	T:number	T:number)

(declare-unsafe-binary-operation $lcm-number-fixnum	T:number	T:fixnum	T:number)
(declare-unsafe-binary-operation $lcm-number-bignum	T:number	T:bignum	T:number)
(declare-unsafe-binary-operation $lcm-number-flonum	T:number	T:flonum	T:number)

(declare-unsafe-binary-operation $lcm-fixnum-fixnum	T:fixnum	T:fixnum	T:exact-integer)
(declare-unsafe-binary-operation $lcm-fixnum-bignum	T:fixnum	T:bignum	T:exact-integer)
(declare-unsafe-binary-operation $lcm-fixnum-flonum	T:fixnum	T:flonum	T:flonum)

(declare-unsafe-binary-operation $lcm-bignum-fixnum	T:bignum	T:fixnum	T:exact-integer)
(declare-unsafe-binary-operation $lcm-bignum-bignum	T:bignum	T:bignum	T:exact-integer)
(declare-unsafe-binary-operation $lcm-bignum-flonum	T:bignum	T:flonum	T:flonum)

(declare-unsafe-binary-operation $lcm-flonum-fixnum	T:flonum	T:fixnum	T:flonum)
(declare-unsafe-binary-operation $lcm-flonum-bignum	T:flonum	T:bignum	T:flonum)
(declare-unsafe-binary-operation $lcm-flonum-flonum	T:flonum	T:flonum	T:flonum)

;;; --------------------------------------------------------------------

(declare-unsafe-binary-operation/2rv $quotient+remainder-fixnum-number	T:fixnum	T:number      T:number	      T:number)
(declare-unsafe-binary-operation/2rv $quotient+remainder-bignum-number	T:bignum	T:number      T:number	      T:number)
(declare-unsafe-binary-operation/2rv $quotient+remainder-flonum-number	T:flonum	T:number      T:number	      T:number)

(declare-unsafe-binary-operation/2rv $quotient+remainder-number-fixnum	T:number	T:fixnum      T:number	      T:number)
(declare-unsafe-binary-operation/2rv $quotient+remainder-number-bignum	T:number	T:bignum      T:number	      T:number)
(declare-unsafe-binary-operation/2rv $quotient+remainder-number-flonum	T:number	T:flonum      T:number	      T:number)

(declare-unsafe-binary-operation/2rv $quotient+remainder-fixnum-fixnum	T:fixnum	T:fixnum      T:exact-integer T:exact-integer)
(declare-unsafe-binary-operation/2rv $quotient+remainder-fixnum-bignum	T:fixnum	T:bignum      T:exact-integer T:exact-integer)
(declare-unsafe-binary-operation/2rv $quotient+remainder-fixnum-flonum	T:fixnum	T:flonum      T:flonum	      T:flonum)

(declare-unsafe-binary-operation/2rv $quotient+remainder-bignum-fixnum	T:bignum	T:fixnum      T:exact-integer T:exact-integer)
(declare-unsafe-binary-operation/2rv $quotient+remainder-bignum-bignum	T:bignum	T:bignum      T:exact-integer T:exact-integer)
(declare-unsafe-binary-operation/2rv $quotient+remainder-bignum-flonum	T:bignum	T:flonum      T:flonum	      T:flonum)

(declare-unsafe-binary-operation/2rv $quotient+remainder-flonum-fixnum	T:flonum	T:fixnum      T:flonum	      T:flonum)
(declare-unsafe-binary-operation/2rv $quotient+remainder-flonum-bignum	T:flonum	T:bignum      T:flonum	      T:flonum)
(declare-unsafe-binary-operation/2rv $quotient+remainder-flonum-flonum	T:flonum	T:flonum      T:flonum	      T:flonum)

;;; --------------------------------------------------------------------

(declare-unsafe-binary-operation $quotient-fixnum-number	T:fixnum	T:number      T:number)
(declare-unsafe-binary-operation $quotient-bignum-number	T:bignum	T:number      T:number)
(declare-unsafe-binary-operation $quotient-flonum-number	T:flonum	T:number      T:number)

(declare-unsafe-binary-operation $quotient-number-fixnum	T:number	T:fixnum      T:number)
(declare-unsafe-binary-operation $quotient-number-bignum	T:number	T:bignum      T:number)
(declare-unsafe-binary-operation $quotient-number-flonum	T:number	T:flonum      T:number)

(declare-unsafe-binary-operation $quotient-fixnum-fixnum	T:fixnum	T:fixnum      T:exact-integer)
(declare-unsafe-binary-operation $quotient-fixnum-bignum	T:fixnum	T:bignum      T:exact-integer)
(declare-unsafe-binary-operation $quotient-fixnum-flonum	T:fixnum	T:flonum      T:flonum)

(declare-unsafe-binary-operation $quotient-bignum-fixnum	T:bignum	T:fixnum      T:exact-integer)
(declare-unsafe-binary-operation $quotient-bignum-bignum	T:bignum	T:bignum      T:exact-integer)
(declare-unsafe-binary-operation $quotient-bignum-flonum	T:bignum	T:flonum      T:flonum)

(declare-unsafe-binary-operation $quotient-flonum-fixnum	T:flonum	T:fixnum      T:flonum)
(declare-unsafe-binary-operation $quotient-flonum-bignum	T:flonum	T:bignum      T:flonum)
(declare-unsafe-binary-operation $quotient-flonum-flonum	T:flonum	T:flonum      T:flonum)

;;; --------------------------------------------------------------------

(declare-unsafe-binary-operation $remainder-fixnum-number	T:fixnum	T:number      T:number)
(declare-unsafe-binary-operation $remainder-bignum-number	T:bignum	T:number      T:number)
(declare-unsafe-binary-operation $remainder-flonum-number	T:flonum	T:number      T:number)

(declare-unsafe-binary-operation $remainder-number-fixnum	T:number	T:fixnum      T:number)
(declare-unsafe-binary-operation $remainder-number-bignum	T:number	T:bignum      T:number)
(declare-unsafe-binary-operation $remainder-number-flonum	T:number	T:flonum      T:number)

(declare-unsafe-binary-operation $remainder-fixnum-fixnum	T:fixnum	T:fixnum      T:exact-integer)
(declare-unsafe-binary-operation $remainder-fixnum-bignum	T:fixnum	T:bignum      T:exact-integer)
(declare-unsafe-binary-operation $remainder-fixnum-flonum	T:fixnum	T:flonum      T:flonum)

(declare-unsafe-binary-operation $remainder-bignum-fixnum	T:bignum	T:fixnum      T:exact-integer)
(declare-unsafe-binary-operation $remainder-bignum-bignum	T:bignum	T:bignum      T:exact-integer)
(declare-unsafe-binary-operation $remainder-bignum-flonum	T:bignum	T:flonum      T:flonum)

(declare-unsafe-binary-operation $remainder-flonum-fixnum	T:flonum	T:fixnum      T:flonum)
(declare-unsafe-binary-operation $remainder-flonum-bignum	T:flonum	T:bignum      T:flonum)
(declare-unsafe-binary-operation $remainder-flonum-flonum	T:flonum	T:flonum      T:flonum)

;;; --------------------------------------------------------------------

(declare-core-primitive $numerator-fixnum
    (safe)
  (signatures
   ((T:fixnum)			=> (T:fixnum)))
  (attributes
   ((_)				foldable effect-free result-true identity)))

(declare-core-primitive $numerator-bignum
    (safe)
  (signatures
   ((T:bignum)			=> (T:bignum)))
  (attributes
   ((_)				foldable effect-free result-true identity)))

(declare-core-primitive $numerator-flonum
    (safe)
  (signatures
   ((T:flonum)			=> (T:flonum)))
  (attributes
   ((_)				foldable effect-free result-true)))

(declare-core-primitive $numerator-ratnum
    (safe)
  (signatures
   ((T:ratnum)			=> (T:exact-integer)))
  (attributes
   ((_)				foldable effect-free result-true)))

(declare-core-primitive $denominator-fixnum
    (safe)
  (signatures
   ((T:fixnum)			=> (T:positive-fixnum)))
  (attributes
   ;;This always returns 1.
   ((_)				foldable effect-free result-true)))

(declare-core-primitive $denominator-bignum
    (safe)
  (signatures
   ((T:bignum)			=> (T:positive-bignum)))
  (attributes
   ;;This always returns 1.
   ((_)				foldable effect-free result-true)))

(declare-core-primitive $denominator-flonum
    (safe)
  (signatures
   ((T:flonum)			=> (T:flonum)))
  (attributes
   ((_)				foldable effect-free result-true)))

(declare-core-primitive $denominator-ratnum
    (safe)
  (signatures
   ((T:ratnum)			=> (T:exact-integer)))
  (attributes
   ((_)				foldable effect-free result-true)))

;;; --------------------------------------------------------------------

(declare-unsafe-binary-operation $modulo-fixnum-number	T:fixnum	T:number	T:number)
(declare-unsafe-binary-operation $modulo-bignum-number	T:bignum	T:number	T:number)
(declare-unsafe-binary-operation $modulo-flonum-number	T:flonum	T:number	T:number)

(declare-unsafe-binary-operation $modulo-number-fixnum	T:number	T:fixnum	T:number)
(declare-unsafe-binary-operation $modulo-number-bignum	T:number	T:bignum	T:number)
(declare-unsafe-binary-operation $modulo-number-flonum	T:number	T:flonum	T:number)

(declare-unsafe-binary-operation $modulo-fixnum-fixnum	T:fixnum	T:fixnum	T:fixnum)
(declare-unsafe-binary-operation $modulo-fixnum-bignum	T:fixnum	T:bignum	T:exact-integer)
(declare-unsafe-binary-operation $modulo-fixnum-flonum	T:fixnum	T:flonum	T:flonum)

(declare-unsafe-binary-operation $modulo-bignum-fixnum	T:bignum	T:fixnum	T:exact-integer)
(declare-unsafe-binary-operation $modulo-bignum-bignum	T:bignum	T:bignum	T:exact-integer)
(declare-unsafe-binary-operation $modulo-bignum-flonum	T:bignum	T:flonum	T:flonum)

(declare-unsafe-binary-operation $modulo-flonum-fixnum	T:flonum	T:fixnum	T:flonum)
(declare-unsafe-binary-operation $modulo-flonum-bignum	T:flonum	T:bignum	T:flonum)
(declare-unsafe-binary-operation $modulo-flonum-flonum	T:flonum	T:flonum	T:flonum)

;;; --------------------------------------------------------------------

(declare-unsafe-binary-operation $max-fixnum-number	T:fixnum	T:number	T:number)
(declare-unsafe-binary-operation $max-bignum-number	T:bignum	T:number	T:number)
(declare-unsafe-binary-operation $max-flonum-number	T:flonum	T:number	T:number)
(declare-unsafe-binary-operation $max-ratnum-number	T:ratnum	T:number	T:number)

(declare-unsafe-binary-operation $max-number-fixnum	T:number	T:fixnum	T:number)
(declare-unsafe-binary-operation $max-number-bignum	T:number	T:bignum	T:number)
(declare-unsafe-binary-operation $max-number-flonum	T:number	T:flonum	T:number)
(declare-unsafe-binary-operation $max-number-ratnum	T:number	T:ratnum	T:number)

(declare-unsafe-binary-operation $max-fixnum-fixnum	T:fixnum	T:fixnum	T:fixnum)
(declare-unsafe-binary-operation $max-fixnum-bignum	T:fixnum	T:bignum	T:exact-integer)
(declare-unsafe-binary-operation $max-fixnum-flonum	T:fixnum	T:flonum	T:real)
(declare-unsafe-binary-operation $max-fixnum-ratnum	T:fixnum	T:ratnum	T:exact-real)

(declare-unsafe-binary-operation $max-bignum-fixnum	T:bignum	T:fixnum	T:exact-integer)
(declare-unsafe-binary-operation $max-bignum-bignum	T:bignum	T:bignum	T:bignum)
(declare-unsafe-binary-operation $max-bignum-flonum	T:bignum	T:flonum	T:real)
(declare-unsafe-binary-operation $max-bignum-ratnum	T:bignum	T:ratnum	T:exact-real)

(declare-unsafe-binary-operation $max-flonum-fixnum	T:flonum	T:fixnum	T:real)
(declare-unsafe-binary-operation $max-flonum-bignum	T:flonum	T:bignum	T:real)
(declare-unsafe-binary-operation $max-flonum-flonum	T:flonum	T:flonum	T:flonum)
(declare-unsafe-binary-operation $max-flonum-ratnum	T:flonum	T:ratnum	T:real)

(declare-unsafe-binary-operation $max-ratnum-fixnum	T:ratnum	T:fixnum	T:exact-real)
(declare-unsafe-binary-operation $max-ratnum-bignum	T:ratnum	T:bignum	T:exact-real)
(declare-unsafe-binary-operation $max-ratnum-flonum	T:ratnum	T:flonum	T:real)
(declare-unsafe-binary-operation $max-ratnum-ratnum	T:ratnum	T:ratnum	T:ratnum)

;;; --------------------------------------------------------------------

(declare-unsafe-binary-operation $min-fixnum-number	T:fixnum	T:number	T:number)
(declare-unsafe-binary-operation $min-bignum-number	T:bignum	T:number	T:number)
(declare-unsafe-binary-operation $min-flonum-number	T:flonum	T:number	T:number)
(declare-unsafe-binary-operation $min-ratnum-number	T:ratnum	T:number	T:number)

(declare-unsafe-binary-operation $min-number-fixnum	T:number	T:fixnum	T:number)
(declare-unsafe-binary-operation $min-number-bignum	T:number	T:bignum	T:number)
(declare-unsafe-binary-operation $min-number-flonum	T:number	T:flonum	T:number)
(declare-unsafe-binary-operation $min-number-ratnum	T:number	T:ratnum	T:number)

(declare-unsafe-binary-operation $min-fixnum-fixnum	T:fixnum	T:fixnum	T:fixnum)
(declare-unsafe-binary-operation $min-fixnum-bignum	T:fixnum	T:bignum	T:exact-integer)
(declare-unsafe-binary-operation $min-fixnum-flonum	T:fixnum	T:flonum	T:real)
(declare-unsafe-binary-operation $min-fixnum-ratnum	T:fixnum	T:ratnum	T:exact-real)

(declare-unsafe-binary-operation $min-bignum-fixnum	T:bignum	T:fixnum	T:exact-integer)
(declare-unsafe-binary-operation $min-bignum-bignum	T:bignum	T:bignum	T:bignum)
(declare-unsafe-binary-operation $min-bignum-flonum	T:bignum	T:flonum	T:real)
(declare-unsafe-binary-operation $min-bignum-ratnum	T:bignum	T:ratnum	T:exact-real)

(declare-unsafe-binary-operation $min-flonum-fixnum	T:flonum	T:fixnum	T:real)
(declare-unsafe-binary-operation $min-flonum-bignum	T:flonum	T:bignum	T:real)
(declare-unsafe-binary-operation $min-flonum-flonum	T:flonum	T:flonum	T:flonum)
(declare-unsafe-binary-operation $min-flonum-ratnum	T:flonum	T:ratnum	T:real)

(declare-unsafe-binary-operation $min-ratnum-fixnum	T:ratnum	T:fixnum	T:exact-real)
(declare-unsafe-binary-operation $min-ratnum-bignum	T:ratnum	T:bignum	T:exact-real)
(declare-unsafe-binary-operation $min-ratnum-flonum	T:ratnum	T:flonum	T:real)
(declare-unsafe-binary-operation $min-ratnum-ratnum	T:ratnum	T:ratnum	T:ratnum)

;;; --------------------------------------------------------------------

(declare-unsafe-unary-operation $abs-fixnum		T:fixnum	T:exact-integer)
(declare-unsafe-unary-operation $abs-bignum		T:bignum	T:exact-integer)
(declare-unsafe-unary-operation $abs-flonum		T:flonum	T:flonum)
(declare-unsafe-unary-operation $abs-ratnum		T:ratnum	T:ratnum)

;;; --------------------------------------------------------------------

(declare-unsafe-unary-operation $sign-fixnum		T:fixnum	T:fixnum)
(declare-unsafe-unary-operation $sign-bignum		T:bignum	T:fixnum)
(declare-unsafe-unary-operation $sign-flonum		T:flonum	T:flonum)
(declare-unsafe-unary-operation $sign-ratnum		T:ratnum	T:fixnum)

;;; --------------------------------------------------------------------

(declare-core-primitive $exact-fixnum
    (unsafe)
  (signatures
   ((T:positive-fixnum)		=> (T:positive-fixnum))
   ((T:negative-fixnum)		=> (T:negative-fixnum))
   ((T:non-positive-fixnum)	=> (T:non-positive-fixnum))
   ((T:non-negative-fixnum)	=> (T:non-negative-fixnum))
   ((T:fixnum)			=> (T:fixnum)))
  (attributes
   ((_)				foldable effect-free result-true identity)))

(declare-core-primitive $exact-bignum
    (unsafe)
  (signatures
   ((T:positive-bignum)		=> (T:positive-bignum))
   ((T:negative-bignum)		=> (T:negative-bignum))
   ((T:bignum)			=> (T:bignum)))
  (attributes
   ((_)				foldable effect-free result-true identity)))

(declare-core-primitive $exact-flonum
    (unsafe)
  (signatures
   ((T:flonum)			=> (T:exact-integer)))
  (attributes
   ((_)				foldable effect-free result-true)))

(declare-core-primitive $exact-ratnum
    (unsafe)
  (signatures
   ((T:ratnum)			=> (T:ratnum)))
  (attributes
   ((_)				foldable effect-free result-true identity)))

(declare-core-primitive $exact-compnum
    (unsafe)
  (signatures
   ((T:compnum)			=> (T:exact-compnum)))
  (attributes
   ((_)				foldable effect-free result-true)))

(declare-core-primitive $exact-cflonum
    (unsafe)
  (signatures
   ((T:cflonum)			=> (T:exact-compnum)))
  (attributes
   ((_)				foldable effect-free result-true)))

;;;

(declare-core-primitive $inexact-fixnum
    (unsafe)
  (signatures
   ((T:positive-fixnum)		=> (T:positive-flonum))
   ((T:negative-fixnum)		=> (T:negative-flonum))
   ((T:non-positive-fixnum)	=> (T:non-positive-flonum))
   ((T:non-negative-fixnum)	=> (T:non-negative-flonum))
   ((T:fixnum)			=> (T:flonum)))
  (attributes
   ((_)				foldable effect-free result-true)))

(declare-core-primitive $inexact-bignum
    (unsafe)
  (signatures
   ((T:positive-bignum)		=> (T:positive-flonum))
   ((T:negative-bignum)		=> (T:negative-flonum))
   ((T:bignum)			=> (T:flonum)))
  (attributes
   ((_)				foldable effect-free result-true)))

(declare-core-primitive $inexact-flonum
    (unsafe)
  (signatures
   ((T:flonum)			=> (T:flonum)))
  (attributes
   ((_)				foldable effect-free result-true identity)))

(declare-core-primitive $inexact-ratnum
    (unsafe)
  (signatures
   ((T:ratnum)			=> (T:flonum)))
  (attributes
   ((_)				foldable effect-free result-true)))

(declare-core-primitive $inexact-compnum
    (unsafe)
  (signatures
   ((T:compnum)			=> (T:cflonum)))
  (attributes
   ((_)				foldable effect-free result-true)))

(declare-core-primitive $inexact-cflonum
    (unsafe)
  (signatures
   ((T:cflonum)			=> (T:cflonum)))
  (attributes
   ((_)				foldable effect-free result-true identity)))

;;; --------------------------------------------------------------------

(declare-unsafe-binary-operation $expt-number-fixnum	T:number	T:number	T:number)

(declare-unsafe-unary-operation $expt-number-zero-fixnum	T:number	T:number)
(declare-unsafe-unary-operation $expt-fixnum-zero-fixnum	T:fixnum	T:fixnum)
(declare-unsafe-unary-operation $expt-flonum-zero-fixnum	T:flonum	T:flonum)
(declare-unsafe-unary-operation $expt-compnum-zero-fixnum	T:compnum	T:number)
(declare-unsafe-unary-operation $expt-cflonum-zero-fixnum	T:cflonum	T:cflonum)

(declare-unsafe-binary-operation $expt-number-negative-fixnum	T:number	T:negative-fixnum      T:number)
(declare-unsafe-binary-operation $expt-fixnum-negative-fixnum	T:fixnum	T:negative-fixnum      T:exact)
(declare-unsafe-binary-operation $expt-bignum-negative-fixnum	T:bignum	T:negative-fixnum      T:exact)
(declare-unsafe-binary-operation $expt-flonum-negative-fixnum	T:flonum	T:negative-fixnum      T:flonum)
(declare-unsafe-binary-operation $expt-ratnum-negative-fixnum	T:ratnum	T:negative-fixnum      T:exact)
(declare-unsafe-binary-operation $expt-compnum-negative-fixnum	T:compnum	T:negative-fixnum      T:number)
(declare-unsafe-binary-operation $expt-cflonum-negative-fixnum	T:cflonum	T:negative-fixnum      T:cflonum)

(declare-unsafe-binary-operation $expt-number-positive-fixnum	T:number	T:positive-fixnum      T:number)
(declare-unsafe-binary-operation $expt-fixnum-positive-fixnum	T:number	T:positive-fixnum      T:exact)
(declare-unsafe-binary-operation $expt-bignum-positive-fixnum	T:number	T:positive-fixnum      T:exact)
(declare-unsafe-binary-operation $expt-flonum-positive-fixnum	T:number	T:positive-fixnum      T:flonum)
(declare-unsafe-binary-operation $expt-ratnum-positive-fixnum	T:number	T:positive-fixnum      T:exact)
(declare-unsafe-binary-operation $expt-compnum-positive-fixnum	T:number	T:positive-fixnum      T:number)
(declare-unsafe-binary-operation $expt-cflonum-positive-fixnum	T:number	T:positive-fixnum      T:cflonum)

(declare-unsafe-binary-operation $expt-fixnum-fixnum	T:fixnum	T:fixnum	T:exact)
(declare-unsafe-binary-operation $expt-bignum-fixnum	T:bignum	T:fixnum	T:exact)
(declare-unsafe-binary-operation $expt-flonum-fixnum	T:flonum	T:fixnum	T:flonum)
(declare-unsafe-binary-operation $expt-ratnum-fixnum	T:ratnum	T:fixnum	T:exact)
(declare-unsafe-binary-operation $expt-compnum-fixnum	T:compnum	T:fixnum	T:number)
(declare-unsafe-binary-operation $expt-cflonum-fixnum	T:cflonum	T:fixnum	T:cflonum)

;;;

(declare-unsafe-binary-operation $expt-number-bignum	T:number	T:bignum	T:number)
(declare-unsafe-binary-operation $expt-number-flonum	T:number	T:flonum	T:number)
(declare-unsafe-binary-operation $expt-number-ratnum	T:number	T:ratnum	T:number)
(declare-unsafe-binary-operation $expt-number-compnum	T:number	T:compnum	T:number)
(declare-unsafe-binary-operation $expt-number-cflonum	T:number	T:cflonum	T:number)

(declare-unsafe-binary-operation $expt-fixnum-bignum	T:fixnum	T:bignum	T:exact)
(declare-unsafe-binary-operation $expt-bignum-bignum	T:bignum	T:bignum	T:exact)
(declare-unsafe-binary-operation $expt-flonum-bignum	T:flonum	T:bignum	T:flonum)
(declare-unsafe-binary-operation $expt-ratnum-bignum	T:ratnum	T:bignum	T:exact)
(declare-unsafe-binary-operation $expt-compnum-bignum	T:compnum	T:bignum	T:number)
(declare-unsafe-binary-operation $expt-cflonum-bignum	T:cflonum	T:bignum	T:cflonum)

(declare-unsafe-binary-operation $expt-fixnum-flonum	T:fixnum	T:flonum	T:flonum)
(declare-unsafe-binary-operation $expt-bignum-flonum	T:bignum	T:flonum	T:flonum)
(declare-unsafe-binary-operation $expt-flonum-flonum	T:flonum	T:flonum	T:flonum)
(declare-unsafe-binary-operation $expt-ratnum-flonum	T:ratnum	T:flonum	T:flonum)
(declare-unsafe-binary-operation $expt-compnum-flonum	T:compnum	T:flonum	T:flonum)
(declare-unsafe-binary-operation $expt-cflonum-flonum	T:cflonum	T:flonum	T:flonum)

(declare-unsafe-binary-operation $expt-fixnum-ratnum	T:fixnum	T:ratnum	T:exact)
(declare-unsafe-binary-operation $expt-bignum-ratnum	T:bignum	T:ratnum	T:exact)
(declare-unsafe-binary-operation $expt-flonum-ratnum	T:flonum	T:ratnum	T:flonum)
(declare-unsafe-binary-operation $expt-ratnum-ratnum	T:ratnum	T:ratnum	T:exact)
(declare-unsafe-binary-operation $expt-compnum-ratnum	T:compnum	T:ratnum	T:number)
(declare-unsafe-binary-operation $expt-cflonum-ratnum	T:cflonum	T:ratnum	T:cflonum)

(declare-unsafe-binary-operation $expt-fixnum-cflonum	T:fixnum	T:cflonum	T:cflonum)
(declare-unsafe-binary-operation $expt-bignum-cflonum	T:bignum	T:cflonum	T:cflonum)
(declare-unsafe-binary-operation $expt-flonum-cflonum	T:flonum	T:cflonum	T:cflonum)
(declare-unsafe-binary-operation $expt-ratnum-cflonum	T:ratnum	T:cflonum	T:cflonum)
(declare-unsafe-binary-operation $expt-compnum-cflonum	T:compnum	T:cflonum	T:cflonum)
(declare-unsafe-binary-operation $expt-cflonum-cflonum	T:cflonum	T:cflonum	T:cflonum)

(declare-unsafe-binary-operation $expt-fixnum-compnum	T:fixnum	T:compnum	T:number)
(declare-unsafe-binary-operation $expt-bignum-compnum	T:bignum	T:compnum	T:number)
(declare-unsafe-binary-operation $expt-flonum-compnum	T:flonum	T:compnum	T:number)
(declare-unsafe-binary-operation $expt-ratnum-compnum	T:ratnum	T:compnum	T:number)
(declare-unsafe-binary-operation $expt-compnum-compnum	T:compnum	T:compnum	T:number)
(declare-unsafe-binary-operation $expt-cflonum-compnum	T:cflonum	T:compnum	T:number)

;;; --------------------------------------------------------------------

(declare-unsafe-unary-operation $sqrt-fixnum		T:fixnum	T:number)
(declare-unsafe-unary-operation $sqrt-bignum		T:bignum	T:number)
(declare-unsafe-unary-operation $sqrt-flonum		T:flonum	T:inexact)
(declare-unsafe-unary-operation $sqrt-ratnum		T:ratnum	T:number)
(declare-unsafe-unary-operation $sqrt-compnum		T:compnum	T:number)
(declare-unsafe-unary-operation $sqrt-cflonum		T:cflonum	T:cflonum)

(declare-unsafe-unary-operation/2rv $exact-integer-sqrt-fixnum	T:fixnum	T:exact-integer	      T:exact-integer)
(declare-unsafe-unary-operation/2rv $exact-integer-sqrt-bignum	T:bignum	T:exact-integer	      T:exact-integer)

(declare-unsafe-unary-operation $cbrt-fixnum		T:fixnum	T:number)
(declare-unsafe-unary-operation $cbrt-bignum		T:bignum	T:number)
(declare-unsafe-unary-operation $cbrt-flonum		T:flonum	T:inexact)
(declare-unsafe-unary-operation $cbrt-ratnum		T:ratnum	T:number)
(declare-unsafe-unary-operation $cbrt-compnum		T:compnum	T:number)
(declare-unsafe-unary-operation $cbrt-cflonum		T:cflonum	T:cflonum)

(declare-unsafe-unary-operation $log-fixnum		T:fixnum	T:number)
(declare-unsafe-unary-operation $log-bignum		T:bignum	T:inexact)
(declare-unsafe-unary-operation $log-flonum		T:flonum	T:inexact)
(declare-unsafe-unary-operation $log-ratnum		T:ratnum	T:inexact)
(declare-unsafe-unary-operation $log-compnum		T:compnum	T:inexact)
(declare-unsafe-unary-operation $log-cflonum		T:cflonum	T:cflonum)

(declare-unsafe-unary-operation $exp-fixnum		T:fixnum	T:real)
(declare-unsafe-unary-operation $exp-bignum		T:bignum	T:flonum)
(declare-unsafe-unary-operation $exp-flonum		T:flonum	T:flonum)
(declare-unsafe-unary-operation $exp-ratnum		T:ratnum	T:flonum)
(declare-unsafe-unary-operation $exp-compnum		T:compnum	T:cflonum)
(declare-unsafe-unary-operation $exp-cflonum		T:cflonum	T:cflonum)

(declare-unsafe-unary-operation $sin-fixnum		T:fixnum	T:real)
(declare-unsafe-unary-operation $sin-bignum		T:bignum	T:flonum)
(declare-unsafe-unary-operation $sin-flonum		T:flonum	T:flonum)
(declare-unsafe-unary-operation $sin-ratnum		T:ratnum	T:flonum)
(declare-unsafe-unary-operation $sin-compnum		T:compnum	T:cflonum)
(declare-unsafe-unary-operation $sin-cflonum		T:cflonum	T:cflonum)

(declare-unsafe-unary-operation $cos-fixnum		T:fixnum	T:real)
(declare-unsafe-unary-operation $cos-bignum		T:bignum	T:flonum)
(declare-unsafe-unary-operation $cos-flonum		T:flonum	T:flonum)
(declare-unsafe-unary-operation $cos-ratnum		T:ratnum	T:flonum)
(declare-unsafe-unary-operation $cos-compnum		T:compnum	T:cflonum)
(declare-unsafe-unary-operation $cos-cflonum		T:cflonum	T:cflonum)

(declare-unsafe-unary-operation $tan-fixnum		T:fixnum	T:real)
(declare-unsafe-unary-operation $tan-bignum		T:bignum	T:flonum)
(declare-unsafe-unary-operation $tan-flonum		T:flonum	T:flonum)
(declare-unsafe-unary-operation $tan-ratnum		T:ratnum	T:flonum)
(declare-unsafe-unary-operation $tan-compnum		T:compnum	T:cflonum)
(declare-unsafe-unary-operation $tan-cflonum		T:cflonum	T:cflonum)

(declare-unsafe-unary-operation $asin-fixnum		T:fixnum	T:inexact)
(declare-unsafe-unary-operation $asin-bignum		T:bignum	T:inexact)
(declare-unsafe-unary-operation $asin-flonum		T:flonum	T:inexact)
(declare-unsafe-unary-operation $asin-ratnum		T:ratnum	T:inexact)
(declare-unsafe-unary-operation $asin-compnum		T:compnum	T:number)
(declare-unsafe-unary-operation $asin-cflonum		T:cflonum	T:inexact)

(declare-unsafe-unary-operation $acos-fixnum		T:fixnum	T:inexact)
(declare-unsafe-unary-operation $acos-bignum		T:bignum	T:inexact)
(declare-unsafe-unary-operation $acos-flonum		T:flonum	T:inexact)
(declare-unsafe-unary-operation $acos-ratnum		T:ratnum	T:inexact)
(declare-unsafe-unary-operation $acos-compnum		T:compnum	T:number)
(declare-unsafe-unary-operation $acos-cflonum		T:cflonum	T:inexact)

(declare-unsafe-binary-operation $atan2-real-real	T:real		T:real	T:flonum)

(declare-unsafe-unary-operation $atan-fixnum		T:fixnum	T:inexact)
(declare-unsafe-unary-operation $atan-bignum		T:bignum	T:inexact)
(declare-unsafe-unary-operation $atan-flonum		T:flonum	T:inexact)
(declare-unsafe-unary-operation $atan-ratnum		T:ratnum	T:inexact)
(declare-unsafe-unary-operation $atan-compnum		T:compnum	T:number)
(declare-unsafe-unary-operation $atan-cflonum		T:cflonum	T:inexact)

(declare-unsafe-unary-operation $sinh-fixnum		T:fixnum	T:flonum)
(declare-unsafe-unary-operation $sinh-bignum		T:bignum	T:flonum)
(declare-unsafe-unary-operation $sinh-flonum		T:flonum	T:flonum)
(declare-unsafe-unary-operation $sinh-ratnum		T:ratnum	T:flonum)
(declare-unsafe-unary-operation $sinh-compnum		T:compnum	T:number)
(declare-unsafe-unary-operation $sinh-cflonum		T:cflonum	T:cflonum)

(declare-unsafe-unary-operation $cosh-fixnum		T:fixnum	T:flonum)
(declare-unsafe-unary-operation $cosh-bignum		T:bignum	T:flonum)
(declare-unsafe-unary-operation $cosh-flonum		T:flonum	T:flonum)
(declare-unsafe-unary-operation $cosh-ratnum		T:ratnum	T:flonum)
(declare-unsafe-unary-operation $cosh-compnum		T:compnum	T:number)
(declare-unsafe-unary-operation $cosh-cflonum		T:cflonum	T:cflonum)

(declare-unsafe-unary-operation $tanh-fixnum		T:fixnum	T:flonum)
(declare-unsafe-unary-operation $tanh-bignum		T:bignum	T:flonum)
(declare-unsafe-unary-operation $tanh-flonum		T:flonum	T:flonum)
(declare-unsafe-unary-operation $tanh-ratnum		T:ratnum	T:flonum)
(declare-unsafe-unary-operation $tanh-compnum		T:compnum	T:number)
(declare-unsafe-unary-operation $tanh-cflonum		T:cflonum	T:cflonum)

(declare-unsafe-unary-operation $asinh-fixnum		T:fixnum	T:flonum)
(declare-unsafe-unary-operation $asinh-bignum		T:bignum	T:flonum)
(declare-unsafe-unary-operation $asinh-flonum		T:flonum	T:flonum)
(declare-unsafe-unary-operation $asinh-ratnum		T:ratnum	T:flonum)
(declare-unsafe-unary-operation $asinh-compnum		T:compnum	T:number)
(declare-unsafe-unary-operation $asinh-cflonum		T:cflonum	T:cflonum)

(declare-unsafe-unary-operation $acosh-fixnum		T:fixnum	T:flonum)
(declare-unsafe-unary-operation $acosh-bignum		T:bignum	T:flonum)
(declare-unsafe-unary-operation $acosh-flonum		T:flonum	T:flonum)
(declare-unsafe-unary-operation $acosh-ratnum		T:ratnum	T:flonum)
(declare-unsafe-unary-operation $acosh-compnum		T:compnum	T:number)
(declare-unsafe-unary-operation $acosh-cflonum		T:cflonum	T:cflonum)

(declare-unsafe-unary-operation $atanh-fixnum		T:fixnum	T:flonum)
(declare-unsafe-unary-operation $atanh-bignum		T:bignum	T:flonum)
(declare-unsafe-unary-operation $atanh-flonum		T:flonum	T:flonum)
(declare-unsafe-unary-operation $atanh-ratnum		T:ratnum	T:flonum)
(declare-unsafe-unary-operation $atanh-compnum		T:compnum	T:number)
(declare-unsafe-unary-operation $atanh-cflonum		T:cflonum	T:cflonum)

;;; --------------------------------------------------------------------

(declare-unsafe-unary-operation $bitwise-not-fixnum		T:fixnum	T:fixnum)
(declare-unsafe-unary-operation $bitwise-not-bignum		T:bignum	T:bignum)

;;; --------------------------------------------------------------------

(declare-unsafe-binary-operation $bitwise-and-fixnum-number	T:fixnum	T:exact-integer	      T:exact-integer)
(declare-unsafe-binary-operation $bitwise-and-fixnum-fixnum	T:fixnum	T:fixnum	      T:fixnum)
(declare-unsafe-binary-operation $bitwise-and-fixnum-bignum	T:fixnum	T:bignum	      T:exact-integer)

(declare-unsafe-binary-operation $bitwise-and-bignum-number	T:bignum	T:exact-integer	      T:exact-integer)
(declare-unsafe-binary-operation $bitwise-and-bignum-fixnum	T:bignum	T:fixnum	      T:exact-integer)
(declare-unsafe-binary-operation $bitwise-and-bignum-bignum	T:bignum	T:bignum	      T:exact-integer)

;;; --------------------------------------------------------------------

(declare-unsafe-binary-operation $bitwise-ior-fixnum-number	T:fixnum	T:exact-integer	      T:exact-integer)
(declare-unsafe-binary-operation $bitwise-ior-fixnum-fixnum	T:fixnum	T:fixnum	      T:fixnum)
(declare-unsafe-binary-operation $bitwise-ior-fixnum-bignum	T:fixnum	T:bignum	      T:exact-integer)

(declare-unsafe-binary-operation $bitwise-ior-bignum-number	T:bignum	T:exact-integer	      T:exact-integer)
(declare-unsafe-binary-operation $bitwise-ior-bignum-fixnum	T:bignum	T:fixnum	      T:exact-integer)
(declare-unsafe-binary-operation $bitwise-ior-bignum-bignum	T:bignum	T:bignum	      T:exact-integer)

;;; --------------------------------------------------------------------

(declare-unsafe-binary-operation $bitwise-xor-fixnum-number	T:fixnum	T:exact-integer	      T:exact-integer)
(declare-unsafe-binary-operation $bitwise-xor-fixnum-fixnum	T:fixnum	T:fixnum	      T:exact-integer)
(declare-unsafe-binary-operation $bitwise-xor-fixnum-bignum	T:fixnum	T:bignum	      T:exact-integer)

(declare-unsafe-binary-operation $bitwise-xor-bignum-number	T:bignum	T:exact-integer	      T:exact-integer)
(declare-unsafe-binary-operation $bitwise-xor-bignum-fixnum	T:bignum	T:fixnum	      T:exact-integer)
(declare-unsafe-binary-operation $bitwise-xor-bignum-bignum	T:bignum	T:bignum	      T:exact-integer)

;;; --------------------------------------------------------------------

(let-syntax
    ((declare-unsafe-rounding-primitives
       (syntax-rules ()
	 ((_ ?who-fixnum ?who-bignum ?who-flonum ?who-ratnum)
	  (begin
	    (declare-core-primitive ?who-fixnum
		(unsafe)
	      (signatures
	       ((T:fixnum)			=> (T:fixnum)))
	      (attributes
	       ((_)				foldable effect-free result-true identity)))
	    (declare-core-primitive ?who-bignum
		(unsafe)
	      (signatures
	       ((T:bignum)			=> (T:bignum)))
	      (attributes
	       ((_)				foldable effect-free result-true identity)))
	    (declare-core-primitive ?who-flonum
		(unsafe)
	      (signatures
	       ((T:flonum)			=> (T:flonum)))
	      (attributes
	       ((_)				foldable effect-free result-true)))
	    (declare-core-primitive ?who-ratnum
		(unsafe)
	      (signatures
	       ((T:ratnum)			=> (T:exact-integer)))
	      (attributes
	       ((_)				foldable effect-free result-true)))))
	 )))
  (declare-unsafe-rounding-primitives $floor-fixnum $floor-bignum $floor-flonum $floor-ratnum)
  (declare-unsafe-rounding-primitives $ceiling-fixnum $ceiling-bignum $ceiling-flonum $ceiling-ratnum)
  (declare-unsafe-rounding-primitives $truncate-fixnum $truncate-bignum $truncate-flonum $truncate-ratnum)
  (declare-unsafe-rounding-primitives $round-fixnum $round-bignum $round-flonum $round-ratnum)
  #| end of LET-SYNTAX |# )


;;;; system interface and foreign functions

(declare-core-primitive errno
    (safe)
  (signatures
   (()				=> (T:fixnum))
   ((T:fixnum)			=> (T:void)))
  (attributes
   (()			effect-free result-true)
   ((_)			result-true)))

;;; --------------------------------------------------------------------

(declare-core-primitive malloc
    (safe)
  (signatures
   ((T:exact-integer)			=> (T:pointer/false))))

(declare-core-primitive realloc
    (safe)
  (signatures
   ((T:pointer T:exact-integer)		=> (T:pointer/false))))

(declare-core-primitive calloc
    (safe)
  (signatures
   ((T:exact-integer T:exact-integer)	=> (T:pointer/false))))

(declare-core-primitive free
    (safe)
  (signatures
   ((T:pointer/memory-block)		=> (T:void))))

;;; --------------------------------------------------------------------

(declare-core-primitive malloc*
    (safe)
  (signatures
   ((T:exact-integer)		=> (T:pointer))))

(declare-core-primitive realloc*
    (safe)
  (signatures
   ((T:pointer T:exact-integer)	=> (T:pointer))))

(declare-core-primitive calloc*
    (safe)
  (signatures
   ((T:exact-integer T:exact-integer)	=> (T:pointer))))

;;; --------------------------------------------------------------------

(declare-core-primitive guarded-malloc
    (safe)
  (signatures
   ((T:exact-integer)			=> (T:pointer/false))))

(declare-core-primitive guarded-realloc
    (safe)
  (signatures
   ((T:pointer T:exact-integer)		=> (T:pointer/false))))

(declare-core-primitive guarded-calloc
    (safe)
  (signatures
   ((T:exact-integer T:exact-integer)	=> (T:pointer/false))))

;;; --------------------------------------------------------------------

(declare-core-primitive guarded-malloc*
    (safe)
  (signatures
   ((T:exact-integer)		=> (T:pointer))))

(declare-core-primitive guarded-realloc*
    (safe)
  (signatures
   ((T:pointer T:exact-integer)	=> (T:pointer))))

(declare-core-primitive guarded-calloc*
    (safe)
  (signatures
   ((T:exact-integer T:exact-integer)	=> (T:pointer))))


;;; --------------------------------------------------------------------

(declare-core-primitive memcpy
    (safe)
  (signatures
   ((T:pointer T:pointer T:exact-integer)	=> (T:void))))

(declare-core-primitive memmove
    (safe)
  (signatures
   ((T:pointer T:pointer T:exact-integer)	=> (T:void))))

(declare-core-primitive memcmp
    (safe)
  (signatures
   ((T:pointer T:pointer T:exact-integer)	=> (T:fixnum))))

(declare-core-primitive memset
    (safe)
  (signatures
   ((T:pointer T:exact-integer T:exact-integer)	=> (T:void))))

;;; --------------------------------------------------------------------

(declare-core-primitive make-memory-block
    (safe)
  (signatures
   ((T:pointer T:exact-integer)			=> (T:memory-block))))

(declare-core-primitive make-memory-block/guarded
    (safe)
  (signatures
   ((T:pointer T:exact-integer)			=> (T:memory-block))))

(declare-core-primitive null-memory-block
    (safe)
  (signatures
   (()						=> (T:memory-block)))
  (attributes
   (()						effect-free result-true)))

(declare-core-primitive memory-block?
    (safe)
  (signatures
   ((T:memory-block)				=> (T:boolean))
   ((T:object)					=> (T:false)))
  (attributes
   ((_)						effect-free)))

(declare-core-primitive memory-block?/not-null
    (safe)
  (signatures
   ((T:memory-block)			=> (T:boolean))
   ((T:object)				=> (T:false)))
  (attributes
   ((_)					effect-free)))

(declare-core-primitive memory-block?/non-null
    (safe)
  (signatures
   ((T:memory-block)			=> (T:boolean))
   ((T:object)				=> (T:false)))
  (attributes
   ((_)					effect-free)))

(declare-core-primitive memory-block-pointer
    (safe)
  (signatures
   ((T:memory-block)			=> (T:pointer)))
  (attributes
   ((_)					effect-free result-true)))

(declare-core-primitive memory-block-size
    (safe)
  (signatures
   ((T:memory-block)			=> (T:exact-integer)))
  (attributes
   ((_)					effect-free result-true)))

;;; --------------------------------------------------------------------

(declare-core-primitive make-out-of-memory-error
    (safe)
  (signatures
   (()					=> (T:record)))
  (attributes
   (()					effect-free result-true)))

(declare-core-primitive out-of-memory-error?
    (safe)
  (signatures
   ((T:record)				=> (T:boolean))
   ((T:object)				=> (T:false)))
  (attributes
   ((_)					effect-free)))

;;; --------------------------------------------------------------------

(declare-core-primitive memory-copy
    (safe)
  (signatures
   ((T:pointer/bytevector T:fixnum T:pointer/bytevector T:fixnum T:fixnum)	=> (T:void))))

(declare-core-primitive memory->bytevector
    (safe)
  (signatures
   ((T:pointer T:fixnum)		=> (T:bytevector)))
  (attributes
   ((_ _)				effect-free result-true)))

(declare-core-primitive bytevector->memory
    (safe)
  (signatures
   ((T:bytevector)			=> (T:pointer/false T:fixnum/false)))
  (attributes
   ((_ _)				effect-free)))

(declare-core-primitive bytevector->guarded-memory
    (safe)
  (signatures
   ((T:bytevector)			=> (T:pointer/false T:fixnum/false)))
  (attributes
   ((_ _)				effect-free)))

(declare-core-primitive bytevector->memory*
    (safe)
  (signatures
   ((T:bytevector)			=> (T:pointer T:fixnum)))
  (attributes
   ((_ _)				effect-free)))

(declare-core-primitive bytevector->guarded-memory*
    (safe)
  (signatures
   ((T:bytevector)			=> (T:pointer T:fixnum)))
  (attributes
   ((_ _)				effect-free)))


#|


 bytevector->memory
 bytevector->guarded-memory
 bytevector->memory*
 bytevector->guarded-memory*

|#


;;;; debugging helpers

(declare-exact-integer-unary integer->machine-word)
(declare-exact-integer-unary machine-word->integer)

;;; --------------------------------------------------------------------

(declare-core-primitive flonum->bytevector
    (safe)
  (signatures
   ((T:flonum)		=> (T:bytevector)))
  (attributes
   ((_)			foldable effect-free result-true)))

(declare-core-primitive bytevector->flonum
    (safe)
  (signatures
   ((T:flonum)		=> (T:bytevector)))
  (attributes
   ((_)			foldable effect-free result-true)))

;;; --------------------------------------------------------------------

(declare-core-primitive bignum->bytevector
    (safe)
  (signatures
   ((T:bignum)		=> (T:bytevector)))
  (attributes
   ((_)			foldable effect-free result-true)))

(declare-core-primitive bytevector->bignum
    (safe)
  (signatures
   ((T:bytevector)	=> (T:bignum)))
  (attributes
   ((_)			foldable effect-free result-true)))


;;;; done

#| list of core primitives to declare

 sra
 sll
 add1
 sub1
 quotient+remainder
 random

 port-mode
 set-port-mode!
 with-input-from-string
 get-output-string
 with-output-to-string
 console-input-port
 console-error-port
 console-output-port
 stdin
 stdout
 stderr
 reset-input-port!
 reset-output-port!
 printf
 fprintf
 format

 print-graph
 print-unicode
 printer-integer-radix



 call/cf
 print-error
 assembler-output
 optimizer-output
 assembler-property-key
 new-cafe
 waiter-prompt-string
 readline-enabled?
 readline
 make-readline-input-port
 expand-form-to-core-language
 expand-library
 expand-library->sexp
 expand-top-level
 expand-top-level->sexp
;;;
 environment?
 environment-symbols
 environment-libraries
 environment-labels
 environment-binding
;;;
 time-and-gather
 stats?
 stats-user-secs
 stats-user-usecs
 stats-sys-secs
 stats-sys-usecs
 stats-real-secs
 stats-real-usecs
 stats-collection-id
 stats-gc-user-secs
 stats-gc-user-usecs
 stats-gc-sys-secs
 stats-gc-sys-usecs
 stats-gc-real-secs
 stats-gc-real-usecs
 stats-bytes-minor
 stats-bytes-major
 time-it
 verbose-timer
;;;
 current-time
 time-from-now
 time?
 time-second
 time-nanosecond
 time-gmt-offset
 date-string
 make-time
 time-addition
 time-difference
 time=?
 time<?
 time<=?
 time>?
 time>=?
;;;
 set-rtd-printer!
 set-rtd-destructor!
 struct?
 make-struct-type
 struct-type-descriptor?
 struct-type-name
 struct-type-symbol
 struct-type-field-names
 struct-type-destructor
 default-struct-printer
 struct-constructor
 struct-predicate
 struct-field-accessor
 struct-field-mutator
 struct-length
 struct-ref
 struct-set!
 struct-printer
 struct-destructor
 struct-name
 struct-rtd
 struct=?
 struct-reset
 struct-guardian-logger
 struct-guardian-log
 code?
 immediate?
 pointer-value
;;;
 apropos
 current-primitive-locations
 boot-library-expand
 current-library-collection
 library-name
 find-library-by-name

;;; --------------------------------------------------------------------

;;;
 $length
 $map1
 $for-each1
 $for-all1
 $exists1
 $memq
 $memv
;;;

 $make-bytevector
 $bytevector-length
 $bytevector-empty?
 $bytevector-s8-ref
 $bytevector-u8-ref
 $bytevector-set!
 $bytevector-ieee-double-native-ref
 $bytevector-ieee-double-native-set!
 $bytevector-ieee-double-nonnative-ref
 $bytevector-ieee-double-nonnative-set!
 $bytevector-ieee-single-native-ref
 $bytevector-ieee-single-native-set!
 $bytevector-ieee-single-nonnative-ref
 $bytevector-ieee-single-nonnative-set!
 $bytevector=
 $bytevector-total-length
 $bytevector-concatenate
 $bytevector-reverse-and-concatenate
 $bytevector-copy
 $uri-encode
 $uri-decode
 $uri-encoded-bytevector?
 $uri-normalise-encoding
 $octets-encoded-bytevector?
 $ascii-encoded-bytevector?
 $latin1-encoded-bytevector?
 $percent-encode
 $percent-decode
 $percent-encoded-bytevector?
 $percent-normalise-encoding
 $bytevector->base64
 $base64->bytevector
 $ascii->string
 $octets->string
 $latin1->string
 $bytevector->string-base64

;;;
;;;

;;; --------------------------------------------------------------------

  (let ((P (C base-rtd)))
    (register-lambda-signature P (S (list (C <struct-type-descriptor>))
				    '())))

  (let ((P (C $struct)))
    (register-lambda-signature P (S (list (C <struct>))
				    (cons (C <struct-type-descriptor>) (C <list>)))))

  (let ((P (C $make-struct)))
    (register-lambda-signature P (S (list (C <struct>))
				    (list (C <struct-type-descriptor>) (C <fixnum>)))))

  (let ((P (C $struct?)))
    (register-lambda-signature P (S (list (C <boolean>))
				    (list (C <top>)))))

  (let ((P (C $struct/rtd?)))
    (register-lambda-signature P (S (list (C <boolean>))
				    (list (C <top>) (C <struct-type-descriptor>)))))

  (let ((P (C $struct-guardian)))
    (register-lambda-signature P (S (list (C <top>))
				    (list (C <struct>)))))

  (let ((P (C $struct-rtd)))
    (register-lambda-signature P (S (list (C <struct-type-descriptor>))
				    (list (C <struct>)))))

  (let ((P (C $struct-set!)))
    (register-lambda-signature P (S (list (C <void>))
				    (list (C <struct>) (C <fixnum>) (C <top>)))))

  (let ((P (C $struct-ref)))
    (register-lambda-signature P (S (list (C <top>))
				    (list (C <struct>) (C <fixnum>)))))

 $record-guardian

 $std-std
 $std-name
 $std-length
 $std-fields
 $std-printer
 $std-symbol
 $std-destructor

 $set-std-std!
 $set-std-name!
 $set-std-length!
 $set-std-fields!
 $set-std-printer!
 $set-std-symbol!
 $set-std-destructor!

;;; --------------------------------------------------------------------
;;; (ikarus system $pointers)

;;;
 $closure-code
 $code->closure
 $code-reloc-vector
 $code-freevars
 $code-size
 $code-annotation
 $code-ref
 $code-set!
 $set-code-annotation!
 procedure-annotation
 $make-annotated-procedure
 $annotated-procedure-annotation
 $cpref
 $make-tcbucket
 $tcbucket-key
 $tcbucket-val
 $tcbucket-next
 $set-tcbucket-val!
 $set-tcbucket-next!
 $set-tcbucket-tconc!
 $arg-list
 $collect-key
 $$apply
 $fp-at-base
 $primitive-call/cc
 $frame->continuation
 $current-frame
 $seal-frame-and-call
 $make-call-with-values-procedure
 $make-values-procedure
 $interrupted?
 $unset-interrupted!
 $swap-engine-counter!
;;;
 interrupted-condition?
 make-interrupted-condition
 source-position-condition?
 make-source-position-condition
 source-position-port-id
 source-position-byte
 source-position-character
 source-position-line
 source-position-column

 $apply-nonprocedure-error-handler
 $incorrect-args-error-handler
 $multiple-values-error
 $debug
 $do-event
 do-overflow
 do-overflow-words
 do-vararg-overflow
 collect
 collect-key
 post-gc-hooks
 register-to-avoid-collecting
 forget-to-avoid-collecting
 replace-to-avoid-collecting
 retrieve-to-avoid-collecting
 collection-avoidance-list
 purge-collection-avoidance-list
 do-stack-overflow
 make-promise
 make-traced-procedure
 make-traced-macro
 fasl-write
 fasl-read
 syntax-parameter-value
 apply
 assert
 assertion-error
 assertion-violation
 boolean=?
 boolean?

 call-with-current-continuation
 call/cc
 call-with-values
 ;;

 cons
 pair?
 error
 warning
 die
 not
 null?
 procedure?


 string->latin1
 latin1->string
 latin1-encoded-bytevector?
 ascii-encoded-string?
 latin1-encoded-string?
 string->ascii
 string->octets
 octets-encoded-bytevector?
 octets-encoded-string?
 octets->string
 ascii->string
 ascii-encoded-bytevector?
 bytevector->hex
 hex->bytevector
 string-hex->bytevector
 bytevector->string-hex
 bytevector->base64
 base64->bytevector
 string-base64->bytevector
 bytevector->string-base64
 string->uri-encoding
 uri-encoding->string
 string->percent-encoding
 percent-encoding->string
 uri-encode
 uri-decode
 normalise-uri-encoding
 uri-encoded-bytevector?
 uri-encoded-string?
 percent-encoded-bytevector?
 percent-encoded-string?
 percent-encode
 percent-decode
 normalise-percent-encoding
 values
 values->list
;;;
 make-no-infinities-violation
 make-no-nans-violation
 &no-infinities
 no-infinities-violation?
 &no-nans
 no-nans-violation?
 bytevector->sint-list
 bytevector->u8-list
 bytevector->s8-list
 bytevector->u16l-list
 bytevector->u16b-list
 bytevector->u16n-list
 bytevector->s16l-list
 bytevector->s16b-list
 bytevector->s16n-list
 bytevector->u32l-list
 bytevector->u32b-list
 bytevector->u32n-list
 bytevector->s32l-list
 bytevector->s32b-list
 bytevector->s32n-list
 bytevector->u64l-list
 bytevector->u64b-list
 bytevector->u64n-list
 bytevector->s64l-list
 bytevector->s64b-list
 bytevector->s64n-list
 bytevector->uint-list
 bytevector->f4l-list
 bytevector->f4b-list
 bytevector->f4n-list
 bytevector->f8l-list
 bytevector->f8b-list
 bytevector->f8n-list
 bytevector->c4l-list
 bytevector->c4b-list
 bytevector->c4n-list
 bytevector->c8l-list
 bytevector->c8b-list
 bytevector->c8n-list
 bytevector-copy
 bytevector-copy!
 bytevector-fill!
 bytevector-ieee-double-native-ref
 bytevector-ieee-double-native-set!
 bytevector-ieee-double-ref
 bytevector-ieee-double-set!
 bytevector-ieee-single-native-ref
 bytevector-ieee-single-native-set!
 bytevector-ieee-single-ref
 bytevector-ieee-single-set!
 bytevector-length
 bytevector-length?
 bytevector-index?
 bytevector-word-size?
 bytevector-word-count?
 bytevector-index-for-word?
 bytevector-index-for-word8?
 bytevector-index-for-word16?
 bytevector-index-for-word32?
 bytevector-index-for-word64?
 bytevector-start-index-and-count-for-word?
 bytevector-start-index-and-count-for-word8?
 bytevector-start-index-and-count-for-word16?
 bytevector-start-index-and-count-for-word32?
 bytevector-start-index-and-count-for-word64?
 list-of-bytevectors?
 bytevector-empty?
 bytevector-s16-native-ref
 bytevector-s16-native-set!
 bytevector-s16-ref
 bytevector-s16-set!
 bytevector-s32-native-ref
 bytevector-s32-native-set!
 bytevector-s32-ref
 bytevector-s32-set!
 bytevector-s64-native-ref
 bytevector-s64-native-set!
 bytevector-s64-ref
 bytevector-s64-set!
 bytevector-s8-ref
 bytevector-s8-set!
 bytevector-sint-ref
 bytevector-sint-set!
 bytevector-u16-native-ref
 bytevector-u16-native-set!
 bytevector-u16-ref
 bytevector-u16-set!
 bytevector-u32-native-ref
 bytevector-u32-native-set!
 bytevector-u32-ref
 bytevector-u32-set!
 bytevector-u64-native-ref
 bytevector-u64-native-set!
 bytevector-u64-ref
 bytevector-u64-set!
 bytevector-u8-ref
 bytevector-u8-set!
 bytevector-uint-ref
 bytevector-uint-set!
 f4l-list->bytevector
 f4b-list->bytevector
 f4n-list->bytevector
 f8l-list->bytevector
 f8b-list->bytevector
 f8n-list->bytevector
 c4l-list->bytevector
 c4b-list->bytevector
 c4n-list->bytevector
 c8l-list->bytevector
 c8b-list->bytevector
 c8n-list->bytevector
 bytevector=?
 bytevector?
 subbytevector-u8
 subbytevector-u8/count
 subbytevector-s8
 subbytevector-s8/count
 bytevector-append
 bytevector-reverse-and-concatenate
 native-endianness
 sint-list->bytevector
 u8-list->bytevector
 s8-list->bytevector
 u16l-list->bytevector
 u16b-list->bytevector
 u16n-list->bytevector
 s16l-list->bytevector
 s16b-list->bytevector
 s16n-list->bytevector
 u32l-list->bytevector
 u32b-list->bytevector
 u32n-list->bytevector
 s32l-list->bytevector
 s32b-list->bytevector
 s32n-list->bytevector
 u64l-list->bytevector
 u64b-list->bytevector
 u64n-list->bytevector
 s64l-list->bytevector
 s64b-list->bytevector
 s64n-list->bytevector
 uint-list->bytevector
 utf8->string
 utf16->string
 utf16le->string
 utf16n->string
 utf16be->string
 utf32->string
 print-condition
 condition?
 &assertion
 assertion-violation?
 &condition
 condition
 condition-accessor
 condition-irritants
 condition-message
 condition-predicate
 condition-who
 define-condition-type
 &error
 error?
 &implementation-restriction
 implementation-restriction-violation?
 &irritants
 irritants-condition?
 &lexical
 lexical-violation?
 make-assertion-violation
 make-error
 make-implementation-restriction-violation
 make-irritants-condition
 make-lexical-violation
 make-message-condition
 make-non-continuable-violation
 make-serious-condition
 make-syntax-violation
 make-undefined-violation
 make-violation
 make-warning
 make-who-condition
 &message
 message-condition?
 &non-continuable
 non-continuable-violation?
 &serious
 serious-condition?
 simple-conditions
 &syntax
 syntax-violation-form
 syntax-violation-subform
 syntax-violation?
 &undefined
 undefined-violation?
 &violation
 violation?
 &warning
 warning?
 &who
 who-condition?
 case-lambda
 do
 unless
 when
 define-enumeration
 enum-set->list
 enum-set-complement
 enum-set-constructor
 enum-set-difference
 enum-set-indexer
 enum-set-intersection
 enum-set-member?
 enum-set-projection
 enum-set-subset?
 enum-set-union
 enum-set-universe
 enum-set=?
 make-enumeration
 enum-set?
 environment
 eval
 raise
 raise-continuable
 with-exception-handler
 guard
 binary-port?
 buffer-mode
 buffer-mode?
 bytevector->string
 call-with-bytevector-output-port
 call-with-port
 call-with-string-output-port

 delay
 force
 null-environment
 promise?
 scheme-report-environment
 interaction-environment
 new-interaction-environment
 close-port
 eol-style
 error-handling-mode
 file-options
 flush-output-port
 get-bytevector-all
 get-bytevector-n
 get-bytevector-n!
 get-bytevector-some
 get-char
 get-datum
 get-line
 read-line
 get-string-all
 get-string-n
 get-string-n!
 get-string-some
 get-u8
 &i/o
 &i/o-decoding
 i/o-decoding-error?
 &i/o-encoding
 i/o-encoding-error-char
 i/o-encoding-error?
 i/o-error-filename
 i/o-error-port
 i/o-error-position
 i/o-error?
 &i/o-file-already-exists
 i/o-file-already-exists-error?
 &i/o-file-does-not-exist
 i/o-file-does-not-exist-error?
 &i/o-file-is-read-only
 i/o-file-is-read-only-error?
 &i/o-file-protection
 i/o-file-protection-error?
 &i/o-filename
 i/o-filename-error?
 &i/o-invalid-position
 i/o-invalid-position-error?
 &i/o-port
 i/o-port-error?
 &i/o-read
 i/o-read-error?
 &i/o-write
 i/o-write-error?
 &i/o-eagain
 i/o-eagain-error?
 &errno
 errno-condition?
 &h_errno
 h_errno-condition?
 &procedure-argument-violation
 procedure-argument-violation?
 &expression-return-value-violation
 expression-return-value-violation?
 lookahead-char
 lookahead-u8
 lookahead-two-u8
 make-bytevector
 make-custom-binary-input-port
 make-custom-binary-output-port
 make-custom-textual-input-port
 make-custom-textual-output-port
 make-custom-binary-input/output-port
 make-custom-textual-input/output-port
 make-binary-file-descriptor-input-port
 make-binary-file-descriptor-input-port*
 make-binary-file-descriptor-output-port
 make-binary-file-descriptor-output-port*
 make-binary-file-descriptor-input/output-port
 make-binary-file-descriptor-input/output-port*
 make-binary-socket-input-port
 make-binary-socket-input-port*
 make-binary-socket-output-port
 make-binary-socket-output-port*
 make-binary-socket-input/output-port
 make-binary-socket-input/output-port*
 make-textual-file-descriptor-input-port
 make-textual-file-descriptor-input-port*
 make-textual-file-descriptor-output-port
 make-textual-file-descriptor-output-port*
 make-textual-file-descriptor-input/output-port
 make-textual-file-descriptor-input/output-port*
 make-textual-socket-input-port
 make-textual-socket-input-port*
 make-textual-socket-output-port
 make-textual-socket-output-port*
 make-textual-socket-input/output-port
 make-textual-socket-input/output-port*
 make-i/o-decoding-error
 make-i/o-encoding-error
 make-i/o-error
 make-i/o-file-already-exists-error
 make-i/o-file-does-not-exist-error
 make-i/o-file-is-read-only-error
 make-i/o-file-protection-error
 make-i/o-filename-error
 make-i/o-invalid-position-error
 make-i/o-port-error
 make-i/o-read-error
 make-i/o-write-error
 make-i/o-eagain
 make-errno-condition
 condition-errno
 make-h_errno-condition
 condition-h_errno
 make-procedure-argument-violation
 procedure-argument-violation
 make-expression-return-value-violation
 expression-return-value-violation
 latin-1-codec
 make-transcoder
 native-eol-style
 native-transcoder
 transcoder?
 open-bytevector-input-port
 open-bytevector-output-port
 open-file-input-port
 open-file-input/output-port
 open-file-output-port
 open-string-input-port
 open-string-output-port
 bytevector-port-buffer-size
 string-port-buffer-size
 input-file-buffer-size
 output-file-buffer-size
 input/output-file-buffer-size
 input/output-socket-buffer-size
 output-port-buffer-mode
 set-port-buffer-mode!
 port-eof?
 port-has-port-position?
 port-has-set-port-position!?
 port-position
 get-char-and-track-textual-position
 port-textual-position
 port-transcoder
 port?
 put-bytevector
 put-char
 put-datum
 put-string
 put-u8
 set-port-position!
 standard-error-port
 standard-input-port
 standard-output-port
 textual-port?
 transcoded-port
 transcoder-codec
 transcoder-eol-style
 transcoder-error-handling-mode
 utf-8-codec
 utf-16-codec
 utf-16le-codec
 utf-16be-codec
 utf-16n-codec
 utf-bom-codec
 would-block-object
 would-block-object?
 input-port?
 output-port?
 input/output-port?
 binary-input-port?
 textual-input-port?
 binary-output-port?
 textual-output-port?
 binary-input/output-port?
 textual-input/output-port?
 current-input-port
 current-output-port
 current-error-port
 eof-object
 eof-object?
 close-input-port
 close-output-port
 display
 newline
 open-input-file
 open-output-file
 peek-char

  (let ((P (C read)))
    (register-lambda-signature P (make-clambda-compound (list (S (list (C <top>)) '())
							      (S (list (C <top>))
								 (list (C <textual-input-port>)))))))

 read-char

  (let ((P (C write)))
    (register-lambda-signature P (make-clambda-compound (list (S (list (C <top>)) (list (C <top>)))
							      (S (list (C <top>)) (list (C <top>) (C <textual-input-port>)))))))

 write-char
 call-with-input-file
 call-with-output-file
 list-sort
 file-exists?
 directory-exists?
 delete-file

;;; --------------------------------------------------------------------

 record-field-mutable?
 record-rtd
 record-type-field-names
 record-type-generative?
 record-type-name
 record-type-opaque?
 record-type-parent
 record-type-sealed?
 record-type-uid
 record?
 make-record-constructor-descriptor
 make-record-type-descriptor
 record-constructor

  (let ((P (C record-predicate)))
    (register-lambda-signature P (S (list (C <predicate>))
				    (list (C <record-type-descriptor>)))))

 record-type-descriptor?
 record-destructor-set!
 record-destructor
 record-guardian-logger
 record-guardian-log
 record-reset
 record-and-rtd?
 record-accessor
 record-mutator
 unsafe-record-accessor
 unsafe-record-mutator

;;; --------------------------------------------------------------------

 syntax-violation
 bound-identifier=?
 datum->syntax
 syntax->datum
 free-identifier=?
 generate-temporaries
 identifier?
 identifier-bound?
 make-variable-transformer
 variable-transformer?
 variable-transformer-procedure
 make-synonym-transformer
 synonym-transformer?
 synonym-transformer-identifier
 make-compile-time-value
 compile-time-value?
 compile-time-value-object
 syntactic-binding-putprop
 syntactic-binding-getprop
 syntactic-binding-remprop
 syntactic-binding-property-list
 syntax-object?
 syntax-object-expression
 syntax-object-marks
 syntax-object-ribs
 syntax-object-source-objects
 load
 void
 eval-core
 current-core-eval
 pretty-print
 pretty-print*
 debug-print
 debug-print-enabled?
 debug-print*
 pretty-format
 pretty-width
 library
 $transcoder->data
 $data->transcoder
 make-file-options
;;;
 set-identifier-unsafe-variant!
;;;
 set-predicate-procedure-argument-validation!
 set-predicate-return-value-validation!
;;;
 push-compensation
 run-compensations
 compensations
 run-compensations-store
 push-compensation-thunk
;;;
 port-id
 port-uid
 port-fd
 port-set-non-blocking-mode!
 port-unset-non-blocking-mode!
 port-in-non-blocking-mode?
 port-putprop
 port-getprop
 port-remprop
 port-property-list
 string->filename-func
 filename->string-func
 string->pathname-func
 pathname->string-func
 port-dump-status
 port-closed?
;;; (ikarus system $io)
 $make-port
 $port-tag
 $port-id
 $port-cookie
 $port-transcoder
 $port-index
 $port-size
 $port-buffer
 $port-get-position
 $port-set-position!
 $port-close
 $port-read!
 $port-write!
 $set-port-index!
 $set-port-size!
 $port-attrs
 $set-port-attrs!
;;;
 get-annotated-datum
 annotation?
 annotation-expression
 annotation-source
 annotation-stripped
 annotation-textual-position


;;; --------------------------------------------------------------------
;;; configuration options

 vicare-built-with-ffi-enabled
 vicare-built-with-iconv-enabled
 vicare-built-with-posix-enabled
 vicare-built-with-glibc-enabled
 vicare-built-with-linux-enabled
 vicare-built-with-srfi-enabled

 vicare-built-with-arguments-validation-enabled

;;; --------------------------------------------------------------------
;;; POSIX functions

 strerror
 errno->string
 getenv
 environ
 mkdir
 mkdir/parents
 real-pathname
 file-pathname?
 file-string-pathname?
 file-bytevector-pathname?
 file-absolute-pathname?
 file-relative-pathname?
 file-colon-search-path?
 file-string-colon-search-path?
 file-bytevector-colon-search-path?
 file-modification-time
 split-pathname-root-and-tail
 search-file-in-environment-path
 search-file-in-list-path
 split-pathname
 split-pathname-bytevector
 split-pathname-string
 split-search-path
 split-search-path-bytevector
 split-search-path-string
 vicare-argv0
 vicare-argv0-string

;;; --------------------------------------------------------------------
;;; environment inquiry

 uname
 utsname?
 utsname-sysname
 utsname-nodename
 utsname-release
 utsname-version
 utsname-machine

 implementation-name
 implementation-version
 cpu-architecture
 machine-name
 os-name
 os-version

 host-info

;;;
 bytevector->cstring
 bytevector->guarded-cstring
 cstring->bytevector
 cstring16->bytevector
 cstring16n->string
 cstring16le->string
 cstring16be->string
 string->cstring
 string->guarded-cstring
 bytevector->cstring*
 bytevector->guarded-cstring*
 cstring->bytevector*
 string->cstring*
 string->guarded-cstring*
 cstring->string
 strlen
 strcmp
 strncmp
 strdup
 strndup
 guarded-strdup
 guarded-strndup
 strdup*
 strndup*
 guarded-strdup*
 guarded-strndup*

 argv->bytevectors
 argv-length
 argv->strings
 bytevectors->argv
 bytevectors->argv*
 bytevectors->guarded-argv
 bytevectors->guarded-argv*
 strings->argv
 strings->argv*
 strings->guarded-argv
 strings->guarded-argv*

;;;
 pointer-ref-c-uint8
 pointer-ref-c-sint8
 pointer-ref-c-uint16
 pointer-ref-c-sint16
 pointer-ref-c-uint32
 pointer-ref-c-sint32
 pointer-ref-c-uint64
 pointer-ref-c-sint64
;;;
 pointer-ref-c-signed-char
 pointer-ref-c-signed-short
 pointer-ref-c-signed-int
 pointer-ref-c-signed-long
 pointer-ref-c-signed-long-long
 pointer-ref-c-unsigned-char
 pointer-ref-c-unsigned-short
 pointer-ref-c-unsigned-int
 pointer-ref-c-unsigned-long
 pointer-ref-c-unsigned-long-long
;;;
 pointer-ref-c-float
 pointer-ref-c-double
 pointer-ref-c-pointer
;;;
 pointer-ref-c-size_t
 pointer-ref-c-ssize_t
 pointer-ref-c-off_t
 pointer-ref-c-ptrdiff_t
;;;
 pointer-set-c-uint8!
 pointer-set-c-sint8!
 pointer-set-c-uint16!
 pointer-set-c-sint16!
 pointer-set-c-uint32!
 pointer-set-c-sint32!
 pointer-set-c-uint64!
 pointer-set-c-sint64!
;;;
 pointer-set-c-signed-char!
 pointer-set-c-signed-short!
 pointer-set-c-signed-int!
 pointer-set-c-signed-long!
 pointer-set-c-signed-long-long!
 pointer-set-c-unsigned-char!
 pointer-set-c-unsigned-short!
 pointer-set-c-unsigned-int!
 pointer-set-c-unsigned-long!
 pointer-set-c-unsigned-long-long!
;;;
 pointer-set-c-float!
 pointer-set-c-double!
 pointer-set-c-pointer!
;;;
 pointer-set-c-size_t!
 pointer-set-c-ssize_t!
 pointer-set-c-off_t!
 pointer-set-c-ptrdiff_t!
;;;
 array-ref-c-uint8
 array-ref-c-sint8
 array-ref-c-uint16
 array-ref-c-sint16
 array-ref-c-uint32
 array-ref-c-sint32
 array-ref-c-uint64
 array-ref-c-sint64
;;;
 array-ref-c-signed-char
 array-ref-c-unsigned-char
 array-ref-c-signed-short
 array-ref-c-unsigned-short
 array-ref-c-signed-int
 array-ref-c-unsigned-int
 array-ref-c-signed-long
 array-ref-c-unsigned-long
 array-ref-c-signed-long-long
 array-ref-c-unsigned-long-long
;;;
 array-ref-c-float
 array-ref-c-double
 array-ref-c-pointer
;;;
 array-ref-c-size_t
 array-ref-c-ssize_t
 array-ref-c-off_t
 array-ref-c-ptrdiff_t
;;;
 array-set-c-uint8!
 array-set-c-sint8!
 array-set-c-uint16!
 array-set-c-sint16!
 array-set-c-uint32!
 array-set-c-sint32!
 array-set-c-uint64!
 array-set-c-sint64!
;;;
 array-set-c-signed-char!
 array-set-c-unsigned-char!
 array-set-c-signed-short!
 array-set-c-unsigned-short!
 array-set-c-signed-int!
 array-set-c-unsigned-int!
 array-set-c-signed-long!
 array-set-c-unsigned-long!
 array-set-c-signed-long-long!
 array-set-c-unsigned-long-long!
;;;
 array-set-c-float!
 array-set-c-double!
 array-set-c-pointer!
;;;
 array-set-c-size_t!
 array-set-c-ssize_t!
 array-set-c-off_t!
 array-set-c-ptrdiff_t!
;;;
 dlopen
 dlerror
 dlclose
 dlsym
;;;
 make-c-callout-maker
 make-c-callout-maker/with-errno
 make-c-callback-maker
 free-c-callback

;;; --------------------------------------------------------------------
;;; syntax utilities

 identifier->string
 string->identifier
 identifier-prefix
 identifier-suffix
 identifier-append
 identifier-format
 duplicate-identifiers?
 delete-duplicate-identifiers
 identifier-memq

 identifier-record-constructor
 identifier-record-predicate
 identifier-record-field-accessor
 identifier-record-field-mutator

 identifier-struct-constructor
 identifier-struct-predicate
 identifier-struct-field-accessor
 identifier-struct-field-mutator

 syntax-car
 syntax-cdr
 syntax->list
 identifiers->list
 all-identifiers?

 syntax->vector
 syntax-unwrap
 syntax=?
 identifier=symbol?
 #;quoted-syntax-object?

 syntax-clauses-unwrap
 syntax-clauses-filter
 syntax-clauses-remove
 syntax-clauses-partition
 syntax-clauses-collapse
 syntax-clauses-verify-at-least-once
 syntax-clauses-verify-at-most-once
 syntax-clauses-verify-exactly-once
 syntax-clauses-verify-mutually-inclusive
 syntax-clauses-verify-mutually-exclusive

    clause specification structs
 make-syntax-clause-spec
 syntax-clause-spec?
 syntax-clause-spec-keyword
 syntax-clause-spec-min-number-of-occurrences
 syntax-clause-spec-max-number-of-occurrences
 syntax-clause-spec-min-number-of-arguments
 syntax-clause-spec-max-number-of-arguments
 syntax-clause-spec-mutually-inclusive
 syntax-clause-spec-mutually-exclusive
 syntax-clause-spec-custom-data
 syntax-clauses-single-spec
 syntax-clauses-fold-specs
 syntax-clauses-validate-specs

;;; --------------------------------------------------------------------
;;; library names

 library-name?
 library-version-numbers?
 library-version-number?
 library-name-decompose
 library-name->identifiers
 library-name->version
 library-name-identifiers=?
 library-name=?
 library-name<?
 library-name<=?
 library-version=?
 library-version<?
 library-version<=?

;;; --------------------------------------------------------------------
;;; library references and conformity

 library-reference?
 library-version-reference?
 library-sub-version-reference?
 library-sub-version?
 library-reference-decompose
 library-reference->identifiers
 library-reference->version-reference
 library-reference-identifiers=?
 conforming-sub-version-and-sub-version-reference?
 conforming-version-and-version-reference?
 conforming-library-name-and-library-reference?

;;; --------------------------------------------------------------------
;;; library infrastructure

 library?
 library-uid
 library-imp-lib*
 library-vis-lib*
 library-inv-lib*
 library-export-subst
 library-export-env
 library-visit-state
 library-invoke-state
 library-visit-code
 library-invoke-code
 library-guard-code
 library-guard-lib*
 library-visible?
 library-source-file-name
 library-option*

 library-path
 library-extensions
 fasl-directory
 fasl-search-path
 fasl-path
 fasl-stem+extension

 current-library-locator
 run-time-library-locator
 compile-time-library-locator
 source-library-locator
 current-source-library-file-locator
 current-binary-library-file-locator
 default-source-library-file-locator
 default-binary-library-file-locator
 installed-libraries
 uninstall-library

;;; --------------------------------------------------------------------


 tagged-identifier-syntax?
 list-of-tagged-bindings?
 tagged-lambda-proto-syntax?
 tagged-formals-syntax?
 standard-formals-syntax?
 formals-signature-syntax?
 retvals-signature-syntax?
 parse-tagged-identifier-syntax
 parse-list-of-tagged-bindings
 parse-tagged-lambda-proto-syntax
 parse-tagged-formals-syntax

 make-clambda-compound
 clambda-compound?
 clambda-compound-common-retvals-signature
 clambda-compound-lambda-signatures

 make-lambda-signature
 lambda-signature?
 lambda-signature-formals
 lambda-signature-retvals
 lambda-signature-formals-tags
 lambda-signature-retvals-tags
 lambda-signature=?

 make-formals-signature
 formals-signature?
 formals-signature-tags
 formals-signature=?

 make-retvals-signature
 retvals-signature?
 retvals-signature-tags
 retvals-signature=?
 retvals-signature-common-ancestor

 tag-identifier?
 all-tag-identifiers?
 tag-identifier-callable-signature
 tag-super-and-sub?
 tag-identifier-ancestry
 tag-common-ancestor
 formals-signature-super-and-sub-syntax?

 set-identifier-object-type-spec!
 identifier-object-type-spec
 set-label-object-type-spec!
 label-object-type-spec
 make-object-type-spec
 object-type-spec?
 object-type-spec-uids
 object-type-spec-type-id
 object-type-spec-parent-spec
 object-type-spec-pred-stx
 object-type-spec-constructor-maker
 object-type-spec-accessor-maker
 object-type-spec-mutator-maker
 object-type-spec-getter-maker
 object-type-spec-setter-maker
 object-type-spec-dispatcher
 object-type-spec-ancestry

 tagged-identifier?
 set-identifier-tag!
 identifier-tag
 set-label-tag!
 label-tag

 expand-time-retvals-signature-violation?
 expand-time-retvals-signature-violation-expected-signature
 expand-time-retvals-signature-violation-returned-signature

 top-tag-id
 void-tag-id
 procedure-tag-id
 list-tag-id
 boolean-tag-id

|#

;;; end of file
;; Local Variables:
;; mode: vicare
;; eval: (put 'declare-core-primitive		'scheme-indent-function 2)
;; eval: (put 'declare-pair-accessor		'scheme-indent-function 1)
;; eval: (put 'declare-pair-mutator		'scheme-indent-function 1)
;; eval: (put 'declare-number-unary		'scheme-indent-function 1)
;; eval: (put 'declare-number-binary		'scheme-indent-function 1)
;; eval: (put 'declare-number-unary/binary	'scheme-indent-function 1)
;; eval: (put 'declare-number-binary/multi-comparison	'scheme-indent-function 1)
;; End:
