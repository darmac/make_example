# 编译,链接基础实验

## 一、实验介绍
本实验用于演示GNU GCC编译和链接的基本方法,通过编译,链接,静态链接,动态链接让用户学习和理解GCC的使用方式.

### 1.1 实验内容
1.编写基本代码

2.对代码进行编译,链接,并执行查看效果

3.添加代码扩展功能,并进行静态链接

4.添加代码扩展功能,并进行动态链接

5.使用静态+动态的混合链接

### 1.2 实验知识点 
1.GCC编译的使用方式
2.GCC链接的使用方式
3.GCC静态链接的使用方式
4.GCC动态链接的使用方式
5.GCC静态链接+动态链接混用的方式

### 1.3 实验环境
Ubuntu系统, GCC

### 1.4 适合人群
本课程难度为一般，属于初级级别课程，适合有代码编写能力的用户，熟悉和掌握GCC的一般用法。

### 1.5 代码获取
git clone git@github.com:darmac/make_example.git

## 二、实验原理【有则写无则不写】
依据GCC编译与链接的基本使用方式测试编译流程

## 三、开发准备【有则写无则不写】
进入实验楼课程即可

## 四、项目文件结构
main.c : 主要文件

add_minus.c add_minus.h : 加减法API及实现

multi_div.c multi_div.h : 乘除法API及实现

## 五、实验步骤

### 5.1 编译,链接和执行Hello Cacu.
#### 5.1.1 添加main.c文件,中间加入
```
#include <stdio.h>

int main(void)
{
    printf("Hello Cacu!\n");
    return 0;
}
```
#### 5.1.2 只编译不链接main.o
执行: gcc -c main.c

可以发现当前文件夹下多了一个main.o文件
#### 5.1.3 使用file查看main.o的格式,并尝试执行
执行: file main.o

会打印出log: "main.o: ELF 64-bit LSB relocatable, x86-64, version 1 (SYSV), not stripped"

表明main.o实际上是一个relocatable文件.

修改main.o的文件属性为可执行: chmod 777 main.o

执行: ./main.o 

会出现错误: "-bash: ./main.o: cannot execute binary file: Exec format error"

实际上relocatable文件是不可执行的

#### 5.1.4 对main.o进行链接,并尝试执行
那么怎样才能生成可执行文件呢? 可执行文件需要通过链接来生成.

使用gcc将main.o链接为main文件: gcc -o main main.o

可以发现文件夹下多了一个main文件.

用file查看main文件格式: file main

会打印出log: 

"main: ELF 64-bit LSB shared object, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 2.6.32, BuildID[sha1]=380489fa1205189710af8a702c2288ec92188bfb, not stripped"

此时文件类型已经变更为"shared object",执行此文件: ./main

可以看到有log印出"Hello Cacu!".

这正是我们main.c里希望打印的语句,说明文件被正常执行.

感兴趣的同学也可以使用readelf工具查看main文件的更多细节.

### 5.2 为Cacu增加加减法并链接执行
#### 5.2.1 添加add_minus.h文件,声明add()和minus()

新建add_minus.h文件,加入以下代码:
```
#ifndef __ADD_MINUS_H__
#define __ADD_MINUS_H__

int add(int a, int b); 
int minus(int a, int b); 

#endif /*__ADD_MINUS_H__*/
```

#### 5.2.2 添加add_minus.c文件,实现add()和minus()
新建add_minus.c文件,加入以下代码:
```
#include "add_minus.h"

int add(int a, int b)
{
    return a+b;
}

int minus(int a, int b)
{
    return a-b;
}
```

#### 5.2.3 编译生成add_minus.o
执行: gcc -c add_minus.c

会生成文件add_minus.o

#### 5.2.4 修改main.c,增加加减法运算并编译
给main.c打上patch v1.0: patch -p2 < v1.0.patch

编译main.c: gcc -c main.c

链接main.o: gcc -o main main.o

链接过程会出现错误: 
```
main.o: In function `main':
main.c:(.text+0x1f): undefined reference to `add'
main.c:(.text+0x47): undefined reference to `minus'
collect2: error: ld returned 1 exit status
```

这是因为链接时,找不到add和minus这两个symbol导致的

#### 5.2.5 将main.o和add_minus.o链接成可执行文件并执行测试

现在将add_minus.o也一起链接进来: gcc -o main main.o add_minus.o

目录下会重新生成main文件,执行: ./main

会有如下打印:
```
Hello Cacu!
3 + 2 = 5
3 - 2 = 1
```

说明程序正常执行

### 5.3 将Cacu的加减法做成静态库,并静态链接执行
#### 5.3.1 重新编译add_minus.c生成静态库文件
重新编译add_minus.c文件: gcc -c add_minus.c 

将add_minus.o打包到静态库中: ar rc libadd_minus.a add_minus.o

#### 5.3.2 链接main.o和静态库文件并执行
执行: gcc -o main2 main.o -L./ -ladd_minus

说明1: -L./表明库文件位置在当前文件夹

说明2: -ladd_minus表示链接libadd_minus.a文件,使用"-l"参数时,前缀"lib"和后缀".a"是需要省略的.

执行: ./main2

会有如下log打印:
```
Hello Cacu!
3 + 2 = 5
3 - 2 = 1
```

说明程序得到正确执行

### 5.4 为Cacu增加乘除法,做成动态库,并动态执行
#### 5.4.1 添加multi_div.h文件,声明multi()和div()
新建multi_div.h文件,添加如下代码:
```
#ifndef __MULTI_DIV_H__
#define __MULTI_DIV_H__

int multi(int a, int b); 
int div(int a, int b); 

#endif /*__MULTI_DIV_H__*/
```

#### 5.4.2 添加multi_div.c文件,实现multi()和div()
新建multi_div.c文件,添加如下代码:
```
#include "multi_div.h"

int multi(int a, int b)
{
    return a*b;
}

int div(int a, int b)
{
    return a/b;
}
```
#### 5.4.3 将multi_div.c编译成动态链接库
执行: gcc multi_div.c -fPIC -shared -o libmulti_div.so

生成libmulti_div.so文件

#### 5.4.4 修改main.c,注释加减运算,新增乘除运算并编译
先还原main.c文件: git checkout main.c

为main.c打上patch v2.0: patch -p2 < v2.0.patch

编译main.c生成main.o: gcc -c main.c

#### 5.4.5 将main.o与动态链接库进行链接并执行
我们已经知道链接时需要指定库文件,否则会找不到symbol

因此需要执行如下命令: gcc -o main3 main.o -L./ -lmulti_div

现在执行main3文件: ./main3

会打印错误: "./main3: error while loading shared libraries: libmulti_div.so: cannot open shared object file: No such file or directory"

这是因为我们生成的动态库libmulti_div.so并不在库文件搜索路径中,解决方法可以二选一:

方法一: 将libmulti_div.so copy到/lib/ 或 /usr/lib/ 下

方法二: 在LD_LIBRARY_PATH变量中指定库文件存放路径,如我的库文件存放在/root/study/make_example/chapter0/下,则执行:

此例使用方法2,修改LD_LIBRARY_PATH环境变量后,再次执行main3: ./main3

会打印如下log:
```
Hello Cacu!
3 * 2 = 6
6 / 2 = 3
```

说明程序得到正确执行

### 5.5 将Cacu的动态库和静态库做混合链接并测试
#### 5.5.1 修改main.c加回加减运算,并编译
现在测试完成的加减乘除运算,先还原main.c文件: git checkout main.c

为main.c打上patch v3.0: patch -p2 < v3.0.patch

编译main.c得到main.o: gcc -c main.c
#### 5.5.1 测试混用静态链接和动态链接的方式并执行
同时链接两个动态库文件: gcc -o main4 main.o -L./ -ladd_minus -lmulti_div

由于我们之前已经修改过LD_LIBRARY_PATH变量,此次无需再次修改

执行main4: ./main4

打印如下log:
```
Hello Cacu!
3 + 2 = 5
3 - 2 = 1
3 * 2 = 6
6 / 2 = 3
```
说明程序得到正确执行

## 六、实验总结
本实验说明了GCC基本编译,链接的方法.
学员在修改和测试代码的过程中需要反复执行编译和链接动作,
由此产生基本的自动化编译需求.

## 七、课后习题
请按照本课程的实验步骤自行编写script进行自动编译.
并思考用script的优点和缺陷.

## 八、参考链接
无