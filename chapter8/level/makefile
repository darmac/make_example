#this is a makefile for special vari in recursion test

subdir := dir_a

.PHONY:all $(subdir)

all:$(subdir)
	@echo "this is level:" $(MAKELEVEL)
	@echo "root dir finished!"

$(subdir):
	cd $@;$(MAKE)

