
.PHONY:all

vari_a := fa.o fb.o fc.o f.o.o
vari_b := $(vari_a:.o=.c)
vari_c := $(vari_a:%.o=%.c)
vari_d := $(vari_a:f.o%=f.c%)

all:
	@echo "vari_a:" $(vari_a)
	@echo "vari_b:" $(vari_b)
	@echo "vari_c:" $(vari_c)
	@echo "vari_d:" $(vari_d)
