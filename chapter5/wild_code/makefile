#this is a makefile for wildcard code test

.PHONY:all clean

code=$(wildcard *.c)
aim=wildtest

all:$(code)
	@echo "objs inlude : " $(code)
	$(CC) -o $(aim) $(code)

clean:
	$(RM) $(aim)
