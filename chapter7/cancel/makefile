#this is a makefile for cancel handle

.PHONY:all clean

all:clean pre_a pre_b pre_c
	sleep 1
	@echo "exe target all!"

clean:
	$(RM) pre_*

pre_%:
	@echo "\n"
	touch $@
	@echo "generate " $@
	@ls -l $@
	@echo "sleep 5s before finish..."
	sleep 5
