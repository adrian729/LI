camino(E,E,C,C,_,P,P).
camino(EstadoActual,EstadoFinal,CaminoHastaAhora,CaminoTotal,N,P,MP):-
	P < MP, unPaso(EstadoActual,EstSiguiente,N), P2 is P + 1,
	\+member(EstSiguiente,CaminoHastaAhora),
	camino(EstSiguiente,EstadoFinal,[EstSiguiente|CaminoHastaAhora],CaminoTotal,N,P2,MP).
% Para permitir volver al inicio si es el estado final
camino(EstadoActual,EstadoFinal,CaminoHastaAhora,CaminoTotal,N,P,MP):-
	MP =:= (P + 1), unPaso(EstadoActual,EstadoFinal,N),
	camino(EstadoFinal,EstadoFinal,[EstadoFinal|CaminoHastaAhora],CaminoTotal,N,MP,MP).

solucionOptima:-
	solucionOptima(33,331).
% N pel tamany del taulell, P el nombre de pasos exactes que volem, M el maxim intents.
solucionOptima(N,MP):-
	N > 0, MP >= 0,
	camino([0,0],[5,4],[[0,0]],C,N,0,MP),!,
	write(C).

% P0
unPaso([X,Y],[X2,Y2],_):-
	X > 0, Y > 1,
	X2 is X - 1, Y2 is Y - 2.
% P1
unPaso([X,Y],[X2,Y2],_):-
	X > 1, Y > 0,
	X2 is X - 2, Y2 is Y - 1.
 % P2
unPaso([X,Y],[X2,Y2],N):-
	X > 1, Y < (N - 1),
	X2 is X - 2, Y2 is Y + 1.
% P3
unPaso([X,Y],[X2,Y2],N):-
	X > 0, Y < (N - 2),
	X2 is X - 1, Y2 is Y + 2.
% P4
unPaso([X,Y],[X2,Y2],N):-
	X < (N - 1), Y < (N - 2),
	X2 is X + 1, Y2 is Y + 2.
% P5
unPaso([X,Y],[X2,Y2],N):-
	X < (N - 2), Y < (N - 1),
	X2 is X + 2, Y2 is Y + 1.
% P6
unPaso([X,Y],[X2,Y2],N):-
	X < (N - 2), Y > 0,
	X2 is X + 2, Y2 is Y - 1.
% P7
unPaso([X,Y],[X2,Y2],N):-
	X < (N - 1), Y > 1,
	X2 is X + 1, Y2 is Y - 2.


%     - 3 - 4 - 4,4
%     2 - - - 5
%     - - I - -
%     1 - - - 6
% 0,0 - 0 - 7 -



% help functions

nat(0).
nat(N):- nat(N1), N is N1 + 1.