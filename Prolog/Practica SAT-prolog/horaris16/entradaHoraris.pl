numYears(4).
numCourses(23).
numRooms(3).
numTeachers(5).

% Sintax: course( year, courseId, numLectures, possibleRooms, possibleTeachers ).
course(1,1,3,[1,2,3],[5]).
course(1,2,5,[2,3],[1]).
course(1,3,5,[1],[1,3,5]).
course(1,4,3,[1,2],[2,3,4]).
course(1,5,5,[1,2,3],[1,2,4,5]).

course(2,6,3,[2],[1,2,3,4]).
course(2,7,5,[1,3],[1,2,3]).
course(2,8,4,[1,2,3],[3,5]).
course(2,9,5,[1,2,3],[4]).
course(2,10,4,[2,3],[1,3,4,5]).

course(3,11,3,[2],[1,2,3,4,5]).
course(3,12,4,[1,3],[2,4,5]).
course(3,13,3,[3],[1,2,3,5]).
course(3,14,3,[1],[1,2,3,4,5]).
course(3,15,5,[1],[1,3,4,5]).
course(3,16,3,[1],[1,2,3,4,5]).

course(4,17,3,[1],[2]).
course(4,18,4,[1,2,3],[4]).
course(4,19,4,[1,2,3],[1,2,3,4,5]).
course(4,20,3,[1,2,3],[1,3,5]).
course(4,21,3,[3],[1,3,4,5]).
course(4,22,3,[1,2,3],[1,2,3,4]).
course(4,23,5,[3],[1,3,4]).

year(1,morning).
year(2,afternoon).
year(3,morning).
year(4,afternoon).

teacher(1,morning).
teacher(2,afternoon).
teacher(3,afternoon).
teacher(4,both).
teacher(5,morning).
