%------------------------------------------------------------------------------
% NOTE: This encoding enforces interior point constraints for ALL polygons 
% (triangles, quadrilaterals, and pentagons). 
% Use this file strictly for evaluating R_ec() with small number of interior points (small I).
% WARNING: Using large values (e.g., I=99) will cause a combinatorial explosion 
% during the grounding phase due to the partition sum (I1+I2+I3=I).
%------------------------------------------------------------------------------

pt(1..n).
ins(tr,t1,tr1;tr,t2,tr2;tr,t3,tr3; quad,q1,quad1;quad,q2,quad2; pent,p1,pent1;pent,p2,pent2).
1{c(A,B,Z): ins(_,Z,I),I=0..99}1 :- pt(A), pt(B), A<B.
1{l(A,B,C,R): R=(-1;1)}1 :- pt(A), pt(B), pt(C), A<B,B<C.

%--- Knuth's Axioms for Monotone Signotopes ---
:- l(A,B,C,R), l(A,C,D,-R), l(B,C,D,R).
:- l(A,B,C,R), l(A,B,D,-R), l(A,C,D,R).
:- l(A,B,C,R), l(A,B,D,-R), l(B,C,D,R).
:- l(A,B,D,R), l(A,C,D,-R), l(B,C,D,R).

% Symmetry breaking using the first point
:- l(1,B,C,-1), sb!=off.

%--- Geometric Definitions ---
% Point X is inside triangle ABC (x-sorted optimization)
i(A,B,C,X) :- l(A,X,B,R), l(A,X,C,-R), B<C.
i(A,B,C,X) :- l(B,X,C,R), l(A,X,C,-R), A<B.

% Triangle containing at most N interior points
tr(A,B,C,N) :- pt(A),pt(B),pt(C), A<B,B<C, {i(A,B,C,X)}<=N, N=0..I, ins(_,_,I), I=0..99.

%--- Constraints: Triangles (tr) ---
:- ins(tr,Z,I),  A<B,B<C,  c(A,B,Z), c(A,C,Z), c(B,C,Z), tr(A,B,C,I).

%--- Constraints: Convex Quadrilaterals (quad) ---
:- ins(quad,Z,I),  A<B,B<C,C<D,  c(A,B,Z), c(B,C,Z), c(C,D,Z), c(A,D,Z),   l(A,B,C,R), l(B,C,D,R),   tr(A,B,C,I1), tr(A,C,D,I2), I1+I2=I.
:- ins(quad,Z,I),  A<B,B<C,C<D,  c(A,B,Z), c(B,D,Z), c(A,C,Z), c(C,D,Z),   l(A,B,D,R), l(A,C,D,-R),  tr(A,B,C,I1), tr(B,C,D,I2), I1+I2=I.

%--- Constraints: Convex Pentagons (pent) ---
:- ins(pent,Z,I),  A<B,B<C,C<D,D<E,  c(A,B,Z), c(B,C,Z), c(C,D,Z), c(D,E,Z), c(A,E,Z),   l(A,B,C,R), l(B,C,D,R), l(C,D,E,R),   tr(A,B,C,I1), tr(A,C,D,I2), tr(A,D,E,I3), I1+I2+I3=I.
:- ins(pent,Z,I),  A<B,B<C,C<D,D<E,  c(A,B,Z), c(B,C,Z), c(C,E,Z), c(A,D,Z), c(D,E,Z),   l(A,B,C,R), l(B,C,E,R), l(A,D,E,-R),  tr(A,B,C,I1), tr(A,C,E,I2), tr(A,D,E,I3), I1+I2+I3=I.
:- ins(pent,Z,I),  A<B,B<C,C<D,D<E,  c(A,B,Z), c(B,D,Z), c(D,E,Z), c(A,C,Z), c(C,E,Z),   l(A,B,D,R), l(B,D,E,R), l(A,C,E,-R),  tr(A,B,D,I1), tr(A,D,E,I2), tr(A,C,E,I3), I1+I2+I3=I.
:- ins(pent,Z,I),  A<B,B<C,C<D,D<E,  c(A,C,Z), c(C,D,Z), c(D,E,Z), c(A,B,Z), c(B,E,Z),   l(A,C,D,R), l(C,D,E,R), l(A,B,E,-R),  tr(A,C,D,I1), tr(A,D,E,I2), tr(A,B,E,I3), I1+I2+I3=I.

#show l/4.
#show c/3.
