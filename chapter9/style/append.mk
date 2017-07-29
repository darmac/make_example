#this makefile is for += test

.PHONY:dir recur

a1 := aa1
a1 += _a1st
a2 := _a2
a1 += $(a2)
a1 += $(a3)
a3 += $(a1)

b1 = bb1
b1 += _b1st
b2 = _b2
b1 += _b2
b1 += $(b3)
b3 += $(b1)

c1 += $(c2)
c2 += $(c1)

d1 ?= dd1
d2 = dd2
d2 ?= dd3

dir:
	@echo "a1:"$(a1)

recur:
	@echo "b1:"$(b1)

def:
	@echo "c1:"$(c1)

cond:
	@echo "d1:"$(d1)
	@echo "d2:"$(d2)
