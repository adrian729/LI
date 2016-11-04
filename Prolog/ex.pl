% Provando
% uso shell: swipl -s file.pl



% EX2
% prod(L,P)
% "P es el producto de los elementos de L"
prod([],_):-fail.
prod([X],X).
prod([X|L],P):-
	prod(L,R),
	P is R*X,!.



% EX3
% pescalar(L1,L2,P)
% "P es el producto escalar de los dos vectores L1 y L2"
pescalar([],_,_):-fail.
pescalar(_,[],_):-fail.
pescalar([X1],[X2],P):-
	P is X1*X2.
pescalar([X1|L1],[X2|L2],P):-
	pescalar(L1,L2,R),
	P is X1*X2 + R,!.



% EX4
% "Interseccion y union conjuntos" (usando listas para representar los conjuntos)

interseccion([],_,[]).
interseccion([X|L1],L2,[X|L3]):-
	concat(_,[X|_],L2),!,interseccion(L1,L2,L3).
interseccion([_|L1],L2,L3):-
	interseccion(L1,L2,L3).

union([],L2,L2).
union([X|L1],L2,L3):-
	concat(_,[X|_],L2),!,union(L1,L2,L3),!.
union([X|L1],L2,[X|L3]):-
	union(L1,L2,L3),!.



% EX5
% Usando "concat"
concat([],L,L).
concat([X|L1],L2,[X|L3]):- concat(L1,L2,L3).
% 1. "Ultimo lista dada"
last([X],X):-!.
last([_|L],R):-
	concat(L,[],L3),
	last(L3,R),!.

ultimo(L,X):- concat(_,[X],L).

% 2. "Inverso lista dada"
inv([],[]).
% -OPCION1
%inv([X|L1],L2):-
%	inv(L1,L3),
%	concat(L3,[X],L2).
% -OPCION2
inv(L1,[X|L2]):-
	concat(L3,[X],L1),
	inv(L3,L2).



% EX6
%fib(N,F)
% "Fibonacci"
fib(1,1).
fib(2,1).
fib(N,F):-
	N > 2,
	N1 is N - 1, N2 is N - 2,
	fib(N1,R1), fib(N2,R2),
	F is R1 + R2.



% EX7
% dados(P,N,L)
% "La lista L expresa una manera de sumar P puntos lanzando N dados"

% Generador de dado de C caras.
dado(6,[1,2,3,4,5,6]):-!.
dado(1,[1]):-!.
dado(C,[C|D]):- C2 is C - 1, dado(C2,D).

dados(0,0,[]):-!.
dados(_,0,_):- fail.
dados(P,N,[X|L]):-
	dado(6,D), concat(_,[X|_],D),
	P2 is P - X, P2 > -1,
	N2 is N - 1,
	dados(P2,N2,L).



% EX8
% suma_demas(L)
% "Existe algun elemento en L que equivale a la suma de todos los demas elementos"
suma_demas(L):- concat(L1,[X|L2],L), concat(L1, L2, L3), suma_lista(L3,X).

suma_lista([],0).
suma_lista([X|L],R):-suma_lista(L,R2), R is X + R2.



% EX9
% suma_ants(L)
% "Existe algun elemento que es suma de todos los anteriores"
suma_ants(L):- concat(L1,[X|_],L), suma_lista(L1,X).



% EX10
% card(L)
% "Dada una lista, escribe una lista de listas con para cada elemento el numero de veces que se repite"
card(L):- create_card(L,LR), writeln(LR),!.

create_card([],[]).
create_card([X|L],[[X,C]|LR]):- 
	seek_and_destroy(X,L,L2,C),
	create_card(L2,LR),!.

seek_and_destroy(_,[],[],1).
seek_and_destroy(X,[X|L],L2,C):- seek_and_destroy(X,L,L2,C2), C is C2 + 1.
seek_and_destroy(X,[Y|L],[Y|L2],C):- seek_and_destroy(X,L,L2,C),!.



% EX11
% esta_ordenada(L)
% "La lista L esta ordenada de menor a mayor"
esta_ordenada(_,[]):- !.
esta_ordenada(X,[Y|L]):- X < Y, esta_ordenada(Y,L),!.
esta_ordenada(X,[Y|L]):- X = Y, esta_ordenada(Y,L),!.
esta_ordenada([]).
esta_ordenada([X|L]):- esta_ordenada(X,L).



% EX12
% ordenacion(L1,L2)
% "L2 es L1 ordenada de menor a mayor"
permutacion([],[]).
permutacion(L,[X|P]):- concat(L1,[X|L2],L), concat(L1,L2,R), permutacion(R,P).

ordenacion(L1,L2):- permutacion(L1,L2), esta_ordenada(L2),!.



% EX13 factorial.



% EX14

% insercion(X,L1,L2)
% "L2 es L1 al insertar X en su sitio (L1 ordenada de menor a mayor)."
insercion(X,[],[X]).
insercion(X,[Y|L1],[X|[Y|L1]]):- X < Y,!.
insercion(X, [Y|L1], [Y|L2]):- insercion(X,L1,L2),!.

% ordenacion_ins(L1,L2)
% "L2 es L1 ordenada de menor a mayor"
ordenacion_ins([X],[X]):-!.
ordenacion_ins([X|L1],LO):- ordenacion_ins(L1,L2), insercion(X,L2,LO).



% EX15 cost O(n^2).



% EX16
% ordenacion_merge(L1,L2)
% "L2 es L1 ordenada, usando un mege sort"

llength([],0).
llength([_|L],N):- llength(L,N2), N is N2 + 1,!.

ssplit([],[],[]):-!.
ssplit([A],[A],[]):-!.
ssplit([A,B|L],[A|La],[B|Lb]):- ssplit(L,La,Lb),!.

merge2([],L2,L2):-!.
merge2(L1,[],L1):-!.
merge2([X|L1],[Y|L2],[X|L3]):- X < Y, merge2(L1,[Y|L2],L3),!.
merge2(L1, [Y|L2],[Y|L3]):- merge2(L1, L2, L3),!.

ordenacion_merge([],[]):-!.
ordenacion_merge([X],[X]):-!.
ordenacion_merge(L1,L2):-
	ssplit(L1,LL,LR),
	ordenacion_merge(LL,LL2), ordenacion_merge(LR,LR2),
	merge2(LL2,LR2,L2),!.
