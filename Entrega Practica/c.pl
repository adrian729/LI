% max numProds, list prods
shopping(K,L):- shopping(0,K,L,[],0).
% numProds act, max numProds, list prods, list nuts, numNuts
shopping(_,_,[],_,NN):-
	numNutrients(NN2), NN >= NN2.
shopping(K,KM,[P|LI],N,NN):-
	K < KM, K2 is K + 1, product(P,PN),
	addNuts(PN,N,N2,A),
	NN2 is NN + A, A > 0,
	shopping(K2,KM,LI,N2,NN2),
	\+concat(_,[P|_],LI).


% Nuts Prod, Nuts act, Nuts new, num nuevos nuts
addNuts([],N,N,0):-!.
addNuts([X|PN],N,[X|N2],A):-
	\+concat(_,[X|_],N),
	addNuts(PN,N,N2,A2),!,
	A is A2 + 1.
addNuts([_|PN],N,N2,A):-
	addNuts(PN,N,N2,A),!.


% Input
numNutrients(8).
product(milk,[2,4,6]).
product(cheese,[2,4,7]).
product(meal,[1,8]).
product(chocolate,[3,5]).
product(burger,[7]).
product(sugar,[1,7,5]).


% help functions
concat([],L,L).
concat([X|L1],L2,[X|L3]):- concat(L1,L2,L3).