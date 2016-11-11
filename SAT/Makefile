CXX = g++
RM = rm -f
CPPFLAGS = -c -std=c++11 -O3

SRCS1 = SAT-ADR.cpp
OBJS1 = $(subst .cpp,.o,$(SRCS1))

SRCS2 = SAT-ADR-REC.cpp
OBJS2 = $(subst .cpp,.o,$(SRCS2))

SRCS3 = SAT-ADR-REC-H.cpp
OBJS3 = $(subst .cpp,.o,$(SRCS3))

ALLOBJS = *.o

ALLDRIVOBS = *.exe *.prova

all: SAT-ADR.exe SAT-ADR-REC.exe SAT-ADR-REC-H.exe

allNew: clear all

SAT-ADR.exe: $(OBJS1)
	$(CXX) $(OBJS1) -o SAT-ADR.exe

SAT-ADR-REC.exe: $(OBJS2)
	$(CXX) $(OBJS2) -o SAT-ADR-REC.exe

SAT-ADR-REC-H.exe: $(OBJS3)
	$(CXX) $(OBJS3) -o SAT-ADR-REC-H.exe

SAT-ADR.o: SAT-ADR.cpp
	$(CXX) $(CPPFLAGS) SAT-ADR.cpp

SAT-ADR-REC.o: SAT-ADR-REC.cpp
	$(CXX) $(CPPFLAGS) SAT-ADR-REC.cpp

SAT-ADR-REC-H.o: SAT-ADR-REC-H.cpp
	$(CXX) $(CPPFLAGS) SAT-ADR-REC-H.cpp

clear: clean dist-clean

clean:
	$(RM) $(ALLOBJS)

dist-clean: clean
	$(RM) $(ALLDRIVOBS)
