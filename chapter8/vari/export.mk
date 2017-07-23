#this is a makefile for recursion test

subdir := dir_a dir_b
export subdir

.PHONY:clean all $(subdir)

all:$(subdir)
	@echo "final target finish!"

$(subdir):
	cd $@;$(MAKE)
