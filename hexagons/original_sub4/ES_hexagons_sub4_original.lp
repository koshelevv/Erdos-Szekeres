#const q=2.
pt(1..n).
rotation(-1;1).
1{l(A,B,C,R): rotation(R)}1 :- pt(A),pt(B),pt(C),A<B,B<C.

% GEOMETRIC CONSTRAINT
:- l(A,B,C,R), l(A,C,D,-R), l(B,C,D,R).
:- l(A,B,C,R), l(A,B,D,-R), l(A,C,D,R).
:- l(A,B,C,R), l(A,B,D,-R), l(B,C,D,R).
:- l(A,B,D,R), l(A,C,D,-R), l(B,C,D,R).
:- l(1,B,C,-1).


% DEFINITION OF INTERIOR POINTS
i(A,B,C,X) :- l(A,X,B,R), l(A,X,C,-R), B<C.
i(A,B,C,X) :- l(B,X,C,R), l(A,X,C,-R), A<B.

tr(A,B,C,N) :- pt(A), pt(B), pt(C), A<B, B<C, {i(A,B,C,X)}==N, N=0..q.

:- l(A,B,C,R), l(B,C,D,R), l(C,D,E,R), l(D,E,F,R),   A<B, B<C, C<D, D<E, E<F, tr(A,C,E,0).
:- l(A,B,C,R), l(B,C,D,R), l(C,D,F,R), l(A,E,F,-R),  A<B, B<C, C<D, D<E, E<F, tr(B,D,E,0).
:- l(A,B,C,R), l(B,C,E,R), l(C,E,F,R), l(A,D,F,-R),  A<B, B<C, C<D, D<E, E<F, tr(B,D,E,0).
:- l(A,B,D,R), l(B,D,E,R), l(D,E,F,R), l(A,C,F,-R),  A<B, B<C, C<D, D<E, E<F, tr(B,C,E,0).
:- l(A,C,D,R), l(C,D,E,R), l(D,E,F,R), l(A,B,F,-R),  A<B, B<C, C<D, D<E, E<F, tr(B,C,E,0).
:- l(A,B,C,R), l(B,C,F,R), l(A,D,E,-R), l(D,E,F,-R), A<B, B<C, C<D, D<E, E<F, tr(A,C,E,0).
:- l(A,B,D,R), l(B,D,F,R), l(A,C,E,-R), l(C,E,F,-R), A<B, B<C, C<D, D<E, E<F, tr(A,D,E,0).
:- l(A,C,D,R), l(C,D,F,R), l(A,B,E,-R), l(B,E,F,-R), A<B, B<C, C<D, D<E, E<F, tr(A,D,E,0).


d(A,B,C,D) :- l(A,B,C,R), l(B,C,D,R),   A<B, B<C, C<D,  tr(A,B,C,N1), tr(A,C,D,N2), N1+N2==q.
d(A,B,C,D) :- l(A,B,D,R), l(A,C,D,-R),  A<B, B<C, C<D,  tr(A,B,C,N1), tr(B,C,D,N2), N1+N2==q.

:- l(A,B,C,R), l(B,C,D,R), l(C,D,E,R), l(D,E,F,R),   A<B, B<C, C<D, D<E, E<F,  d(A,C,D,F).   % BE
:- l(A,B,C,R), l(B,C,D,R), l(C,D,F,R), l(A,E,F,-R),  A<B, B<C, C<D, D<E, E<F,  d(A,B,D,F).   % CE
:- l(A,B,C,R), l(B,C,E,R), l(C,E,F,R), l(A,D,F,-R),  A<B, B<C, C<D, D<E, E<F,  d(A,B,E,F).   % CD
:- l(A,B,D,R), l(B,D,E,R), l(D,E,F,R), l(A,C,F,-R),  A<B, B<C, C<D, D<E, E<F,  d(A,B,E,F).   % CD
:- l(A,C,D,R), l(C,D,E,R), l(D,E,F,R), l(A,B,F,-R),  A<B, B<C, C<D, D<E, E<F,  d(A,C,E,F).   % BD
:- l(A,B,C,R), l(B,C,F,R), l(A,D,E,-R), l(D,E,F,-R), A<B, B<C, C<D, D<E, E<F,  d(A,B,E,F).   % CD
:- l(A,B,D,R), l(B,D,F,R), l(A,C,E,-R), l(C,E,F,-R), A<B, B<C, C<D, D<E, E<F,  d(A,B,E,F).   % CD
:- l(A,C,D,R), l(C,D,F,R), l(A,B,E,-R), l(B,E,F,-R), A<B, B<C, C<D, D<E, E<F,  d(A,C,E,F).   % BD

:- l(A,B,C,R), l(B,C,D,R), l(C,D,E,R), l(D,E,F,R),   A<B, B<C, C<D, D<E, E<F,  d(B,C,E,F).   % AD
:- l(A,B,C,R), l(B,C,D,R), l(C,D,F,R), l(A,E,F,-R),  A<B, B<C, C<D, D<E, E<F,  d(B,C,E,F).   % AD
:- l(A,B,C,R), l(B,C,E,R), l(C,E,F,R), l(A,D,F,-R),  A<B, B<C, C<D, D<E, E<F,  d(B,C,D,F).   % AE
:- l(A,B,D,R), l(B,D,E,R), l(D,E,F,R), l(A,C,F,-R),  A<B, B<C, C<D, D<E, E<F,  d(B,C,D,F).   % AE
:- l(A,C,D,R), l(C,D,E,R), l(D,E,F,R), l(A,B,F,-R),  A<B, B<C, C<D, D<E, E<F,  d(B,C,D,F).   % AE
:- l(A,B,C,R), l(B,C,F,R), l(A,D,E,-R), l(D,E,F,-R), A<B, B<C, C<D, D<E, E<F,  d(B,C,D,E).   % AF
:- l(A,B,D,R), l(B,D,F,R), l(A,C,E,-R), l(C,E,F,-R), A<B, B<C, C<D, D<E, E<F,  d(B,C,D,E).   % AF
:- l(A,C,D,R), l(C,D,F,R), l(A,B,E,-R), l(B,E,F,-R), A<B, B<C, C<D, D<E, E<F,  d(B,C,D,E).   % AF

:- l(A,B,C,R), l(B,C,D,R), l(C,D,E,R), l(D,E,F,R),   A<B, B<C, C<D, D<E, E<F,  d(A,B,D,E).   % CF
:- l(A,B,C,R), l(B,C,D,R), l(C,D,F,R), l(A,E,F,-R),  A<B, B<C, C<D, D<E, E<F,  d(A,C,D,E).   % BF
:- l(A,B,C,R), l(B,C,E,R), l(C,E,F,R), l(A,D,F,-R),  A<B, B<C, C<D, D<E, E<F,  d(A,C,D,E).   % BF
:- l(A,B,D,R), l(B,D,E,R), l(D,E,F,R), l(A,C,F,-R),  A<B, B<C, C<D, D<E, E<F,  d(A,C,D,E).   % BF
:- l(A,C,D,R), l(C,D,E,R), l(D,E,F,R), l(A,B,F,-R),  A<B, B<C, C<D, D<E, E<F,  d(A,B,D,E).   % CF
:- l(A,B,C,R), l(B,C,F,R), l(A,D,E,-R), l(D,E,F,-R), A<B, B<C, C<D, D<E, E<F,  d(A,C,D,F).   % BE
:- l(A,B,D,R), l(B,D,F,R), l(A,C,E,-R), l(C,E,F,-R), A<B, B<C, C<D, D<E, E<F,  d(A,C,D,F).   % BE
:- l(A,C,D,R), l(C,D,F,R), l(A,B,E,-R), l(B,E,F,-R), A<B, B<C, C<D, D<E, E<F,  d(A,B,D,F).   % CE


#show l/4.

