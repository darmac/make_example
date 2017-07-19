#this is a makefile for multi-aim test

.PHONY:clean

file_1 file_2 file_3:depen_1 depen_2
	@echo "this is a multi-aim rule for " $@
	touch $@

depen_1:
	touch depen_1

depen_2:
	touch depen_2

clean:
	$(RM) depen_* file_*
