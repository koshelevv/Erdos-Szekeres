pt(1..n).
1{l(A,B,C,R): R=(-1;1)}1 :- pt(A),pt(B),pt(C),A<B,B<C.

% GEOMETRIC CONSTRAINTS
:- l(A,B,C,R), l(A,C,D,-R), l(B,C,D,R).
:- l(A,B,C,R), l(A,B,D,-R), l(A,C,D,R).
:- l(A,B,C,R), l(A,B,D,-R), l(B,C,D,R).
:- l(A,B,D,R), l(A,C,D,-R), l(B,C,D,R).
:- l(1,B,C,-1), sb!=off.

% DEFINITION OF INTERIOR POINTS
i(A,B,C,X) :- l(A,X,B,R), l(A,X,C,-R), B<C.
i(A,B,C,X) :- l(B,X,C,R), l(A,X,C,-R), A<B.

tr(A,B,C) :- pt(A), pt(B), pt(C), A<B,B<C, {i(A,B,C,X)}<=k.

:- l(A,B,C,R), l(B,C,D,R), l(C,D,E,R),  l(D,E,F,R),   A<B,B<C,C<D,D<E,E<F,  tr(A,C,E).
:- l(A,B,C,R), l(B,C,D,R), l(C,D,F,R),  l(A,E,F,-R),  A<B,B<C,C<D,D<E,E<F,  tr(B,D,E).
:- l(A,B,C,R), l(B,C,E,R), l(C,E,F,R),  l(A,D,F,-R),  A<B,B<C,C<D,D<E,E<F,  tr(B,D,E).
:- l(A,B,D,R), l(B,D,E,R), l(D,E,F,R),  l(A,C,F,-R),  A<B,B<C,C<D,D<E,E<F,  tr(B,C,E).
:- l(A,C,D,R), l(C,D,E,R), l(D,E,F,R),  l(A,B,F,-R),  A<B,B<C,C<D,D<E,E<F,  tr(B,C,E).
:- l(A,B,C,R), l(B,C,F,R), l(A,D,E,-R), l(D,E,F,-R),  A<B,B<C,C<D,D<E,E<F,  tr(A,C,E).
:- l(A,B,D,R), l(B,D,F,R), l(A,C,E,-R), l(C,E,F,-R),  A<B,B<C,C<D,D<E,E<F,  tr(A,D,E).
:- l(A,C,D,R), l(C,D,F,R), l(A,B,E,-R), l(B,E,F,-R),  A<B,B<C,C<D,D<E,E<F,  tr(A,D,E).

#show l/4.

