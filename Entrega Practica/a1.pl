camino(E,E,C,C).
camino(EstadoActual,EstadoFinal,CaminoHastaAhora,CaminoTotal):-
	unPaso(EstadoActual,EstSiguiente),
	\+member(EstSiguiente,CaminoHastaAhora),
	camino(EstSiguiente,EstadoFinal,[EstSiguiente|CaminoHastaAhora],CaminoTotal).

solucionOptima:-
	nat(N),
	camino([0,0],[0,4],[[0,0]],C),
	length(C,N),!,
	write(C).

% llenar X
unPaso([X,Y],[5,Y]):- X < 5.
% llenar Y
unPaso([X,Y],[X,8]):- Y < 8.
% vaciar X
unPaso([X,Y],[0,Y]):- X > 0.
% vaciar Y
unPaso([X,Y],[X,0]):- Y > 0.
% verter X
unPaso([X,Y],[X2,8]):-
	X > 0, Y < 8,
	(X + Y) >= 8, % buidar X a Y vesa (o dona 8 just)
	X2 is X + (Y - 8).
unPaso([X,Y],[0,Y2]):-
	X > 0, Y < 8,
	(X + Y) < 8, % buidar X a Y no vesa ni dona 8 just
	Y2 is X + Y.
% verter Y
unPaso([X,Y],[5,Y2]):-
	X < 5, Y > 0,
	(X + Y) >= 5, %buidar Y a X vesa (o dona 5 just)
	Y2 is X + (Y - 5).
unPaso([X,Y],[X2,0]):-
	X < 5, Y > 0,
	(X + Y) < 5, % buidar X a Y no vesa ni dona 5 just
	X2 is X + Y.





% help functions

nat(0).
nat(N):- nat(N1), N is N1 + 1.