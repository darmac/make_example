#this is a makefile for error handle test

.PHONY:all

all:pre_a pre_b pre_c
	$(RM) pre_a
	$(RM) pre_b
	$(RM) pre_c
	$(RM) d
	-rm e
	rm f
	rm g

pre_%:
	touch $@
