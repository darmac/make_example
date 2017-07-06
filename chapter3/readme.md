## 一、实验介绍
本实验重点介绍 make 的两个处理阶段和条件执行语句。

### 1.1 实验内容
1. 验证 make 的两个处理阶段。
2. 测试 make 目标指令的执行细节。
3. 测试 make 的条件执行语句。

### 1.2 实验知识点 
1. make 分为两个处理阶段：1）读取所有 makefile 文件，内建变量、规则和依赖关系结构链表。2）执行更新和重建。
2. makefile 中可以使用反斜线将语句和命令分成多行。
3. makefile 中可以使用 $$$$ 打印当前进程 id。
4. makefile 中条件语句的基本格式。
5. makefile ifeq，ifneq，ifdef，ifndef的使用。

### 1.3 实验环境
Ubuntu系统, GNU gcc工具，GNU make工具

### 1.4 适合人群
本课程难度为简单，属于入门级别课程，适合有代码编写能力的用户，熟悉和掌握make的一般用法。

### 1.5 代码获取
git clone https://github.com/darmac/make_example.git

## 二、实验原理
依据 makefile 的基本规则设计相应的正反示例，验证规则。

## 三、开发准备
进入实验楼课程即可。

## 四、项目文件结构
makefile：make工程文件。

## 五、实验步骤

### 5.1 make 的两个执行阶段
#### 5.1.1 抓取源代码
使用如下 cmd 获取 GitHub 源代码：
```
cd ~/Code/
git clone https://github.com/darmac/make_example.git
cd make_example/chapter3
```

#### 5.1.2 新增 makefile 并测试执行状况
源代码中已经存在 makefile 文件，查看文件内容：
```
# this is a makefile example

vari_a = "vari a from makefile"
vari_b = "vari b from makefile"

.PHONY:all

all:
        @echo $(vari_a)
        @echo $(vari_b)

```
此文件定义了两个变量 vari_a，vari_b，并在执行 all 规则时打印它们的值。
执行 make：
```
make
```
终端打印如下：
```
vari a from makefile
vari b from makefile
```

#### 5.1.3 新增被包含文件并修改 makefile 
现在新增一个文件 inc_a，并在其中将 vari_b 变量改为 “vari b from inc_a”。
源代码中已有此文件，内容如下：
```
# this is a include file for make

vari_b = "vari b from inc_a"
```

修改 makefile 在最后一行包含 inc_a 档案。
```
include inc_a
```

#### 5.1.4 测试 include 文件是否在第一阶段被包含
我们知道 make 是按照顺序一行行读入 makefile。
前面介绍 make 的第一阶段是读入所有 makefile 及 include 文档，内建变量。
所以解析新修改的 makefile 时，inc_a 应该在第一阶段被解析完毕，vari_b 变量也被 inc_a 修改掉。
执行 make 进行验证：
```
make
```
终端打印：
```
vari a from makefile
vari b from inc_a
```
说明 vari_b 已经被修改，与 include 指示符在 makefile 的位置无关。
实验过程如下图所示：
![5.1](https://dn-anything-about-doc.qbox.me/document-uid66754labid3153timestamp1499301996552.png/wm)

### 5.2 make 目标指令的执行细节
#### 5.2.1 makefile 目标下指令的执行过程
到目前为止，我们看到 makefile 中的指令都是 shell 指令，那么 make 是怎样执行目标对应指令呢？
答案还是 shell。make 会调用 shell 去执行每一条指令。
但需要注意的是，即便在同一个目标下，每一条指令都是相互独立的。
也就是说 make 会分别调用 shell 去执行每一条指令，而非使用一个 shell 进程按顺序将所有指令都执行一遍。

#### 5.2.2 新建 makefile 测试命令 pwd 和 cd 的执行效果。
现在使用 cd 命令和 pwd 命令查看两条相邻的命令能否相互产生影响。
源文件代码中已经有 cd_test.mk 文件，内容如下：
```
# this is a makefile to test cd and pwd cmd

.PHONY:all

all:
        @pwd
        cd ..
        @pwd
```
all 规则由三条命令构成，其中“@pwd”表示打印当前绝对路径，但不要显示“pwd”命令，“cd ..”表示回到上一层目录。
因此，若三条指令是在一个 shell  进程中顺序执行，应该会先打印当前目录的绝对路径，
再返回上一层目录并打印上一层目录的绝对路径。
执行 make -f cd_test.mk 进行测试：
```
make -f cd_test.mk
```
终端打印：
```
/root/study/make_example/chapter3
cd ..
/root/study/make_example/chapter3
```
可见实际执行状况中 cd 命令并不会对下一条指令产生影响。

#### 5.2.3 在每一条指令中打印进程 id 确认指令会被不同的进程执行。
还有一个更简单的方法是打印执行当前命令的进程 id。
源文件代码中已经有 cmd_test.mk 文件，内容如下：
```
#this is a command test makefile

.PHONY:all

all:
        @echo "cmd1 process id is :" $$$$
        @echo "cmd2 process id is :" $$$$
```
其中 “$$$$” 代表的是当前进程 id。
所以 cmd_test.mk 的命令执行过程就是分别打印 all 目标下两条命令的进程 id。
执行 make -f cmd_test.mk 进行测试：
```
make -f cmd_test.mk
```
终端打印：
```
cmd1 process id is : 298
cmd2 process id is : 299
```
可以看出两条命令执行的进程 id 并不相同。

#### 5.2.4 在同一行中使用多条命令
有些状况下，用户希望能够使用 cd 命令来控制命令执行时所在的路径，
比如 cd 到某个目录下，编译其中的源代码，要如何实现呢？
此时必须在一行中写入多条指令。
先修改 cd_test.mk 文件，将三条指令都放在一行，并用“;”隔开。
请注意第三条“@pwd”的指令中，“@”符号要删掉，此符号只用于每一行的开头。
修改后的 cd_test.mk 内容如下：
```
# this is a makefile to test cd and pwd cmd

.PHONY:all

all:
        @pwd; cd .. ; pwd
```
再次执行 cmd_test.mk 文件：
```
make -f cd_test.mk
```
终端打印：
```
/root/study/make_example/chapter3
/root/study/make_example
```
说明现在三条语句已经在同一个进程中被执行到了。

同样，我们也对 cmd_test.mk 文件进行修改，再确认进程号是否一致。
修改后的 cmd_test.mk 文件内容如下：
```
#this is a command test makefile

.PHONY:all

all:
        @echo "cmd1 process id is :" $$$$;echo "cmd2 process id is :" $$$$
```
使用 make 执行此文件：
```
make -f cmd_test.mk
```
终端打印：
```
cmd1 process id is : 666
cmd2 process id is : 666
```
由此可见同一行的指令的确会被同一个进程执行到。

#### 5.2.5 使用反斜线分割命令
在同一行中书写多条指令是一件比较麻烦的事情，尤其是指令较长时，非常不方便阅读和修改。
makefile 中可以使用反斜线“\”来将一行的内容分割成多行。
源文件中有一个 multi_test.mk 脚本，用于测试反斜线的作用，内容如下：
```
#this is a command test makefile

.PHONY:all

all:
        @echo "cmd1 process \
        id is :" $$$$; \
        echo "cmd2 process id is :" $$$$
```
此文件将一条指令分割成3行，其中第一行和第二行组成一条完整的指令，内容与第三行指令相似。
两条指令的作用也是打印当前执行进程的 id 号。
使用 make 执行此文件：
```
make -f multi_test.mk
```
终端打印如下：
```
cmd1 process id is : 675
cmd2 process id is : 675
```
执行效果与修改后的 cmd_test.mk 文件一致，说明反斜杠的确能起到连接多行指令的作用。
实验过程如下图所示：
![5.2A](https://dn-anything-about-doc.qbox.me/document-uid66754labid3153timestamp1499302020075.png/wm)
![5.2B](https://dn-anything-about-doc.qbox.me/document-uid66754labid3153timestamp1499302030515.png/wm)
![5.2C](https://dn-anything-about-doc.qbox.me/document-uid66754labid3153timestamp1499302039450.png/wm)

### 5.3 条件执行语句
#### 5.3.1 条件语句的基本格式
makefile 中不包含 else 分支条件判断语句的语法格式为：
```
CONDITIONAL-DIRECTIVE
TEXT-IF-TRUE
endif
```
TEXT-IF-TRUE 可以为若干任何文本行，当条件为真时它被 make 作为需要执行的一部分。
包含 else 的格式为：
```
CONDITIONAL-DIRECTIVE
TEXT-IF-TRUE
else
TEXT-IF-FALSE
endif
```
make 在条件为真时执行 TEXT-IF-TRUE，否则执行 TEXT-IF-FALSE。

#### 5.3.2 ifeq 语句
ifeq 用于判断条件是否相等，可以支持以下几种格式：
ifeq (ARG1, ARG2)
ifeq 'ARG1' 'ARG2'
ifeq "ARG1" "ARG2"
ifeq "ARG1" 'ARG2'
ifeq 'ARG1' "ARG2"
**请注意：ifeq/ifneq 等关键字后面一定要接一个空格，否则 make 会因为无法识别关键字而报错！**
源文件代码中已有 eq.mk 文件，内容如下：
```
#this is a makefile to test ifeq

.PHONY:all

b="ifeq default"

ifeq ($(a),1)
b="ifeq a 1"
endif

ifeq '$(a)' '2'
b="ifeq a 2"
endif

ifeq "$(a)" "3"
b="ifeq a 3"
endif

ifeq "$(a)" '4'
b="ifeq a 4"
endif

ifeq '$(a)' "5"
b="ifeq a 5"
endif

all:
        @echo $(b)
```
使用 make 重建目标 all 时，将会根据 a 的值重新定义 b 的值并将其打印出来。
使用 make 命令执行此文件，指令及打印内容如下：
```
shiyanlou:chapter3/ (master*) $ make -f eq.mk
ifeq default
shiyanlou:chapter3/ (master*) $ make -f eq.mk a=1
ifeq a 1
shiyanlou:chapter3/ (master*) $ make -f eq.mk a="1"
ifeq a 1
shiyanlou:chapter3/ (master*) $ make -f eq.mk a=2  
ifeq a 2
shiyanlou:chapter3/ (master*) $ make -f eq.mk a=3
ifeq a 3
shiyanlou:chapter3/ (master*) $ make -f eq.mk a=4
ifeq a 4
shiyanlou:chapter3/ (master*) $ make -f eq.mk a=5
ifeq a 5
shiyanlou:chapter3/ (master*) $ make -f eq.mk a=6
ifeq default
```

#### 5.3.3 ifneq 语句
ifneq 支持的格式与 ifeq 相同，
源文件代码中已经有 neq.mk，内容如下：
```
#this is a mekfile to test ifneq

.PHONY:all

ifneq ($(a),)
b=$(a)
else
b="null"
endif

all:
        @echo "value b is:" $(b)
```
neq.mk 中使用了 ifneq ... else ... endif 结构。
当 a 不为空时，b 的值与 a 相同，否则 b 为默认值“null”。
执行 make 时会打印 b 的值，指令及打印内容如下：
```
shiyanlou:chapter3/ (master*) $ make -f neq.mk
value b is: null
shiyanlou:chapter3/ (master*) $ make -f neq.mk a=1
value b is: 1
shiyanlou:chapter3/ (master*) $ make -f neq.mk a=2
value b is: 2
shiyanlou:chapter3/ (master*) $ make -f neq.mk a="hello"
value b is: hello
```

#### 5.3.4 ifdef 语句
ifdef 语句的语法格式如下：
ifdef VARIABLE-NAME
ifdef 只会判断变量是否有值，而不关心其值是否为空。

现在我们测试 ifdef 的用法，以及要怎样理解变量值为空和变量未定义的差别。
源文件代码中已经存在 def.mk 文件，内容如下：
```
#this is a makefile to test ifdef

.PHONY:all

a=
b=$(a)

ifdef a
c="a is defined"
else
c="a is not defined"
endif

ifdef b
d="b is defined"
else
d="b is not defined"
endif

all:
        @echo "vari a is:" $(a)
        @echo "vari b is:" $(b)
        @echo "vari c is:" $(c)
        @echo "vari d is:" $(d)
```

def.mk 文件中先声明了一个变量 a，但并未给其赋值，这相当于是未定义变量。
变量 a 又被赋给了变量 b，由于 a 是未定义变量，因此 b 为空值。
make 执行此文件时分别打印变量 a b c d 的值。
执行 make：
```
make -f def.mk
```
终端打印：
```
vari a is:
vari b is:
vari c is: a is not defined
vari d is: b is defined
```
可见对 make 来说，它认为 a 属于未定义变量，b 则属于已定义变量。

#### 5.3.5 ifndef 语句
ifneq 格式与 ifeq 相同，逻辑上与 ifneq 相反。
源文件代码中已有 ndef.mk 文件，内容与 def.mk 相似：
```
#this is a makefile to test ifndef

.PHONY:all

a=
b=$(a)

ifndef a
c="a is not defined"
else
c="a is defined"
endif

ifndef b
d="b is not defined"
else
d="b is defined"
endif

all:
        @echo "vari a is:" $(a)
        @echo "vari b is:" $(b)
        @echo "vari c is:" $(c)
        @echo "vari d is:" $(d)
```
执行 make：
```
make -f ndef.mk
```
终端打印：
```
vari a is:
vari b is:
vari c is: a is not defined
vari d is: b is defined
```
实验过程如下图所示：
![5.3](https://dn-anything-about-doc.qbox.me/document-uid66754labid3153timestamp1499302063942.png/wm)

## 六、实验总结
本实验测试了 make 执行的两个阶段，目标指令的执行细节和条件执行语句的编写。

## 七、课后习题
无

## 八、参考链接
无
