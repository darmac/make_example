#this is a makefile for wildcard code test

.PHONY:all clean

objs=$(patsubst %.c,%.o,$(wildcard *.c))
aim=wildtest2

all:$(objs)
	@echo "objs inlude : " $(objs)
	$(CC) -o $(aim) $(objs)

clean:
	$(RM) $(objs)
	$(RM) $(aim)
