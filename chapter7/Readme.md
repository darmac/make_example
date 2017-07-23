chapter7 will include the content as below:
1.$(SHELL) environment vari,default is "/bin/sh",SHELL overide test;how to print $ in shell with makefile:"\$$"
2.make -j with sleeping test
3.make error,ignore with "-","-i",keep going with "-k"
4.terminate make when it making,test if make will delete tmp files with the same timestamp
5.-w option print make dir
6.define and cmdpack
7..PHONY aim with %pattern is not compatible

chapter8
1.make recursion
2.why use $(MAKE) instead of make 
3.make vari with recursion,vari name conflict in recursion;2 special vari $(SHELL) & $(MAKEFLAGS);export vari&export all;unexport & confict with export&unexport
4.$(MAKELEVEL)
5.cmdline param with recursion;$(MAKEFLAGS);"-C -f -o -W" flag;discard $(MAKEFLAGS);$(MAKEOVERRIDE)

