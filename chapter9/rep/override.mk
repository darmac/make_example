
.PHONY:all

vari_a = abc
vari_b := def

override vari_c = hij
override vari_d := lmn

vari_c += xxx
vari_d += xxx

override vari_c += zzz
override vari_d += zzz

all:
	@echo "vari_a:" $(vari_a)
	@echo "vari_b:" $(vari_b)
	@echo "vari_c:" $(vari_c)
	@echo "vari_d:" $(vari_d)
	@echo "vari_e:" $(vari_e)

