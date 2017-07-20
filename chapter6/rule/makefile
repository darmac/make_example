#this is a test makefile

.PHONY:clean

aim::depen_a
	@echo $@ " : " $^ " [cmd1]"

aim::depen_b depen_c
	@echo $@ " : " $^ " [cmd2]"

aim::depen_d
	@echo $@ " : " $^ " [cmd3]"

aim::
	@echo $@ " : " $^ " [cmd4]"

depen_%:
	touch $@

clean:
	$(RM) depen_*
