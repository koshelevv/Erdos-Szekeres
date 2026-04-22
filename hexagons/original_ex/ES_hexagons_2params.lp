#const q=2.
pt(1..n).
rotation(-1;1).
1{l(A,B,C,R): rotation(R)}1 :- pt(A),pt(B),pt(C),A<B,B<C.
q(q1). q(q2).

% GEOMETRIC CONSTRAINT
:- l(A,B,C,R), l(A,C,D,-R), l(B,C,D,R).
:- l(A,B,C,R), l(A,B,D,-R), l(A,C,D,R).
:- l(A,B,C,R), l(A,B,D,-R), l(B,C,D,R).
:- l(A,B,D,R), l(A,C,D,-R), l(B,C,D,R).
:- l(1,B,C,-1).


% DEFINITION OF INTERIOR POINTS
i(A,B,C,X) :- l(A,X,B,R), l(A,X,C,-R), B<C.
i(A,B,C,X) :- l(B,X,C,R), l(A,X,C,-R), A<B.

tr(A,B,C,N) :- pt(A), pt(B), pt(C), A<B, B<C, {i(A,B,C,X)}==N, N=0..Q, q(Q).

:- l(A,B,C,R), l(B,C,D,R), l(C,D,E,R),  l(D,E,F,R),   A<B,B<C,C<D,D<E,E<F,  tr(A,C,E,0).
:- l(A,B,C,R), l(B,C,D,R), l(C,D,F,R),  l(A,E,F,-R),  A<B,B<C,C<D,D<E,E<F,  tr(B,D,E,0).
:- l(A,B,C,R), l(B,C,E,R), l(C,E,F,R),  l(A,D,F,-R),  A<B,B<C,C<D,D<E,E<F,  tr(B,D,E,0).
:- l(A,B,D,R), l(B,D,E,R), l(D,E,F,R),  l(A,C,F,-R),  A<B,B<C,C<D,D<E,E<F,  tr(B,C,E,0).
:- l(A,C,D,R), l(C,D,E,R), l(D,E,F,R),  l(A,B,F,-R),  A<B,B<C,C<D,D<E,E<F,  tr(B,C,E,0).
:- l(A,B,C,R), l(B,C,F,R), l(A,D,E,-R), l(D,E,F,-R),  A<B,B<C,C<D,D<E,E<F,  tr(A,C,E,0).
:- l(A,B,D,R), l(B,D,F,R), l(A,C,E,-R), l(C,E,F,-R),  A<B,B<C,C<D,D<E,E<F,  tr(A,D,E,0).
:- l(A,C,D,R), l(C,D,F,R), l(A,B,E,-R), l(B,E,F,-R),  A<B,B<C,C<D,D<E,E<F,  tr(A,D,E,0).


f(A,B,C,D,I+J) :- l(A,B,C,R), l(B,C,D,R),   A<B,B<C,C<D,  tr(A,B,C,I), tr(A,C,D,J), I+J<=Q, q(Q).
f(A,B,C,D,I+J) :- l(A,B,D,R), l(A,C,D,-R),  A<B,B<C,C<D,  tr(A,B,C,I), tr(B,C,D,J), I+J<=Q, q(Q).


:- l(A,B,C,R), l(B,C,D,R), l(C,D,E,R),  l(D,E,F,R),   A<B,B<C,C<D,D<E,E<F,  f(B,C,D,E,I), f(A,B,E,F,J), I+J==Q, q(Q).
:- l(A,B,C,R), l(B,C,D,R), l(C,D,F,R),  l(A,E,F,-R),  A<B,B<C,C<D,D<E,E<F,  f(A,B,C,E,I), f(C,D,E,F,J), I+J==Q, q(Q).
:- l(A,B,C,R), l(B,C,E,R), l(C,E,F,R),  l(A,D,F,-R),  A<B,B<C,C<D,D<E,E<F,  f(A,B,C,D,I), f(C,D,E,F,J), I+J==Q, q(Q).
:- l(A,B,D,R), l(B,D,E,R), l(D,E,F,R),  l(A,C,F,-R),  A<B,B<C,C<D,D<E,E<F,  f(A,B,C,D,I), f(C,D,E,F,J), I+J==Q, q(Q).
:- l(A,C,D,R), l(C,D,E,R), l(D,E,F,R),  l(A,B,F,-R),  A<B,B<C,C<D,D<E,E<F,  f(A,B,C,D,I), f(B,D,E,F,J), I+J==Q, q(Q).
:- l(A,B,C,R), l(B,C,F,R), l(A,D,E,-R), l(D,E,F,-R),  A<B,B<C,C<D,D<E,E<F,  f(A,B,C,D,I), f(C,D,E,F,J), I+J==Q, q(Q).
:- l(A,B,D,R), l(B,D,F,R), l(A,C,E,-R), l(C,E,F,-R),  A<B,B<C,C<D,D<E,E<F,  f(A,B,C,D,I), f(C,D,E,F,J), I+J==Q, q(Q).
:- l(A,C,D,R), l(C,D,F,R), l(A,B,E,-R), l(B,E,F,-R),  A<B,B<C,C<D,D<E,E<F,  f(A,B,C,D,I), f(B,D,E,F,J), I+J==Q, q(Q).

#show l/4.
