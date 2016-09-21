CC	= gcc
CFLAGS	= -g -O2
LIBS	=

DESTDIR ?= /usr/local/bin

default: build

clean:
	rm -rf *.o hello-ci

build: main.o
	$(CC) -o hello-ci main.o

main.o: main.c
	$(CC) -c $(CFLAGS) main.c $(LIBS)

install: hello-ci
	cp hello-ci '$(DESTDIR)/hello-ci'

uninstall:
	rm '$(DESTDIR)/hello-ci'
