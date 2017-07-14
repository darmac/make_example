#this is a makefile for gpath test

.PHONY:all clean

vpath %.c ../wild_code/

depen=main.o foo1.o foo2.o
aim=main

all:$(depen)
	@echo "objs inlude : " $(depen)
	$(CC) -o $(aim) $^

clean:
	$(RM) $(depen)
	$(RM) $(aim)
