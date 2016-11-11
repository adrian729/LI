% solve([[4,1],[4,2],[5,2],[5,3]]).
% Sol:
% [5,3] jumps over [4,2]
% [3,1] jumps over [4,1]
% [5,1] jumps over [5,2]

solve(L):-
	length(L,N),
	solve(L,LR,N,5),
	printLR(LR).
solve(_,_,1,_):-!.
solve(L,[[B1,B2]|LR],N,M):-
	jump(L,L2,M,B1,B2),
	N2 is N - 1,
	solve(L2,LR,N2,M),!.

printLR([]):-!.
printLR([[B1,B2]|LR]):-
	write(B1), write(" jumps over "), writeln(B2),
	printLR(LR),!.

% Moviments possibles
% Falta mirar que hi hagi alguna bola a la posicio intermitja i que NO hi ha cap a la final!

% boles inicials, boles despres del salt.
% jump dalt esq
jump(LI,LF,_,[X1,Y1],[X2,Y2]):-
	concat(L1E,[[X1,Y1]|L1D],LI), X1 > 2, Y1 > 2, 	 		 % bola que salta i restriccions sobre la bola, resta de llista sense b1 esq i dreta
	X2 is X1 - 1, Y2 is Y1 - 1, concat(L1E,L1D,L1),  		 % pos de la bola intermitja i resta de la llista
	concat(L2E,[[X2,Y2]|L2D],L1),					 		 % bola 2 existeix i resta llista esq i dreta sense bola 2 (ni bola 1)
	X3 is X1 - 2, Y3 is Y1 - 2, \+concat(_,[[X3,Y3]|_],L1),  % pos final del salt, restriccions pos final, NO existeix cap bola on ha dacabar el salt
	concat([[X3,Y3]|L2E],L2D,LF).

% jump dalt dreta
jump(LI,LF,_,[X1,Y],[X2,Y]):-
	concat(L1E,[[X1,Y]|L1D],LI), X1 > 2, 	 				  % bola que salta i restriccions sobre la bola, resta de llista sense b1 esq i dreta
	X2 is X1 - 1, concat(L1E,L1D,L1),  						  % pos de la bola intermitja i resta de la llista
	concat(L2E,[[X2,Y]|L2D],L1),					 		  % bola 2 existeix i resta llista esq i dreta sense bola 2 (ni bola 1)
	X3 is X1 - 2, Y =< X3, \+concat(_,[[X3,Y]|_],L1),		  % pos final del salt, restriccions pos final, NO existeix cap bola on ha dacabar el salt
	concat([[X3,Y]|L2E],L2D,LF).

% jump dreta
jump(LI,LF,_,[X,Y1],[X,Y2]):-
	concat(L1E,[[X,Y1]|L1D],LI), Y1 < (X - 1), 	 			  % bola que salta i restriccions sobre la bola, resta de llista sense b1 esq i dreta
	Y2 is Y1 + 1, concat(L1E,L1D,L1),  						  % pos de la bola intermitja i resta de la llista
	concat(L2E,[[X,Y2]|L2D],L1),					 		  % bola 2 existeix i resta llista esq i dreta sense bola 2 (ni bola 1)
	Y3 is Y1 + 2, \+concat(_,[[X,Y3]|_],L1), 				  % pos final del salt, restriccions pos final, NO existeix cap bola on ha dacabar el salt
	concat([[X,Y3]|L2E],L2D,LF).

% jump baix dreta
jump(LI,LF,M,[X1,Y1],[X2,Y2]):-
	concat(L1E,[[X1,Y1]|L1D],LI), X1 < (M - 1), Y1 < (M - 1), % bola que salta i restriccions sobre la bola, resta de llista sense b1 esq i dreta
	X2 is X1 + 1, Y2 is Y1 + 1, concat(L1E,L1D,L1),  		  % pos de la bola intermitja i resta de la llista
	concat(L2E,[[X2,Y2]|L2D],L1),					 		  % bola 2 existeix i resta llista esq i dreta sense bola 2 (ni bola 1)
	X3 is X1 + 2, Y3 is Y1 + 2, \+concat(_,[[X3,Y3]|_],L1),   % pos final del salt, restriccions pos final, NO existeix cap bola on ha dacabar el salt
	concat([[X3,Y3]|L2E],L2D,LF).

% jump baix esq
jump(LI,LF,M,[X1,Y],[X2,Y]):-
	concat(L1E,[[X1,Y]|L1D],LI), X1 < (M - 1), 	 		 	  % bola que salta i restriccions sobre la bola, resta de llista sense b1 esq i dreta
	X2 is X1 + 1, concat(L1E,L1D,L1),  						  % pos de la bola intermitja i resta de la llista
	concat(L2E,[[X2,Y]|L2D],L1),					 		  % bola 2 existeix i resta llista esq i dreta sense bola 2 (ni bola 1)
	X3 is X1 + 2, \+concat(_,[[X3,Y]|_],L1),  				  % pos final del salt, restriccions pos final, NO existeix cap bola on ha dacabar el salt
	concat([[X3,Y]|L2E],L2D,LF).

% jump esq
jump(LI,LF,_,[X,Y1],[X,Y2]):-
	concat(L1E,[[X,Y1]|L1D],LI), Y1 > 2, 	 				  % bola que salta i restriccions sobre la bola, resta de llista sense b1 esq i dreta
	Y2 is Y1 - 1, concat(L1E,L1D,L1),  		 				  % pos de la bola intermitja i resta de la llista
	concat(L2E,[[X,Y2]|L2D],L1),					 		  % bola 2 existeix i resta llista esq i dreta sense bola 2 (ni bola 1)
	Y3 is Y1 - 2, \+concat(_,[[X,Y3]|_],L1),  				  % pos final del salt, restriccions pos final, NO existeix cap bola on ha dacabar el salt
	concat([[X,Y3]|L2E],L2D,LF).


% help functions
concat([],L,L).
concat([X|L1],L2,[X|L3]):- concat(L1,L2,L3).