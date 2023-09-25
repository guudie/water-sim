.PHONY: all app temp clean subdirs

EXT =
ifeq ($(OS), Windows_NT)
	EXT = .exe
endif
SUBDIRS = ODE_solvers
ARGS = -O2
GCC = g++

CFLAGS = -O2 -Wall -mconsole -lm -lmingw32 -lSDL2main -lSDL2

all: subdirs renderer.o mouse.o main.o app$(EXT)
clean:
	-rm *.o *.exe; \
	for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir clean; \
	done

subdirs:
	for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir; \
	done

renderer.o: renderer.h renderer.cpp
	$(GCC) $(ARGS) -c renderer.cpp -o renderer.o

mouse.o: mouse.h mouse.cpp
	$(GCC) $(ARGS) -c mouse.cpp -o mouse.o

main.o: main.cpp renderer.h mouse.h utils.h ./ODE_solvers/implicitEuler.h ./ODE_solvers/ODESolver.h
	$(GCC) $(ARGS) -c main.cpp -o main.o

app$(EXT): main.o renderer.o mouse.o ./ODE_solvers/ode_joined.o
	$(GCC) -o $@ $^ $(CFLAGS)