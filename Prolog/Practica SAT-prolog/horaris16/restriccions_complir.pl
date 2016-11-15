
% We want to compute the weekly schedule of a university. Classes should
% be allocated from 8h to 20h (12 hours per day) from Monday to
% Friday. File entradaHoraris.pl contains all necessary input data.

%  - there is a certain number of years, courses, rooms and teachers. OK!
%- each course
% - belongs to a certain year OK!
% - has a certain number of 1-hour lectures per week OK!
% - at most 1 lecture per day
% - can be taught only at some rooms 
% - only by some teachers. OK!
% - the courses of a year can only be taught in the morning (8-14) OR in the afternoon (14-20). OK!
% - every teacher expresses his availability to teach (morning, afternoon or both). OK!

% There is an additional set of constraints to be considered:

%  - all lectures of a course are taught by the same teacher
%  - all lectures of a course are taught at the same room OK!
  - it is not possible to hold two lectures at the same room simultaneously
  - a teacher cannot teach two lectures simultaneously
%  - at most 5 lectures of a given year can be taught every day OK!
%  - two lectures belonging to the same year cannot be taught at the same time