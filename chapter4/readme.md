## 一、实验介绍
本次实验介绍 make 目标认定的细节，包括终极目标如何认定，目标重建的条件，目标依赖的类型以及如何使用文件名通配符。

### 1.1 实验内容
1. 验证 make 终极目标认定的优先级。
2. 验证 make 终极目标的重建条件。
3. 测试不同依赖类型的区别。
4. 验证文件名通配符的使用。

### 1.2 实验知识点 
1. makefile 终极目标的定义：make 不指定具体目标时的默认目标，一般为 makefile 文件中的第一个目标。
2. 不能作为终极目标的情况：1）以“.”开头，其后不为“/”的目标；2）模式规则的目标；3）MAKEFILES指定文件中的目标。
3. 目标重建的条件需要满足下列条件之一：1）目标文件不存在；2）依赖项的时间比目标文件要晚；3）目标为伪目标。
4. makefile 的目标可以有两种依赖：1）常规依赖；2）order-only 依赖。
5. 文件名可以使用“*”，“?”，“[...]”，“~”等通配符进行匹配。

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
依据 makefile 的基本规则设计相应的正反示例，验证规则。

## 三、开发准备
进入实验楼课程即可。

## 四、项目文件结构
makefile：用于测试终极目标的 makefile 文件
envir_make：用于测试环境变量的 makefile 文件
order_make：用于测试 order-only 依赖项的 makefile 文件
pattern_make：用于测试匹配模式的 makefile 文件
phony_make：用于测试 .PHONY 规则的 makefile 文件
rebuild_make：用于测试目标重建时机和过程的 makefile 文件
wildcard_make：用于测试通配符的 makefile 文件

## 五、实验步骤

### 5.1 make 对终极目标的认定
#### 5.1.1 抓取源代码
使用如下 cmd 获取 GitHub 源代码并进入相应章节：
```bash
cd ~/Code/
git clone https://github.com/darmac/make_example.git
cd make_example/chapter4
```

#### 5.1.2 确定 makefile 的终极目标
一般情况下 makefile 的终极目标是第一条规则的目标。
源代码中已经有一个名为 makefile 的文件可以验证其终极目标的选定，内容如下：
```
# this is a makefile to verify the default aim

aim_1:
        @echo "this is " $@

aim_2:
        @echo "this is " $@

aim_3:
        @echo "this is " $@
```
makefile 中指定了三个目标，执行的动作相同：打印当前执行的目标名称。
自动化变量 $@ 会被 make 自动展开为目标名称。
顺序执行这三个规则：
```bash
make aim_1;make aim_2;make aim_3
```
PS：shell中可以使用分号隔开一系列指令并顺序执行。
终端打印：
```bash
this is  aim_1
this is  aim_2
this is  aim_3
```
而不指定目标时，make 默认执行的目标就是终极目标，如下所示：
```bash
make
```
终端打印：
```bash
this is  aim_1
```
这就表示第一个目标 aim_1 为终极目标。
感兴趣的同学可以自己调换一下 aim_1 aim_2 aim_3 的顺序看看终极目标是否会随之改变。

#### 5.1.3 终极目标认定的例外（1）
当目标名以“.”开头且其后不是斜线符号“/”（即不被解析为目录符号），此目标无法作为终极目标。
如前面所述的“.PHONY:”规则，代表声明伪目标，这则规则可以被执行，却无法作为终极目标。
源文件中有一份名为 phony_make 的文件，内容如下：
```
# this is a makefile to verify the default aim

.PHONY: aim_2
        @echo "this is " $@

aim_1:
        @echo "this is " $@

aim_2:
        @echo "this is " $@

aim_3:
        @echo "this is " $@
```
相比 makefile 文件，它在最前面多了一条 .PHONY 目标。
执行 .PHONY 目标进行验证：
```bash
make -f phony_make .PHONY
```
终端打印：
```bash
this is  aim_2
this is  .PHONY
```
说明 .PHONY 可以被正确执行。
再执行 make 试试终极目标：
```bash
make -f phony_make
```
终端打印：
```bash
this is  aim_1
```
可见终极目标仍然是 aim_1。

#### 5.1.4 终极目标认定的例外（2）
第二个例外是模式目标无法被认定为终极目标。
请参考 pattern_make 文件：
```
# this is a makefile to verify the default aim

%:
        @echo "this is " $@

aim_1:
        @echo "this is " $@

aim_2:
        @echo "this is " $@

aim_3:
        @echo "this is " $@
```
相比 makefile 文件，其第一条目标变成了模式规则，“%”符号可以匹配任何未显示定义的目标。
先测试模式匹配的效果：
```bash
make -f pattern_make 123
```
终端打印：
```bash
this is  123
```
“123”为未定义的目标，测试说明模式匹配已经生效。
再执行 make：
```bash
make -f pattern_make
```
终端打印：
```bash
this is  aim_1
```
由此说明模式规则无法作为终极目标。

#### 5.1.5 终极目标认定的例外（3）
使用 MAKEFILES 指定的文件会被 make 首先读入，但其中的目标无法作为终极目标。
参考 envir_make 文件：
```
# this is a makefile to verify the default aim

envir_1:
        @echo "this is " $@
```
此文件中有一个 envir_1 目标。
现在修改 makefile，在 aim_2 后面增加依赖项 envir_1，来确认 envir_make 是否被正常读入。
修改后 makefile 中的目标 aim_2 内容如下：
```
aim_2:envir_1
        @echo "this is " $@
```
执行 make aim_2：
```bash
make aim_2
```
终端打印：
```bash
make: *** No rule to make target 'envir_1', needed by 'aim_2'.  Stop.
```
这是因为 envir_1 还没被加入到 MAKEFILES 环境变量中，现在将其加入：
```bash
export MAKEFILES=envir_make
```
再次执行：
```bash
make aim_2
```
终端打印：
```bash
this is  envir_1
this is  aim_2
```
说明 envir_make 已经被正确包含。
再执行 make，看 envir_make 的目标能否得到执行：
```bash
make
```
终端打印：
```
this is  aim_1
```
说明 aim_1 依然是终极目标。

#### 5.1.6 include 指定文件中的目标可以作为终极目标
与 MAKEFILES 环境变量不同，使用 include 包含的文件目标则可以被认定为终极目标。
现在清空 MAKEFILES 环境变量：
```bash
export MAKEFILES=
```
再次修改 makefile 在 aim_1 目标之前加入对 envir_make 文件的包含，增加的 makefile 内容如下：
```
include envir_make
```
执行 make：
```bash
make
```
终端打印：
```bash
this is  envir_1
```
可见 envir_make 中的 envir_1 目标被作为终极目标进行重建了。
实验过程截图如下：
![5.1A](https://dn-anything-about-doc.qbox.me/document-uid66754labid3181timestamp1499643657029.png/wm)
![5.1B](https://dn-anything-about-doc.qbox.me/document-uid66754labid3181timestamp1499643668249.png/wm)
![5.1C](https://dn-anything-about-doc.qbox.me/document-uid66754labid3181timestamp1499643680941.png/wm)

### 5.2 make 终极目标的重建
#### 5.2.1 目标重建时机
makefile 中的规则传递给 make 两条信息：
1）目标重建的时机；
2）目标如何重建。

目标重建的时机依据下面规则：
1）目标是否为伪目标，若是则需要执行重建，否则参考2）；
2）目标是否存在，若存在，参考3），若不存在则需要执行重建；
3）目标文件是否比其全部依赖项都新，若比其任一依赖项文件要旧则需要执行重建。

#### 5.2.2 目标重建的验证
先来验证伪目标的重建，参考 rebuild_make 文件内容：
```
# this is a makefile to verify the rebuild rule

aim_1:test_1
        touch aim_1

aim_2:
        @echo "this is " $@
```
终极目标为 aim_1，依赖项为 test_1。
新建一个 test_1 文件并执行 make：
```bash
touch test_1; make -f rebuild_make; ls -l aim_1
```
终端打印：
```bash
touch aim_1
-rw-r--r-- 1 root root 0 Jul  9 17:41 aim_1
```
表示当前路径下有一个 aim_1 文件被生成。
其判断流程如下：1）aim_1 不是伪目标 2) aim_1 不存在，因此执行重建。
再次执行 make：
```bash
make -f rebuild_make
```
终端打印：
```bash
make: 'aim_1' is up to date.
```
其判断流程如下：1）aim_1 不是伪目标 2) aim_1 存在 3）aim_1 比 test_1 时间戳要新，因此不执行重建。
重新生成 test_1，再执行 make：
```bash
touch test_1; make -f rebuild_make; ls -l aim_1
```
终端打印：
```bash
touch aim_1
-rw-r--r-- 1 root root 0 Jul  9 17:46 aim_1
```
此次判断流程如下：1）aim_1 不是伪目标 2) aim_1 存在 3）aim_1 比 test_1 时间戳要旧，因此执行重建。
最后再看伪目标的情况，
我们不再更新 test_1 文件，此时执行 make 依然会出现 “'aim_1' is up to date” 的提示，并且 aim_1 不会被重建。
现在修改 rebuild_make 文件，添加伪目标 aim_1，添加的内容如下：
```
.PHONY: aim_1
```
再连续执行 make：
```bash
make -f rebuild_make; make -f rebuild_make; make -f rebuild_make
```
终端打印：
```bash
touch aim_1
touch aim_1
touch aim_1
```
说明终极目标被声明为伪目标后，无论如何都会进行重建。
实验过程截图如下：
![5.2A](https://dn-anything-about-doc.qbox.me/document-uid66754labid3181timestamp1499643915000.png/wm)
![5.2B](https://dn-anything-about-doc.qbox.me/document-uid66754labid3181timestamp1499643921205.png/wm)

### 5.3 makefile 的依赖类型
#### 5.3.1 makefile 的两种依赖类型
GNU make 的规则中可以使用两种不同类型的依赖：1）常规依赖；2）order-only 依赖。
常规依赖：告诉 make 目标重建所需的依赖文件以及何时需要更新目标。
order-only 依赖：告诉 make 目标重建所需的依赖文件，这些依赖文件的更新不会导致目标被重建。

order-only 依赖以管道符号“|”开始，管道符号左边为常规依赖项，管道符号右边为 order-only 依赖项。

#### 5.3.2 测试 order-only 依赖
参考源文件 order_make 内容：
```
# this is a makefile to verify the order-only rule

.PHONY:clean

aim_1:test_1 |test_2 test_3
        touch aim_1

clean:
        rm -f test_1 test_2 test_3 aim_1
```
aim_1规则的常规依赖项为 test_1，order-only 依赖项为 test_2 和 test_3
先执行 make clean，清除各项文件，并手动生成 test_1 test_2 test_3文件：
```bash
make -f order_make clean; touch test_1 test_2 test_3; ls -l test*
```
终端打印：
```bash
rm -f test_1 test_2 test_3 aim_1
-rw-r--r-- 1 root root 0 Jul  9 18:19 test_1
-rw-r--r-- 1 root root 0 Jul  9 18:19 test_2
-rw-r--r-- 1 root root 0 Jul  9 18:19 test_3
```
执行 make 生成 aim_1 文件：
```bash
make -f order_make; ls -l aim_1
```
终端打印：
```bash
touch aim_1
-rw-r--r-- 1 root root 0 Jul  9 18:21 aim_1
```
更新 test_2 test_3 文件，并测试 aim_1 是否会重建：
```bash
touch test_2 test_3; make -f order_make
```
终端打印：
```bash
make: 'aim_1' is up to date.
```
说明 test_2 test_3 文件的更新都不会影响到目标的重建。
删除 test_2 测试目标是否会检查依赖项文件：
```bash
rm test_2; make -f order_make
```
终端打印：
```
make: *** No rule to make target 'test_2', needed by 'aim_1'.  Stop.
```
说明 order-only 依赖项对应的文件依然会被 make 检查。
实验过程截图如下：
![5.3](https://dn-anything-about-doc.qbox.me/document-uid66754labid3181timestamp1499644058155.png/wm)

### 5.4 文件名通配符的使用
#### 5.4.1 文件名通配符的种类及使用场合
makefile 文件中通配符的用法和含义与 linux 的 Bourne shell 相同。
常用的通配符包括：
“*”：匹配任意长度的任意字符。（注意：匹配文件名，无法匹配 makefile 文件中的规则等字段）
“?”：匹配单个任意字符。
“[...]”：匹配括号中指定的任意一个字符。
“~”：代表当前用户目录。

通配符出现在下面场合：
1）可以出现在规则的目标或依赖项中。
2）可以出现在规则的命令中。

#### 5.4.2 通配符用法测试
通配符的使用变化很多，此处使用简单的实验来进行展示。
参考文件 wildcard_make，内容如下：
```
#this is a makefile test for wildcard

.PHONY:all clean prepare test_1

all:aim_1

aim_%:test_*
        @echo "aim : " $@ "depen : " $^
        @cd ~ ; echo "print user home path:";pwd
        @ls *

test_%:
        touch $@

test_1:test_4
        @echo "exe " $@

clean:
        rm -f test_*

prepare:
        touch test_1 test_2 test_3
```
wildcard_make 使用 all 作为终极目标，依赖项为 aim_1。
aim_1 规则与 aim_% 相匹配，依赖项为所有的 test_ 开头的前缀文件，执行命令则为打印一些信息。
test_ 开头的文件名若为 test_1，则会依赖于 test_4，并打印执行 test_1 目标的信息。
test_4 匹配 test_% 规则，会新建一个 test_4 文件。
先清除一些干扰测项，并生成所需的文件：
```bash
make -f wildcard_make clean; make -f wildcard_make prepare
```
现在执行 make，看看会发生什么事情：
```bash
make -f wildcard_make
```
终端打印：
```bash
touch test_4
exe  test_1
aim :  aim_1 depen :  test_1 test_2 test_3
print user home path:
/home/shiyanlou
aim_1    makefilepattern_make  readme.md     test_1  test_3  wildcard_make
envir_make  order_makephony_make    rebuild_make  test_2  test_4
```
可见由于依赖项层层传递，最先执行的是 test_4 目标，生成 test_4 文件，
接下来打印 test_1 的执行信息，
最后执行 aim_1 目标打印相关的信息。
此测试演示了在依赖项和命令行中使用文件名通配符匹配，并成功匹配到了 test_1 test_2 test_3 文件和用户宿主目录。
实验过程截图如下：
![5.4](https://dn-anything-about-doc.qbox.me/document-uid66754labid3181timestamp1499644206499.png/wm)

## 六、实验总结
本实验测试了 make 如何认定终极目标，如何决定目标重建时机，order-only 依赖的特点以及文件名通配符的使用。

## 七、课后习题
请自行设计通配符 makefile 实验，并解释实验过程中的非预期现象。

## 八、参考链接
无
