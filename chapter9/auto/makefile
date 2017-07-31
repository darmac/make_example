# $@ $^ $% $< $? $* $+

.PHONY:clean

PRE:=pre_a pre_b pre_a pre_c

all:$(PRE) lib -ladd
	@echo "$$""@:"$@
	@echo "$$""^:"$^
	@echo "$$""+:"$+
	@echo "$$""<:"$<
	@echo "$$""?:"$?
	@echo "$$""*:"$*
	@echo "$$""%:"$%
	@touch $@

$(PRE):pre_%:depen_%
	@echo "$$""*(in $@):"$*
	touch $@


depen_%:
	@echo "use depen rule to build:"$@
	touch $@

lib:libadd.a(add.o minus.o)
	@echo "$$""?(in $@):" $?
	touch $@
	
libadd.a(add.o minus.o):add.o minus.o
	@echo "$$""?(in $@):" $?
	@echo "$$""%(in $@):" $%
	$(AR) r $@ $%

clean:
	$(RM) pre_* depen_* *.a *.o lib all
