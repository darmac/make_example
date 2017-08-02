#test for file related function

.PHONY:init clean 

dirs := dir_a dir_b dir_a/dir_1 dir_a/dir2 dir_b/dir_1 dir_b/dir_2
dira_files := a.c b.c
dira1_files := a1_a.c a1_b.c a1_c.c
dira2_files := a2_a.c a2_b.c a2_c.c
dirb_files := a.c b.c
dirb1_files := b1_a.c b1_b.c b1_c.c
dirb2_files := b2_a.c b2_b.c b2_c.c

dir_num := $(words $(dirs))
each_dir := 

init:
	@mkdir $(dirs)
	
