## 一、实验介绍
本次实验将介绍 make 对规则命令的执行，命令执行过程中的错误处理以及命令包的使用。

### 1.1 实验内容
1. make 对规则命令的执行
2. make 的多线程执行
3. make 的错误忽略选项
4. make 的异常结束
5. 命令包的使用

### 1.2 实验知识点 
1. make 使用 $(SHELL) 来执行规则命令，make 会对 $(SHELL) 环境变量重新赋值，而非使用系统同名变量。
2. make 可以使用 -j 选项来进行多线程执行。
3. make 可以使用 - 来忽略当前行命令的错误，使用 -i 忽略所有错误，使用 -k  跳过依赖项错误继续重建其它依赖项。
4. 当 make 被异常结束时，会删除当前的目标文件。
5. 使用 define 可以定义命令包，其本质与C语言的宏定义相似。

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
├── cancel：make 的异常结束处理
│   └── makefile
├── error：make 命令的错误处理
│   ├── iopt.mk
│   ├── kopt.mk
│   └── makefile
├── joption：make 的并行使用
│   └── makefile
├── pack：命令包使用测试
│   └── makefile
├── Readme.md
└── shell_vari：验证 $(SHELL) 环境变量的传递
    └── shell.mk
```

## 五、实验步骤

### 5.1 make 对规则命令的执行
#### 5.1.1 抓取源代码
使用如下 cmd 获取 GitHub 源代码并进入相应章节：
```bash
cd ~/Code/
git clone https://github.com/darmac/make_example.git
cd make_example/chapter7
```

#### 5.1.2 SHELL 环境变量的传递
make 使用环境变量 SHELL 指定的程序来处理规则命令行，GNU make 中默认的程序是 /bin/sh；
与其它环境变量不同的是，SHELL 变量会由 GNU make 自行定义，而不会使用当前系统的同名变量。
这样做的理由是：make 认为系统的 SHELL 变量适用于定义人机交互接口，make 没有交互过程，因此不适用。

shell_vari 目录下的 shell.mk 文件演示了系统环境变量 SHELL 和 make 使用的环境变量的差异，
文件内容如下：
```bash
#this is a makefile for $(SHELL) test

.PHONY:all

all:
        @echo "\$$SHELL environment is $$SHELL"
        @echo "\$$SHELL in makefile is " $(SHELL)
```
由于符号 $ 是变量引用的起始字符，因此要使用 $ 本身这个字符时需要使用 $$ 进行转义。
all 规则的第一条指令是打印系统环境变量 SHELL，$$ 代表 $ 字符，所以在终端上印出来的内容相当于：
```
"\$SHELL environment is $SHELL"
```
\ 符号是终端下的转义字符，$ 符号在终端下同样是变量引用的起始字符，因此 $SHELL 会被系统环境变量 SHELL 的内容代替，而 \$SHELL 会被打印为 “$SHELL”。
all 规则的第二条指令是打印当前 make 使用的 SHELL 变量。
进入 shell_vari 目录，并查看当前系统 SHELL 变量：
```bash
cd shell_vari/;echo $SHELL
```
终端打印：
```bash
/usr/bin/zsh
```
再执行 make 看看 SHELL 变量定义是什么：
```bash
make -f shell.mk
```
终端打印：
```bash
$SHELL environment is /usr/bin/zsh
$SHELL in makefile is  /bin/sh
```
可见 make 使用的是自己默认的变量，与系统 SHELL 变量无关。

#### 5.1.3 SHELL 变量传参
下面再实验在执行 make 时，传入 SHELL 变量为 abc：
```bash
make -f shell.mk SHELL=abc
```
终端打印：
```bash
make: abc: Command not found
make: *** [all] Error 127
```
可见 make 尝试用我们传入的 abc 来执行规则结果因为找不到 abc 导致执行失败。
这说明 make 自身的 SHELL 变量也是可以通过传参进行修改的。
实验过程如下图所示：
![5.1](https://dn-anything-about-doc.qbox.me/document-uid66754labid3334timestamp1500902386792.png/wm)

### 5.2 make 的多线程执行
make 也可以使用多线程进行并发执行，使用方法为执行 make 时加入命令行选项 -jN，N 为一个数字，表示要执行的线程数。
当 make 的每个线程会执行一个规则的重建，每条规则只由一个线程执行。
不使用 -j 选项时为单线程编译。

chapter7/joption/makefile 文件给出了测试方法，内容如下：
```
#this is a makefile for -j option

.PHONY:all

all:aim1 aim2 aim3 aim4
        @echo "build final finish!"

aim%:
        @echo "now build " $@
        @sleep 2
        @echo "build " $@ " finish!"
```
终极目标 all 有 aim1 到 aim4 四个依赖项，每个依赖项的规则一致，打印信息并睡眠两秒。
进入 joption 目录，并执行 make，完成编译需要8秒。
```bash
cd ../joption/;make
```
终端打印：
```bash
now build  aim1
build  aim1  finish!
now build  aim2
build  aim2  finish!
now build  aim3
build  aim3  finish!
now build  aim4
build  aim4  finish!
build final finish!
```
现在使用两个线程执行 makefile：
```bash
make -j2
```
可以看到终端先同时印出 aim1 aim2 的执行信息，两秒后再打印 aim3 aim4 的执行信息，用时为4秒，比单线程缩短一倍，内容如下：
```bash
now build  aim2
now build  aim1
build  aim2  finish!
build  aim1  finish!
now build  aim3
now build  aim4
build  aim3  finish!
build  aim4  finish!
build final finish!
```
大家可以再测试一下三线程和四线程的并行执行过程，并尝试在目标中加入依赖项来限制并行编译的顺序。
实验过程如下图所示：
![5.2](https://dn-anything-about-doc.qbox.me/document-uid66754labid3334timestamp1500903287157.png/wm)

### 5.3 make 的错误忽略选项
#### 5.3.1 make 执行过程出错的简单测试
下面我们来看一下 make 执行出错的状况。
chapter7/error/ 目录下的 makefile 文件演示了 rm 命令的执行状况，内容如下：
```
#this is a makefile for error handle test

.PHONY:all

all:pre_a pre_b pre_c
        $(RM) pre_a
        $(RM) pre_b
        $(RM) pre_c
        $(RM) d
        -rm e
        rm f
        rm g

pre_%:
        touch $@
```
前面三条指令是删除生成的文件，后面四条指令则是删除不存在的文件，在 shell 使用 rm 会直接运行失败。
现在执行此 makefile 并解释执行状况：
```bash
cd ../error/;make
```
终端打印：
```bash
touch pre_a
touch pre_b
touch pre_c
rm -f pre_a
rm -f pre_b

rm -f pre_c
rm -f d
rm e
rm: cannot remove 'e': No such file or directory
make: [all] Error 1 (ignored)
rm f
rm: cannot remove 'f': No such file or directory
make: *** [all] Error 1
```
make 在运行规则命令结束后会检测命令执行的返回状态，返回成功则启动另外一个子 shell 来执行下一条命令。
在 makefile 执行过程中，先生成 pre_a pre_b pre_c 三个文件，再使用 rm -f 或者 rm 删除它们，这个过程没有问题。
第四条指令是删除不存在的文件 d，由于使用了 -f 参数，因此 shell 也不会返回错误。
第五条指令是删除不存在的文件 e，由于命令行起始处使用了符号“-”，make 会忽略此命令的执行错误，所以 shell 虽然返回并打印错误，但 make 继续往下执行。
第六条指令是删除不存在的文件 f，由于只使用了 rm 命令，shell 返回错误，make 收到错误后不再往下执行，
因此第七条指令已经没机会执行到。

#### 5.3.2 忽略命令执行错误
在某些状况下，用户希望 make 遇上错误可以继续往下执行。在多人维护的庞大工程中，makefile 文件随时可能出现错误，这时用户希望它能继续执行下去方便测试自己的模块，而不是被其他人的错误阻塞住。
此时可以使用 -i 选项，-i 选项会让 make 忽略所有的错误。
iopt.mk 文件可以演示 -i 选项的用法，内容如下：
```
#this is a makefile for error handle test

.PHONY:all

all:
        rm a
        rm b
        rm c
        rm d

```
make 会直接调用 rm 删除四个不存在的文件，每一条指令都会返回错误。
先看正常执行结果，直接使用 make：
```bash
make -f iopt.mk
```
终端打印：
```bash
rm a
rm: cannot remove 'a': No such file or directory
make: *** [all] Error 1
```
现在加入 -i 选项：
```bash
make -f iopt.mk -i
```
终端打印：
```bash
rm a
rm: cannot remove 'a': No such file or directory
make: [all] Error 1 (ignored)
rm b
rm: cannot remove 'b': No such file or directory
make: [all] Error 1 (ignored)
rm c
rm: cannot remove 'c': No such file or directory
make: [all] Error 1 (ignored)
rm d
rm: cannot remove 'd': No such file or directory
make: [all] Error 1 (ignored)
```
现在 make 可以执行到每一条指令了。

#### 5.3.3 忽略依赖项错误
当 make 遇上依赖项不存在时，-i 选项就不管用了，因为它不属于命令行错误。
kopt.mk 文件用于演示依赖文件错误的状况，内容如下：
```bash
#this is a makefile for error handle test

.PHONY:all

all: h i j
        @echo "exe OK!"

```
分别使用 make 和 make -i 执行此文件：
```bash
make -f kopt.mk ; make -f kopt.mk -i
```
终端打印：
```bash
make: *** No rule to make target 'h', needed by 'all'.  Stop.
make: *** No rule to make target 'h', needed by 'all'.  Stop.
```
说明在依赖项错误中 -i 选项没有任何作用。此时可以使用 -k 选项让其忽略依赖项错误并继续执行：
```bash
make -f kopt.mk -k
```
终端打印：
```bash
make: *** No rule to make target 'h', needed by 'all'.
make: *** No rule to make target 'i', needed by 'all'.
make: *** No rule to make target 'j', needed by 'all'.
make: Target 'all' not remade because of errors.
```
-k 选项可以让 make 继续检查其它依赖项，但并不会执行终极目标的指令。
若有多个依赖项被修改过后，可以使用此选项测试哪些依赖项的修改有问题。

请谨慎使用 -i 和 -k 选项，以免产生预期外的错误。
实验过程如下图所示：
![5.3A](https://dn-anything-about-doc.qbox.me/document-uid66754labid3334timestamp1500903634972.png/wm)
![5.3B](https://dn-anything-about-doc.qbox.me/document-uid66754labid3334timestamp1500903648989.png/wm)

### 5.4 make 的异常结束
make 若收到致命信号被终止时，它会删除此过程中已经重建的目标文件，以免目标文件出现预期外的错误。
例如某个目标规则需要对目标文件进行多次处理，处理到一半时 make 被终止，导致目标文件处于异常状态，
因此 make 会删除此文件以免产生难以察觉的问题。
chapter7/cancel/ 目录下目录下的 makefile 用于演示 make 异常结束的状况，内容如下：
```
#this is a makefile for cancel handle

.PHONY:all clean

all:clean pre_a pre_b pre_c
        sleep 1
        @echo "exe target all!"

clean:
        $(RM) pre_*

pre_%:
        @echo "\n"
        touch $@
        @echo "generate " $@
        @ls -l $@
        @echo "sleep 5s before finish..."
        sleep 5
```
终极目标 all 依赖于 pre_a pre_b pre_c 文件，这三个文件在建立过程中会 sleep 五秒钟，方便用户结束 make 命令。
先正常执行一次：
```bash
cd ../cancel/;make
```
终端显示执行成功，并在当前目录下生成 pre_a pre_b pre_c 三个目标文件。
现在在产生 pre_b 的过程中使用 ctrl+c 结束 make 进程，终端打印如下：
```bash
rm -f pre_*


touch pre_a
generate  pre_a
-rw-rw-r-- 1 shiyanlou shiyanlou 0 Jul 24 21:44 pre_a
sleep 5s before finish...
sleep 5


touch pre_b
generate  pre_b
-rw-rw-r-- 1 shiyanlou shiyanlou 0 Jul 24 21:44 pre_b
sleep 5s before finish...
sleep 5
^Cmake: *** Deleting file `pre_b'
make: *** [pre_b] Interrupt

```
在 pre_b 规则命令使用 ls 命令查看到当前目录下已经有 pre_b 文件生成。
make 被强制结束后，再次使用 ls 命令查看当前目录文件：
```bash
ls -l pre*
```
文件内容如下：
```bash
-rw-r--r-- 1 root root 0 Jul 24 08:12 pre_a
```
可见 pre_b 已经被 make 自行删除。从 make 的打印内容中也可以看出它有执行删除 pre_b 的动作。
实验过程如下图所示：
![5.4A](https://dn-anything-about-doc.qbox.me/document-uid66754labid3334timestamp1500903955685.png/wm)
![5.4B](https://dn-anything-about-doc.qbox.me/document-uid66754labid3334timestamp1500903965157.png/wm)

### 5.5 命令包的使用
书写 makefile 时，可能有多个规则会使用一组相同的命令，就像 c 语言要调用函数一样，
我们可以使用 define 来完成这项功能。define 以“define”开头，以“endef” 结束，作用与 c 语言的宏定义类似。
chapter7/pack/ 目录下演示了命令包的使用方法，其内容如下：
```
#this is a makefile for define test

.PHONY:all

define echo-target
@echo "now rebuilding target : " $@
touch $@
endef

all:pre_a pre_b pre_c
        @echo "final target finish!"

pre_%:
        $(echo-target)
```
终极目标 all 的依赖项都会调用同一组命令包。
进入 pack 目录并测试执行效果：
```bash
cd ../pack/;make
```
终端打印：
```bash
now rebuilding target :  pre_a
touch pre_a
now rebuilding target :  pre_b
touch pre_b
now rebuilding target :  pre_c
touch pre_c
final target finish!
```
实验过程如下图所示：
![5.5](https://dn-anything-about-doc.qbox.me/document-uid66754labid3334timestamp1500904033315.png/wm)

## 六、实验总结
本次实验测试了 make 对规则命令的执行，命令执行过程中的错误处理以及命令包的使用方式。

## 七、课后习题
1.请使用目标依赖来控制并行编译的顺序。
2.请尝试在命令包中使用变量控制参数的输入和输出。

## 八、参考链接
无
