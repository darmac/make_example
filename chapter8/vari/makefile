#this is a makefile for recursion test

subdir := dir_a dir_b

.PHONY:clean all $(subdir)

all:$(subdir)
	@echo "final target finish!"

$(subdir):
	cd $@;$(MAKE)
