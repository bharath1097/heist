; Control structures

; (cond) acts like the 'switch' statement in C-style languages.
; Once a matching precondition is found, its consequent is
; tail-called and no further preconditions are evaluated.
; TODO support the '=>' keyword
(define-syntax cond (syntax-rules (else =>)
  [(cond (else expression))
    expression]
  [(cond (test expression ...))
    (if test (begin expression ...))]
  [(cond (test expression ...) clause ...)
    (if test
        (begin expression ...)
        (cond clause ...))]))

;----------------------------------------------------------------

; Binding constructs

; (let), (let*) and (letrec) each create a new scope and bind
; values to some symbols before executing a series of lists.
; They differ according to how they evaluate the bound values.

; (let) evaluates values in the enclosing scope, so lambdas will
; not be able to refer to other values assigned using the (let).
(define-syntax let (syntax-rules ()
  [(let ([name expression] ...) body ...)
    ((lambda (name ...)
        body ...)
     expression ...)]))

; (let*) creates a new scope for each variable and evaluates
; each expression in its enclosing scope. Basically a shorthand
; for several nested (let)s. Variables may refer to those that
; preceed them but not vice versa.
(define-syntax let* (syntax-rules ()
  [(let* ([name expression]) body ...)
    (let ([name expression]) body ...)]
  [(let* ([n1 e1] [n2 e2] ...) body ...)
    (let ([n1 e1])
      (let* ([n2 e2] ...) body ...))]))

; (letrec) evaluates values in the inner scope, so lambdas are
; able to refer to other values assigned using the (letrec).
(define-syntax letrec (syntax-rules ()
  [(letrec ([name expression] ...) body ...)
    ((lambda ()
      (define name expression) ...
      body ...))]))

(define let-syntax let)
(define letrec-syntax letrec)

