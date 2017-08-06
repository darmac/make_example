## 一、实验介绍
本实验将 make 的内建函数分为三类，并介绍它们的使用方法。

### 1.1 实验内容
1.测试字符串处理函数的使用方式
2.测试 make 控制函数的使用方式
3.测试文件名处理函数的使用方式

### 1.2 实验知识点 
1.替换字符串函数：subst，patsubst #以单词为单位，而非以整个变量展开的字符串为单位
2.简化空格函数：strip #去前后空格，合并多个空格
3.字符串查找：findstring #若查找字符存在则返回查找字符串，否则返回空
4.过滤：filter，filter-out #过滤和反向过滤指定的字符串
5.排序：sort #按首字母从小到大排列字符串
6.单词查找：word，wordlist，firstword #取出指定位置的单词
7.统计单词数量：words 
8.单词连接：jion #将两个字符串的单词一一合并
9.取目录/文件：dir，notdir #获取文件的路径或者文件名
10.取前后缀：basename，suffix
11.加前后缀：addprefix，addsuffix
12.文件名匹配：wildcard #匹配指定路径下符合指定模式的文件，返回文件名
13.循环：foreach #遍历单词
14.条件控制：if
15.make控制：error，warning #产生错误或警告
16.函数调用：call #调用其它函数
17.调用shell：shell #调用 shell 命令
18.获取变量展开前的值：value #展开变量为其定义的文本格式
19.二次展开：eval #对指定变量展开为 makefile 规则的一部分
20.查询变量出处：origin

### 1.3 实验环境
Ubuntu系统, GNU gcc工具，GNU make工具

### 1.4 适合人群
本课程难度为中等，适合已经初步了解 makefile 规则的学员进行学习。

### 1.5 代码获取
可以通过以下命令获取代码：
```bash
$ git clone https://github.com/darmac/make_example.git
```

## 二、实验原理
依据 makefile 的基本规则进行正反向实验，学习和理解规则的使用方式。

## 三、开发准备
进入实验楼课程即可。

## 四、项目文件结构
```bash
.
├── control：控制相关的内建函数
│   ├── cond.mk
│   ├── eval.mk
│   └── vari.mk
├── files：文件名相关的内建函数
│   └── files.mk
└── strings：字符串处理相关的内建函数
    ├── rep.mk
    └── word.mk
```

## 五、实验步骤

### 5.1 字符串处理函数
#### 5.1.1 抓取源代码
使用如下 cmd 获取 GitHub 源代码并进入相应章节：
```bash
cd ~/Code/
git clone https://github.com/darmac/make_example.git
cd make_example/chapter10
```

#### 5.1.2 函数的使用规则
GNU make 函数的调用格式与变量引用相似，基本格式如下：
```
$(FUNCTION ARGUMENTS)
```
FUNCTION 为函数名，ARGUMENTS 为函数的参数，参数以“,”进行分割。
函数处理参数时，若参数中存在其它变量或函数的引用，则先展开参数再进行函数处理，展开顺序与参数的先后顺序一致。
函数中的参数不能直接出现逗号和空格，前导空格会被忽略，若需要使用逗号和空格则需要将它们赋值给变量。

#### 5.1.3 文本替换函数
subst 和 patsubst 可以对字符串进行替换，其中 patsubst 可以使用模式替换，函数格式如下：
$(subst FROM,TO,TEXT)
$(patsubst PATTERN,REPLACEMENT,TEXT)
strip 函数可以简化字符串中的空格，将多个连续空格合并成一个，函数格式如下：
$(strip STRING)
文件 chapter10/strings/rep.mk 演示了函数的用法，内容如下：
```
#test function subst patsubst strip 

.PHONY:raw sub patsub

str_a := a.o b.o c.o f.o.o abcdefg
str_b := $(subst .o,.c,$(str_a))

str_c := $(patsubst %.o,%.c,$(str_a))
str_d := $(patsubst .o,.c,$(str_a))
str_e := $(patsubst a.o,a.c,$(str_a))

str_1 := abc.o  def.o     gh.o    i.o     #end
str_2 := $(strip $(str_1))

sub:raw
        @echo "str_b=" $(str_b) #replace all match char for per word

patsub:raw
        @echo "str_c=" $(str_c) #replace match pattern
        @echo "str_d=" $(str_d) #replace nothing
        @echo "str_e=" $(str_e) #replace all-match word

strip:
        @echo "str_1=" $(str_1) #looks like auto strip by make4.1
        @echo "str_2=" $(str_2)

raw:
        @echo "str_a=" $(str_a)
```
str_a 是原字符串，str_b 使用 subst 函数将所有的 .o 字符替换成 .c 字符。
str_c 使用 patsubst 用模式替换将 .o 后缀替换为 .c 后缀。
str_d 和 str_e 演示在没有通配符的情况下，patsubst 需要匹配整个字符串。
str_1 和 str_2 演示 strip 的字符串简化功能。
进入 strings 目录并执行 rep.mk 文件：
```bash
cd strings; make -f rep.mk sub; make -f rep.mk patsub; make -f rep.mk strip
```
终端打印：
```bash
str_a= a.o b.o c.o f.o.o abcdefg
str_b= a.c b.c c.c f.c.c abcdefg
str_a= a.o b.o c.o f.o.o abcdefg
str_c= a.c b.c c.c f.o.c abcdefg
str_d= a.o b.o c.o f.o.o abcdefg
str_e= a.c b.o c.o f.o.o abcdefg
str_1=       a      b         c        
str_2=  a b c 
```

#### 5.1.4 单词处理函数
单词处理函数包括：
```
$(findstring FIND,IN)：查找字符串，若存在返回字符串，否则返回空
$(filter PATTERN...,TEXT)：去除指定模式的字符串
$(filter-out PATTERN...,TEXT)：保留指定模式的字符串，去除其它字符串
$(sort LIST)：按首字母顺序进行排序
$(word N,TEXT)：获取第 N 个单词
$(wordlist S,E,TEXT)：获取从 S 位置到 E 位置的单词
$(words TEXT)：统计字符串中的单词数量
$(firstword NAMES...)：获取第一个单词
$(join LIST1,LIST2)：将 LIST1 和 LIST2 中的单词按顺序逐个连接
```

文件 word.mk 演示了以上函数的用法，由于篇幅较长，请自行阅读。
测试 findstring 函数：
```bash
make -f word.mk find
```
终端打印：
```bash
str_a= cxx.o n.o fxx.o xy.c fab.o zy.py jor.py abc.o
str_b= xx
str_c= .o x
str_d=
```
str_b 是匹配字符串“xx”的结果，str_c 匹配“.o x”，str_d 匹配不存在的字符串“nothing”。

测试 filter 和 filter-out 函数：
```bash
make -f word.mk filt;make -f word.mk filt_out 
```
终端打印：
```bash
str_a= cxx.o n.o fxx.o xy.c fab.o zy.py jor.py abc.o
str_e= zy.py jor.py
str_a= cxx.o n.o fxx.o xy.c fab.o zy.py jor.py abc.o
str_f= cxx.o n.o fxx.o xy.c fab.o abc.o
```
str_e 和 str_f 分别过滤和反过滤 .py 结尾的字符串。

测试 sort 函数：
```bash
make -f word.mk sort
```
终端打印：
```bash
str_a= cxx.o n.o fxx.o xy.c fab.o zy.py jor.py abc.o
str_g= abc.o cxx.o fab.o fxx.o jor.py n.o xy.c zy.py
```
str_g 是对 str_a 中单词首字母进行排序的结果，若首字母相同则以第二个字母排序，以此类推。

测试 wordlist 函数：
```bash
make -f word.mk word_list
```
终端打印：
```bash
str_a= cxx.o n.o fxx.o xy.c fab.o zy.py jor.py abc.o
str_j= fxx.o xy.c fab.o
str_k= fxx.o xy.c fab.o zy.py jor.py abc.o
```
str_j 和 str_k 的定义如下：
```
str_j := $(wordlist 3,5,$(str_a)) #list 3rd to 5rd words
str_k := $(wordlist 3,99,$(str_a)) #list our of range
```
str_j 打印第 3，4，5 个单词
str_k 则打印从 3 开始的所有单词，当 end 位置超出界限时，wordlist 会取到 str_a 的最后一个单词处。

利用 words 函数统计 str_a 的单词数量：
```
str_m := $(words $(str_a)) #cacu words num
```
测试 words 函数：
```bash
make -f word.mk words
```
终端打印：
```bash
str_a= cxx.o n.o fxx.o xy.c fab.o zy.py jor.py abc.o
str_m= 8
```

利用 join 函数会逐个连接下面两个字符串中对应同一位置的单词：
```
str_a := cxx.o n.o fxx.o xy.c fab.o zy.py jor.py abc.o 
str_join := ./dira/ ./dirb/ ./dirc/ ./dird/ ./dire/ ./dirf/
str_n := $(join $(str_join),$(str_a))
```
测试 join 函数：
```bash
make -f word.mk join
```
终端打印：
```bash
str_a= cxx.o n.o fxx.o xy.c fab.o zy.py jor.py abc.o
str_join= ./dira/ ./dirb/ ./dirc/ ./dird/ ./dire/ ./dirf/
str_n= ./dira/cxx.o ./dirb/n.o ./dirc/fxx.o ./dird/xy.c ./dire/fab.o ./dirf/zy.py jor.py abc.o
```

利用 call 函数反转前四个单词的位置，并舍弃其它参数：
```
part_rev = $(4) $(3) $(2) $(1)
str_o = $(call part_rev,a,b,c,d,e,f,g) #must use "=" 
```
$(1) 到 $(4) 分别代表传给 call 的 4 个参数 a b c d，$(0) 代表 part_rev 函数。
测试 call 函数：
```bash
make -f word.mk call
```
终端打印：
```
str_o= d c b a
```
可见 a b c d 的位置发生了翻转，且 e f g 三个参数被丢弃。

实验过程如下图所示：
![5.1A](https://dn-anything-about-doc.qbox.me/document-uid66754labid3381timestamp1502003772346.png/wm)
![5.1B](https://dn-anything-about-doc.qbox.me/document-uid66754labid3381timestamp1502003787194.png/wm)
![5.1C](https://dn-anything-about-doc.qbox.me/document-uid66754labid3381timestamp1502003796119.png/wm)

### 5.2 文件名相关函数
文件名处理相关的函数包括：
```
$(dir NAMES...)：获取目录
$(notdir NAMES...)：获取文件名
$(suffix NAMES...)：获取后缀
$(basename NAMES...)：获取前缀
$(addsuffix SUFFIX,NAMES...)：增加后缀
$(addprefix PREFIX,NAMES...)：增加前缀
$(wildcard PATTERN)：获取匹配的文件名
```

chapter10/files/files.mk 文件演示了文件名相关函数的用法，
进入目录并执行 init 规则会自动生成用于函数测试的目录和文件：
```bash
cd ../files;make -f files.mk init
```
终端打印生成的文件树：
```bash
.
├── dir_a
│   ├── file_a.c
│   ├── file_b.s
│   └── file_c.o
└── files.mk

1 directory, 4 files
```
由于 files.mk 内容较长，请大家自行阅读。
detect_files 变量利用 foreach 函数（后面会介绍此函数的用法）和 wildcard 函数获取 dir_a 目录下的文件，并在每个目录前增加换行符后赋值给 show  变量方便打印和观察：
```
detect_files := $(foreach each,$(dirs),$(wildcard $(each)/*))
detect_files := $(foreach each,$(detect_files),$(PWD)"/"$(each))
show := $(patsubst %,"\n"%,$(detect_files)) #add '\n' for view
```

dir 和 notdir 函数测试代码如下：
```
vari_dir := $(dir $(detect_files))
show_dir := $(patsubst %,"\n"%,$(vari_dir))

vari_files := $(notdir $(detect_files))
```
vari_dir 和 vari_files 分别利用 dir 和 notdir 函数取得文件目录和文件名。
由于文件目录过长，show_dir 变量在每个目录前加入换行符便于观察。
测试 dir 和 notdir 函数：
```
make -f files.mk dir ; make -f files.mk notdir
```
终端打印：
```bash
detected files: 
/home/shiyanlou/Code/make_example/chapter10/files/dir_a/file_a.c 
/home/shiyanlou/Code/make_example/chapter10/files/dir_a/file_b.s 
/home/shiyanlou/Code/make_example/chapter10/files/dir_a/file_c.o
get dir: 
/home/shiyanlou/Code/make_example/chapter10/files/dir_a/ 
/home/shiyanlou/Code/make_example/chapter10/files/dir_a/ 
/home/shiyanlou/Code/make_example/chapter10/files/dir_a/
detected files: 
/home/shiyanlou/Code/make_example/chapter10/files/dir_a/file_a.c 
/home/shiyanlou/Code/make_example/chapter10/files/dir_a/file_b.s 
/home/shiyanlou/Code/make_example/chapter10/files/dir_a/file_c.o
get files:
file_a.c file_b.s file_c.o
```

获取文件名前后缀函数测试代码如下：
```
vari_base := $(basename $(detect_files))
show_base := $(patsubst %,"\n"%,$(vari_base))

vari_suffix := $(suffix $(detect_files))
```
vari_base 和 show_base 得到文件的前缀名， vari_suffix 得到文件的后缀名。
测试 basename 和 suffix 函数：
```bash
make -f files.mk base ; make -f files.mk suffix 
```
终端打印如下：
```bash
detected files: 
/home/shiyanlou/Code/make_example/chapter10/files/dir_a/file_a.c 
/home/shiyanlou/Code/make_example/chapter10/files/dir_a/file_b.s 
/home/shiyanlou/Code/make_example/chapter10/files/dir_a/file_c.o
file base name: 
/home/shiyanlou/Code/make_example/chapter10/files/dir_a/file_a 
/home/shiyanlou/Code/make_example/chapter10/files/dir_a/file_b 
/home/shiyanlou/Code/make_example/chapter10/files/dir_a/file_c
detected files: 
/home/shiyanlou/Code/make_example/chapter10/files/dir_a/file_a.c 
/home/shiyanlou/Code/make_example/chapter10/files/dir_a/file_b.s 
/home/shiyanlou/Code/make_example/chapter10/files/dir_a/file_c.o
file suffix: .c .s .o
```

测试增加前后缀函数的代码如下：
```
vari_addprefix := $(addprefix "full name:",$(detect_files))
show_addprefix := $(patsubst %,"\n"%,$(vari_addprefix))

vari_addsuffix := $(addsuffix ".text",$(detect_files))
show_addsuffix := $(patsubst %,"\n"%,$(vari_addsuffix))
```
vari_addprefix 和 vari_addsuffix 分别利用 addprefix 函数和 addsuffix 函数为文件名增加前缀“full name:”，后缀“.text”
测试 addprefix 和 addsuffix 函数：
```bash
make -f files.mk addprefix ; make -f files.mk addsuffix
```
终端打印：
```
detected files: 
/home/shiyanlou/Code/make_example/chapter10/files/dir_a/file_a.c 
/home/shiyanlou/Code/make_example/chapter10/files/dir_a/file_b.s 
/home/shiyanlou/Code/make_example/chapter10/files/dir_a/file_c.o
file add prefix: 
full nname:/home/shiyanlou/Code/make_example/chapter10/files/dir_a/file_a.c 
full nname:/home/shiyanlou/Code/make_example/chapter10/files/dir_a/file_b.s 
full nname:/home/shiyanlou/Code/make_example/chapter10/files/dir_a/file_c.o
detected files: 
/home/shiyanlou/Code/make_example/chapter10/files/dir_a/file_a.c 
/home/shiyanlou/Code/make_example/chapter10/files/dir_a/file_b.s 
/home/shiyanlou/Code/make_example/chapter10/files/dir_a/file_c.o
file add suffix: 
/home/shiyanlou/Code/make_example/chapter10/files/dir_a/file_a.c.text 
/home/shiyanlou/Code/make_example/chapter10/files/dir_a/file_b.s.text 
/home/shiyanlou/Code/make_example/chapter10/files/dir_a/file_c.o.text
```

实验过程如下图所示：
![5.2A](https://dn-anything-about-doc.qbox.me/document-uid66754labid3381timestamp1502004090112.png/wm)
![5.2B](https://dn-anything-about-doc.qbox.me/document-uid66754labid3381timestamp1502004099322.png/wm)

### 5.3 控制和变量相关的函数
控制和变量相关的函数包括：
```
$(foreach VAR,LIST,TEXT)：把 LIST 中的单词依次赋给 VAR，并执行 TEXT 中的表达式
$(if CONDITION,THEN-PART[,ELSE-PART])：如果满足 CONDITION 条件，执行 THEN-PART 语句，否则执行 ELSE-PART 语句
$(error TEXT...)：产生致命错误并以 TEXT 内容进行提示
$(warning TEXT...)：产生警告并以 TEXT 内容进行提示
$(shell CMD...)：调用 shell 并传入 CMD 作为参数
$(value VARIABLE)：返回 VARIABLE 未展开前的定义值，即 makefile 中定义变量时所书写的字符串
$(origin VARIABLE)：返回变量的初始定义方式，包括：
    undefined，default，environment，environment override，file，command line，override，automatic
$(eval TEXT...)：将 TEXT 内容展开为 makefile 的一部分，可用于将字符串展开为规则供 make 解析
```

chapter10/control/cond.mk 文件演示了 foreach if error warning shell 这几个函数的用法。
其中 init 规则利用 foreach 函数遍历需要生成的文件，并与 $(dir) 路径结合生成文件全名：
```
files_a := $(foreach each,$(files),$(word 1,$(dirs))"/"$(each)) #get all files under a dir by foreach & word func
files_b := $(foreach each,$(files),$(word 2,$(dirs))"/"$(each))
files_c := $(foreach each,$(files),$(word 3,$(dirs))"/"$(each))
files_d := $(foreach each,$(files),$(word 4,$(dirs))"/"$(each))
```
detect_files 变量则使用 foreach 函数遍历全部目录，并获取目录下的文件名。
```
detect_files := $(foreach each,$(dirs),$(wildcard $(each)/*))
```

执行 init 规则生成测试所需的文件：
```bash
cd ../control; make -f cond.mk init
```
终端打印当前的文件树：
```bash
.
├── cond.mk
├── dir_a
│   ├── file_a
│   ├── file_b
│   └── file_c
├── dir_b
│   ├── file_a
│   ├── file_b
│   └── file_c
├── dir_c
│   ├── file_a
│   ├── file_b
│   └── file_c
├── dir_d
│   ├── file_a
│   ├── file_b
│   └── file_c
├── eval.mk
└── vari.mk
```
其中 dir_a dir_b dir_c dir_d 就是测试中需要用到的目录。

测试 foreach 函数：
```bash
make -f cond.mk for_loop
```
终端打印：
```bash
files= 
dir_a/file_b 
dir_a/file_c 
dir_a/file_a 
dir_b/file_b 
dir_b/file_c 
dir_b/file_a 
dir_c/file_b 
dir_c/file_c 
dir_c/file_a 
dir_d/file_b 
dir_d/file_c 
dir_d/file_a
```

接下来测试 if 函数，测试代码如下：
```
vari_a :=
vari_b := b
vari_c := $(if $(vari_a),"vari_a has value:"$(vari_a),"vari_a has no value")
vari_d := $(if $(vari_b),"vari_b has value:"$(vari_b),"vari_b has no value")
```
vari_c 和 vari_d 根据 vari_a vari_b 的定义与否来得到不同的值。
执行测试：
```bash
make -f cond.mk if_cond
```
终端打印：
```bash
vari_a=
vari_b= b
vari_c= vari_a has no value
vari_d= vari_b has value:b
```
可见 vari_c 因为 vari_a 没有定义，所以取值为参数 $(3)，而 vari_d 因为 vari_b 有定义，取值为 $(2)。

warning 和 error 的测试代码如下：
```
err_exit := $(if $(vari_e),$(error "you generate a error!"),"no error defined") #define vari_e to enable error
warn_go := $(if $(vari_f),$(warning "you generate a warning!"),"no warning defined") #define vari_f to enalbe warning
```
如果有定义 vari_e 变量，会产生一条错误信息并使 make 停止执行，如果有定义 vari_f 变量，会产生一条警告信息，make 继续执行。
执行测试：
```bash
make -f cond.mk warn
```
终端打印：
```bash
no warning defined
```
这是一条普通信息，再执行：
```bash
make -f cond.mk warn vari_f=1
```
终端打印：
```bash
cond.mk:23: "you generate a warning!"
```
这是一条 make 抛出的警告信息，error的测试方法也类似：
```bash
make -f cond.mk err vari_e=1 
```
终端打印：
```bash
cond.mk:22: *** "you generate a error!".  Stop.
```
make 在抛出错误信息后退出执行。

shell 函数的测试代码如下：
```
shell_cmd := $(shell date)
```
make 调用 shell 执行 date 程序打印当前时间。
执行测试：
```bash
make -f cond.mk shell
```
终端打印：
```bash
Sun Aug 6 14:36:55 CST 2017
```
此处的时间是变量展开时的时间，而不是执行规则时的时间，请自行设计实验证明。

接下来测试 value 和 origin 函数，测试代码位于 vari.mk 文件中。
定义五个变量如下：
```
vari_a = abc
vari_b = $(vari_a)
vari_c = $(vari_a) "+" $(vari_b)
override vari_d = vari_a
vari_e = $($(vari_d))
```
使用 value 函数得到他们的定义字符串并打印：
```
vari_1 = $(value vari_a)
vari_2 = $(value vari_b)
vari_3 = $(value vari_c)
vari_4 = $(value vari_d)
vari_5 = $(value vari_e)

value:
        @echo "vari_1=" '$(vari_1)'
        @echo "vari_2=" '$(vari_2)'
        @echo "vari_3=" '$(vari_3)'
        @echo "vari_4=" '$(vari_4)'
        @echo "vari_5=" '$(vari_5)'
```
执行测试：
```bash
make -f vari.mk value
```
终端打印：
```bash
vari_1= abc
vari_2= $(vari_a)
vari_3= $(vari_a) "+" $(vari_b)
vari_4= vari_a
vari_5= $($(vari_d))
```
可见打印内容与其定义一致。

origin 函数测试代码如下：
```
origin:
        @echo "origin vari_a:" $(origin vari_a)
        @echo "origin vari_b:" $(origin vari_b)
        @echo "origin vari_c:" $(origin vari_c)
        @echo "origin vari_d:" $(origin vari_d)
        @echo "origin vari_e:" $(origin vari_e)
        @echo 'origin $$@:' $(origin @)
        @echo "origin vari_f:" $(origin vari_f)
        @echo "origin PATH:" $(origin PATH)
        @echo "origin MAKE:" $(origin MAKE)
```
其中 vari_a 到 vari_e 已经在 vari.mk 中定义，我们将 vari_e 导出为环境变量，并在命令行中添加 vari_a 的定义，观察打印的变量出处：
```bash
export vari_e=1;make -f vari.mk origin vari_a=1 -e
```
终端打印：
```bash
origin vari_a: command line
origin vari_b: file
origin vari_c: file
origin vari_d: override
origin vari_e: environment override
origin $@: automatic
origin vari_f: undefined
origin PATH: environment
origin MAKE: default
```
请对照每个变量的定义查看出处与定义是否一致。

eval 函数是一个二次解析函数，函数先将其变量做一次展开，展开的结果将会作为 makefile 规则的一部分被 make 做第二次解析，这样就可以定义一些规则模板，增强 makefile 灵活性。
eval 的测试文件为 eval.mk，内容如下：
```
#this is a eval func test

PROGRAMS = server client
server_OBJS = server.o server_pri.o server_access.o
server_LIBS = priv protocol

client_OBJS = client.o client_api.o client_mem.o
client_LIBS = protocol

.PHONY:all

define PROGRAM_template
$(1):
        touch $$($(1)_OBJS) $$($(1)_LIBS)
        @echo $$@ " build finished!"
endef

$(foreach prog,$(PROGRAMS),$(eval $(call PROGRAM_template,$(prog))))

$(PROGRAMS):

clean:
        $(RM) *.o $(server_LIBS) $(client_LIBS)
```
其中 PROGRAM_template 被定义为一个模板，根据传入的参数产生不同的规则。
此实验中 server 和 client 被传入模板中产生 server 和 client 规则。
请注意由于 make 需要读入展开的规则模板，因此作为 make 解析和重构规则的文本中变量引用要使用 $$，$$ 会被转义成 $，这样才能使得变量引用生效，否则 make 在读入时就会展开变量产生预期外的效果。
现在分别测试这两条规则：
```bash
make -f eval.mk server; make -f eval.mk client
```
终端打印：
```bash
touch server.o server_pri.o server_access.o priv protocol
server  build finished!
touch client.o client_api.o client_mem.o protocol
client  build finished!
```
可见使用规则模板后，server 规则和 client 规则行为类似，依赖文件却不一样。

实验过程如下图所示：
![5.3A](https://dn-anything-about-doc.qbox.me/document-uid66754labid3381timestamp1502004403912.png/wm)
![5.3B](https://dn-anything-about-doc.qbox.me/document-uid66754labid3381timestamp1502004417262.png/wm)
![5.3C](https://dn-anything-about-doc.qbox.me/document-uid66754labid3381timestamp1502004429378.png/wm)

## 六、实验总结
本次实验测试了 make 各个内建函数的使用方式。

## 七、课后习题
请自行设计实验测试各个函数的使用和验证方式。

## 八、参考链接
无
