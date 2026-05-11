pt(0..n-1).

% Knuth's axioms for monotone signotopes (order types)
1{l(A,B,C,R): R=(-1;1)}1 :- pt(A),pt(B),pt(C), A<B,B<C.

:- l(A,B,C,R), l(A,C,D,-R), l(B,C,D,R).
:- l(A,B,C,R), l(A,B,D,-R), l(A,C,D,R).
:- l(A,B,C,R), l(A,B,D,-R), l(B,C,D,R).
:- l(A,B,D,R), l(A,C,D,-R), l(B,C,D,R).

% Symmetry breaking
:- l(1,B,C,-1), sb!=off.

% Color assignment
select(red,(red1;red2); blue,(blue1;blue2)).
1{c(A,Z): select(Z,_)}1 :- pt(A).

% Interior point definition for x-sorted points
i(A,B,C,X) :- l(A,X,B,R), l(A,X,C,-R), B<C.
i(A,B,C,X) :- l(B,X,C,R), l(A,X,C,-R), A<B.

ne(A,B,C) :- i(A,B,C,X).

%--- Structure: Cravat ---
:- select(Z,cravat),    l(A,B,C,R), l(B,C,D,R),   c(A,Z),c(B,Z),c(C,Z),c(D,Z),  A<B,B<C,C<D,  not ne(A,B,C), not ne(A,C,D).
:- select(Z,cravat),    l(A,B,D,R), l(A,C,D,-R),  c(A,Z),c(B,Z),c(C,Z),c(D,Z),  A<B,B<C,C<D,  not ne(A,B,C), not ne(B,C,D).

%--- Structure: Necklace ---
:- select(Z,necklace),  l(A,B,C,R), l(B,C,D,R),   c(A,Z),c(B,Z),c(C,Z),c(D,Z),  A<B,B<C,C<D,   not ne(A,B,C), not ne(A,B,D).
:- select(Z,necklace),  l(A,B,C,R), l(B,C,D,R),   c(A,Z),c(B,Z),c(C,Z),c(D,Z),  A<B,B<C,C<D,   not ne(A,B,C), not ne(B,C,D).
:- select(Z,necklace),  l(A,B,C,R), l(B,C,D,R),   c(A,Z),c(B,Z),c(C,Z),c(D,Z),  A<B,B<C,C<D,   not ne(A,C,D), not ne(A,B,D).
:- select(Z,necklace),  l(A,B,C,R), l(B,C,D,R),   c(A,Z),c(B,Z),c(C,Z),c(D,Z),  A<B,B<C,C<D,   not ne(A,C,D), not ne(B,C,D).
:- select(Z,necklace),  l(A,B,D,R), l(A,C,D,-R),  c(A,Z),c(B,Z),c(C,Z),c(D,Z),  A<B,B<C,C<D,   not ne(A,B,D), not ne(A,B,C).
:- select(Z,necklace),  l(A,B,D,R), l(A,C,D,-R),  c(A,Z),c(B,Z),c(C,Z),c(D,Z),  A<B,B<C,C<D,   not ne(A,B,D), not ne(B,C,D).
:- select(Z,necklace),  l(A,B,D,R), l(A,C,D,-R),  c(A,Z),c(B,Z),c(C,Z),c(D,Z),  A<B,B<C,C<D,   not ne(A,C,D), not ne(A,B,C).
:- select(Z,necklace),  l(A,B,D,R), l(A,C,D,-R),  c(A,Z),c(B,Z),c(C,Z),c(D,Z),  A<B,B<C,C<D,   not ne(A,C,D), not ne(B,C,D).

%--- Structure: Bowtie (Self-intersecting 4-gon) ---
:- select(Z,bowtie),    l(A,B,C,R), l(B,C,D,R),   c(A,Z),c(B,Z),c(C,Z),c(D,Z),  A<B,B<C,C<D,  {pt(X):i(A,B,C,X),i(A,B,D,X)}0, {pt(X):i(A,C,D,X),i(B,C,D,X)}0.
:- select(Z,bowtie),    l(A,B,C,R), l(B,C,D,R),   c(A,Z),c(B,Z),c(C,Z),c(D,Z),  A<B,B<C,C<D,  {pt(X):i(A,B,C,X),i(B,C,D,X)}0, {pt(X):i(A,B,D,X),i(A,C,D,X)}0.
:- select(Z,bowtie),    l(A,B,D,R), l(A,C,D,-R),  c(A,Z),c(B,Z),c(C,Z),c(D,Z),  A<B,B<C,C<D,  {pt(X):i(A,B,C,X),i(A,B,D,X)}0, {pt(X):i(A,C,D,X),i(B,C,D,X)}0.
:- select(Z,bowtie),    l(A,B,D,R), l(A,C,D,-R),  c(A,Z),c(B,Z),c(C,Z),c(D,Z),  A<B,B<C,C<D,  {pt(X):i(A,B,C,X),i(A,C,D,X)}0, {pt(X):i(A,B,D,X),i(B,C,D,X)}0.

%--- Structure: Skirt ---
:- select(Z,skirt),     l(A,B,D,R), l(A,B,C,-R),  c(A,Z),c(B,Z),c(C,Z),c(D,Z),  A<B,B<C,C<D,  not ne(A,B,C), not ne(A,B,D), not ne(B,C,D).
:- select(Z,skirt),     l(A,C,D,R), l(B,C,D,-R),  c(A,Z),c(B,Z),c(C,Z),c(D,Z),  A<B,B<C,C<D,  not ne(A,B,C), not ne(A,C,D), not ne(B,C,D).

%--- Structure: Pant ---
:- select(Z,pant),      l(A,B,D,R), l(A,B,C,-R),  c(A,Z),c(B,Z),c(C,Z),c(D,Z),  A<B,B<C,C<D,  not ne(A,B,C), not ne(A,B,D).
:- select(Z,pant),      l(A,B,D,R), l(A,B,C,-R),  c(A,Z),c(B,Z),c(C,Z),c(D,Z),  A<B,B<C,C<D,  not ne(A,B,C), not ne(B,C,D).
:- select(Z,pant),      l(A,B,D,R), l(A,B,C,-R),  c(A,Z),c(B,Z),c(C,Z),c(D,Z),  A<B,B<C,C<D,  not ne(A,B,D), not ne(B,C,D).
:- select(Z,pant),      l(A,C,D,R), l(B,C,D,-R),  c(A,Z),c(B,Z),c(C,Z),c(D,Z),  A<B,B<C,C<D,  not ne(A,B,C), not ne(A,C,D).
:- select(Z,pant),      l(A,C,D,R), l(B,C,D,-R),  c(A,Z),c(B,Z),c(C,Z),c(D,Z),  A<B,B<C,C<D,  not ne(A,B,C), not ne(B,C,D).
:- select(Z,pant),      l(A,C,D,R), l(B,C,D,-R),  c(A,Z),c(B,Z),c(C,Z),c(D,Z),  A<B,B<C,C<D,  not ne(A,C,D), not ne(B,C,D).

#show l/4.
#show c/2.
