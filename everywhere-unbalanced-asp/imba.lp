#const imba = 2.

pt(1..n).
r(-1;1).
1{l(A,B,C,R): R=-1..1}1 :- pt(A),pt(B),pt(C),A<B,B<C.

% 1. Geometric constraints for non-collinear quadruplets
:- l(A,B,C,R), l(A,C,D,-R), l(B,C,D,R), r(R).
:- l(A,B,C,R), l(A,B,D,-R), l(A,C,D,R), r(R).
:- l(A,B,C,R), l(A,B,D,-R), l(B,C,D,R), r(R).
:- l(A,B,D,R), l(A,C,D,-R), l(B,C,D,R), r(R).

% 2. Symmetry breaking
:- l(1,B,C,-1), sb!=off.

la(AA,BB,CC, R) :- l(A,B,C,R), (AA,BB,CC) = ((A,B,C); (B,C,A); (C,A,B)).
la(AA,BB,CC,-R) :- l(A,B,C,R), (AA,BB,CC) = ((A,C,B); (B,A,C); (C,B,A)).

% 3. Transitivity of collinearity (if any two triplets are 0, all 4 triplets must be 0)
:- la(A,B,C,0), la(A,B,D,0), la(A,C,D,R),  r(R).

% 4. Sign consistency around a collinear line
:-  l(A,B,C,0), la(A,B,D,R), la(A,C,D,-R), r(R).
:-  l(A,B,C,0), la(A,B,D,R), la(B,C,D,-R), r(R).

% 5. Balanced lines are forbidden
:- pt(A), pt(B), A<B,  -imba+1 <= #sum{R,X:la(A,B,X,R),r(R)} <= imba-1.

#show l/4.
