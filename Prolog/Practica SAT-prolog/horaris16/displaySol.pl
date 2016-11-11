extraBlank(N):- 
    N < 10, !, write(' ').
extraBlank(_).

drawTail(Y, Hour):-
    Hour > 48, 
    write('  Year: '), write(Y), nl.
drawTail(_, _).

drawCell(Y, S, M):-
    member(cls-C-L-S, M),
    course(Y, C, _, _, _), !,
    write(' '), extraBlank(C), write(C), write(' - '),
    extraBlank(L), write(L), 
    write('  ['), member(cr-C-R, M), write('R:'), extraBlank(R), write(' '), write(R), write(']'),
    write('  ['), member(ct-C-T, M), write('T:'), extraBlank(T), write(' '), write(T), write(']'),
    write(' ').
drawCell(_, _, _):- 
    write('                           ').    

drawRow(Row, _):-
    1 is Row mod 2,
    H is Row // 2 + 8, 
    extraBlank(H), 
    write(' '), write(H), write(':00 '), 
    between(1, 141, _), write('='), 
    fail.
drawRow(Row, _):-
    1 is Row mod 2, !, nl.

drawRow(Row, M):-
    year(Y),
    write('       |'),
    between(0, 4, Day), 
    Hour is Row // 2 + Day * 12,
    drawCell(Y, Hour, M), 
    write('|'), 
    drawTail(Y, Hour), 
    fail.
drawRow(_, _).

drawHeader:-
    nl, nl, 
    write(' Ouput format: Course - Lecture [R: Room] [T: Teacher]'), 
    nl, nl, 
    write('                 Monday                      Tuesday                     Wednesday                    Thursday                   Friday   ').


displaySchedule(M):-
    drawHeader, nl,
    between(1, 25, Row), 
    drawRow(Row, M), 
    fail.

