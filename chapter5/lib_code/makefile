#this is a makefile for -lNAME test

.PHONY: all clean static_lib dynamic_lib

VPATH=lib/

all: main.o -lfoo
	$(CC) -o main $^

static_lib: foo_static.o
	$(AR) rc libfoo.a $^;\
	mv libfoo.a lib/

dynamic_lib: foo_dynamic.o
	$(CC) $^ -fPIC -shared -o libfoo.so;\
	mv libfoo.so lib/

clean:
	$(RM) *.o *.a *.so main
	$(RM) lib/*.a lib/*.so
