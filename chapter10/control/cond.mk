
.PHONY:init clean for_loop if_cond err warn shell

dirs := dir_a dir_b dir_c dir_d #each dir
files := file_a file_b file_c #each file under per dir
files_a := $(foreach each,$(files),$(word 1,$(dirs))"/"$(each)) #get all files under a dir by foreach & word func
files_b := $(foreach each,$(files),$(word 2,$(dirs))"/"$(each))
files_c := $(foreach each,$(files),$(word 3,$(dirs))"/"$(each))
files_d := $(foreach each,$(files),$(word 4,$(dirs))"/"$(each))
all_files := $(files_a)
all_files += $(files_b)
all_files += $(files_c)
all_files += $(files_d)
detect_files := $(foreach each,$(dirs),$(wildcard $(each)/*))
detect_files := $(patsubst %,"\n"%,$(detect_files)) #add '\n' for view

vari_a :=
vari_b := b
vari_c := $(if $(vari_a),"vari_a has value:"$(vari_a),"vari_a has no value")
vari_d := $(if $(vari_b),"vari_b has value:"$(vari_b),"vari_b has no value")

err_exit := $(if $(vari_e),$(error "you generate a error!"),"no error defined") #define vari_e to enable error
warn_go := $(if $(vari_f),$(warning "you generate a warning!"),"no warning defined") #define vari_f to enalbe warning

shell_cmd := $(shell date)

init:
	@mkdir $(dirs);\
	touch $(all_files);\
	tree

for_loop:
	@echo "files=" $(detect_files)

if_cond:
	@echo "vari_a=" $(vari_a)
	@echo "vari_b=" $(vari_b)
	@echo "vari_c=" $(vari_c)
	@echo "vari_d=" $(vari_d)

warn:
	@echo $(warn_go)

err:
	@echo $(err_exit)

shell:
	@echo $(shell_cmd)

clean:
	@rm -rf $(dirs)
