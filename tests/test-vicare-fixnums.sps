;;; -*- coding: utf-8-unix -*-
;;;
;;;Part of: Vicare Scheme
;;;Contents: tests for fixnum functions
;;;Date: Thu Nov 22, 2012
;;;
;;;Abstract
;;;
;;;
;;;
;;;Copyright (C) 2012-2015 Marco Maggi <marco.maggi-ipsu@poste.it>
;;;
;;;This program is free software:  you can redistribute it and/or modify
;;;it under the terms of the  GNU General Public License as published by
;;;the Free Software Foundation, either version 3 of the License, or (at
;;;your option) any later version.
;;;
;;;This program is  distributed in the hope that it  will be useful, but
;;;WITHOUT  ANY   WARRANTY;  without   even  the  implied   warranty  of
;;;MERCHANTABILITY or  FITNESS FOR  A PARTICULAR  PURPOSE.  See  the GNU
;;;General Public License for more details.
;;;
;;;You should  have received a  copy of  the GNU General  Public License
;;;along with this program.  If not, see <http://www.gnu.org/licenses/>.
;;;


#!vicare
(import (vicare)
  (vicare system $fx)
  (only (vicare platform words)
	case-word-size)
  (vicare checks))

(check-set-mode! 'report-failed)
(check-display "*** testing Vicare fixnum functions and operations\n")


(parametrise ((check-test-name	'core))

  (when #t
    (fprintf (current-error-port)
	     "fixnum width=~a\nleast fixnum=~a\ngreatest fixnum=~a\n"
	     (fixnum-width)
	     (least-fixnum)
	     (greatest-fixnum)))

  (check
      (least-fixnum)
    => (case-word-size
	((32)	-536870912)
	((64)	-1152921504606846976)))

  (check
      (greatest-fixnum)
    => (case-word-size
	((32)	+536870911)
	((64)	+1152921504606846975)))

  (check
      (fixnum-width)
    => (case-word-size
	((32)	30)
	((64)	61)))

  #t)


(parametrise ((check-test-name	'compar))

  (check-for-true	(fx!=? 1 2))
  (check-for-false	(fx!=? 1 1))

  (check-for-true	(fx!= 1 2))
  (check-for-false	(fx!= 1 1))

  #t)


(parametrise ((check-test-name	'mod))

  (check (fxmod +12 +12)	=> 0)
  (check (fxmod +12 -12)	=> 0)
  (check (fxmod -12 +12)	=> 0)
  (check (fxmod -12 -12)	=> 0)

  (check (fxmod +12 +3)		=> 0)
  (check (fxmod +12 -3)		=> 0)
  (check (fxmod -12 +3)		=> 0)
  (check (fxmod -12 -3)		=> 0)

  (check (fxmod +12 +4)		=> 0)
  (check (fxmod +12 -4)		=> 0)
  (check (fxmod -12 +4)		=> 0)
  (check (fxmod -12 -4)		=> 0)

  (check (fxmod +12 +5)		=> +2)
  (check (fxmod +12 -5)		=> +2)
  (check (fxmod -12 +5)		=> +3)
  (check (fxmod -12 -5)		=> +3)

  (check (fxmod +12 +7)		=> +5)
  (check (fxmod +12 -7)		=> +5)
  (check (fxmod -12 +7)		=> +2)
  (check (fxmod -12 -7)		=> +2)

  (check (fxmod +12 +24)	=> +12)
  (check (fxmod +12 -24)	=> +12)
  (check (fxmod -12 +24)	=> +12)
  (check (fxmod -12 -24)	=> +12)

  (check (fxmod +12 +20)	=> +12)
  (check (fxmod +12 -20)	=> +12)
  (check (fxmod -12 +20)	=> +8)
  (check (fxmod -12 -20)	=> +8)

;;; --------------------------------------------------------------------

  (check ($fxmod +12 +12)	=> 0)
  (check ($fxmod +12 -12)	=> 0)
  (check ($fxmod -12 +12)	=> 0)
  (check ($fxmod -12 -12)	=> 0)

  (check ($fxmod +12 +3)	=> 0)
  (check ($fxmod +12 -3)	=> 0)
  (check ($fxmod -12 +3)	=> 0)
  (check ($fxmod -12 -3)	=> 0)

  (check ($fxmod +12 +4)	=> 0)
  (check ($fxmod +12 -4)	=> 0)
  (check ($fxmod -12 +4)	=> 0)
  (check ($fxmod -12 -4)	=> 0)

  (check ($fxmod +12 +5)	=> +2)
  (check ($fxmod +12 -5)	=> +2)
  (check ($fxmod -12 +5)	=> +3)
  (check ($fxmod -12 -5)	=> +3)

  (check ($fxmod +12 +7)	=> +5)
  (check ($fxmod +12 -7)	=> +5)
  (check ($fxmod -12 +7)	=> +2)
  (check ($fxmod -12 -7)	=> +2)

  (check ($fxmod +12 +24)	=> +12)
  (check ($fxmod +12 -24)	=> +12)
  (check ($fxmod -12 +24)	=> +12)
  (check ($fxmod -12 -24)	=> +12)

  (check ($fxmod +12 +20)	=> +12)
  (check ($fxmod +12 -20)	=> +12)
  (check ($fxmod -12 +20)	=> +8)
  (check ($fxmod -12 -20)	=> +8)

  #t)


(parametrise ((check-test-name	'modulo))

  (check (fxmodulo +12 +12)	=> 0)
  (check (fxmodulo +12 -12)	=> 0)
  (check (fxmodulo -12 +12)	=> 0)
  (check (fxmodulo -12 -12)	=> 0)

  (check (fxmodulo +12 +3)	=> 0)
  (check (fxmodulo +12 -3)	=> 0)
  (check (fxmodulo -12 +3)	=> 0)
  (check (fxmodulo -12 -3)	=> 0)

  (check (fxmodulo +12 +4)	=> 0)
  (check (fxmodulo +12 -4)	=> 0)
  (check (fxmodulo -12 +4)	=> 0)
  (check (fxmodulo -12 -4)	=> 0)

  (check (fxmodulo +12 +5)	=> +2)
  (check (fxmodulo +12 -5)	=> -3)
  (check (fxmodulo -12 +5)	=> +3)
  (check (fxmodulo -12 -5)	=> -2)

  (check (fxmodulo +12 +7)	=> +5)
  (check (fxmodulo +12 -7)	=> -2)
  (check (fxmodulo -12 +7)	=> +2)
  (check (fxmodulo -12 -7)	=> -5)

  (check (fxmodulo +12 +24)	=> +12)
  (check (fxmodulo +12 -24)	=> -12)
  (check (fxmodulo -12 +24)	=> +12)
  (check (fxmodulo -12 -24)	=> -12)

  (check (fxmodulo +12 +20)	=> +12)
  (check (fxmodulo +12 -20)	=> -8)
  (check (fxmodulo -12 +20)	=> +8)
  (check (fxmodulo -12 -20)	=> -12)

;;; --------------------------------------------------------------------

  (check ($fxmodulo +12 +12)	=> 0)
  (check ($fxmodulo +12 -12)	=> 0)
  (check ($fxmodulo -12 +12)	=> 0)
  (check ($fxmodulo -12 -12)	=> 0)

  (check ($fxmodulo +12 +3)	=> 0)
  (check ($fxmodulo +12 -3)	=> 0)
  (check ($fxmodulo -12 +3)	=> 0)
  (check ($fxmodulo -12 -3)	=> 0)

  (check ($fxmodulo +12 +4)	=> 0)
  (check ($fxmodulo +12 -4)	=> 0)
  (check ($fxmodulo -12 +4)	=> 0)
  (check ($fxmodulo -12 -4)	=> 0)

  (check ($fxmodulo +12 +5)	=> +2)
  (check ($fxmodulo +12 -5)	=> -3)
  (check ($fxmodulo -12 +5)	=> +3)
  (check ($fxmodulo -12 -5)	=> -2)

  (check ($fxmodulo +12 +7)	=> +5)
  (check ($fxmodulo +12 -7)	=> -2)
  (check ($fxmodulo -12 +7)	=> +2)
  (check ($fxmodulo -12 -7)	=> -5)

  (check ($fxmodulo +12 +24)	=> +12)
  (check ($fxmodulo +12 -24)	=> -12)
  (check ($fxmodulo -12 +24)	=> +12)
  (check ($fxmodulo -12 -24)	=> -12)

  (check ($fxmodulo +12 +20)	=> +12)
  (check ($fxmodulo +12 -20)	=> -8)
  (check ($fxmodulo -12 +20)	=> +8)
  (check ($fxmodulo -12 -20)	=> -12)

;;; --------------------------------------------------------------------

  (check (fxquotient  13 4)	=>  3)
  (check (fxmodulo    13 4)	=>  1)
  (check (fxremainder 13 4)	=>  1)

  (check (fxquotient  -13 4)	=>  -3)
  (check (fxmodulo    -13 4)	=>  3)
  (check (fxremainder -13 4)	=>  -1)

  (check (fxquotient  13 -4)	=>  -3)
  (check (fxmodulo    13 -4)	=>  -3)
  (check (fxremainder 13 -4)	=>  1)

  (check (fxquotient  -13 -4)	=>  3)
  (check (fxmodulo    -13 -4)	=>  -1)
  (check (fxremainder -13 -4)	=>  -1)

  (check-for-true (= +13 (+ (* +4 (fxquotient  +13 +4)) (fxremainder +13 +4))))
  (check-for-true (= +13 (+ (* -4 (fxquotient  +13 -4)) (fxremainder +13 -4))))
  (check-for-true (= -13 (+ (* +4 (fxquotient  -13 +4)) (fxremainder -13 +4))))
  (check-for-true (= -13 (+ (* -4 (fxquotient  -13 -4)) (fxremainder -13 -4))))

  #t)


(parametrise ((check-test-name	'conversion))

  (check (fixnum->char 65)	=> #\A)
  (check (fixnum->char 66)	=> #\B)

  (check (char->fixnum #\A)	=> 65)
  (check (char->fixnum #\B)	=> 66)

  (check (fixnum->string 65)	=> "65")
  (check (fixnum->string 66)	=> "66")

  #t)


(parametrise ((check-test-name	'predicates))

  (check (fxnonpositive? 0)		=> #t)
  (check (fxnonpositive? +123)		=> #f)
  (check (fxnonpositive? -123)		=> #t)

  (check (fxnonnegative? 0)		=> #t)
  (check (fxnonnegative? +123)		=> #t)
  (check (fxnonnegative? -123)		=> #f)

;;; --------------------------------------------------------------------

  (check-for-true  (non-zero-fixnum? +1))
  (check-for-true  (non-zero-fixnum? -1))
  (check-for-false (non-zero-fixnum? 0))
  (check-for-false (non-zero-fixnum? "ciao"))

  (check-for-true  (positive-fixnum? +123))
  (check-for-false (positive-fixnum? 0))
  (check-for-false (positive-fixnum? -123))
  (check-for-false (positive-fixnum? "ciao"))

  (check-for-true  (negative-fixnum? -123))
  (check-for-false (negative-fixnum? 0))
  (check-for-false (negative-fixnum? +123))
  (check-for-false (negative-fixnum? "ciao"))

  (check-for-true  (non-positive-fixnum? 0))
  (check-for-true  (non-positive-fixnum? -123))
  (check-for-false (non-positive-fixnum? +123))
  (check-for-false (non-positive-fixnum? "ciao"))

  (check-for-true  (non-negative-fixnum? 0))
  (check-for-true  (non-negative-fixnum? +123))
  (check-for-false (non-negative-fixnum? -123))
  (check-for-false (non-negative-fixnum? "ciao"))

;;; --------------------------------------------------------------------

  (check ($fxpositive? 0)		=> #f)
  (check ($fxpositive? +123)		=> #t)
  (check ($fxpositive? -123)		=> #f)

  (check ($fxnegative? 0)		=> #f)
  (check ($fxnegative? +123)		=> #f)
  (check ($fxnegative? -123)		=> #t)

  (check ($fxnonpositive? 0)		=> #t)
  (check ($fxnonpositive? +123)		=> #f)
  (check ($fxnonpositive? -123)		=> #t)

  (check ($fxnonnegative? 0)		=> #t)
  (check ($fxnonnegative? +123)		=> #t)
  (check ($fxnonnegative? -123)		=> #f)

  #t)


(parametrise ((check-test-name	'fixing-errors))

  (check
      (internal-body
	(define* (doit {x fixnum?})
	  ($fxlogxor x 60000))
	(doit 123))
    => 59931)

  #;(debug-print
   (assembly-of
    (internal-body
      (define* (doit {x fixnum?})
	($fxlogxor x 283))
      (doit (read)))))

  #t)


;;;; done

(check-report)

;;; end of file
