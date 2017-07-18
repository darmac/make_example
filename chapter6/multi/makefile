#this is a makefile for multi-command test

.PHONY: multi prepare

multi:dep_a dep_b
	@echo $^ "[cmd1]"

multi:dep_c dep_d
	@echo $^ "[cmd2]"

multi:prepare
	@echo $^ "[cmd3]"

multi:
	@echo $^ "[cmd4]"

prepare:
	@touch dep_a dep_b dep_c dep_d
