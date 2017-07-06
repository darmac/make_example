#this is a makefile to test ifeq

.PHONY:all

b="ifeq default"

ifeq ($(a),1)
b="ifeq a 1"
endif

ifeq '$(a)' '2'
b="ifeq a 2"
endif

ifeq "$(a)" "3"
b="ifeq a 3"
endif

ifeq "$(a)" '4'
b="ifeq a 4"
endif

ifeq '$(a)' "5"
b="ifeq a 5"
endif

all:
	@echo $(b)
