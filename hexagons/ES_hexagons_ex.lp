% ==============================================================================
% Solving the Erdos--Szekeres-type problem for hexagons with exact number of
% interior points from Q \subset \mathbb{N}, 0 \in Q --  ~h_ex(6, Q)
% ==============================================================================
% This script searches for point configurations that do not contain 
% convex hexagons with a number of interior points belonging to set Q.
%
% Input parameters:
% -c n=N : Total number of points
% -c q=Q1, -c q1=Q2, -c q2=Q3 : Elements of set Q (where Q_i > 0)
% ==============================================================================

pt(1..n).

% Define set Q from provided constants (only positive integers are used)
% Note: Q=0 is handled separately by mandatory empty triangle constraints.
raw_q(q; q1; q2).
q(Q) :- raw_q(Q), Q=1..99.

% Generation of the chirotope (signotope)
1{l(A,B,C,R): R=(-1;1)}1 :- pt(A),pt(B),pt(C), A<B,B<C.

% Geometric constraints (signotope axioms)
:- l(A,B,C,R), l(A,C,D,-R), l(B,C,D,R).
:- l(A,B,C,R), l(A,B,D,-R), l(A,C,D,R).
:- l(A,B,C,R), l(A,B,D,-R), l(B,C,D,R).
:- l(A,B,D,R), l(A,C,D,-R), l(B,C,D,R).
:- l(1,B,C,-1), sb!=off.

% Definition of interior points
i(A,B,C,X) :- l(A,X,B,R), l(A,X,C,-R), B<C.
i(A,B,C,X) :- l(B,X,C,R), l(A,X,C,-R), A<B.

% Triangle ABC contains exactly I interior points.
% Q is taken from the input set to bound the counting.
tr(A,B,C,I) :- pt(A), pt(B), pt(C), A<B,B<C, {i(A,B,C,X)}==I, I=0..Q, q(Q).

% Empty triangle constraints (to ensure convexity and avoid empty hexagons)
:- l(A,B,C,R), l(B,C,D,R), l(C,D,E,R),  l(D,E,F,R),   A<B,B<C,C<D,D<E,E<F,  tr(A,C,E,0).
:- l(A,B,C,R), l(B,C,D,R), l(C,D,F,R),  l(A,E,F,-R),  A<B,B<C,C<D,D<E,E<F,  tr(B,D,E,0).
:- l(A,B,C,R), l(B,C,E,R), l(C,E,F,R),  l(A,D,F,-R),  A<B,B<C,C<D,D<E,E<F,  tr(B,D,E,0).
:- l(A,B,D,R), l(B,D,E,R), l(D,E,F,R),  l(A,C,F,-R),  A<B,B<C,C<D,D<E,E<F,  tr(B,C,E,0).
:- l(A,C,D,R), l(C,D,E,R), l(D,E,F,R),  l(A,B,F,-R),  A<B,B<C,C<D,D<E,E<F,  tr(B,C,E,0).
:- l(A,B,C,R), l(B,C,F,R), l(A,D,E,-R), l(D,E,F,-R),  A<B,B<C,C<D,D<E,E<F,  tr(A,C,E,0).
:- l(A,B,D,R), l(B,D,F,R), l(A,C,E,-R), l(C,E,F,-R),  A<B,B<C,C<D,D<E,E<F,  tr(A,D,E,0).
:- l(A,C,D,R), l(C,D,F,R), l(A,B,E,-R), l(B,E,F,-R),  A<B,B<C,C<D,D<E,E<F,  tr(A,D,E,0).

% Decomposition of hexagons into quadrilaterals f(A,B,C,D, K)
f(A,B,C,D,I+J) :- l(A,B,C,R), l(B,C,D,R),   A<B,B<C,C<D,  tr(A,B,C,I), tr(A,C,D,J), I+J<=Q, q(Q).
f(A,B,C,D,I+J) :- l(A,B,D,R), l(A,C,D,-R),  A<B,B<C,C<D,  tr(A,B,C,I), tr(B,C,D,J), I+J<=Q, q(Q).

% Hexagon constraints (Excluding hexagons with exactly Q interior points)
:- l(A,B,C,R), l(B,C,D,R), l(C,D,E,R),  l(D,E,F,R),   A<B,B<C,C<D,D<E,E<F,  f(B,C,D,E,I), f(A,B,E,F,J), I+J==Q, q(Q).
:- l(A,B,C,R), l(B,C,D,R), l(C,D,F,R),  l(A,E,F,-R),  A<B,B<C,C<D,D<E,E<F,  f(A,B,C,E,I), f(C,D,E,F,J), I+J==Q, q(Q).
:- l(A,B,C,R), l(B,C,E,R), l(C,E,F,R),  l(A,D,F,-R),  A<B,B<C,C<D,D<E,E<F,  f(A,B,C,D,I), f(C,D,E,F,J), I+J==Q, q(Q).
:- l(A,B,D,R), l(B,D,E,R), l(D,E,F,R),  l(A,C,F,-R),  A<B,B<C,C<D,D<E,E<F,  f(A,B,C,D,I), f(C,D,E,F,J), I+J==Q, q(Q).
:- l(A,C,D,R), l(C,D,E,R), l(D,E,F,R),  l(A,B,F,-R),  A<B,B<C,C<D,D<E,E<F,  f(A,B,C,D,I), f(B,D,E,F,J), I+J==Q, q(Q).
:- l(A,B,C,R), l(B,C,F,R), l(A,D,E,-R), l(D,E,F,-R),  A<B,B<C,C<D,D<E,E<F,  f(A,B,C,D,I), f(C,D,E,F,J), I+J==Q, q(Q).
:- l(A,B,D,R), l(B,D,F,R), l(A,C,E,-R), l(C,E,F,-R),  A<B,B<C,C<D,D<E,E<F,  f(A,B,C,D,I), f(C,D,E,F,J), I+J==Q, q(Q).
:- l(A,C,D,R), l(C,D,F,R), l(A,B,E,-R), l(B,E,F,-R),  A<B,B<C,C<D,D<E,E<F,  f(A,B,C,D,I), f(B,D,E,F,J), I+J==Q, q(Q).

#show l/4.
