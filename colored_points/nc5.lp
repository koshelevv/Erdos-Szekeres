% --- SELECT TARGET POLYGONS ---
% rp = relaxed pentagons (allows intersection), sp = strict pentagons (no intersection)
ins(rp,r1,rp1; rp,r2,rp2; rp,r3,rp3;
    sp,s1,sp1; sp,s2,sp2; sp,s3,sp3).

% --- PERMUTATION ALIASES ---
% Map ordered chirotope l/4 to all 6 permutations with correct signs
la(AA,BB,CC, R) :- l(A,B,C,R), (AA,BB,CC) = ((A,B,C); (B,C,A); (C,A,B)).
la(AA,BB,CC,-R) :- l(A,B,C,R), (AA,BB,CC) = ((A,C,B); (B,A,C); (C,B,A)).

% Map ordered triangle density tr/4 to all 6 permutations
tra(AA,BB,CC,J) :- tr(A,B,C,J), (AA,BB,CC) = ((A,B,C); (A,C,B); (B,A,C); (B,C,A); (C,A,B); (C,B,A)).

% --- PENTAGON SHAPE INTEGRITY CONSTRAINTS ---

% Relaxed mode: fast filtering but allows abc and cde to intersect
:- ins(rp,Z,I), c(A,Z),c(B,Z),c(C,Z),c(D,Z),c(E,Z),  la(A,B,C,1), la(B,C,D,-1), la(C,D,E,1), A!=E,
    tra(A,B,C,I1), tra(B,C,D,I2), tra(C,D,E,I3), I1+I2+I3=I.

% Strict mode: structurally strict clauses to guarantee geometric soundness (abc and cde must not intersect)
:- ins(sp,Z,I), c(A,Z),c(B,Z),c(C,Z),c(D,Z),c(E,Z),  la(A,B,C,1), la(B,C,D,-1), la(C,D,E,1), la(A,C,D,-1), A!=E,
    tra(A,B,C,I1), tra(B,C,D,I2), tra(C,D,E,I3), I1+I2+I3=I.

:- ins(sp,Z,I), c(A,Z),c(B,Z),c(C,Z),c(D,Z),c(E,Z),  la(A,B,C,1), la(B,C,D,-1), la(C,D,E,1), la(B,C,E,-1), A!=E,
    tra(A,B,C,I1), tra(B,C,D,I2), tra(C,D,E,I3), I1+I2+I3=I.

:- ins(sp,Z,I), c(A,Z),c(B,Z),c(C,Z),c(D,Z),c(E,Z),  la(A,B,C,1), la(B,C,D,-1), la(C,D,E,1), la(A,C,D,1), la(B,C,E,1), la(A,C,E,1), A!=E,
    tra(A,B,C,I1), tra(B,C,D,I2), tra(C,D,E,I3), I1+I2+I3=I.
