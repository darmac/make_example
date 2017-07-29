递归展开变量
展开时机测试
递归死锁
直接展开变量
(sub，跳过)如何定义空格
+=
与原定义展开风格一致
追加的单词会有空格隔开
?=     
变量的替换引用：后缀替换引用，模式替换引用

verride指示符
override普通用法
后续改变也要override指示符，否则无效
系统环境变量与-e选项
系统环境变量对make可见
使用-e选项
export CC=xyz;echo ${CC};make -f envi.mk;make -f envi.mk
目标指定变量与模式指定变量
目标指定变量与全局变量的冲突：局部使用目标，不影响全局变量的值
使用-e选项会覆盖目标指定变量，因此推荐使用override
与全局变量风格可以不一致
目标指定变量在目标的依赖项中也有效
模式指定变量与目标指定变量用法相似
make;make pre_d;make file_d
自动化变量
七种基本变量
变量扩展


makefile 变量就是一个名字，代表一个文本字符串。变量有两种定义方式：递归展开式变量和直接展开式变量。
变量在 makefile 的读入阶段被展开成字符串。
####5.1.2 递归展开式变量
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
现在传入
