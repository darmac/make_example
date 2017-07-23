#this is a makefile for MAKEFLAGS test

subdir := dir_a

.PHONY:all $(subdir)

all:$(subdir)
	@echo "root dir finished!"

$(subdir):
	@echo "MAKEFLAGS before subdir is : " $(MAKEFLAGS)
	cd $@;$(MAKE)

