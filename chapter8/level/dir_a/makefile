#this is a makefile for special MAKELEVEL test

subdir := dir_b

.PHONY:all $(subdir)

all:$(subdir)
	@echo "this is level:" $(MAKELEVEL)
	@echo "dir_a finished!"

$(subdir):
	cd $@;make

