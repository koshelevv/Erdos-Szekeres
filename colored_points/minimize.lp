pt(0..n-1).

min_p3(3,1; 4,3; 5,7; 6,13; 7,21; 8,31; 9,43; 10,58; 11,75; 12,94; 13,114).
min_p4(3,0; 4,0; 5,1; 6,3;  7,6;  8,10; 9,15; 10,23; 11,32; 12,42; 13,51).

min_p5(9,0; 10,1; 11,2; 12,3; 13,3; 14,6; 15,9; 16,11).

1{l(A,B,C,R): R=(-1;1)}1 :- pt(A),pt(B),pt(C), A<B,B<C.

:- l(A,B,C,R), l(A,C,D,-R), l(B,C,D,R).
:- l(A,B,C,R), l(A,B,D,-R), l(A,C,D,R).
:- l(A,B,C,R), l(A,B,D,-R), l(B,C,D,R).
:- l(A,B,D,R), l(A,C,D,-R), l(B,C,D,R).
:- l(1,B,C,-1), sb!=off.

i(A,B,C,X) :- l(A,X,B,R), l(A,X,C,-R), B<C.
i(A,B,C,X) :- l(B,X,C,R), l(A,X,C,-R), A<B.

ne(A,B,C) :- i(A,B,C,X).

p3(A,B,C) :- pt(A),pt(B),pt(C), A<B,B<C, not ne(A,B,C).

:- #count{A,B,C: p3(A,B,C)}=M, min_p3(n,M), p3=-1.
:- #count{A,B,C: p3(A,B,C)}>M, min_p3(n,M), p3= 1.

p4(A,B,C,D) :- l(A,B,C,R), l(B,C,D,R),  A<B,B<C,C<D, not ne(A,B,C), not ne(A,C,D).
p4(A,B,C,D) :- l(A,B,D,R), l(A,C,D,-R), A<B,B<C,C<D, not ne(A,B,C), not ne(B,C,D).

:- #count{A,B,C,D: p4(A,B,C,D)}=M, min_p4(n,M), p4=-1.
:- #count{A,B,C,D: p4(A,B,C,D)}>M, min_p4(n,M), p4= 1.

p5(A,B,C,D,E) :- l(A,B,C,R), l(B,C,D,R), l(C,D,E,R),   A<B,B<C,C<D,D<E,  not ne(A,B,C), not ne(A,C,D), not ne(A,D,E).
p5(A,B,C,D,E) :- l(A,B,C,R), l(B,C,E,R), l(A,D,E,-R),  A<B,B<C,C<D,D<E,  not ne(A,B,C), not ne(A,C,E), not ne(A,D,E).
p5(A,B,C,D,E) :- l(A,B,D,R), l(B,D,E,R), l(A,C,E,-R),  A<B,B<C,C<D,D<E,  not ne(A,B,D), not ne(A,D,E), not ne(A,C,E).
p5(A,B,C,D,E) :- l(A,C,D,R), l(C,D,E,R), l(A,B,E,-R),  A<B,B<C,C<D,D<E,  not ne(A,C,D), not ne(A,D,E), not ne(A,B,E).

:- #count{A,B,C,D,E: p5(A,B,C,D,E)}=M, min_p5(n,M), p5=-1.
:- #count{A,B,C,D,E: p5(A,B,C,D,E)}>M, min_p5(n,M), p5= 1.
