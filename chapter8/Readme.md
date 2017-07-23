1.makefile recursion example:
	#1 get code
	#2 test simple recursion
	top makefile will call 2dir makefiles
	use MAKE instead of make
	use := instead of =
2.vari in makefile recursion
	#1 vari pass with export
	vari cannot pass to next layer
	#2 vari pass with export
	use export to pass to next layer
	use unexport to cancel vari pass
	conflict with export and unexport
	#3 special vari with auto pass
	2 special vari auto pass without export declare
	-w option will auto append to MAKEFLAGS
3.MAKELEVEL example
4.MAKEFLAGS example
	#1 simple test default flags
	#2 cmdline with option
	#3 cmdline with vari
