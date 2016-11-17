CXX = g++
RM = rm -f
CPPFLAGS = -c -std=c++11 -O3

SRCS5 = SAT-ADR-RH.cpp
OBJS5 = $(subst .cpp,.o,$(SRCS5))

ALLOBJS = *.o

ALLDRIVOBS = *.exe *.prova

all: dist-clean SAT-ADR-RH.exe

allNew: clear all

SAT-ADR-RH.exe: $(OBJS5)
	$(CXX) $(OBJS5) -o SAT-ADR-RH.exe

SAT-ADR-RH.o: SAT-ADR-H.cpp
	$(CXX) $(CPPFLAGS) SAT-ADR-RH.cpp

clear: clean dist-clean

clean:
	$(RM) $(ALLOBJS)

dist-clean: clean
	$(RM) $(ALLDRIVOBS)
