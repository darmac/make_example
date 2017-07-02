## 一、实验介绍
本实验在上一个实验的基础上，继续深入介绍 makefile 的基础规则。

### 1.1 实验内容
1. 验证 makefile 的自动推导规则。
2. 验证 makefile include 文件规则。
3. 验证 makefile 环境变量 MAKEFILES，MAKEFILE_LIST 和 .VARIABLES 的作用。
4. 测试 makefile 的重载。


### 1.2 实验知识点 
1. makefile 文件不存在的情况下也可以利用make的自动推导规则实现代码编译。
2. include 指示符可以让 make 读入其指定的文件。
3. include 指定文件时可以支持通配符。
4. include 的默认查找路径：/usr/gnu/include，/usr/local/include，/usr/include。
5. include 可以用 -I 选项指定查找路径。
6. 变量 MAKEFILES 可以指定需要读入的 makefile 文件。
7. 变量 MAKEFILES 的使用限制：不可作为终极目标。
8. 变量 MAKEFILE_LIST 的作用：将“MAKEFILES”，命令行指定，默认 makefile 文件及“include”指定的文件名都记录下来。
9. makefile 重载另一个 makefile 的限制条件：规则名称不得重名。
10. makefile 的“所有匹配模式”的使用。

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

### 5.1 makefile 的自动推导规则。
#### 5.1.1 抓取源代码
使用如下 cmd 获取 GitHub 源代码：
```
cd ~/Code/
git clone https://github.com/darmac/make_example.git
cd make_example/chapter2
```
#### 5.1.2 makefile 自动推导规则说明
makefile 有一套隐含的自动推导规则：
1. 对于 xxx.o 目标会默认使用命令“cc -c xxx.c -o xxx.o”来进行编译。
2. 对于 xxx 目标会默认使用命令“cc xxx.o -o xxx”

下面用两个小实验来验证 makefile 的自动推导规则。

#### 5.1.3 编写 main.c 源文件
代码中已有 main.c 文件，内容如下：
```
#include <stdio.h>

int main(void)
{
        printf("Hello world!\n");
        return 0;
}
```
#### 5.1.4 使用 make main.o 验证规则
确认当前目录下没有 makefile 类型的文件。
输入如下命令：
```
make main.o
```
终端打印：
```
cc    -c -o main.o main.c
```
说明 make 自动使用 cc -c 命令生成了 main.o 文件。
#### 5.1.5 使用 make main 验证规则
接下来验证另一条规则，输入如下命令：
```
make main
```
终端打印：
```
cc   main.o   -o main
```
说明 make 自动使用 cc 命令生成了 main 文件。
由于 main.o 文件是上一个小实验生成的，现在我们删掉它和main文件：
```
rm main.o main
```
再次输入：
```
make main
```
终端打印：
```
cc     main.c   -o main
```
这说明当 main.o 不存在时，make 会尝试直接使用源文件编译来生成目标文件。

实验过程如下图所示：
![5.1](https://dn-anything-about-doc.qbox.me/document-uid66754labid3113timestamp1498954083377.png/wm)

### 5.2 makefile include 使用规则
makefile 中可以使用 include 指令来包含另一个文件。
当 make 识别到 include 指令时，会暂停读入当前的 makefile 文件，并转而读入 include 指定的文件，之后再继续读取本文件的剩余内容。

#### 5.2.1 编写 makefile 需要包含的文件
makefile_dir 目录下有一份需要被包含的文件 inc_a，文件内容如下：
```
#this is a include file for makefile

vari_c="vari_c from inc_a"
```

#### 5.2.2 编写基本的 makefile 文件
拷贝 makefile_dir 目录下的 makefile 文件到当前目录：
```
cp makefile_dir/makefile ./
```
makefile 内容如下：
```
# this is a basic makefile

.PHONY:all clean

vari_a="original vari a"
vari_b="original vari b"

include ./makefile_dir/inc_a

all:
        @echo $(vari_a)
        @echo $(vari_b)
        @echo $(vari_c)

clean:
```
#### 5.2.3 测试 make 能否正常工作
执行指令：
```
make
```
终端打印：
```
original vari a
original vari b
vari_c from inc_a
```
从打印信息可以看出来 makefile 已经成功包含了 inc_a 文件，并且正确获取到了 vari_c 变量。
值得一提的是 include 指示符所指示的文件名可以是任何 shell 能够识别的文件名，这表明 include 还可以支持包含通配符的文件名。我们将在下面的实验中进行验证。
#### 5.2.4 新建另一个被包含文件
makefile_dir 目录下有一份需要被包含的文件 inc_b，文件内容如下：
```
#this is a include file for makefile

vari_d="vari_d from inc_b"
```

#### 5.2.5 使用通配符让 makefile 包含匹配的文件
修改 makefile，使用通配符同时包含 inc_a 和 inc_b 文件。
修改后的 makefile 内容如下：
```
# this is a basic makefile

.PHONY:all clean

vari_a="original vari a"
vari_b="original vari b"

include ./makefile_dir/inc_*

all:
        @echo $(vari_a)
        @echo $(vari_b)
        @echo $(vari_c)
        @echo $(vari_d)

clean:
```
执行：
```
make
```
终端打印出：
```
original vari a
original vari b
vari_c from inc_a
vari_d from inc_b
```
说明文件 inc_a 和 inc_b 被同时包含到 makefile 中。

#### 5.2.6 makefile include 文件的查找路径
当 include 指示符包含的文件不包含绝对路径，且在当前路径下也无法寻找到时，make 会按以下优先级寻找文件：
1. -I 指定的目录
2. /usr/gnu/include
3. /usr/local/include
4. /usr/include

#### 5.2.7 指定 makefile 的 include 路径
修改 makefile，不再指定 inc_a 和 inc_b 的相对路径：

再执行一次 make：
```
make
```
终端打印：
```
makefile:8: inc_*: No such file or directory
make: *** No rule to make target 'inc_*'.  Stop.
```
可以看到 makefile 无法找到 inc_a 和 inc_b 文件。
使用“-I”命令来指定搜寻路径：
```
make -I ./makefile_dir/
```
终端依然打印：
```
makefile:8: inc_*: No such file or directory
make: *** No rule to make target 'inc_*'.  Stop.
```
看起来 make 在搜寻 “inc_*” 档案。
修改 makefile ，将 “inc_*” 改为 "inc_a" "inc_b"
```
include inc_a inc_b
```
执行：
```
make -I ./makefile_dir/
```
终端打印：
```
original vari a
original vari b
vari_c from inc_a
vari_d from inc_b
```
可见不使用通配符的情况下 include 配合 -I 选项才能得到预期效果。

#### 5.2.8 makefile include 的处理细节
下面再研究一下 make 对 include 指示符的处理细节。
前面提到 make 读入 makefile 时遇见 include 指示符会暂停读入当前文件，转而读入 include 指定的文件，之后才继续读入当前文件。
拷贝文件 makefile_dir/makefile_b 到当前目录并命名为 makefile：
```
cp makefile_dir/makefile_b ./makefile
```
查看 makefile 的内容：
```
#this makefile is test for include process

.PHONY:all clean

vari_a="vari_a @ 1st"

include ./makefile_dir/c_inc

vari_a += " @2nd ..."

all:
        @echo $(vari_a)

clean:

```
可以看出 makefile 是先设定 vari_a 变量，再包含 c_inc 文件，之后再修改 vari_a 变量。
查看 c_inc 文件内容：
```
#this is a include file for include process

vari_a="vari_a from c_inc"
```
可以看出 c_inc 文件中也设定了 vari_a 变量。
执行 make 看最终 vari_a 变量定义为什么：
```
make
```
终端打印：
```
vari_a from c_inc  @2nd ...
```
这说明 vari_a 在 include 过程中被修改掉，并在其后添加了字串 " @2nd ..."，结果与预期中 make 处理 include 指示符的行为一致。

实验过程如下图所示：
![5.2A](https://dn-anything-about-doc.qbox.me/document-uid66754labid3113timestamp1498954124910.png/wm)
![5.2B](https://dn-anything-about-doc.qbox.me/document-uid66754labid3113timestamp1498954143968.png/wm)
![5.2C](https://dn-anything-about-doc.qbox.me/document-uid66754labid3113timestamp1498954158339.png/wm)
![5.2D](https://dn-anything-about-doc.qbox.me/document-uid66754labid3113timestamp1498954210478.png/wm)
![5.2E](https://dn-anything-about-doc.qbox.me/document-uid66754labid3113timestamp1498954223804.png/wm)

### 5.3 makefile 的几个通用变量测试
#### 5.3.1 测试 MAKEFILES 变量指定的文件是否能正确被包含
MAKEFILES 环境变量有定义时，它起到类似于include的作用。
该变量在被展开时以空格作为文件名的分隔符。
删掉当前 makefile 文件：
```
rm makefile
```
新建 makefile 内容如下：
```
#this makefile is test for include process

.PHONY:all clean

vari_a += " 2nd vari..."

all:
        @echo $(vari_a)

clean:
```
执行 make：
```
make
```
终端打印：
```
 2nd vari...
```
增加环境变量 MAKEFILES：
```
export MAKEFILES=./makefile_dir/c_inc
```
再次执行 make：
```
make
```
终端打印：
```
vari_a from c_inc  2nd vari...
```
可见 make 按照 MAKEFILES 的文件列表载入了 makefile_dir/c_inc 文件。

#### 5.3.2 测试 MAKEFILES 变量的使用限制
需要注意：
1. MAKEFILES 指定文件的目标不能作为 make 的终极目标。
2. MAKEFILES 是环境变量，它对所有的 makefile 都会产生影响，因此尽量不要使用该变量。

新建一个文件 aim_b_file，内容如下：
```
#this is aim_b file

.PHONY:aim_b

aim_b:
        @echo "now we exe aim_b"
```
此文件定一个 aim_b 规则，执行此规则时打印“now we exe aim_b”。
修改 MAKEFILES 变量：
```
export MAKEFILES=./aim_b_file
```
执行 make：
```
make
```
终端打印：
```
 2nd vari...
```
可见 make 虽然先包含 aim_b_file 文件，但依然以 makefile 中的 all 作为最终目标。
我们再来验证 aim_b 规则是否已经被正常解析到，修改 makefile，为 all 增加一条依赖：
```
all: aim_b
```
这样，执行 all 规则之前必须先执行 aim_b 规则。
执行 make：
```
make
```
终端打印：
```
now we exe aim_b
 2nd vari...
```
再执行：
```
make aim_b
```
终端打印：
```
now we exe aim_b
```
“make” 和 “make aim_b” 的打印都说明 aim_b 已经能够被正确执行，但它的确不会作为默认的目标规则，只有明确指定此规则时才会执行其对应的命令。

#### 5.3.3 打印 MAKEFILE_LIST 
所有 MAKEFILES 指定的文件名，命令行指定的文件名，默认 makefile 文件以及 include 指定的文件名都记录下来。
当前路径下总共有 ./aim_b_file，./makefile，./makefile_dir/inc_a，./makefile_dir/inc_b，./makefile_dir/c_inc 这5个文件。
现在我们使用不同的方式将它们包含进来。
./aim_b_file 已经被包含在 MAKEFILES 变量中。
./makefile 会在执行 make 时被自动调用。
修改 makefile 用 include 指示符包含文件./makefile_dir/inc_a 和./makefile_dir/inc_b 。
并在 all 目标中打印 MAKEFILE_LIST 变量，修改后的 makefile 内容如下：
```
#this makefile is test for include process

.PHONY:all clean

include ./makefile_dir/inc_a ./makefile_dir/inc_b

vari_a += " 2nd vari..."

all:
        @echo $(vari_a)
        @echo $(MAKEFILE_LIST)
clean:

```
执行 make：
```
make
```
终端打印：
```
now we exe aim_b
 2nd vari...
./aim_b_file makefile makefile_dir/inc_a makefile_dir/inc_b
```
第二行打印内容说明 MAKEFILE_LIST 已经包含了./aim_b_file makefile makefile_dir/inc_a makefile_dir/inc_b。

实验过程如下图所示：
![5.3A](https://dn-anything-about-doc.qbox.me/document-uid66754labid3113timestamp1498954417212.png/wm)
![5.3B](https://dn-anything-about-doc.qbox.me/document-uid66754labid3113timestamp1498954466628.png/wm)
![5.3C](https://dn-anything-about-doc.qbox.me/document-uid66754labid3113timestamp1498954479052.png/wm)
![5.3D](https://dn-anything-about-doc.qbox.me/document-uid66754labid3113timestamp1498954491773.png/wm)

### 5.4 重载另一个 makefile
#### 5.4.1 使用 make -f 重载另一个 makefile
现在拷贝 makefile 文件为 inc_test：
```
cp makefile inc_test
```
再使用 make -f 命令指定需要读取的 makefile 文件为 inc_test：
```
make -f inc_test
```
终端打印：
```
now we exe aim_b
 2nd vari...
./aim_b_file inc_test makefile_dir/inc_a makefile_dir/inc_b
```
可见原来默认执行的 makefile 文件被替换成了 inc_test 文件，且被 MAKEFILE_LIST 正确记录。

#### 5.4.2 测试重载 makefile 的限制条件
makefile 重载另一个 makefile 的时，不允许有规则名重名。
若是有规则发生重名会发生什么状况呢？
修改 aim_b_file 增加 all 规则：
```
all:
        @echo "all in aim_b"
```
执行：
```
make
```
终端打印：
```
makefile:10: warning: overriding commands for target `all'
./aim_b_file:9: warning: ignoring old commands for target `all'
now we exe aim_b
 2nd vari...
./aim_b_file makefile makefile_dir/inc_a makefile_dir/inc_b
```
从打印日志中可以看出 makefile 重写了 aim_b_file 文件中的 all 规则。

#### 5.4.3 用“所有匹配模式”重载另一个 makefile
从上面的实验中可以看出，对于两个文件中同名的规则，make 后读入的规则会重写先读入的规则。
现在假如有两个 makefile 文件，AMake 和 BMake，它们都定义了一条 intro 规则，但行为不同。
用户希望执行在生成目标 AAim 和 BAim 的时候分别调用 AMake 和 BMake 的 intro 规则，要怎样来做呢？

我们无法用 include 指示符来包含这两个 makefile，否则会产生重写规则的行为。
此时需要用到重载另一个 makefile 的技巧。
具体方法就是在对应的规则中重新调用 make 并传入需要重载的 makefile 文件名及目标名。

chapter2/makefile_dir/ 目录底下的 makefile_c AMake BMake 这三个文件可以演示我们所需的功能。
先拷贝三个文件到当前目录下：
```
cp makefile_dir/makefile_c makefile
cp makefile_dir/AMake ./
cp makefile_dir/BMake ./
```
查看 makefile 文件，内容如下：
```
#this is a makefile reload example main part

.PHONY:AAim BAim

AAim:
        make -f AMake intro

BAim:
        make -f BMake intro
```
当目标为 AAim 时，会执行“make -f AMake intro”。
也就是会重载 AMake 作为 makefile 文件并执行 intro 规则。
BAim 的处理方式也类似。
现在测试一下执行效果，执行：
```
make AAim
```
终端打印：
```
make -f AMake intro
make[1]: Entering directory '/root/study/make_example/chapter2'
Hello, this is AMake
make[1]: Leaving directory '/root/study/make_example/chapter2'
```
可见 AMake 下的 intro 规则的确被执行到了。
再执行 BAim 规则：
```
make BAim
```
终端打印：
```
make -f BMake intro
make[1]: Entering directory '/root/study/make_example/chapter2'
Hello, this is BMake
make[1]: Leaving directory '/root/study/make_example/chapter2'
```
BMake 的规则也被顺利执行。
上述部分是基本的重载方式。

现在我们在多一条需求，希望其它未定义规则都要执行另一条 intro 规则，此规则定义在 CMake 文件中。
为了匹配其它所有的未定义规则，我们需要用到通配符“%”。

修改 makefile 在文件最后加入“所有匹配模式”规则：
```
%:
        make -f CMake intro
```
并将 makefile_dir/CMake 文件拷贝到当前目录下：
```
cp makefile_dir/CMake ./
```
随便执行一条规则 AAA：
```
make AAA
```
终端打印：
```
make -f CMake intro
make[1]: Entering directory '/root/study/make_example/chapter2'
Hello, this is CMake
make[1]: Leaving directory '/root/study/make_example/chapter2'
```
说明这条未定义的规则最后会重载 CMake 并执行其 intro 规则。

实验效果如图所示：
![5.4A](https://dn-anything-about-doc.qbox.me/document-uid66754labid3113timestamp1498954887794.png/wm)
![5.4B](https://dn-anything-about-doc.qbox.me/document-uid66754labid3113timestamp1498954961382.png/wm)
![5.4C](https://dn-anything-about-doc.qbox.me/document-uid66754labid3113timestamp1498954974201.png/wm)

## 六、实验总结
本实验验证了 makefile 的自动推导规则，一些环境变量的使用，include 指示符的使用和限制，以及 makefile 重载的技巧。

## 七、课后习题
无

## 八、参考链接
无
