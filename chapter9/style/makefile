#this makefile is for recursively vari test

.PHONY:recur loop

a1 = abc
a2 = $(a3)
a3 = $(a1)

b1 = $(b2)
b2 = $(b1)

recur:
	@echo "a1:"$(a1)
	@echo "a2:"$(a2)
	@echo "a3:"$(a3)

loop:
	@echo "b1:"$(b1)
	@echo "b2:"$(b2)
