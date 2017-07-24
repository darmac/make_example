#this is a makefile for special vari in recursion test

subdir := dir_c

.PHONY:all $(subdir)

all:$(subdir)
	@echo "finished!"

$(subdir):
	cd $@;$(MAKE)

