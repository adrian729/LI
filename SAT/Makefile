CXX = g++
RM = rm -f
CPPFLAGS = -c -std=c++11 -O3

SRCS5 = SAT-ADR-RH.cpp
OBJS5 = $(subst .cpp,.o,$(SRCS5))

SRCS6 = satsolver.cpp
OBJS6 = $(subst .cpp,.o,$(SRCS6))

ALLOBJS = *.o

ALLDRIVOBS = *.exe *.prova

all: dist-clean SAT-ADR-RH.exe satsolver.exe

allNew: clear all

SAT-ADR-RH.exe: $(OBJS5)
	$(CXX) $(OBJS5) -o SAT-ADR-RH.exe

satsolver.exe: $(OBJS6)
	$(CXX) $(OBJS6) -o satsolver.exe

SAT-ADR-RH.o: SAT-ADR-H.cpp
	$(CXX) $(CPPFLAGS) SAT-ADR-RH.cpp

satsolver.o: satsolver.cpp
	$(CXX) $(CPPFLAGS) satsolver.cpp

clear: clean dist-clean

clean:
	$(RM) $(ALLOBJS)

dist-clean: clean
	$(RM) $(ALLDRIVOBS)
