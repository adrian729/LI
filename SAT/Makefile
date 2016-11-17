CXX = g++
RM = rm -f
CPPFLAGS = -c -std=c++11 -O3

SRCS1 = SAT-ADR.cpp
OBJS1 = $(subst .cpp,.o,$(SRCS1))

SRCS2 = SAT-ADR-REC.cpp
OBJS2 = $(subst .cpp,.o,$(SRCS2))

SRCS3 = SAT-ADR-REC-H.cpp
OBJS3 = $(subst .cpp,.o,$(SRCS3))

SRCS4 = SAT-ADR-H.cpp
OBJS4 = $(subst .cpp,.o,$(SRCS4))

SRCS5 = SAT-ADR-RH.cpp
OBJS5 = $(subst .cpp,.o,$(SRCS5))

ALLOBJS = *.o

ALLDRIVOBS = *.exe *.prova

all: SAT-ADR.exe SAT-ADR-REC.exe SAT-ADR-REC-H.exe SAT-ADR-H.exe SAT-ADR-RH.exe

allNew: clear all

SAT-ADR.exe: $(OBJS1)
	$(CXX) $(OBJS1) -o SAT-ADR.exe

SAT-ADR-REC.exe: $(OBJS2)
	$(CXX) $(OBJS2) -o SAT-ADR-REC.exe

SAT-ADR-REC-H.exe: $(OBJS3)
	$(CXX) $(OBJS3) -o SAT-ADR-REC-H.exe

SAT-ADR-H.exe: $(OBJS4)
	$(CXX) $(OBJS4) -o SAT-ADR-H.exe

SAT-ADR-RH.exe: $(OBJS5)
	$(CXX) $(OBJS5) -o SAT-ADR-RH.exe

SAT-ADR.o: SAT-ADR.cpp
	$(CXX) $(CPPFLAGS) SAT-ADR.cpp

SAT-ADR-REC.o: SAT-ADR-REC.cpp
	$(CXX) $(CPPFLAGS) SAT-ADR-REC.cpp

SAT-ADR-REC-H.o: SAT-ADR-REC-H.cpp
	$(CXX) $(CPPFLAGS) SAT-ADR-REC-H.cpp

SAT-ADR-H.o: SAT-ADR-H.cpp
	$(CXX) $(CPPFLAGS) SAT-ADR-H.cpp

SAT-ADR-RH.o: SAT-ADR-H.cpp
	$(CXX) $(CPPFLAGS) SAT-ADR-RH.cpp

clear: clean dist-clean

clean:
	$(RM) $(ALLOBJS)

dist-clean: clean
	$(RM) $(ALLDRIVOBS)
