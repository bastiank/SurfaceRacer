CFLAGS=-ggdb -Wall

all: polytracker

clean:
	rm *.o polytracker

%.o: %.c surface.h
	g++ $(CFLAGS) -c -o $@ $<

polytracker: polytracker.o surface.o
	g++ $(CFLAGS) -o $@ $^ -lusb -lm -lopencv_core -lopencv_highgui -lopencv_imgproc -loscpack

