#this is a makefile to test ifndef

.PHONY:all

a=
b=$(a)

ifndef a
c="a is not defined"
else
c="a is defined"
endif

ifndef b
d="b is not defined"
else
d="b is defined"
endif

all:
	@echo "vari a is:" $(a)
	@echo "vari b is:" $(b)
	@echo "vari c is:" $(c)
	@echo "vari d is:" $(d)
