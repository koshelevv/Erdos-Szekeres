% ==============================================================================
% Solving the Erdos--Szekeres-type Problem with Interior Points (~h_sub variant)
% ==============================================================================
% This ASP (Clingo) script determines the minimum number of points 'n' 
% in general position required to guarantee a convex hexagon with specific 
% interior point constraints (the ~h_sub(6, q) problem).
%
% Theoretical background: 
% The script verifies the existence of a convex hexagon where at least one 
% of the three sub-quadrilaterals (formed by removing opposite vertices) 
% contains exactly 0 or 'q' interior points.
%
% Computational Note: 
% For q=2, the exhaustive search for n=18 required   1 days of CPU time.
% For q=3, the exhaustive search for n=20 required  13 days of CPU time.
% For q=4, the exhaustive search for n=21 required 214 days of CPU time.
% ==============================================================================

pt(1..n).

% Generation of the chirotope (signotope) of rank 3
% l(A,B,C,R) represents the orientation (R = 1 or -1) of the triple (A,B,C)
1{l(A,B,C,R): R=(-1;1)}1 :- pt(A),pt(B),pt(C), A<B,B<C.

% GEOMETRIC CONSTRAINTS (Signotope axioms for points in general position)
:- l(A,B,C,R), l(A,C,D,-R), l(B,C,D,R).
:- l(A,B,C,R), l(A,B,D,-R), l(A,C,D,R).
:- l(A,B,C,R), l(A,B,D,-R), l(B,C,D,R).
:- l(A,B,D,R), l(A,C,D,-R), l(B,C,D,R).

% Symmetry breaking: fix the orientation of the first triple
:- l(1,B,C,-1), sb!=off.

% DEFINITION OF INTERIOR POINTS
% i(A,B,C,X) is true if point X is inside the triangle formed by A, B, and C
i(A,B,C,X) :- l(A,X,B,R), l(A,X,C,-R), B<C.
i(A,B,C,X) :- l(B,X,C,R), l(A,X,C,-R), A<B.

% tr(A,B,C,I): triangle (A,B,C) contains exactly I interior points
tr(A,B,C,I) :- pt(A), pt(B), pt(C), A<B,B<C, {i(A,B,C,X)}==I, I=0..q.

% d(A,B,C,D): unified structure for sub-polygons
% Case 1: Empty triangle (modeled as a degenerate quadrilateral)
d(A,B,C,0) :- tr(A,B,C,0).

% Case 2: Convex quadrilateral containing exactly 'q' interior points
d(A,B,C,D) :- l(A,B,C,R), l(B,C,D,R),   A<B,B<C,C<D,  tr(A,B,C,I1), tr(A,C,D,I2), I1+I2==q.
d(A,B,C,D) :- l(A,B,D,R), l(A,C,D,-R),  A<B,B<C,C<D,  tr(A,B,C,I1), tr(B,C,D,I2), I1+I2==q.

% CONSTRAINTS FOR 8 COMBINATORIAL TYPES OF CONVEX HEXAGONS
% We exclude configurations where the hexagon contains at least one 
% "forbidden" sub-structure (empty triangle or quadrilateral with q points).
% Pooling (;) is used to generate flat clauses for maximum performance.

:- l(A,B,C,R), l(B,C,D,R), l(C,D,E,R),  l(D,E,F,R),   A<B,B<C,C<D,D<E,E<F,   d(A,C,E,0;  A,C,D,F; B,C,E,F; A,B,D,E).
:- l(A,B,C,R), l(B,C,D,R), l(C,D,F,R),  l(A,E,F,-R),  A<B,B<C,C<D,D<E,E<F,   d(B,D,E,0;  A,B,D,F; B,C,E,F; A,C,D,E).
:- l(A,B,C,R), l(B,C,E,R), l(C,E,F,R),  l(A,D,F,-R),  A<B,B<C,C<D,D<E,E<F,   d(B,D,E,0;  A,B,E,F; B,C,D,F; A,C,D,E).
:- l(A,B,D,R), l(B,D,E,R), l(D,E,F,R),  l(A,C,F,-R),  A<B,B<C,C<D,D<E,E<F,   d(B,C,E,0;  A,B,E,F; B,C,D,F; A,C,D,E).
:- l(A,C,D,R), l(C,D,E,R), l(D,E,F,R),  l(A,B,F,-R),  A<B,B<C,C<D,D<E,E<F,   d(B,C,E,0;  A,C,E,F; B,C,D,F; A,B,D,E).
:- l(A,B,C,R), l(B,C,F,R), l(A,D,E,-R), l(D,E,F,-R),  A<B,B<C,C<D,D<E,E<F,   d(A,C,E,0;  A,B,E,F; B,C,D,E; A,C,D,F).
:- l(A,B,D,R), l(B,D,F,R), l(A,C,E,-R), l(C,E,F,-R),  A<B,B<C,C<D,D<E,E<F,   d(A,D,E,0;  A,B,E,F; B,C,D,E; A,C,D,F).
:- l(A,C,D,R), l(C,D,F,R), l(A,B,E,-R), l(B,E,F,-R),  A<B,B<C,C<D,D<E,E<F,   d(A,D,E,0;  A,C,E,F; B,C,D,E; A,B,D,F).

#show l/4.

