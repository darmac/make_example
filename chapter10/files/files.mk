
.PHONY:init clean dir notdir base suffix addprefix addsuffix wildcard

dirs := dir_a
files := file_a.c file_b.s file_c.o #each file under per dir
files_a := $(foreach each,$(files),$(dirs)"/"$(each)) #get all files under a dir by foreach & word func
all_files := $(files_a)
detect_files := $(foreach each,$(dirs),$(wildcard $(each)/*))
detect_files := $(foreach each,$(detect_files),$(PWD)"/"$(each))
show := $(patsubst %,"\n"%,$(detect_files)) #add '\n' for view

vari_dir := $(dir $(detect_files))
show_dir := $(patsubst %,"\n"%,$(vari_dir))

vari_files := $(notdir $(detect_files))

vari_base := $(basename $(detect_files))
show_base := $(patsubst %,"\n"%,$(vari_base))

vari_suffix := $(suffix $(detect_files))

vari_addprefix := $(addprefix "full name:",$(detect_files))
show_addprefix := $(patsubst %,"\n"%,$(vari_addprefix))

vari_addsuffix := $(addsuffix ".text",$(detect_files))
show_addsuffix := $(patsubst %,"\n"%,$(vari_addsuffix))

init:
	@mkdir $(dirs);\
	touch $(all_files);\
	tree

dir:
	@echo "detected files:" $(show)
	@echo "get dir:" $(show_dir)

notdir:
	@echo "detected files:" $(show)
	@echo "get files:"
	@echo $(vari_files)

base:
	@echo "detected files:" $(show)
	@echo "file base name:" $(show_base)

suffix:
	@echo "detected files:" $(show)
	@echo "file suffix:" $(vari_suffix)

addprefix:
	@echo "detected files:" $(show)
	@echo "file add prefix:" $(show_addprefix)

addsuffix:
	@echo "detected files:" $(show)
	@echo "file add suffix:" $(show_addsuffix)

clean:
	@rm -rf $(dirs)
