## 一、实验介绍
本次实验将介绍 makefile 中 wildcard，VPATH，vpath，GPATH，-lNAME 的使用方法及文件路径保存算法。

### 1.1 实验内容
1. 函数 wildcard 的使用
2. VPATH 和 vpath 的使用
3. 文件路径的保存及 GPATH 的使用
4. -lNAME 文件的使用

### 1.2 实验知识点 
1. 在变量定义或者函数引用时不能直接使用通配符，而要用 wildcard 函数来代替
2. VPATH 变量可以指定依赖文件的搜索路径，使用空格或冒号将多个路径分开
3. vpath 关键字比 VPATH 更灵活，可以为符合模式匹配的文件指定搜索路径，还可以清除搜索路径
4. make 的文件路径保存算法如下：

    1）在当前工作目录搜索目标文件，若不存在则执行目录搜索；
    2）依赖文件也使用同样的处理方式；
    3）决定目标是否需要重建时做出如下选择：
    3.1）不需要重建时规则中所有文件的完整路径名有效；
    3.2）需要重建时，目标的完整路径失效，目标在会在当前工作目录下重建，而非目录搜索时得到的目录，但依赖文件的完整路径依然有效；
5. 若目标文件的完整路径存在于 GPATH 变量列表中，make 会使用完整路径来重建目标，而非当前工作目录
6. 当出现 -lNAME 形式的文件名时，make会先查找 libNAME.so，文件不存在时查找 libNAME.a 文件，路径搜索顺序为：当前目录 > VPATH or vpath 指定目录 > /lib/ > /usr/lib/ > /usr/local/lib/
7. -lNAME 被展开成 libNAME.so 或 libNAME.so 是由变量".LIBPATTERNS"指定的

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
├── gpath_code：用于测试 GPATH 
│   ├── main
│   └── makefile
├── lib_code：用于测试 -lNAME 的使用方法
│   ├── lib
│   │   ├── foo_dynamic.c
│   │   └── foo_static.c
│   ├── main.c
│   └── makefile
├── vpath_code：用于测试 VPATH 和 vpath
│   ├── main.c
│   ├── makefile
│   └── vpath.mk
└── wild_code：用于测试 wildcard 函数
    ├── foo1.c
    ├── foo1.h
    ├── foo2.c
    ├── foo2.h
    ├── main.c
    ├── makefile
    └── pat_make.mk
```

## 五、实验步骤

### 5.1 函数 wildcard 的使用
#### 5.1.1 抓取源代码
使用如下 cmd 获取 GitHub 源代码并进入相应章节：
```bash
cd ~/Code/
git clone https://github.com/darmac/make_example.git
cd make_example/chapter5
```

#### 5.1.2 wildcard 的使用时机
前面章节介绍了文件通配符的使用，在规则中通配符会被自动展开，但在变量定义和函数引用时，通配符将会失效。
此时如果需要使用通配符就要使用 wildcard 函数。
它的语法格式为：$(wildcard PATTERN...)。
在 makefile 中，它被展开为已经存在的、使用空格分开的、匹配此模式的所有文件列表。

#### 5.1.3 使用 wildcard 来匹配当前目录下所有的 .c 文件
此处我们用代码编译流程来进行测试，先进入 wild_code 目录：
```bash
cd wild_code
```
wild_code 目录下文件如下：
```bash
├── foo1.c
├── foo1.h
├── foo2.c
├── foo2.h
├── main.c
└── makefile
```
foo1.c 定义了 foo1() 函数，打印“Hello foo1!”，foo2.c 定义了 foo2() 函数，打印“Hello foo2!”。
main.c 依次调用 foo1() 和 foo2()。
makefile 文件内容如下：
```
#this is a makefile for wildcard code test

.PHONY:all clean

code=$(wildcard *.c)
aim=wildtest

all:$(code)
        @echo "objs inlude : " $(code)
        $(CC) -o $(aim) $(code)

clean:
        $(RM) $(aim)
```
它的终极目标 all 依赖于当前目录下所有的 .c 文件。
重建目标 all 时会打印依赖文件并使用 cc 将其链接为 wildtest 文件。
执行 make 看看效果：
```bash
make
```
终端打印：
```bash
objs inlude :  foo1.c main.c foo2.c
cc -o wildtest foo1.c main.c foo2.c
```
执行 wildtest：
```bash
./wildtest
```
终端打印：
```bash
Hello foo1!
Hello foo2!
```
可见 wildtest 程序符合预期流程。

#### 5.1.4 更复杂的用法
在实际的项目管理中，我们通常用 .o 文件作为依赖，而非 .c 文件，此时需要用到函数的嵌套调用。
我们可以使用 $(patsubst SRC_PATTERN,DEST_PATTERN,FULL_STR) 来进行字符串替换，将 .c 文件替换为 .o 文件：
```
objs=$(patsubst %.c,%.o,$(wildcard *.c))
```
这样就可以将当前目录下的 .c 文件列表转换为 .o 文件列表，再利用 make 的隐含规则自动编译。
具体使用方法可以参考 pat_make.mk 文件：
```
#this is a makefile for wildcard code test

.PHONY:all clean

objs=$(patsubst %.c,%.o,$(wildcard *.c))
aim=wildtest2

all:$(objs)
        @echo "objs inlude : " $(objs)
        $(CC) -o $(aim) $(objs)

clean:
        $(RM) $(objs)
        $(RM) $(aim)
```
执行 make：
```bash
make -f pat_make.mk
```
终端打印：
```bash
cc    -c -o foo1.o foo1.c
cc    -c -o foo2.o foo2.c
cc    -c -o main.o main.c
objs inlude :  foo1.o foo2.o main.o
cc -o wildtest2 foo1.o foo2.o main.o
```
可见 foo1.c main.c foo2.c 都已经被替换为对应的 .o 文件。
实验过程如下图所示：
![5.1](https://dn-anything-about-doc.qbox.me/document-uid66754labid3182timestamp1500174322609.png/wm)

### 5.2 VPATH 变量和 vpath 关键字的使用
#### 5.2.1 VPATH 变量测试
VPATH 变量可以指定文件的搜索路径，若规则的依赖文件或目标文件在当前目录不存在时，make 会在此变量指定的目录下去寻找依赖文件。
VPATH 可以定义多个目录，目录间用“:”隔开，目录搜索顺序与 VPATH 中定义的顺序一致。

进入到 vpath_code 目录下：
```bash
cd ../vpath_code
```
这里有一份 main.c 文件，内容如下：
```
#include <stdio.h>

extern void foo1(void);
extern void foo2(void);

int main(void)
{
        foo1();
        foo2();
        return 0;
}
```
main 函数的实现与 5.1 中的 mian 函数一致，都是分别调用 foo1() 和 foo2()。
但此处用 extern 声明了 foo1() 和 foo2() 是外部函数，而不再通过包含头文件来声明这两个函数。
这使得 main.c 本身不需要关注这两个函数的头文件放在什么位置，只要链接时的 .o 文件能够包含它们的实现即可。
foo1() 和 foo2() 的函数实现位于 chapter5/wild_code/ 目录下，我们可以通过 VPATH 变量告知 makefile 它们的路径。
makefile 文件内容如下：
```
#this is a makefile for VPATH test

.PHONY:all clean

depen=main.o foo1.o foo2.o
aim=main

all:$(depen)
        @echo "objs inlude : " $(depen)
        $(CC) -o $(aim) $(depen)

clean:
        $(RM) $(depen)
        $(RM) $(aim)
```
它只是单纯指定了三个依赖项分别为 main.o foo1.o 和 foo2.o，并在重建 all 目标时将三者链接为 main 文件。
直接执行 make 会怎样呢？
```bash
make
```
终端打印：
```bash
cc    -c -o main.o main.c
make: *** No rule to make target 'foo1.o', needed by 'all'.  Stop.
```
由于 make 找不到 foo1.o，当前路径下也没有 foo1.c 文件，无法依靠隐含规则自动重建 foo1.o，因此 make 报错并退出执行。
现在我们设定 VPATH 为 ../wild_code/ 并传给 make 执行：
```bash
make VPATH=../wild_code/
```
预期终端打印：
```bash
cc    -c -o main.o main.c
cc    -c -o foo1.o ../wild_code/foo1.c
cc    -c -o foo2.o ../wild_code/foo2.c
objs inlude :  main.o foo1.o foo2.o
cc -o main main.o foo1.o foo2.o
```
但在实验楼环境中打印如下：
```bash
objs inlude :  main.o foo1.o foo2.o
cc -o main main.o foo1.o foo2.o
cc: error: main.o: No such file or directory
cc: error: foo1.o: No such file or directory
cc: error: foo2.o: No such file or directory
cc: fatal error: no input files
compilation terminated.
make: *** [all] Error 4
```
不但找不到 foo1.o 和 foo2.o，而且连 main.o 的隐含规则都没有被执行到。
实验楼用的 make 版本为 3.81，换成 make 4.1 版本即可出现预期打印，这表明 3.81 版本的 make 工具无法正确支持 VPATH 变量。但没有关系，接下来我们使用更灵活，更受推荐的方式来指定搜索目录。

#### 5.2.2 vpath 关键字的使用
vpath 关键字的作用与 VPATH 变量相似，可以指定依赖文件或目标文件的目录。
但 vpath 的用法更加灵活，其用法如下：
1）vpath PATTERN DIR：为匹配 PATTERN 模式的文件指定搜索目录。
2）vpath PATTERN：清除匹配 PATTERN 模式的文件设置的搜索目录。
3）vpath：清除全部搜索目录。

参考 vpath.mk 的内容，与 makefile 一致，只是多出一行：
```
vpath %.c ../wild_code/
```
这一行指定了所有 .c 文件的搜索目录。
先 clean 掉上次的编译结果，再执行新的 makefile 进行测试：
```bash
make clean; make -f vpath.mk
```
终端打印：
```bash
rm -f main.o foo1.o foo2.o
rm -f main
cc    -c -o main.o main.c
cc    -c -o foo1.o ../wild_code/foo1.c
cc    -c -o foo2.o ../wild_code/foo2.c
objs inlude :  main.o foo1.o foo2.o
cc -o main main.o foo1.o foo2.o
```
可知 vpath.mk 的执行效果与使用 VPATH 一致。
有兴趣的同学可以再自行实验 vpath 清除搜索目录的功能。
实验过程如下图所示：
![5.2](https://dn-anything-about-doc.qbox.me/document-uid66754labid3182timestamp1500246714458.png/wm)

### 5.3 文件路径的保存及 GPATH 的使用
#### 5.3.1 文件路径的保存
如前面实验所展示，有时候某些依赖文件或目标文件需要搜索 VPATH 或 vpath 指定目录才能得到。
因此后续的流程中需要决定目录搜索得到的完整路径是要保留还是废弃。
make 在解析 makefile 文件时对文件路径的保存/废弃算法如下：
1）在当前目录查找文件，若不存在则搜索指定路径。
2）若目录搜索成功则将完整路径作为临时文件名保存。
3）依赖文件直接使用完整路径名。
4）目标文件若不需要重建则使用完整路径名，否则完整路径名被废弃。
比较难理解的是第四点，简单来说意思就是目标文件会在当前路径被进行重建。

#### 5.3.2 文件路径规则验证
下面进行规则验证，先清除掉上次实验的结果并切换目录：
```bash
make -f vpath.mk clean; cd ../gpath_code/
```
gpath_code 目录下有一份 makefile 文件，内容如下：
```
#this is a makefile for gpath test

.PHONY:all clean

vpath %.c ../wild_code/

depen=main.o foo1.o foo2.o
aim=main

all:$(depen)
        @echo "objs inlude : " $(depen)
        $(CC) -o $(aim) $^

clean:
        $(RM) $(depen)
        $(RM) $(aim)
```
相比之前的 makefile 此处同时指定了 .c 和 .o 文件的搜索路径。
此外，还在重建 all 目标时使用自动化变量 $^ 代替 $(depen)，$^ 变量会将指定的目标文件展开为完整路径名。

但此次所有的 .c 文件都在 ../wild_code/ 目录下，根据文件路径的保存规则，其对应的 .o 文件要在当前路径下生成。
执行 make 进行测试：
```bash
make;ls
```
终端打印：
```bash
cc    -c -o main.o ../wild_code/main.c
cc    -c -o foo1.o ../wild_code/foo1.c
cc    -c -o foo2.o ../wild_code/foo2.c
objs inlude :  main.o foo1.o foo2.o
cc -o main main.o foo1.o foo2.o
foo1.o  foo2.o  main  main.o  makefile
```
可以发现 foo1.o foo2.o main.o main 全部都在当前路径被生成。

#### 5.3.3 GPATH 变量的使用
如果不希望在当前目录下生成目标文件，可以使用 GPATH 变量。
若目标文件与 GPATH 变量指定目录相匹配，其完整路径名不会被废弃，此时目标文件会在搜寻到的目录中被重建。
为了测试 GPATH 变量的效果，我们先清除掉上一次测试产生的文件，并切换到 ../wild_code/ 目录编译得到对应的 .o 文件：
```bash
make clean;ls;cd ../wild_code;
cc -c foo1.c;touch foo1.c
cc -c foo2.c;touch foo2.c
cc -c main.c;touch main.c
```
现在 wild_code 目录下已经存在 foo1.o foo2.o main.o 文件了。
切回 gpath_code 目录并在执行 make 时使用 GPATH 变量：
```bash
cd ../gpath_code/; make GPATH=../wild_code/;ls
```
终端打印：
```bash
cc    -c -o main.o ../wild_code/main.c
cc    -c -o foo1.o ../wild_code/foo1.c
cc    -c -o foo2.o ../wild_code/foo2.c
objs inlude :  main.o foo1.o foo2.o
cc -o main main.o foo1.o foo2.o
foo1.o  foo2.o  main  main.o  makefile
```
从 ls 的结果来看 .o 文件依然在当前路径下生成，不符合预期，为什么？
检查 makefile 文件，发现：
```
vpath %.c ../wild_code/
```
但我们并没有为 .o 目标文件指定目录。
修改 makefile，在 vpath 关键字下面一行再增加一条规则：
```
vpath %.o ../wild_code/
```
清除掉上次的执行结果，再执行一次：
```bash
touch ../wild_code/main.c
touch ../wild_code/foo1.c
touch ../wild_code/foo2.c
make clean;ls;make GPATH=../wild_code/;ls
```
终端打印：
```bash
rm -f main.o foo1.o foo2.o
rm -f main
makefile
cc    -c -o ../wild_code/main.o ../wild_code/main.c
cc    -c -o ../wild_code/foo1.o ../wild_code/foo1.c
cc    -c -o ../wild_code/foo2.o ../wild_code/foo2.c
objs inlude :  main.o foo1.o foo2.o
cc -o main ../wild_code/main.o ../wild_code/foo1.o ../wild_code/foo2.o
main  makefile
```
可见这一次只有 main 文件在当前路径下生成，其余 .o 文件都在 ../wild_code/ 中被重建。
实验过程如下图所示：
![5.3A](https://dn-anything-about-doc.qbox.me/document-uid66754labid3182timestamp1500247023284.png/wm)
![5.3B](https://dn-anything-about-doc.qbox.me/document-uid66754labid3182timestamp1500247033843.png/wm)

### 5.4 -lNAME 文件的使用
#### 5.4.1 -lNAME 的搜索
makefile 中可以使用 -lNAME 来链接共享库和静态库。文件列表中的 -lNMAE 将被解析为名为 libNAME.so 或 libNAME.a 文件。
make 搜索 -lNAME 的过程如下：
1）在当前目录搜索名为 libNAME.so 的文件；
2）若不存在则搜索 VPATH 或 vpath 定义的路径；
3）若仍然不存在，make 将搜索系统默认目录，顺序为 /lib , /usr/lib , /usr/local/lib；
4）若依然无法找到文件，make 将按照以上顺序查找名为 libNAME.a 的文件。

#### 5.4.2 库文件搜索规则验证：
本次实验步骤如下：
1）编写同名的动态库文件和静态库文件，使用相同的 api 内部打印不同信息；
2）编写 main 文件调用库文件 api；
3）编译库文件生成静态库和动态库；
4）makefile 中使用 -lNAME 依赖项进行链接，验证使用的哪个库文件；
5）删除之前链接到的库文件再次执行 make 确认另一个库文件能否被成功链接；

示例代码已经在 chapter5/lib_code/ 目录下，文件如下：
```bash
.
├── lib
│   ├── foo_dynamic.c
│   └── foo_static.c
├── main.c
└── makefile
```
lib/ 下有两个 .c 文件 foo_dynamic.c 和 foo_static.c，定义了同一个函数 foo()，分别返回 1 和 2，这两份代码会被分别用于生成动态库和静态库文件。
主目录下的 main.c 调用 foo() 函数并打印得到的结果。
makefile 中提供了生成库文件和链接 main.o 的方法，内容如下：
```
#this is a makefile for -lNAME test

.PHONY: all clean static_lib dynamic_lib

VPATH=lib/

all: main.o -lfoo
        $(CC) -o main $^

static_lib: foo_static.o
        $(AR) rc libfoo.a $^;\
        mv libfoo.a lib/

dynamic_lib: foo_dynamic.o
        $(CC) $^ -fPIC -shared -o libfoo.so;\
        mv libfoo.so lib/

clean:
        $(RM) *.o *.a *.so main
        $(RM) lib/*.a lib/*.soso
```
动态库和静态库的链接，我们在 chapter0 已经测试过了，现在先分别生成动态库和静态库文件。
执行：
```bash
cd ../lib_code
make static_lib;make dynamic_lib;ls lib/
```
终端打印：
```bash
cc    -c -o foo_static.o lib/foo_static.c
ar rc libfoo.a foo_static.o;\
mv libfoo.a lib/
cc    -c -o foo_dynamic.o lib/foo_dynamic.c
cc foo_dynamic.o -fPIC -shared -o libfoo.so;\
mv libfoo.so lib/
foo_dynamic.c  foo_static.c  libfoo.a  libfoo.so
```
再执行 make　看看终极目标链接的是哪个库文件：
```bash
make; ./main
```
终端打印：
```bash
cc    -c -o main.o main.c
cc -o main main.o lib/libfoo.so
get i=1
```
可见 -lNAME 优先被解析为动态库。

删除动态库再次编译执行：
```bash
rm lib/libfoo.so 
make; ./main
```
终端打印：
```bash
cc -o main main.o lib/libfoo.a
get i=2
```
可见动态库文件不存在时，make 会尝试查找和链接静态库文件。

-lNAME 的展开是由变量 .LIBPATTERNS 来指定的，其值默认为“lib%.so lib%.a”。
感兴趣的同学可以自己尝试打印和修改此变量。
实验过程如下图所示：
![5.4](https://dn-anything-about-doc.qbox.me/document-uid66754labid3182timestamp1500248278624.png/wm)

## 六、实验总结
本实验测试了wildcard，VPATH，vpath，GPATH，-lNAME 的使用方法及文件路径保存算法。

## 七、课后习题
尝试使用 make 4.1 以后版本的 VPATH 功能。

## 八、参考链接
无
