pt(1..n).
ins(tr,t1,tr1;tr,t2,tr2;tr,t3,tr3; four,f1,four1;four,f2,four2; pent,p1,pent1;pent,p2,pent2).
1{c(A,B,Z): ins(_,Z,I),I=0..99}1 :- pt(A), pt(B), A<B.
1{l(A,B,C,R): R=(-1;1)}1 :- pt(A), pt(B), pt(C), A<B,B<C.

% GEOMETRIC CONSTRAINT
:- l(A,B,C,R), l(A,C,D,-R), l(B,C,D,R).
:- l(A,B,C,R), l(A,B,D,-R), l(A,C,D,R).
:- l(A,B,C,R), l(A,B,D,-R), l(B,C,D,R).
:- l(A,B,D,R), l(A,C,D,-R), l(B,C,D,R).
:- l(1,B,C,-1), sb!=off.

% DEFINITION OF INTERIOR POINTS
i(A,B,C,X) :- l(A,X,B,R), l(A,X,C,-R), B<C.
i(A,B,C,X) :- l(B,X,C,R), l(A,X,C,-R), A<B.

tr(A,B,C,N) :- pt(A),pt(B),pt(C), A<B,B<C, {i(A,B,C,X)}<=N, N=0..I, ins(_,_,I), I=0..99.


:- ins(tr,Z,I),  A<B,B<C,  c(A,B,Z), c(A,C,Z), c(B,C,Z), tr(A,B,C,I).

:- ins(four,Z,I),  A<B,B<C,C<D,  c(A,B,Z), c(B,C,Z), c(C,D,Z), c(A,D,Z),   l(A,B,C,R), l(B,C,D,R).
:- ins(four,Z,I),  A<B,B<C,C<D,  c(A,B,Z), c(B,D,Z), c(A,C,Z), c(C,D,Z),   l(A,B,D,R), l(A,C,D,-R).

:- ins(pent,Z,I),  A<B,B<C,C<D,D<E,  c(A,B,Z), c(B,C,Z), c(C,D,Z), c(D,E,Z), c(A,E,Z),   l(A,B,C,R), l(B,C,D,R), l(C,D,E,R).
:- ins(pent,Z,I),  A<B,B<C,C<D,D<E,  c(A,B,Z), c(B,C,Z), c(C,E,Z), c(A,D,Z), c(D,E,Z),   l(A,B,C,R), l(B,C,E,R), l(A,D,E,-R).
:- ins(pent,Z,I),  A<B,B<C,C<D,D<E,  c(A,B,Z), c(B,D,Z), c(D,E,Z), c(A,C,Z), c(C,E,Z),   l(A,B,D,R), l(B,D,E,R), l(A,C,E,-R).
:- ins(pent,Z,I),  A<B,B<C,C<D,D<E,  c(A,C,Z), c(C,D,Z), c(D,E,Z), c(A,B,Z), c(B,E,Z),   l(A,C,D,R), l(C,D,E,R), l(A,B,E,-R).

#show l/4.
#show c/3.

%l(A,B,C,1)  :- A<B,B<C,C<n, xy(A,X1,Y1), xy(B,X2,Y2), xy(C,X3,Y3), (X1+X2)*(Y1-Y2)+(X2+X3)*(Y2-Y3)+(X3+X1)*(Y3-Y1) > 0.
%l(A,B,C,-1) :- A<B,B<C,C<n, xy(A,X1,Y1), xy(B,X2,Y2), xy(C,X3,Y3), (X1+X2)*(Y1-Y2)+(X2+X3)*(Y2-Y3)+(X3+X1)*(Y3-Y1) < 0.
