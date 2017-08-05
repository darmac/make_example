#test wrods related function

.PHONY:raw find filt filt_out sort word word_list first_word words join call

str_a := cxx.o n.o fxx.o xy.c fab.o zy.py jor.py abc.o 
str_b := $(findstring xx,$(str_a)) #make sure if xx include in str_a
str_c := $(findstring .o x,$(str_a)) #even can include space char
str_d := $(findstring nothing,$(str_a)) #search no-exist words

str_e := $(filter %.py,$(str_a)) #filster
str_f := $(filter-out %.py,$(str_a)) #filter-out

str_g := $(sort $(str_a)) #sort according first char,if same then next char

str_h := $(word 3,$(str_a)) # get the 3rd word
str_i := $(word 99,$(str_a)) # out of range

str_j := $(wordlist 3,5,$(str_a)) #list 3rd to 5rd words
str_k := $(wordlist 3,99,$(str_a)) #list our of range

str_l := $(firstword $(str_a)) #first word

str_m := $(words $(str_a)) #cacu words num

str_join := ./dira/ ./dirb/ ./dirc/ ./dird/ ./dire/ ./dirf/
str_n := $(join $(str_join),$(str_a))

part_rev = $(4) $(3) $(2) $(1)
str_o = $(call part_rev,a,b,c,d,e,f,g) #must use "=" 

raw:
	@echo "str_a=" $(str_a)

find:raw
	@echo "str_b=" $(str_b)
	@echo "str_c=" $(str_c)
	@echo "str_d=" $(str_d)

filt:raw
	@echo "str_e=" $(str_e)

filt_out:raw
	@echo "str_f=" $(str_f)

sort:raw
	@echo "str_g=" $(str_g)

word:raw
	@echo "str_h=" $(str_h)
	@echo "str_i=" $(str_i)

word_list:raw
	@echo "str_j=" $(str_j)
	@echo "str_k=" $(str_k)

first_word:raw
	@echo "str_l=" $(str_l)

words:raw
	@echo "str_m=" $(str_m)

join:raw
	@echo "str_join=" $(str_join)
	@echo "str_n=" $(str_n)

call:
	@echo "str_o=" $(str_o)
