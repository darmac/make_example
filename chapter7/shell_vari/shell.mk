#this is a makefile for $(SHELL) test

.PHONY:all

all:
	@echo "\$$SHELL environment is $$SHELL"
	@echo "\$$SHELL in makefile is " $(SHELL)
