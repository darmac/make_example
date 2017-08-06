#test function subst patsubst strip 

.PHONY:raw sub patsub

str_a := a.o b.o c.o f.o.o abcdefg
str_b := $(subst .o,.c,$(str_a))

str_c := $(patsubst %.o,%.c,$(str_a))
str_d := $(patsubst .o,.c,$(str_a))
str_e := $(patsubst a.o,a.c,$(str_a))

str_1 := "      a      b         c        "
str_2 := $(strip $(str_1))

sub:raw
	@echo "str_b=" $(str_b) #replace all match char for per word

patsub:raw
	@echo "str_c=" $(str_c) #replace match pattern
	@echo "str_d=" $(str_d) #replace nothing
	@echo "str_e=" $(str_e) #replace all-match word

strip:
	@echo "str_1=" $(str_1) #looks like auto strip by make4.1
	@echo "str_2=" $(str_2)

raw:
	@echo "str_a=" $(str_a)
