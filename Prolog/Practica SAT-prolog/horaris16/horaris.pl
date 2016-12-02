:-include(entradaHoraris).
:-include(displaySol).
:-dynamic(varNumber/3).
symbolicOutput(0). % set to 1 to see symbolic output only; 0 otherwise.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% We want to compute the weekly schedule of a university. Classes should
% be allocated from 8h to 20h (12 hours per day) from Monday to
% Friday. File entradaHoraris.pl contains all necessary input data.

%  - there is a certain number of years, courses, rooms and teachers.
%  - each course belongs to a certain year, has a certain number of
%     1-hour lectures per week (at most 1 lecture per day), can be taught
%     only at some rooms and only by some teachers.
%  - the courses of a year can only be taught in the morning (8-14)
%     or in the afternoon (14-20).
%  - every teacher expresses his availability to teach (morning, afternoon or both).

% There is an additional set of constraints to be considered:

%  - all lectures of a course are taught by the same teacher and at the same room 
%  - it is not possible to hold two lectures at the same room simultaneously,
%    and similarly, a teacher cannot teach two lectures simultaneously
%  - at most 5 lectures of a given year can be taught every day
%  - two lectures belonging to the same year cannot be taught at the same time
%
%  File displaySol.pl contains the predicate drawSchedule, which will output
%  the resulting schedule in a readable format. If your code is incorrect and
%  produces a wrong schedule, its output is unpredictable.

%%%%%% Some helpful definitions to make the code cleaner:
day(D)               :- between(1,5,D).
hour(H)              :- between(1,12,H).
year(Y)              :- numYears(N), between(1,N,Y).
course(C)            :- numCourses(N), between(1,N,C).
teacher(T)           :- numTeachers(N), between(1,N,T).
room(R)              :- numRooms(N), between(1,N,R).
lectureOfCourse(C,L) :- course(_,C,N,_,_), between(1,N,L). % given C, computes L
roomOfCourse(C,RC)   :- course(_,C,_,R,_), concat(_,[RC|_],R). %given C, computes RC
teacherOfCourse(C,TC) :- course(_,C,_,_,T), concat(_,[TC|_],T). %given C, computes RC
courseOfYear(Y,C)    :- course(Y,C,_,_,_). % given Y, computes C
timeOfCourse(C,Time) :- courseOfYear(Y,C), year(Y,Time).

slot(S)                 :- between(1,60,S). % Monday slots [1,..,12], Tuesday [13,..24]
slotOfDay(D,S)          :- hour(H), S is (D-1)*12 + H. % given D, computes S
morningSlotOfDay(D,S)   :- between(1,6,H),  S is (D-1)*12 + H. % given D, computes S
afternoonSlotOfDay(D,S) :- between(7,12,H), S is (D-1)*12 + H. % given D, computes S
timeSlotOfDay(D,S,morning) :- morningSlotOfDay(D,S).
timeSlotOfDay(D,S,afternoon) :- afternoonSlotOfDay(D,S).
morningSlot(S)          :- slot(S), S12 is (S - 1) mod 12, between(0,5,S12).
afternoonSlot(S)        :- slot(S), S12 is (S - 1) mod 12, between(6,11,S12).
timeSlot(S,morning)     :- morningSlot(S).
timeSlot(S,afternoon)   :- afternoonSlot(S).

%% other
concat([],L2,L2).
concat([X|L1],L2,[X|L3]):- concat(L1,L2,L3).

%%%%%%  Variables: It is mandatory to use AT LEAST these variables!
% ct-C-T    : course is taught by teacher T
% cr-C-R    : course C is taught at room R
% cls-C-L-S : lecture L of course C is given at slot S (slots between 1 and 60)

% ycs-Y-C-S
% cs-C-S
% ys-Y-S

writeClauses:-
    defineYearPerCoursePerSlot,
    defineCoursePerSlot,
    defineYearPerSlot,
    oneSlotPerLecture,
    oneLessCourseLecturePerDay,
    oneYearCoursePerSlot,
    atMost5YearLecturesDay,
    oneRoomPerCourse,
    justOnceRoomPerSlot,
    oneTeacherPerCourse,
    justOnceTeacherPerSlot,
    true.

% define new vars:
% ycs-Y-C-S
defineYearPerCoursePerSlot:-
    year(Y,Time), courseOfYear(Y,C), timeSlot(S,Time),
    findall(cls-C-L-S,lectureOfCourse(C,L),Lits),
    expressOr(ycs-Y-C-S,Lits),
    fail.
defineYearPerCoursePerSlot.
% cs-C-S
defineCoursePerSlot:-
    course(C), timeOfCourse(C,Time), timeSlot(S,Time),
    findall(cls-C-L-S,lectureOfCourse(C,L),Lits),
    expressOr(cs-C-S,Lits),
    fail.
defineCoursePerSlot.
% ys-Y-S
defineYearPerSlot:-
    year(Y,Time), timeSlot(S,Time),
    findall(cls-C-L-S,(courseOfYear(Y,C),lectureOfCourse(C,L)),Lits),
    expressOr(ys-Y-S,Lits),
    fail.
defineYearPerSlot.

% each lecture only one slot && no lectures on wrong year time
oneSlotPerLecture:-
    course(C), lectureOfCourse(C,L), timeOfCourse(C,Time),
    findall(cls-C-L-S,timeSlot(S,Time),Lits), exactly(1,Lits),
    fail.
oneSlotPerLecture.
% at most one course lecture each day
oneLessCourseLecturePerDay:-
    course(C), day(D), timeOfCourse(C,Time),
    findall(cls-C-L-S,(lectureOfCourse(C,L),timeSlotOfDay(D,S,Time)),Lits), atMost(1,Lits),
    fail.
oneLessCourseLecturePerDay.
% at most one year course lecture each slot
oneYearCoursePerSlot:-
    year(Y,Time),
    timeSlot(S,Time),
    findall(ycs-Y-C-S,courseOfYear(Y,C),Lits), atMost(1,Lits),
    fail.
oneYearCoursePerSlot.
% at most 5 lectures of a given year can be taught every day
atMost5YearLecturesDay:-
    year(Y,Time), day(D),
    findall(\+ys-Y-S,timeSlotOfDay(D,S,Time),Lits),
    atLeast(1,Lits),
    fail.
atMost5YearLecturesDay.

% each course only one room
oneRoomPerCourse:-
    course(C),
    findall(cr-C-R,roomOfCourse(C,R),Lits), exactly(1,Lits),
    fail.
oneRoomPerCourse.
% it is not possible to hold two lectures at the same room simultaneously
justOnceRoomPerSlot:-
    timeOfCourse(C1,Time), timeOfCourse(C2,Time), C1 < C2,
    roomOfCourse(C1,R), roomOfCourse(C2,R),
    timeSlot(S,Time),
    writeClause([\+cs-C1-S,\+cs-C2-S,\+cr-C1-R,\+cr-C2-R]),
    fail.
justOnceRoomPerSlot.

% each course only one teacher && with same time as the course-year time
oneTeacherPerCourse:-
    course(C), timeOfCourse(C,Time),
    findall(ct-C-T,(teacherOfCourse(C,T),(teacher(T,Time);teacher(T,both))),Lits), exactly(1,Lits),
    fail.
oneTeacherPerCourse.
% a teacher cannot teach two lectures simultaneously
justOnceTeacherPerSlot:-
    timeOfCourse(C1,Time), timeOfCourse(C2,Time), C1 < C2,
    (teacher(T,Time);teacher(T,both)), teacherOfCourse(C1,T), teacherOfCourse(C2,T),
    timeSlot(S,Time),
    writeClause([\+cs-C1-S,\+cs-C2-S,\+ct-C1-T,\+ct-C2-T]),
    fail.
justOnceTeacherPerSlot.


%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% show the solution. Here M contains the literals that are true in the model:

displaySol(M):-write(M),nl,fail.
displaySol(M):-displaySchedule(M),fail.
displaySol(_).


%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Express that Var is equivalent to the disjunction of Lits:
expressOr( Var, Lits ):- member(Lit,Lits), negate(Lit,NLit), writeClause([ NLit, Var ]), fail.
expressOr( Var, Lits ):- negate(Var,NVar), writeClause([ NVar | Lits ]),!.


%%%%%% Cardinality constraints on arbitrary sets of literals Lits:

exactly(K,Lits):- atLeast(K,Lits), atMost(K,Lits),!.

atMost(K,Lits):-   % l1+...+ln <= k:  in all subsets of size k+1, at least one is false:
    negateAll(Lits,NLits), 
    K1 is K+1,    subsetOfSize(K1,NLits,Clause), writeClause(Clause),fail.
atMost(_,_).

atLeast(K,Lits):-  % l1+...+ln >= k: in all subsets of size n-k+1, at least one is true:
    length(Lits,N),
    K1 is N-K+1,  subsetOfSize(K1, Lits,Clause), writeClause(Clause),fail.
atLeast(_,_).

negateAll( [], [] ).
negateAll( [Lit|Lits], [NLit|NLits] ):- negate(Lit,NLit), negateAll( Lits, NLits ),!.

negate(\+Lit,  Lit):-!.
negate(  Lit,\+Lit):-!.

subsetOfSize(0,_,[]):-!.
subsetOfSize(N,[X|L],[X|S]):- N1 is N-1, length(L,Leng), Leng>=N1, subsetOfSize(N1,L,S).
subsetOfSize(N,[_|L],   S ):-            length(L,Leng), Leng>=N,  subsetOfSize( N,L,S).


%%%%%% main:

main:-  symbolicOutput(1), !, writeClauses, halt.   % print the clauses in symbolic form and halt
main:-  initClauseGeneration,
        tell(clauses), writeClauses, told,          % generate the (numeric) SAT clauses and call the solver
	tell(header),  writeHeader,  told,
	numVars(N), numClauses(C),
	write('Generated '), write(C), write(' clauses over '), write(N), write(' variables. '),nl,
	shell('cat header clauses > infile.cnf',_),
	write('Calling solver....'), nl, 
	shell('picosat -v -o model infile.cnf', Result),  % if sat: Result=10; if unsat: Result=20.
	treatResult(Result),!.

treatResult(20):- write('Unsatisfiable'), nl, halt.
treatResult(10):- write('Solution found: '), nl, see(model), symbolicModel(M), seen, displaySol(M), nl,nl,halt.

initClauseGeneration:-  %initialize all info about variables and clauses:
    retractall(numClauses(   _)), 
    retractall(numVars(      _)), 
    retractall(varNumber(_,_,_)),
    assert(numClauses( 0 )), 
    assert(numVars(    0 )),     !.

writeClause([]):- symbolicOutput(1),!, nl.
writeClause([]):- countClause, write(0), nl.
writeClause([Lit|C]):- w(Lit), writeClause(C),!.
w( Lit ):- symbolicOutput(1), write(Lit), write(' '),!.
w(\+Var):- var2num(Var,N), write(-), write(N), write(' '),!.
w(  Var):- var2num(Var,N),           write(N), write(' '),!.


% given the symbolic variable V, find its variable number N in the SAT solver:
var2num(V,N):- hash_term(V,Key), existsOrCreate(V,Key,N),!.
existsOrCreate(V,Key,N):- varNumber(Key,V,N),!.                            % V already existed with num N
existsOrCreate(V,Key,N):- newVarNumber(N), assert(varNumber(Key,V,N)), !.  % otherwise, introduce new N for V

writeHeader:- numVars(N),numClauses(C), write('p cnf '),write(N), write(' '),write(C),nl.

countClause:-     retract( numClauses(N0) ), N is N0+1, assert( numClauses(N) ),!.
newVarNumber(N):- retract( numVars(   N0) ), N is N0+1, assert(    numVars(N) ),!.
 
% Getting the symbolic model M from the output file:
symbolicModel(M):- get_code(Char), readWord(Char,W), symbolicModel(M1), addIfPositiveInt(W,M1,M),!.
symbolicModel([]).
addIfPositiveInt(W,L,[Var|L]):- W = [C|_], between(48,57,C), number_codes(N,W), N>0, varNumber(_,Var,N),!.
addIfPositiveInt(_,L,L).
readWord( 99,W):- repeat, get_code(Ch), member(Ch,[-1,10]), !, get_code(Ch1), readWord(Ch1,W),!. % skip line starting w/ c
readWord(115,W):- repeat, get_code(Ch), member(Ch,[-1,10]), !, get_code(Ch1), readWord(Ch1,W),!. % skip line starting w/ s
readWord(-1,_):-!, fail. %end of file
readWord(C,[]):- member(C,[10,32]), !. % newline or white space marks end of word
readWord(Char,[Char|W]):- get_code(Char1), readWord(Char1,W), !.
%========================================================================================
