CC := gcc
CFLAGS := -Wall -Wextra -O2
LIBS := -lGL -lGLU -lglut

SRC := $(wildcard src/*.c)
OBJS := $(patsubst src/%.c, build/%, $(SRC))

.PHONY: all run clean

all: $(OBJS)

build/%: src/%.c
	$(CC) $(CFLAGS) -o $@ $< $(LIBS)

run: build/main
	./build/main

clean:
	rm -f build/*
