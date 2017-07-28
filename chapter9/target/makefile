.PHONY:all

vari_a=abc
vari_b=def

all:vari_a:=all_target

all:pre_a pre_b file_c
	@echo $@ ":" $(vari_a)
	@echo $@ ":" $(vari_b)


pre_%:vari_b:=pat
pre_%:
	@echo $@ ":" $(vari_a)
	@echo $@ ":" $(vari_b)

file_%:
	@echo $@ ":" $(vari_a)
	@echo $@ ":" $(vari_b)
