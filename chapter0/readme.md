# 编译,链接基础实验

## 一、实验介绍
本实验用于演示 GNU GCC 编译和链接的基本方法,通过编译,链接,静态链接,动态链接让用户学习和理解 GCC 的使用方式.

### 1.1 实验内容
1.编写基本代码

2.对代码进行编译，链接，并执行查看效果

3.添加代码扩展功能，并进行静态链接

4.添加代码扩展功能,并进行动态链接

5.使用静态+动态的混合链接

### 1.2 实验知识点 
1. GCC编译的使用方式
2. GCC链接的使用方式
3. GCC静态链接的使用方式
4. GCC动态链接的使用方式
5. GCC静态链接+动态链接混用的方式

### 1.3 实验环境
Ubuntu系统, GCC

### 1.4 适合人群
本课程难度为一般，属于初级级别课程，适合有代码编写能力的用户，熟悉和掌握GCC的一般用法。

### 1.5 代码获取
git clone https://github.com/darmac/make_example.git

## 二、实验原理
依据 GCC 编译与链接的基本使用方式测试编译流程

## 三、开发准备
进入实验楼课程即可

## 四、项目文件结构
main.c : 主要文件
add_minus.c add_minus.h : 加减法API及实现
multi_div.c multi_div.h : 乘除法API及实现

## 五、实验步骤

### 5.1 编译，链接和执行Hello Cacu
#### 5.1.1 使用git clone获取源代码
执行: 
```
cd ~/Code
git clone https://github.com/darmac/make_example.git
```
本章节的源代码位于 make_example/chapter0/ 目录下
查看 main.c 文件,内容如下:
```
#include <stdio.h>

int main(void)
{
    printf("Hello Cacu!\n");
    return 0;
}
```
#### 5.1.2 只编译不链接 main.o
执行命令:
```
gcc -c main.c
```
可以发现当前文件夹下多了一个 main.o 文件
#### 5.1.3 使用 file 查看 main.o 的格式，并尝试执行
执行: 
```
file main.o
```
会打印出 log：“main.o: ELF 64-bit LSB relocatable, x86-64, version 1 (SYSV), not stripped”

表明 main.o 实际上是一个 relocatable 文件。

修改 main.o 的文件属性为可执行：
```
chmod 777 main.o
```
再尝试执行main.o文件: 
```
./main.o 
```
会出现错误：“zsh: exec format error: ./main.o”
实际上relocatable文件是不可执行的
#### 5.1.4 对main.o进行链接,并尝试执行
那么怎样才能生成可执行文件呢? 可执行文件需要通过链接来生成.

使用 gcc 将 main.o 链接为 main 文件：
```
gcc -o main main.o
```
可以发现文件夹下多了一个 main 文件。

用 file 查看 main 文件格式：
```
file main
```
会打印出 log：
“main: ELF 64-bit LSB  executable, x86-64, version 1 (SYSV), dynamically linked (uses shared libs), for
 GNU/Linux 2.6.24, BuildID[sha1]=3753fcc57530a2eb08e63879f8363013bef5d161, not stripped”
此时文件类型已经变更为 "executable" ，执行此文件：
```
./main
```
可以看到有log印出“Hello Cacu!”。
这正是我们main.c里希望打印的语句，说明文件被正常执行。
感兴趣的同学也可以使用readelf工具查看main文件的更多细节。
实验截图如下:
![实验5.1截图](http://img.blog.csdn.net/20170624082829314?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvZGFybWFj/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

### 5.2 为 Cacu 增加加减法并链接执行
#### 5.2.1 添加 add_minus.h 文件，声明 add() 和 minus()

源代码已有 add_minus.h 文件，文件内容为：
```
#ifndef __ADD_MINUS_H__
#define __ADD_MINUS_H__

int add(int a, int b); 
int minus(int a, int b); 

#endif /*__ADD_MINUS_H__*/
```
#### 5.2.2 添加 add_minus.c 文件,实现 add() 和 minus()
源代码已有 add_minus.c 文件，文件内容为：
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
#### 5.2.3 编译生成 add_minus.o
执行：
```
gcc -c add_minus.c
```
会生成文件 add_minus.o

#### 5.2.4 修改 main.c，增加加减法运算并编译
给 main.c 打上 patch v1.0：
```
patch -p2 < v1.0.patch
```
打完 patch 后 main.c 内容如下：
```
#include <stdio.h>
#include "add_minus.h"

int main(void)
{
int rst;

printf("Hello Cacu!\n");

rst = add(3,2);
printf("3 + 2 = %d\n",rst);

rst = minus(3,2);
printf("3 - 2 = %d\n",rst);

return 0;
}
```
编译 main.c：
```
gcc -c main.c
```
链接main.o：
```
gcc -o main main.o
```
链接过程会出现错误：
```
main.o: In function `main':
main.c:(.text+0x1f): undefined reference to `add'
main.c:(.text+0x47): undefined reference to `minus'
collect2: error: ld returned 1 exit status
```

这是因为链接时，找不到 add 和 minus 这两个symbol导致的。

#### 5.2.5 将 main.o 和 add_minus.o 链接成可执行文件并执行测试

现在将 add_minus.o 也一起链接进来：
```
gcc -o main main.o add_minus.o
```
目录下会重新生成main文件，执行：
```
./main
```
会有如下打印：
```
Hello Cacu!
3 + 2 = 5
3 - 2 = 1
```
说明程序正常执行，实验截图如下：
![实验5.2](http://img.blog.csdn.net/20170624084422860?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvZGFybWFj/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

### 5.3 将 Cacu 的加减法做成静态库，并静态链接执行
#### 5.3.1 重新编译 add_minus.c 生成静态库文件
重新编译 add_minus.c 文件：
```
gcc -c add_minus.c 
```
将 add_minus.o 打包到静态库中：
```
ar rc libadd_minus.a add_minus.o
```
将会生成 libadd_minus.a 静态库文件
使用 file 查看 libadd_minus.a：
```
file libadd_minus.a
```
可以看到说明：“libadd_minus.a: current ar archive”
实际上 libxxx.a 只是将指定的.o文件打包汇集在一起，它的本质上还是 relocatable 文件集合。
#### 5.3.2 链接 main.o 和静态库文件并执行
执行：
```
gcc -o main2 main.o -L./ -ladd_minus
```
说明1: -L./ 表明库文件位置在当前文件夹

说明2: -ladd_minus 表示链接 libadd_minus.a 文件,使用“-l”参数时,前缀“lib”和后缀“.a”是需要省略的。

执行：
```
./main2
```
会有如下log打印:
```
Hello Cacu!
3 + 2 = 5
3 - 2 = 1
```

说明程序得到正确执行，实验截图如下：
![实验5.3](http://img.blog.csdn.net/20170624085249896?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvZGFybWFj/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

### 5.4 为 Cacu 增加乘除法,做成动态库,并动态执行
#### 5.4.1 添加 multi_div.h 文件,声明 multi() 和 div()
源代码已有 multi_div.h 文件，文件内容为：
```
#ifndef __MULTI_DIV_H__
#define __MULTI_DIV_H__

int multi(int a, int b); 
int div(int a, int b); 

#endif /*__MULTI_DIV_H__*/
```
#### 5.4.2 添加 multi_div.c 文件，实现 multi() 和 div()
源代码已有 multi_div.c 文件，文件内容为：
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
#### 5.4.3 将 multi_div.c 编译成动态链接库
执行：
```
gcc multi_div.c -fPIC -shared -o libmulti_div.so
```
生成 libmulti_div.so 文件

使用 file 查看 libmulti_div.so：
```
file libmulti_div.so
```
可得到文件格式：“libmulti_div.so: ELF 64-bit LSB  shared object, x86-64, version 1 (SYSV), dynamically linked, BuildID[
sha1]=2334680eed2923cb153d687fd0605d320f7fb8a2, not stripped”
即表明 libmulti_div.so 是一个 shared object 文件。

#### 5.4.4 修改 main.c，注释加减运算，新增乘除运算并编译
先还原 main.c 文件：
```
git checkout main.c
```
为 main.c 打上 patch v2.0：
```
patch -p2 < v2.0.patch
```
打完 patch 后 main.c 内容如下：
```
#include <stdio.h>
/*
#include "add_minus.h"
*/
#include "multi_div.h"

int main(void)
{
int rst;

printf("Hello Cacu!\n");
/*
        rst = add(3,2);
        printf("3 + 2 = %d\n",rst);

        rst = minus(3,2);
        printf("3 - 2 = %d\n",rst);
*/
rst = multi(3,2);
printf("3 * 2 = %d\n",rst);

rst = div(6,2);
printf("6 / 2 = %d\n",rst);

return 0;
}
```
编译 main.c 生成 main.o：
```
gcc -c main.c
```
#### 5.4.5 将 main.o 与动态链接库进行链接并执行
我们已经知道链接时需要指定库文件，否则会找不到 symbol

因此需要执行如下命令：
```
gcc -o main3 main.o -L./ -lmulti_div
```
现在执行 main3 文件：
```
./main3
```
会打印错误：“./main3: error while loading shared libraries: libmulti_div.so: cannot open shared object file: No such file or directory”

这是因为我们生成的动态库 libmulti_div.so 并不在库文件搜索路径中，解决方法可以二选一：
方法一：将 libmulti_div.so copy到 /lib/ 或 /usr/lib/ 下。
方法二：在 LD_LIBRARY_PATH 变量中指定库文件路径，如我的库文件存放在“/home/shiyanlou/Code/make_example/chapter0/”下，则执行：
```
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/shiyanlou/Code/make_example/chapter0/
```
此例使用方法二，修改LD_LIBRARY_PATH环境变量后，再次执行main3：./main3

会打印如下log：
```
Hello Cacu!
3 * 2 = 6
6 / 2 = 3
```

说明程序得到正确执行，实验截图如下：
![实验5.4](http://img.blog.csdn.net/20170624090649356?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvZGFybWFj/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)
### 5.5 将 Cacu 的动态库和静态库做混合链接并测试
#### 5.5.1 修改 main.c 加回加减运算，并编译
现在测试完成的加减乘除运算，先还原 main.c 文件：
```
git checkout main.c
```
为 main.c 打上 patch v3.0：
```
patch -p2 < v3.0.patch
```
编译 main.c 得到 main.o：
```
gcc -c main.c
```
#### 5.5.1 测试混用静态链接和动态链接的方式并执行
同时链接两个动态库文件：
```
gcc -o main4 main.o -L./ -ladd_minus -lmulti_div
```
由于我们之前已经修改过 LD_LIBRARY_PATH 变量,此次无需再次修改

执行main4：
```
./main4
```
打印如下log：
```
Hello Cacu!
3 + 2 = 5
3 - 2 = 1
3 * 2 = 6
6 / 2 = 3
```
说明程序得到正确执行，实验截图如下：
![实验5.5](http://img.blog.csdn.net/20170624090927949?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvZGFybWFj/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

## 六、实验总结
本实验说明了 GCC 基本编译，链接的方法。
学员在修改和测试代码的过程中需要反复执行编译和链接动作，由此产生基本的自动化编译需求。

## 七、课后习题
1. 请思考和验证若静态库和动态库名称关键字相同，如：
    静态库名称：libxxx.a
    动态库名称：libxxx.so
    二者的链接优先级如何？如何指定链接其中之一？
2. 请按照本课程的实验步骤自行编写 script 进行自动编译.
3. 并思考用 script 的优点和缺陷.

## 八、参考链接
无
