% for the given K, M is a subset of the roads that connects all cities
% forming a tree and total length of the roads in M is at most K.

mainroads(K,L):-
	cities(C),length(C,NCT), concat(_,[C1|_],C),
	mainroads(0,K,L,[C1],1,NCT).

% Km act, max Km, roads list, act cities list, num cities act, num cities tot
mainroads(K,KM,[],_,NCT,NCT):- K =< KM.
mainroads(K,KM,[[C1,C2]|L],C,NCA,NCT):-
	road(C1,C2,RK),
	(
		\+concat(_,[C1|_],C),concat(_,[C2|_],C),CN is C1;
		concat(_,[C1|_],C),\+concat(_,[C2|_],C),CN is C2
	),
	K2 is K + RK, NCA2 is NCA + 1,
	mainroads(K2,KM,L,[CN|C],NCA2,NCT).


% Input
cities([1,2,3,4]).
road(1,2, 10).
road(1,4, 20).
road(2,3, 25).
road(3,4, 12). % road between cities 1 and 2 of 10km


% help functions
concat([],L,L).
concat([X|L1],L2,[X|L3]):- concat(L1,L2,L3).