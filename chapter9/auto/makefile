# $@ $^ $% $< $? $* $+

.PHONY:clean

PRE:=pre_a pre_b pre_a pre_c

all:$(PRE) lib -lfake
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

lib:libfake.a(fake.o)
	touch $@

libfake.a(fake.o):fake.o
	$(AR) r $@ $%

clean:
	$(RM) pre_* depen_* *.a lib all
