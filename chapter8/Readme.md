## 一、实验介绍
本次实验将介绍 make 的递归执行及其过程中变量、命令行参数的传递规则。

### 1.1 实验内容
1. make 的递归执行示例
2. 递归执行过程中变量的传递
3. 测试 MAKELEVEL 环境变量
4. 命令行参数和变量的传递

### 1.2 实验知识点 
1. make 的 -w 选项可以打印 make 进入和离开目录的信息。
2. makefile 中通常使用 $(MAKE) 递归执行下层 makefile，以确保上下层的 make 程序一致。
3. 递归执行过程中，顶层文件的变量默认不会传给下层文件。
4. 可以使用 export 进行变量传递，也可以使用 unexport 取消传递。
5. 当上层变量和下层变量定义有冲突时，下层优先级更高，也可以使用 -e 选项取消下层的定义。
6. $(SHELL) 变量和 $(MAKEFLAGS) 变量默认会传给下层文件。
7. $(MAKELEVEL) 可以显示 make 当前的文件层级。
8. $(MAKEFLAGS) 变量会记录 make 的命令行选项和参数。

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
├── flags：用于测试 MAKEFLAGS 变量
│   ├── dir_a
│   │   └── makefile
│   └── makefile
├── level：用于测试 MAKELEVEL 变量
│   ├── dir_a
│   │   ├── dir_b
│   │   │   └── makefile
│   │   └── makefile
│   └── makefile
├── Readme.md
├── recur：用于测试 make 的递归调用
│   ├── dir_a
│   │   └── makefile
│   ├── dir_b
│   │   └── makefile
│   └── makefile
└── vari：用于测试 make 递归调用的变量传递
    ├── dir_a
    │   └── makefile
    ├── dir_b
    │   └── makefile
    ├── dir_c
    │   └── makefile
    ├── export.mk
    ├── makefile
    └── spec.mk
```

## 五、实验步骤

### 5.1 make 的递归执行示例
#### 5.1.1 抓取源代码
使用如下 cmd 获取 GitHub 源代码并进入相应章节：
```bash
cd ~/Code/
git clone https://github.com/darmac/make_example.git
cd make_example/chapter8
```

#### 5.1.2 测试 make 的递归调用
make 的递归过程是指：在 makefile 中使用 make 作为命令来执行本身或其它 makefile 文件。
在实际项目中，我们经常需要用到 make 的递归调用，这样可以简化每个模块的 makefile 设计与调试，便于项目管理。
chapter8/recur/ 目录演示了一个简单的递归调用过程，主目录 makefile 内容如下：
```
#this is a makefile for recursion test

subdir := dir_a dir_b

.PHONY:clean all $(subdir)

all:$(subdir)
        @echo "final target finish!"

$(subdir):
        cd $@;$(MAKE)
```
终极目标 all 依赖于两个依赖项，依赖项的规则命令是进入子目录并调用底层的 makefile。
这里有三个地方需要说明：
1）subdir 变量使用了 := 进行赋值，这是直接展开赋值，即 make 读到此行时就直接将 subidr 文本固定为后面赋值的内容。我们会在后续章节继续讲解 := 与 = 的差别。对简单的 makefile 而言，推荐大家尽量使用 := 的赋值方式。
2）.PHONY 中也引用了变量 subdir，这样做没有任何问题。
3）观察依赖项的规则命令，进入子目录后使用了 $(MAKE) 而非 make，这样做的好处是保证执行上下层 makefile 的 make 都是同一个程序。

两个子目录下的 makefile 文件内容相同，都是：
```
.PHONY:show

show:
        @echo "target " $@ "@" $(PWD)
```
所以子目录的执行过程是更新目录时间戳，并打印当前执行路径。

现在进入 recur 目录并执行 make：
```bash
cd recur/;make
```
终端打印：
```bash
cd dir_a;make
make[1]: Entering directory `/home/shiyanlou/Code/make_example/chapter8/recur/dir_a'
target  show @ /home/shiyanlou/Code/make_example/chapter8/recur/dir_a
make[1]: Leaving directory `/home/shiyanlou/Code/make_example/chapter8/recur/dir_a'
cd dir_b;make
make[1]: Entering directory `/home/shiyanlou/Code/make_example/chapter8/recur/dir_b'
target  show @ /home/shiyanlou/Code/make_example/chapter8/recur/dir_b
make[1]: Leaving directory `/home/shiyanlou/Code/make_example/chapter8/recur/dir_b'
final target finish!
```
分析打印内容可知，make 先后进入 dir_a 和 dir_b 目录执行目录下的 makefile，并完成终极目标的重建。
除了预期打印之外，终端上还多出了几行 make 进出目录的打印信息，这其实是由 -w 选项来控制的。
make 在进行递归调用时会自动传递 -w 选项给下层 make。
我们在顶层 make 也加上 -w 确认一下效果：
```bash
make -w
```
终端打印：
```bash
make: Entering directory `/home/shiyanlou/Code/make_example/chapter8/recur'
cd dir_a;make
make[1]: Entering directory `/home/shiyanlou/Code/make_example/chapter8/recur/dir_a'
target  show @ /home/shiyanlou/Code/make_example/chapter8/recur/dir_a
make[1]: Leaving directory `/home/shiyanlou/Code/make_example/chapter8/recur/dir_a'
cd dir_b;make
make[1]: Entering directory `/home/shiyanlou/Code/make_example/chapter8/recur/dir_b'
target  show @ /home/shiyanlou/Code/make_example/chapter8/recur/dir_b
make[1]: Leaving directory `/home/shiyanlou/Code/make_example/chapter8/recur/dir_b'
final target finish!
make: Leaving directory `/home/shiyanlou/Code/make_example/chapter8/recur'
```
可知 make 在执行顶层 makefile 和执行完毕之后都会打印进出当前目录的信息。
实验过程如下图所示：
![5.1](https://dn-anything-about-doc.qbox.me/document-uid66754labid3336timestamp1501111567479.png/wm)

### 5.2 递归执行过程中变量的传递
#### 5.2.1 变量传递
在 make 的递归执行过程中，上层的变量默认状态下是不会传递给下层 makefile 的。
chapter8/vari/ 目录下的内容演示了变量传递的过程，先看看 chapter8/vari/makefile 文件：
```
#this is a makefile for recursion test

subdir := dir_a dir_b

.PHONY:clean all $(subdir)

all:$(subdir)
        @echo "final target finish!"

$(subdir):
        cd $@;$(MAKE)
```
与上一个实验中的内容一致，进入两个子目录并调用 $(MAKE) 之后打印完成消息。
dir_a/makefile 的内容如下：
```
.PHONY:show

show:
    @echo "target " $@ "@" $(PWD)
    @echo "vari subdir is " $(subdir)
```
打印当前目录，并打印 subdir 变量的内容。
dir_b/makefile 内容相似,但多出了一个 subdir 的定义：
```
.PHONY:show

subdir := none

show:
        @echo "target " $@ "@" $(PWD)
        @echo "vari subdir is " $(subdir)
```
执行打印，看看子目录的 subdir 内容：
```bash
cd ../vari/;make
```
终端打印：
```bash
cd dir_a;make
make[1]: Entering directory `/home/shiyanlou/Code/make_example/chapter8/vari/dir_a'
target  show @ /home/shiyanlou/Code/make_example/chapter8/vari/dir_a
vari subdir is 
make[1]: Leaving directory `/home/shiyanlou/Code/make_example/chapter8/vari/dir_a'
cd dir_b;make
make[1]: Entering directory `/home/shiyanlou/Code/make_example/chapter8/vari/dir_b'
target  show @ /home/shiyanlou/Code/make_example/chapter8/vari/dir_b
vari subdir is  none
make[1]: Leaving directory `/home/shiyanlou/Code/make_example/chapter8/vari/dir_b'
final target finish!
```
可见上层的 subdir 变量没有传递到下层 makefile 中。

#### 5.2.2 使用 export 传递变量
如果想要将上层变量往下层传递，需要用到 export 关键字，格式为：
```
export VARIABLE ...
```
export.mk 文件演示了 export 的用法，它的内容与 makefile 一致，只是在定义完 subdir 之后多了一行：
```
export subdir
```
执行 export.mk 文件：
```bash
make -f export.mk
```
终端打印：
```
cd dir_a;make
make[1]: Entering directory `/home/shiyanlou/Code/make_example/chapter8/vari/dir_a'
target  show @ /home/shiyanlou/Code/make_example/chapter8/vari/dir_a
vari subdir is  dir_a dir_b
make[1]: Leaving directory `/home/shiyanlou/Code/make_example/chapter8/vari/dir_a'
cd dir_b;make
make[1]: Entering directory `/home/shiyanlou/Code/make_example/chapter8/vari/dir_b'
target  show @ /home/shiyanlou/Code/make_example/chapter8/vari/dir_b
vari subdir is  none
make[1]: Leaving directory `/home/shiyanlou/Code/make_example/chapter8/vari/dir_b'
final target finish!
```
这次 dir_a 目录下的 makefile 可以成功继承上层传递的 subdir 变量，
但 dir_b 目录下的 makefile 打印出来依然为“none”，这是因为低层的 makefile 对变量定义具有更高的优先级。
可以使用 -e 选项来取消低层的高优先级：
```bash
make -f export.mk -e
```
终端打印：
```bash
cd dir_a;make
make[1]: Entering directory `/home/shiyanlou/Code/make_example/chapter8/vari/dir_a'
target  show @ /home/shiyanlou/Code/make_example/chapter8/vari/dir_a
vari subdir is  dir_a dir_b
make[1]: Leaving directory `/home/shiyanlou/Code/make_example/chapter8/vari/dir_a'
cd dir_b;make
make[1]: Entering directory `/home/shiyanlou/Code/make_example/chapter8/vari/dir_b'
target  show @ /home/shiyanlou/Code/make_example/chapter8/vari/dir_b
vari subdir is  dir_a dir_b
make[1]: Leaving directory `/home/shiyanlou/Code/make_example/chapter8/vari/dir_b'
final target finish!
```
可以看出，现在 subdir 可以顺利传递给每个子目录的 makefile。
如果不希望变量再往下传递，可以使用 unexport 关键字，格式与 export 一致。
当 unexport 和 export 作用于同一个变量时，以最后声明的 unexport/export 为准，请大家课后自行测试 unexport 的用法。

#### 5.2.3 两个默认传递的环境变量
需要注意的是有两个变量默认会传递给下层的 makefile，它们是 $(SHELL) 和 $(MAKEFLAGS) 变量。
之前的实验已经说明了 $(SHELL) 的作用：指明要使用何种 shell 程序执行规则命令。
$(MAKEFLAGS) 则是用来传递 make 的命令行选项和参数，实验 5.4 会对这个变量做进一步说明。
spec.mk 文件演示了这两个变量的传递，内容如下：
```
#this is a makefile for special vari in recursion test

subdir := dir_c

.PHONY:all $(subdir)

all:$(subdir)
        @echo "finished!"

$(subdir):
        cd $@;$(MAKE)
```
spec.mk 会进入 dir_c 为子目录并执行 $(MAKE)。
子目录 makefile 内容如下：
```
.PHONY:show

show:
        @echo "SHELL is " $(SHELL)
        @echo "MAKEFLAGS is " $(MAKEFLAGS)
        @echo "subdir is " $(subdir)
```
因此子目录的执行内容就是打印三个变量的值。
执行 spec.mk 进行测试：
```bash
make -f spec.mk
```
终端打印：
```bash
cd dir_c;make
make[1]: Entering directory `/home/shiyanlou/Code/make_example/chapter8/vari/dir_c'
SHELL is  /bin/sh
MAKEFLAGS is  w
subdir is 
make[1]: Leaving directory `/home/shiyanlou/Code/make_example/chapter8/vari/dir_c'
finished!
```
可见 SHELL 和 MAKEFLAGS 变量默认是有值的，如何证明他们是从上层传递下来的而不是 make 的默认值呢？
只需要在顶层调用 make 时修改他们的值即可：
```bash
make -f spec.mk SHELL=bash -i -k
```
终端打印：
```bash
cd dir_c;make
make[1]: Entering directory `/home/shiyanlou/Code/make_example/chapter8/vari/dir_c'
SHELL is  bash
MAKEFLAGS is  wki -- SHELL=bash
subdir is 
make[1]: Leaving directory `/home/shiyanlou/Code/make_example/chapter8/vari/dir_c'
finished!
```
上个章节的实验已经测试过 SHELL 变量和 -i -k 选项的作用，大家可以自行复习一下。
此时两个变量都得到了更新。
实验过程如下图所示：
![5.2A](https://dn-anything-about-doc.qbox.me/document-uid66754labid3336timestamp1501111596607.png/wm)
![5.2B](https://dn-anything-about-doc.qbox.me/document-uid66754labid3336timestamp1501111607430.png/wm)

### 5.3 测试 MAKELEVEL 环境变量
变量 MAKELEVEL 表明当前的调用深度，每一级的递归调用中，MAKELEVEL 的值都会发生变化，
最上层值为 0，每往下一层加 1。
chapter8/level/makefile 演示了 MAKELEVEL 的变化，level/ 目录下还有两层子目录 dir_a 和 dir_b，
每一层的 makefile 都会打印当前 MAKELEVEL 的值。
进入 level 目录并执行 makefile，确认 MAKELEVEL 的变化：
```bash
cd ../level/;make
```
终端打印：
```bash
cd dir_a;make
make[1]: Entering directory `/home/shiyanlou/Code/make_example/chapter8/level/dir_a'
cd dir_b;make
make[2]: Entering directory `/home/shiyanlou/Code/make_example/chapter8/level/dir_a/dir_b'
this is level: 2
dir_b finished!
make[2]: Leaving directory `/home/shiyanlou/Code/make_example/chapter8/level/dir_a/dir_b'
this is level: 1
dir_a finished!
make[1]: Leaving directory `/home/shiyanlou/Code/make_example/chapter8/level/dir_a'
this is level: 0
root dir finished!
```
由打印可以看出 dir_b 目录下 MAKELEVEL 值为 2，dir_a 值为 1，level 目录值为 0。
有些项目中需要利用 MAKELEVEL 变量的特性来进行条件编译，大家可以自己设计实验使用 MAKELEVEL。
实验过程如下图所示：
![5.3](https://dn-anything-about-doc.qbox.me/document-uid66754labid3336timestamp1501111680525.png/wm)

### 5.4 命令行参数和变量的传递
在 make 的递归执行过程中，最上层 make 的命令行选项会被自动通过环境变量 MAKEFLAGS 传递给子 make 进程。
如前面的实验，通过命令行指定了 -i 和 -k 选项，MAKEFLAGS 的值会被自动设定为“ki”。
需要注意的是：
1）-w 选项默认会被传递给子make
2）有几个特殊的命令行选项不会被记录进变量，它们是 -C -f -o 和 -W
顶层 makefile 内容如下：
```
#this is a makefile for MAKEFLAGS test

subdir := dir_a

.PHONY:all $(subdir)

all:$(subdir)
        @echo "root dir finished!"

$(subdir):
        @echo "MAKEFLAGS before subdir is : " $(MAKEFLAGS)
        cd $@;$(MAKE)
```
它会在进入 subdir 之前打印 MAKEFLAGS 变量，底层 makefile 也同样会打印 MAKEFLAGS 变量。
执行 make：
```bash
cd ../flags/;make
```
终端打印：
```bash
MAKEFLAGS before subdir is : 
cd dir_a;make
make[1]: Entering directory `/home/shiyanlou/Code/make_example/chapter8/flags/dir_a'
MAKEFLAGS in dir_a is : w
dir_a finished!
make[1]: Leaving directory `/home/shiyanlou/Code/make_example/chapter8/flags/dir_a'
root dir finished!
```
可见顶层 MAKEFLAGS 变量为空，底层自动添加了 -w 选项。
现在可以利用这些打印测试传入不同参数。
先将 makefile 拷贝为 test.mk，再用 -f 选项指定执行 test.mk，并添加其它参数：
```bash
cp makefile test.mk;make -f test.mk -i -k SHELL=bash
```
终端打印如下：
```bash
MAKEFLAGS before subdir is :  ki -- SHELL=bash
cd dir_a;make
make[1]: Entering directory `/home/shiyanlou/Code/make_example/chapter8/flags/dir_a'
MAKEFLAGS in dir_a is : wki -- SHELL=bash
dir_a finished!
make[1]: Leaving directory `/home/shiyanlou/Code/make_example/chapter8/flags/dir_a'
root dir finished!
```
可见顶层 makefile 中，MAKEFLAGS 变量为“ik -- SHELL=bash”，-f 选项没有添加进来。
底层 makefile 中，MAKEFLAGS 变量为“ikw -- SHELL=bash”，除了多出默认需要传递的 -w 选项外，其它部分与顶层传参一致。
实验过程如下图所示：
![5.4](https://dn-anything-about-doc.qbox.me/document-uid66754labid3336timestamp1501111797081.png/wm)

## 六、实验总结
本次实验测试了make 的递归执行及其过程中变量、命令行参数的传递规则。

## 七、课后习题
1.请测试 export 和 unexport 作用于同一个变量时，make 的处理方式。
2.请使用 MAKELEVEL 变量进行编译流程控制。
3.请查找资料并测试 $(MAKE) 和 make 在命令行参数的传递处理上有何区别并设计实验进行测试。

## 八、参考链接
无
