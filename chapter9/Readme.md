## 一、实验介绍
本次实验将介绍 make 的变量定义风格，变量的替换引用，环境变量、命令行变量、目标指定变量的使用及自动化变量的使用。

### 1.1 实验内容
1. 不同的变量风格和赋值风格
2. 变量的替换引用，环境变量、命令行变量的使用
3. 目标指定变量的使用
4. 自动化变量的使用

### 1.2 实验知识点 
1. 变量的定义及展开时机。
2. 递归展开变量使用“=”或 define 定义，在使用时展开。
3. 递归展开变量的定义与书写顺序无关，但也会产生难于调试和函数重复调用的问题。
4. 直接展开变量使用“:=”定义，在 make 读入当前行时立即展开。
5. += 操作符可以对变量进行追加，展开方式与变量原始的赋值方式一致。
6. ?= 操作符可以在变量未定义时进行赋值。
7. 变量的替换引用可以将变量展开的内容进行字符串替换。
8. 系统环境变量对 makefile 来说是可见的，但文件中的同名变量会覆盖环境变量，可以使用 -e 选项避免覆盖。
9. 命令行变量比 makefile 中的普通变量具有更高的优先级，可以使用 override 关键字防止 makefile 中的同名变量被命令行指定变量覆盖。
10. 目标指定变量仅在包括依赖项在内的上下文可见，类似于局部变量，优先级高于普通变量。
11. 自动化变量可以根据具体目标和依赖项自动生成相应的文件列表。

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

```

## 五、实验步骤

### 5.1 make 的递归执行示例
#### 5.1.1 抓取源代码
使用如下 cmd 获取 GitHub 源代码并进入相应章节：
```bash
cd ~/Code/
git clone https://github.com/darmac/make_example.git
cd make_example/chapter9
```

#### 5.1.2 递归展开式变量
makefile 变量就是一个名字，代表一个文本字符串。变量有两种定义方式：递归展开式变量和直接展开式变量。变量在 makefile 的读入阶段被展开成字符串。
递归展开式变量可以通过“=”和“define”进行定义，在变量定义过程中，对其它变量的定义不会立即展开，而是在变量被规则使用到时才进行展开。
chapter9/style/ 目录下的 makefile 文件演示了递归展开式变量的定义和使用方式。
文件内容如下：
```
#this makefile is for recursively vari test

.PHONY:recur loop

a1 = abc
a2 = $(a3)
a3 = $(a1)

b1 = $(b2)
b2 = $(b1)

recur:
	@echo "a1:"$(a1)
	@echo "a2:"$(a2)
	@echo "a3:"$(a3)

loop:
	@echo "b1:"$(b1)
	@echo "b2:"$(b2)
```
文件中 recur 规则用到3个变量，a1 是直接定义字符串，a2 引用后面才定义到的 a3，a3 则引用 a1。
loop 规则用到 b1，b2 2个变量，二者相互引用。
进入 style 目录，测试 recur 规则：
```bash
cd style;make recur
```
终端打印：
```bash
a1:abc
a2:abc
a3:abc
```
可见 a1 a2 a3 的值是一致的，变量的展开与定义顺序无关。
再测试 loop 命令：
```bash
make loop
```
终端打印：
```bash
makefile:9: *** Recursive variable 'b1' references itself (eventually).  Stop.
```
make 因为两个变量的无限递归而报错退出。
从上面测试可以看出递归展开式的优点：此变量对引用变量的定义顺序无关。缺点则是：多个变量在互相引用时可能导致无限递归。
除此之外，递归展开式变量中若有函数引用，每次引用该变量都会导致函数重新执行，效率较低。

#### 5.1.3 直接展开式变量
直接展开式变量通过“:=”进行定义，对其它变量的引用和函数的引用都将在定义时被展开。
文件 direct.mk 将 makefile 中的“=”替换为“:=”，重新执行 recur 和 loop 规则：
```bash
make -f direct.mk recur;make -f direct.mk loop
```
终端打印：
```bash
a1:abc
a2:
a3:abc
b1:
b2:
```
从测试结果可以看出，由于 a2，b1 都引用了尚未定义的变量，因此被展开为空。
使用直接展开式变量可以避免无限递归问题和函数重复展开引发的效率问题，并且更符合一般的程序设计逻辑，便于调试问题，因此推荐用户尽量使用直接展开式变量。

#### 5.1.4 变量追加和条件赋值
使用 += 赋值符号可以对变量进行追加，变量追加时的赋值风格与变量定义时一致，若追加的是未定义变量，则默认以递归展开式风格进行赋值。
使用 ?= 赋值符号可以对变量进行条件赋值，若变量未被定义则会对变量进行赋值，否则不改变变量的当前定义。
append.mk 文件演示了追加赋值和条件赋值的使用方式，内容如下：
```
#this makefile is for += test

.PHONY:dir recur

a1 := aa1
a1 += _a1st
a2 := _a2
a1 += $(a2)
a1 += $(a3)
a3 += $(a1)

b1 = bb1
b1 += _b1st
b2 = _b2
b1 += _b2
b1 += $(b3)
b3 += $(b1)

c1 += $(c2)
c2 += $(c1)

d1 ?= dd1
d2 = dd2
d2 ?= dd3

dir:
	@echo "a1:"$(a1)

recur:
	@echo "b1:"$(b1)

def:
	@echo "c1:"$(c1)


cond:
	@echo "d1:"$(d1)
	@echo "d2:"$(d2)
```
dir 和 recur 规则演示了递归展开式变量和直接展开式变量使用追加赋值的区别。
def 规则演示了未定义变量追加赋值的默认风格。
cond 演示了条件赋值的使用。
分别执行四条规则：
```bash
make -f append.mk dir;make -f append.mk recur;make -f append.mk def;make -f append.mk cond
```
终端打印：
```bash
a1:aa1 _a1st _a2
append.mk:16: *** Recursive variable 'b1' references itself (eventually).  Stop.
append.mk:19: *** Recursive variable 'c1' references itself (eventually).  Stop.
d1:dd1
d2:dd2
```
请自行分析每一行打印与其原因。

### 5.2 变量的替换
#### 5.2.1 替换引用
对于已经定义的变量，可以使用“替换引用”对其指定的字符串进行替换。
替换引用的格式为 $(VAR:A=B)，它可以将变量 VAR 中所有 A 结尾的字符替换为 B 结尾的字符。
也可以使用模式符号将符合 A 模式的字符替换为 B 模式。
chapter9/rep/makefile 演示了变量的替换引用，内容如下：
```
.PHONY:all

vari_a := fa.o fb.o fc.o f.o.o
vari_b := $(vari_a:.o=.c)
vari_c := $(vari_a:%.o=%.c)
vari_d := $(vari_a:f.o%=f.c%)

all:
	@echo "vari_a:" $(vari_a)
	@echo "vari_b:" $(vari_b)
	@echo "vari_c:" $(vari_c)
	@echo "vari_d:" $(vari_d)

```
文件中分别对不同的变量进行替换引用和模式替换引用，进入 rep 目录并测试：
```bash
cd ../rep;make
```
终端打印：
```bash
vari_a: fa.o fb.o fc.o f.o.o
vari_b: fa.c fb.c fc.c f.o.c
vari_c: fa.c fb.c fc.c f.o.c
vari_d: fa.o fb.o fc.o f.c.o
```
vari_b 中的 .o 后缀被替换成了 .c 后缀，f.o.o 被替换未 f.o.c，这表明只有后缀会被替换，字符串的其它部分保持不变。
vari_c 则是使用模式符号替换后缀，结果与 vari_b 一致。
vari_d 使用模式符号将前缀 f.o 替换为 f.c。

#### 5.2.2 环境变量的使用
对于 makefile 来说，系统下的环境变量都是可见的。若文件中的变量名与环境变量名一致，默认引用文件中的变量。
文件 envi.mk 演示了变量 CC 与环境变量 CC 发生冲突时的执行情况：
```

.PHONY:all

CC := abc

all:
	@echo $(CC)

```
文件定义一个 CC 变量并赋值为 abc，执行终极目标时打印 CC 变量的内容。
我们先 export 一个环境变量 CC，再执行 envi.mk 观察两个变量是否有区别：
```bash
export CC=def;echo $CC;make -f envi.mk
```
终端打印：
```bash
def
abc
```
说明 makefile 自定义变量优先级高于环境变量。我们也可以在 makefile 中取消 CC 变量的定义或者修改 PATH 变量定义看看会发生什么状况。

#### 5.2.3 防止环境变量被覆盖
可以使用 -e 选项防止环境变量被同名变量覆盖，如上述实验加入 -e 选项：
```bash
make -f envi.mk -e
```
终端打印：
```bash
def
```

#### 5.2.4 命令行变量
与环境变量不同，在执行 make 时指定的命令行变量会覆盖 makefile 中同名的变量定义，
如果希望变量不被覆盖则需要使用 override 关键字。
override.mk 文件演示了命令行参数的覆盖和 override 关键字的使用：
```
.PHONY:all

vari_a = abc
vari_b := def

override vari_c = hij
override vari_d := lmn

vari_c += xxx
vari_d += xxx

override vari_c += zzz
override vari_d += zzz

all:
	@echo "vari_a:" $(vari_a)
	@echo "vari_b:" $(vari_b)
	@echo "vari_c:" $(vari_c)
	@echo "vari_d:" $(vari_d)
	@echo "vari_e:" $(vari_e)
```
vari_a 和　vari_c 是递归展开式变量，vari_b 和　vari_d 是直接展开式变量，vari_e 是未定义变量。
现在从命令行传入 vari_a 到 vari_e 并查看变量最终的展开值：
```bash
make -f override.mk vari_a=va vari_b=vb vari_c=vc vari_d=vd vari_e=ve
```
终端打印：
```bash
vari_a: va
vari_b: vb
vari_c: hij zzz
vari_d: lmn zzz
vari_e: ve
```
从打印可以看出无论哪种风格的变量，都需要使用 override 指示符才能防止命令行定义的同名变量覆盖。
同时，用 override 定义的变量在进行修改时也需呀使用 override，否则修改不会生效，验证方法如下：
```bash
make -f override.mk
```
终端打印：
```bash
vari_a: abc
vari_b: def
vari_c: hij zzz
vari_d: lmn zzz
vari_e:
```
可见命令行没有传入变量，但 vari_c 和 vari_d 仍然无法追加不用 override 指示符时的 “+= zzz”。

### 5.3 目标指定变量和模式指定变量
makefile 中定义的变量通常时对整个文件有效，类似于全局变量。除了普通的变量定义以外，还有一种目标指定变量，定义在目标依赖项处，仅对目标上下文可见。这里的目标上下文也包括了目标依赖项的规则。
目标指定变量还可以定义在模式目标中，称为模式指定变量。
当目标中使用的变量既在全局中定义，又在目标中定义时，目标定义优先级更高，但需注意：目标指定变量与全局变量是两个变量，它们的值互不影响。
chapter9/target/makefile 演示了目标指定变量的用法，内容如下：
```bash
.PHONY:all

vari_a=abc
vari_b=def

all:vari_a:=all_target

all:pre_a pre_b file_c
	@echo $@ ":" $(vari_a)
	@echo $@ ":" $(vari_b)

pre_%:vari_b:=pat
	pre_%:
	@echo $@ ":" $(vari_a)
	@echo $@ ":" $(vari_b)

file_%:
	@echo $@ ":" $(vari_a)
	@echo $@ ":" $(vari_b)
```
makefile 中定义了 vari_a 和 vari_b 两个全局变量，目标 all 指定了一个同名的 vari_a 变量，模式目标 pre_% 指定了一个同名的 vari_b变量。
每个目标的规则中都打印它们能看到的 vari_a 和 vari_b 的值，大家可以根据前面所述的规则推测每个目标分别会打印什么信息。
进入 target 目录，执行 make：
```bash
cd ../target;make
```
终端打印：
```bash
pre_a : all_target
pre_a : pat
pre_b : all_target
pre_b : pat
file_c : all_target
file_c : def
all : all_target
all : def
```
由于终极目标 all 指定了 vari_a 为“all_target”，因此在整个目标重建过程中 vari_a 都以目标指定变量的形式出现。vari_b 仅在模式目标 pre_% 中被定义，因此对 pre_a 和 pre_b 来说，vari_b 为”pat“，但对 file_% 和 all 目标而言，vari_b 是全局变量，展开后为”def“。

我们也可以单独以 pre_a 和 file_c 为目标，看看内容有什么区别：
```bash
make pre_a
```
终端打印：
```bash
pre_a : abc
pre_a : pat
```
再执行：
```bash
make file_c
```
终端打印：
```bash
file_c : abc
file_c : def
```
由于此时并非处于 all 目标的上下文中，所以 all 指定的 vari_a 变量失效，取而代之的是原有的值 "abc"，而 pre_% 指定了 vari_b 变量，所以对 pre_a 来说，vari_b 变量依然是 "pat"。
#### 5.4 自动化变量
在模式规则中，一个模式目标可以匹配多个不同的目标名，但工程重建过程中经常需要指定一个确切的目标名，为了方便获取规则中的具体的目标名和依赖项，makefile 中需要用到自动化变量，自动化变量的取值是根据具体所执行的规则来决定的，取决于所执行规则的目标和依赖文件名。
总共有七种自动化变量：
$@：目标名称
$%：若目标名为静态库，代表该静态库的一个成员名，否则为空
$<：第一个依赖项名称
$?：所有比目标文件新的依赖项列表
$^：所有依赖项列表，重名依赖项被忽略
$+：包括重名依赖项的所有依赖项列表
$*：模式规则或静态模式规则中的茎，也即”%“所代表的部分

chapter9/auto/makefile 演示了七种自动化变量的用法，文件内容如下：
```bash
# $@ $^ $% $< $? $* $+

.PHONY:clean

PRE:=pre_a pre_b pre_a pre_c

all:$(PRE) lib -ladd
	@echo "$$""@:"$@
	@echo "$$""^:"$^
	@echo "$$""+:"$+
	@echo "$$""<:"$<
	@echo "$$""?:"$?
	@echo "$$""*:"$*
	@echo "$$""%:"$%
	@touch $@

$(PRE):pre_%:depen_%
	@echo "$$""*(in $@):"$*
	touch $@

depen_%:
	@echo "use depen rule to build:"$@
	touch $@

lib:libadd.a(add.o minus.o)

libadd.a(add.o minus.o):add.o minus.o
	@echo "$$""%(in $@):" $%
	$(AR) r $@ $%
	
clean:
	$(RM) pre_* depen_* *.a *.o lib all

```
终极目标 all 的依赖项包括 pre_a pre_b pre_c lib 和库文件 libadd.a，其中重复包含了一次 pre_a 依赖项。
模式规则 pre_% 利用静态模式依赖于对应的 depen_% 规则，打印匹配到的茎，并生成目标文件，库文件规则打印 $% 并打包生成 libadd.a。

现在进入 auto 目录并执行 make：
```bash
cd ../auto;make
```
终端打印：
```bash
makefile:17: target 'pre_a' given more than once in the same rule
use depen rule to build:depen_a
touch depen_a
$*(in pre_a):a
touch pre_a
use depen rule to build:depen_b
touch depen_b
$*(in pre_b):b
touch pre_b
use depen rule to build:depen_c
touch depen_c
$*(in pre_c):c
touch pre_c
cc    -c -o add.o add.c
cc    -c -o minus.o minus.c
$%(in libadd.a): add.o
ar r libadd.a add.o
ar: creating libadd.a
make: Warning: Archive 'libadd.a' seems to have been created in deterministic mode. 'add.o' will always be updated. Please consider passing the U flag to ar to avoid the problem.
$%(in libadd.a): minus.o
ar r libadd.a minus.o
make: Warning: Archive 'libadd.a' seems to have been created in deterministic mode. 'minus.o' will always be updated. Please consider passing the U flag to ar to avoid the problem.
$@:all
$^:pre_a pre_b pre_c lib libadd.a
$+:pre_a pre_b pre_a pre_c lib libadd.a
$<:pre_a
$?:pre_a pre_b pre_c lib libadd.a
$*:
$%:

```
make 首先重建 pre_a pre_b pre_c 依赖项，并打印匹配到的茎 a b c，接下来重建 lib 规则，libadd.a 在重建过程中打印 $% ，从打印和打包命令可以看出 $% 展开后仅为 add.o 这一项文件，但静态文件目标会依据给定的文件列表展开多次。最后，make 执行终极目标 all 的命令列表，分别打印其自动化变量，并生成 all 文件。
请大家仔细观察不同规则下自动化变量的变化。由于这是初次建立终极目标，因此 $? 得到的依赖项列表是全部的依赖项。使用 touch 命令更新 pre_a pre_b 再次测试：
```bash
touch pre_a pre_b;make
```
终端打印：
```bash
makefile:17: target 'pre_a' given more than once in the same rule
make: Warning: Archive 'libadd.a' seems to have been created in deterministic mode. 'add.o' will always be updated. Please consider passing the U flag to ar to avoid the problem.
$%(in libadd.a): add.o
ar r libadd.a add.o
make: Warning: Archive 'libadd.a' seems to have been created in deterministic mode. 'add.o' will always be updated. Please consider passing the U flag to ar to avoid the problem.
make: Warning: Archive 'libadd.a' seems to have been created in deterministic mode. 'minus.o' will always be updated. Please consider passing the U flag to ar to avoid the problem.
$%(in libadd.a): minus.o
ar r libadd.a minus.o
make: Warning: Archive 'libadd.a' seems to have been created in deterministic mode. 'minus.o' will always be updated. Please consider passing the U flag to ar to avoid the problem.
$@:all
$^:pre_a pre_b pre_c lib libadd.a
$+:pre_a pre_b pre_a pre_c lib libadd.a
$<:pre_a
$?:pre_a pre_b lib libadd.a
$*:
$%:
```
打印中的警告部分暂时可以忽略，若对此部分感兴趣可以查阅 GNU make 手册静态库编译一章。
现在打印的 $? 内容为 pre_a pre_b lib libadd.a，pre_a pre_b 为手动更新的部分，而 lib 和 libadd.a 的更新则是由静态库编译规则所引发。
上述七个自动化变量除了直接引用外，还可以在其后增加 D 或者 F 字符获取目录名和文件名，
如：$(@D) 表示目标文件的目录名，$(@F) 表示目标文件的文件名。这种用法非常简单，也适用于所有的自动化变量，请大家自行实验测试。

## 六、实验总结
本本次实验介绍了 make 的变量定义风格，变量的替换引用，环境变量、命令行变量、目标指定变量的使用及自动化变量的使用。

## 七、课后习题
请自行设计实验测试自动化变量的目录名和文件名的获取。

## 八、参考链接
无
