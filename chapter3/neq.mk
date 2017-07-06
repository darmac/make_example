#this is a mekfile to test ifneq

.PHONY:all

ifneq ($(a),)
b=$(a)
else
b="null"
endif

all:
	@echo "value b is:" $(b)
