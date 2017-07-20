#this is a makefile for static mode

.PHONY:clean aim_1 aim_2 aim_3

aim_1 aim_2 aim_3:aim_%:depen_%
	@echo "target:"$@ " depen:" $^

depen_%:
	touch $@

clean:
	$(RM) aim_* depen*
