## 一、实验介绍
本实验介绍 makefile 的基础规则。

### 1.1 实验内容
1. makefile 基本规则。
2. makefile 时间戳检验测试。
3. 验证 makefile 依赖文件的执行顺序。
4. 变量，PHONY和“-”功能测试。
5. makefile 文件命名及隐式规则。
6. 编写一段程序的 makefile 文件。

### 1.2 实验知识点 
1. makefile 的基本编译规则。
2. make 更新目标的依据：时间戳。
3. makefile 目标依赖的执行顺序为从左至右。
4. makefile 变量的赋值与使用。
5. .PHONY的作用：声明伪目标。
6. “-”的作用：让make忽略该命令的错误。
7. make搜寻makefile的命名规则："GNUmakefile" > "makefile" > "Makefile"。
8. makefile不存在的情况下也可以利用make的隐式规则实现代码编译。

### 1.3 实验环境
Ubuntu系统, GNU gcc工具，GNU make工具

### 1.4 适合人群
本课程难度为简单，属于入门级别课程，适合有代码编写能力的用户，熟悉和掌握make的一般用法。

### 1.5 代码获取
git clone https://github.com/darmac/make_example.git

## 二、实验原理
测试 makefile 的基础规则和一些简单的特性。

## 三、开发准备
进入实验楼课程即可。

## 四、项目文件结构
main.c：主要的 C 语言源代码。
makefile：make工程文件。

## 五、实验步骤

### 5.1 makefile 基本规则。
#### 5.1.1 抓取源代码
使用如下 cmd 获取 GitHub 源代码：
```
cd ~/Code/
git clone https://github.com/darmac/make_example.git
```
#### 5.1.2 编写 main.c 源文件
实验中将用“hello world！”程序来验证 makefile 的基本规则，因此先编写一段小程序 main.c 。
源代码中已有 main.c 文件，代码如下：
```
#include <stdio.h>

int main(void)
{
    printf("hello world!\n");
    return 0;
}
```
#### 5.1.3 熟悉 makefile 的基础规则
makefile 是为了自动管理编译、链接流程而存在的。
makefile 的基本书写规则如下：
```
TARGET... : PREREQUISITES...
COMMAND
```
TARGET：规则目标,可以为文件名或动作名
PREREQUISITES：规则依赖
COMMAND：命令行,必须以[TAB]开始,由shell执行

#### 5.1.4 编写简单的 makefile 文件管理 main.c 的编译
源代码中已有 makefile 文件，内容如下：
```
  1 #this is a makefile example
  2 
  3 main:main.o
  4     gcc -o main main.o
  5 
  6 main.o:main.c
  7     gcc -c main.c
```
line1：“#”为注释符号，后面接注释文本。
line3 - line4：声明目标 main 的依赖文件 main.o 及链接 command。
line6 - line7：声明目标 main.o 的编译command。

#### 5.1.5 测试make命令
make 工具的基本使用方法为：make TARGET 。
在终端输入命令：
```
make main.o
```
可以看见shell会执行：
```
gcc -c main.c
```
接下来输入：
```
make main
```
可以看见shell执行：
```
gcc -o main main.o
```
执行main文件：
```
./main
```
终端会打印：
```
hello world!
```
说明程序正常执行。
#### 5.1.6 自动化编译终极目标
清除掉 main.o 和 main 文件：
```
rm main.o main
```
由于我们的“终极”目标是 main 文件，实际上我们并不关心中间目标“main.o”。
现在尝试只运行一次 make 编译出我们需要的终极目标。
```
make main
```
终端会打印出 make 实际执行的命令：
```
gcc -c main.c
gcc -o main main.o
```
可见 make 还是先生成 makefile 中 main 的依赖文件 main.o，再链接生成 main 文件。
#### 5.1.7 让 make自动寻找目标
再次清除掉 main.o 和 main 文件：
```
rm main.o main
```
并执行 make，但不输入目标：
```
make
```
终端打印出 make 的执行命令还是一样：
```
gcc -c main.c
gcc -o main main.o
```
这是因为默认情况下，make 会以第一条规则作为其“终极目标”。
现在我们尝试修改 makefile，在目标 “main”之前再增加一条规则：
```
dft_test:middle_file
	mv middle_file dft_test
middle_file:
	touch middle_file
```
执行：
```
make
```
可以看见终端印出：
```
touch middle_file
mv middle_file dft_test
```
当前文件夹下会多出一个 dft_test 文件。
### 5.2 makefile 时间戳检验测试。
### 5.2.1 文件的时间戳检测规则
make在执行命令时会检测依赖文件的时间戳：
1. 若依赖文件不存在或者依赖文件的时间戳比目标文件新，则执行依赖文件对应的命令。
2. 若依赖文件的时间戳比目标文件老，则忽略依赖文件对应的命令。
#### 5.2.2 文件时间戳测试
还原 makefile 文件，并打上 v1.0 补丁：
```
git checkout makefile
patch -p2 < v1.0.patch
```
此时 makefile 文件内容如下：
```
#this is a makefile example

main:main.o testa testb
        gcc -o main main.o

main.o:main.c
        gcc -c main.c

testa:
        touch testa

testb:
        touch testb
```
清除可能存在的中间文件：
```
rm main.o testa testb
```
执行 make：
```
make
```
终端会输出：
```
gcc -c main.c
touch testa
touch testb
gcc -o main main.o
```
make 会分别生成 main.o testa testb 这三个中间文件。这验证了 5.2.1 中说明的第一条特性。
现在删除 testb 文件，再看看 make 会如何执行：
```
rm testb
make
```
终端打印：
```
touch testb
gcc -o main main.o
```
可见 make 分别执行了 testb 和 main 两条规则，main.o 和 testa 规则对应的命令没有被执行到。
这验证了 5.2.1 中说明的第二条特性。
### 5.3 实验 makefile 依赖文件的执行顺序。
从上述实验可以看出 make 目标文件的依赖文件是按照从左到右的顺序生成的。
对应规则“main”：
```
main:main.o testa testb
    gcc -o main main.o
```
make 按照顺序分别执行 main.o testa testb 所对应的规则。
现在我们调换 main.o testa testb 的顺序。
修改 makefile 文件的 main 规则的依赖顺序：
```
  3 main:testb testa main.o
```
清除上次编译过程中产生的中间文件：
```
rm main.o testa testb
```
执行 make：
```
make
```
终端有如下打印：
```
touch testa
touch testb
gcc -c main.c
gcc -o main main.o
```
可见 make 的确是按照从左到右的规则分别执行依赖文件对应的命令。
### 5.4 变量，PHONY和“-”功能测试。
#### 5.4.1 makefile 的变量定义
makefile 也可以使用变量，它类似于 C 语言中的宏定义。
变量可以直接使用“vari=string”的写法来定义，并以“$(vari)”格式来使用。
我们用变量来定义目标的依赖项，使 makefile 保持良好的扩展性。
#### 5.4.2 在 makefile 中添加变量并使用
先还原 makefile 文件到 v1.0 补丁，并清除上一次编译的中间文件。
```
git checkout makefile
patch -p2 < v1.0.patch
rm main.o testa testb
```
在目标 “main”之前定义一个变量“depen”：
```
depen=main.o testa testb
```
修改 main 目标的依赖项声明：
```
main:$(depen)
```
执行 make ：
```
make
```
终端打印：
```
gcc -c main.c
touch testa
touch testb
gcc -o main main.o
```
可见 makefile 还是能够正常执行。
之后 main 目标的依赖项有变化时，只需修改“depen”变量即可。

#### 5.4.3 为 makefile 添加 clean 规则
每次测试 makefile 的时候我们都要清除中间文件，为了使得编译工程更加自动化，我们在 makefile 中添加规则让其自动清除。
在 makefile 中修改 depen 变量，增加 clean 依赖：
```
depen=clean main.o testa testb
```
增加 clean 规则及其命令：
```

clean:
    rm main.o testa testb
```
当前目录下是存在 main.o testa testb 三个中间文件的，执行 make 看看效果：
```
make
```
可以看见终端打印：
```
rm main.o testa testb
gcc -c main.c
touch testa
touch testb
gcc -o main main.o
```
说明现在 make 会先清除掉上次编译的中间文件并重建。

#### 5.4.4 让 clean 规则也使用变量
makefile 中定义了 depen 变量来声明各个依赖项。
但新增的 clean 规则没有使用这个变量，这会让 makefile 的维护产生麻烦：当依赖项变更的时候需要同时修改 depen 变量和 clean 规则。
因此，我们让 clean 规则的 rm 命令也使用 depen 变量。
修改 clean 规则下的 rm 命令行：
```
rm $(depen)
```
再次执行 make 猜猜会发生什么？
```
make
```
终端打印：
```
rm clean main.o testa testb
rm: cannot remove 'clean': No such file or directory
makefile:18: recipe for target 'clean' failed
make: *** [clean] Error 1
```
原来是因为 depen 变量指明 clean 为依赖项，因此 rm 命令也会试图删除 clean 文件时出现错误。
而 make 在执行命令行过程中出现错误后会退出执行。
#### 5.4.5 让 clean 命令出错后 make 也能继续执行
rm 某个不存在的文件是很常见的错误，在大部分情况下我们也不将其真正作为错误来看待。
如何让 make 忽略这个错误呢？
我们需要用到“-”符号。
“-”：让 make 忽略该指令的错误。
修改 makefile 中的 clean 规则：
```
clean:
    -rm $(depen)
```
再次执行 make：
```
make
```
终端打印：
```
rm clean main.o testa testb
rm: cannot remove 'clean': No such file or directory
rm: cannot remove 'main.o': No such file or directory
rm: cannot remove 'testa': No such file or directory
rm: cannot remove 'testb': No such file or directory
makefile:18: recipe for target 'clean' failed
make: [clean] Error 1 (ignored)
gcc -c main.c
touch testa
touch testb
gcc -o main main.o
```
看起来效果不错，虽然 rm 指令报出错误，make 却依然可以生成我们的终极目标：main 文件。

#### 5.4.6 使用伪目标
前面提到 makefile 依赖文件的时间戳若比目标文件旧，则对应规则的命令不会执行。
我们现在定义了一个 clean 规则，但如果文件夹下正好有一个 clean 文件会发生什么样的冲突呢？
先在当前目录下新建一个 clean 文件：
```
touch clean
```
再执行 make 命令：
```
make
```
终端打印：
```
gcc -o main main.o
```
看来由于 clean 文件已经存在，make 不会再执行 clean 目标对应的规则了。
但实际上 clean 是一个伪目标，我们不期望它会与真正 clean 文件有任何关联。
此时需要使用“.PHONY”来声明伪目标。
修改 makefile 在变量 depen 之前加入一条伪目标声明：
```
.PHONY: clean
```
执行 make：
```
make
```
终端打印：
```
rm clean main.o testa testb
gcc -c main.c
touch testa
touch testb
gcc -o main main.o
```
makefile 又能得到正常执行了，所有流程都符合我们的预期。
现在减除掉依赖项 testa testb，因为实际上 main 文件并不需要用到这两个文件。
修改 makefile 的 depen 变量：
```
depen=clean main.o
```
执行 make：
```
make
```
终端打印：
```
rm clean main.o
rm: cannot remove 'clean': No such file or directory
makefile:20: recipe for target 'clean' failed
make: [clean] Error 1 (ignored)
gcc -c main.c
gcc -o main main.o
```
我们已经可以随心所欲的定制 main 文件的依赖规则了。
### 5.5 makefile 文件命名及隐式规则。
#### 5.5.1 make 默认调用的文件名
迄今为止，我们写的自动编译规则都放在 makefile 中，通过实验也可以明确了解到 make 工具会自动调用 makefile 文件。
是否文件名必须命名为“makefile”呢？
不是的，GNU make 会按默认的优先级查找当前文件夹的文件，查找的优先级为：
“GNUmakefile”> “makefile”> “Makefile”
#### 5.5.2 测试 make 调用的文件优先级
新建 GNUmakefile 文件，添加以下内容：
```
#this is a GNUmakefile

.PHONY: all

all:
        @echo "this is GNUmakefile"
```
新建 Makefile 文件，添加以下内容：
```
#this is a Makefile

.PHONY: all

all:
        @echo "this is Makefile"
```
查看以下当前目录文件，现在应该有三个 makefile 能够识别到的文件。
```
ls *file* -hl
```
终端打印：
```
-rw-r--r-- 1 root root  71 Jun 25 12:22 GNUmakefile
-rw-r--r-- 1 root root 192 Jun 25 09:18 makefile
-rw-r--r-- 1 root root  65 Jun 25 12:23 Makefile
```
执行一次 make 看看哪个文件被调用：
```
make
```
终端打印：
```
this is GNUmakefile
```
说明 make 调用的是 GNUmakefile。
删除 GNUmakefile 再执行一次 make：
```
rm GNUmakefile
make
```
终端打印：
```
rm clean main.o
rm: cannot remove 'clean': No such file or directory
makefile:20: recipe for target 'clean' failed
make: [clean] Error 1 (ignored)
gcc -c main.c
gcc -o main main.o
```
说明 make 调用的是 makefile。
删除 makefile，执行 make：
```
rm makefile
make
```
终端打印：
```
this is Makefile
```
说明 Makefile 属于三者中优先级最的文件。
*建议：推荐以 makefile 或者 Makefile 进行命名，而不使用 GNUmakefile，因为 GNUmakefile 只能被 GNU 的 make 工具识别到。*
### 5.6 编写一段程序的 makefile 文件。
#### 5.6.1 小型计算程序说明
现在我们已经掌握了 makefile 的基本规则，可以尝试自己写一个 makefile 进行工程管理。
在 make_example/chapter0 目录下有一段简单的计算器示例程序，现在要为它建立一个 makefile 文件。
切换到 chapter0 目录，查看目录下的文件：
```
cd ../chapter0
ls
```
终端打印：
```
add_minus.c  add_minus.h main.c  multi_div.c  multi_div.h  readme.md  v1.0.patch  v2.0.patch  v3.0.patch
```
简单介绍一下程序的需求：
1. add_minus.c 要求被编译成静态链接库 libadd_minus.a。
2. multi_div.c 要求被编译成动态链接库 libmulti_div.so。
3. main.c 是主要的源文件，会调用上述两个代码文件中的 API，main.c 要求被编译为 main.o 。
4. 将main.o libadd_minus.a libmulti_div.so 链接成可执行文件 main。
5. 每次编译前要清除上次编译时产生的文件。

打上补丁 v3.0 并增加库文件路径，export 环境变量 LD_LIBRARY_PATH 为当前路径：
```
patch -p2 < v3.0.patch
export LD_LIBRARY_PATH=$PWD
```
#### 5.6.2 makefile 文件示例
请参照 5.6.1 的要求完成 makefile 文件，下面给出示例样本：
```
# this is a chapter0 makefile
.PHONY:all clean depen

depen=clean main.o add_minus.o libadd_minus.a multi_div.o libmulti_div.so

all:$(depen)
    gcc -o main main.o -L./ -ladd_minus -lmulti_div

main.o:main.c
    gcc -c main.c

add_minus.o:
    gcc -c add_minus.c

libadd_minus.a:add_minus.o
    ar rc libadd_minus.a add_minus.o

libmulti_div.so:
    gcc multi_div.c -fPIC -shared -o libmulti_div.so

clean:
    -rm $(depen)
```
## 六、实验总结
本实验测试了 makefile 的基础规则和一些简单的特性。

## 七、课后习题
无

## 八、参考链接
无
