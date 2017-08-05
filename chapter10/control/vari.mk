
.PHONY:value origin

vari_a = abc
vari_b = $(vari_a)
vari_c = $(vari_a) "+" $(vari_b)
override vari_d = vari_a
vari_e = $($(vari_d))

vari_1 = $(value vari_a)
vari_2 = $(value vari_b)
vari_3 = $(value vari_c)
vari_4 = $(value vari_d)
vari_5 = $(value vari_e)

FOO=$PATH
all:
	@echo $(FOO)
	@echo $(value FOO)

value:
	@echo "vari_1=" '$(vari_1)'
	@echo "vari_2=" '$(vari_2)'
	@echo "vari_3=" '$(vari_3)'
	@echo "vari_4=" '$(vari_4)'
	@echo "vari_5=" '$(vari_5)'

origin:
	@echo "origin vari_a:" $(origin vari_a)
	@echo "origin vari_b:" $(origin vari_b)
	@echo "origin vari_c:" $(origin vari_c)
	@echo "origin vari_d:" $(origin vari_d)
	@echo "origin vari_e:" $(origin vari_e)
	@echo 'origin $$@:' $(origin @)
	@echo "origin vari_f:" $(origin vari_f)
	@echo "origin PATH:" $(origin PATH)
	@echo "origin MAKE:" $(origin MAKE)
