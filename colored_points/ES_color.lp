pt(0..n-1).

%  --- SELECT TARGET POLYGONS ---
%  Format: ins(Type, ColorID, MaxInteriorPoints)
ins(pr,p1,pr1;
    tr,t1,tr1; tr,t2,tr2; tr,t3,tr3; tr,t4,tr4; tr,t5,tr5;
    cv,c1,cv1; cv,c2,cv2; cv,c3,cv3;
    cv,i1,is1; cv,i2,is2; cv,i3,is3;
    is,i1,is1+1; is,i2,is2+1; is,i3,is3+1;
    (nc;cv),n1,nc1; (nc;cv),n2,nc2; (nc;cv),n3,nc3).
#const is1=-2. #const is2=-2. #const is3=-2.

%  --- GENERATORS ---
%  Assign exactly one color to each point
1{c(A,Z): ins(_,Z,I),I=0..99}1 :- pt(A).
#heuristic c(A,Z): pt(A), ins(_,Z,I), I=0..99. [10, level]
%  Assign exactly one rotation to each triplet (Chirotope base)
1{l(A,B,C,R): R=(-1;1)}1 :- pt(A),pt(B),pt(C), A<B,B<C.

%  --- GEOMETRIC CONSTRAINTS (Axioms for Signotope) ---
%  These ensure that the relative positions of points are physically possible
:- l(A,B,C,R), l(A,C,D,-R), l(B,C,D,R).
:- l(A,B,C,R), l(A,B,D,-R), l(A,C,D,R).
:- l(A,B,C,R), l(A,B,D,-R), l(B,C,D,R).
:- l(A,B,D,R), l(A,C,D,-R), l(B,C,D,R).
%  Symmetry breaking: fix orientation of the first triplets to avoid rotated solutions
:- l(0,B,C,-1), sb!=off.

%  --- INTERIOR POINTS LOGIC ---
%  Define if point X is inside triangle (A,B,C) based on relative orientations
i(A,B,C,X) :- l(A,X,B,R), l(A,X,C,-R), B<C.
i(A,B,C,X) :- l(B,X,C,R), l(A,X,C,-R), A<B.

%  Calculate if triangle (A,B,C) contains no more that J interior points
tr(A,B,C,J) :- pt(A),pt(B),pt(C), A<B,B<C, {i(A,B,C,X)}<=J, J=0..I, ins(_,_,I), I=0..99.

%  --- SHAPE INTEGRITY CONSTRAINTS ---

%  Pairs
:- ins(pr,Z,_),  c(A,Z), c(B,Z), A<B.

%  Triangles
:- ins(tr,Z,I),  c(A,Z), c(B,Z), c(C,Z),  A<B,B<C,  tr(A,B,C,I).

%  Convex quadrilaterals
:- ins(cv,Z,I),  l(A,B,C,R), l(B,C,D,R),   c(A,Z), c(B,Z), c(C,Z), c(D,Z),  A<B,B<C,C<D,  tr(A,B,C,I1), tr(A,C,D,I2), I1+I2=I.
:- ins(cv,Z,I),  l(A,B,D,R), l(A,C,D,-R),  c(A,Z), c(B,Z), c(C,Z), c(D,Z),  A<B,B<C,C<D,  tr(A,B,C,I1), tr(B,C,D,I2), I1+I2=I.

%  Non-convex quadrilaterals
:- ins(nc,Z,I),  l(A,B,D,R), l(A,B,C,-R),  c(A,Z), c(B,Z), c(C,Z), c(D,Z),  A<B,B<C,C<D,  tr(A,B,C,I1), tr(A,B,D,I2), I1+I2=I.
:- ins(nc,Z,I),  l(A,B,D,R), l(A,B,C,-R),  c(A,Z), c(B,Z), c(C,Z), c(D,Z),  A<B,B<C,C<D,  tr(A,B,C,I1), tr(B,C,D,I2), I1+I2=I.
:- ins(nc,Z,I),  l(A,B,D,R), l(A,B,C,-R),  c(A,Z), c(B,Z), c(C,Z), c(D,Z),  A<B,B<C,C<D,  tr(A,B,D,I1), tr(B,C,D,I2), I1+I2=I.
:- ins(nc,Z,I),  l(A,C,D,R), l(B,C,D,-R),  c(A,Z), c(B,Z), c(C,Z), c(D,Z),  A<B,B<C,C<D,  tr(A,B,C,I1), tr(A,C,D,I2), I1+I2=I.
:- ins(nc,Z,I),  l(A,C,D,R), l(B,C,D,-R),  c(A,Z), c(B,Z), c(C,Z), c(D,Z),  A<B,B<C,C<D,  tr(A,B,C,I1), tr(B,C,D,I2), I1+I2=I.
:- ins(nc,Z,I),  l(A,C,D,R), l(B,C,D,-R),  c(A,Z), c(B,Z), c(C,Z), c(D,Z),  A<B,B<C,C<D,  tr(A,C,D,I1), tr(B,C,D,I2), I1+I2=I.

%  4-islands
:- ins(is,Z,I), l(A,B,D,R), l(A,B,C,-R),   c(A,Z), c(B,Z), c(C,Z), c(D,Z),  A<B,B<C,C<D,  tr(A,C,D,I).
:- ins(is,Z,I), l(A,C,D,R), l(B,C,D,-R),   c(A,Z), c(B,Z), c(C,Z), c(D,Z),  A<B,B<C,C<D,  tr(A,B,D,I).

#show c/2.
#show l/4.
