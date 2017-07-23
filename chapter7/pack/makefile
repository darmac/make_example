#this is a makefile for define test

.PHONY:all

define echo-target
@echo "now rebuilding target : " $@
touch $@
endef

all:pre_a pre_b pre_c
	@echo "final target finish!"

pre_%:
	$(echo-target)

