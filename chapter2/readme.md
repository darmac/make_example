## һ��ʵ�����
��ʵ������һ��ʵ��Ļ����ϣ������������ makefile �Ļ�������

### 1.1 ʵ������
1. ��֤ makefile ���Զ��Ƶ�����
2. ��֤ makefile include �ļ�����
3. ��֤ makefile �������� MAKEFILES��MAKEFILE_LIST �� .VARIABLES �����á�
4. ���� makefile �����ء�


### 1.2 ʵ��֪ʶ�� 
1. makefile �ļ������ڵ������Ҳ��������make���Զ��Ƶ�����ʵ�ִ�����롣
2. include ָʾ�������� make ������ָ�����ļ���
3. include ָ���ļ�ʱ����֧��ͨ�����
4. include ��Ĭ�ϲ���·����/usr/gnu/include��/usr/local/include��/usr/include��
5. include ������ -I ѡ��ָ������·����
6. ���� MAKEFILES ����ָ����Ҫ����� makefile �ļ���
7. ���� MAKEFILES ��ʹ�����ƣ�������Ϊ�ռ�Ŀ�ꡣ
8. ���� MAKEFILE_LIST �����ã�����MAKEFILES����������ָ����Ĭ�� makefile �ļ�����include��ָ�����ļ�������¼������
9. makefile ������һ�� makefile �������������������Ʋ���������
10. makefile �ġ�����ƥ��ģʽ����ʹ�á�

### 1.3 ʵ�黷��
Ubuntuϵͳ, GNU gcc���ߣ�GNU make����

### 1.4 �ʺ���Ⱥ
���γ��Ѷ�Ϊ�򵥣��������ż���γ̣��ʺ��д����д�������û�����Ϥ������make��һ���÷���

### 1.5 �����ȡ
git clone https://github.com/darmac/make_example.git

## ����ʵ��ԭ��
���� makefile �Ļ������������Ӧ������ʾ������֤����

## ��������׼��
����ʵ��¥�γ̼��ɡ�

## �ġ���Ŀ�ļ��ṹ
makefile��make�����ļ���

## �塢ʵ�鲽��

### 5.1 makefile ���Զ��Ƶ�����
#### 5.1.1 ץȡԴ����
ʹ������ cmd ��ȡ GitHub Դ���룺
```
cd ~/Code/
git clone https://github.com/darmac/make_example.git
cd make_example/chapter2
```
#### 5.1.2 makefile �Զ��Ƶ�����˵��
makefile ��һ���������Զ��Ƶ�����
1. ���� xxx.o Ŀ���Ĭ��ʹ�����cc -c xxx.c -o xxx.o�������б��롣
2. ���� xxx Ŀ���Ĭ��ʹ�����cc xxx.o -o xxx��

����������Сʵ������֤ makefile ���Զ��Ƶ�����

#### 5.1.3 ��д main.c Դ�ļ�
���������� main.c �ļ����������£�
```
#include <stdio.h>

int main(void)
{
        printf("Hello world!\n");
        return 0;
}
```
#### 5.1.4 ʹ�� make main.o ��֤����
ȷ�ϵ�ǰĿ¼��û�� makefile ���͵��ļ���
�����������
```
make main.o
```
�ն˴�ӡ��
```
cc    -c -o main.o main.c
```
˵�� make �Զ�ʹ�� cc -c ���������� main.o �ļ���
#### 5.1.5 ʹ�� make main ��֤����
��������֤��һ�����������������
```
make main
```
�ն˴�ӡ��
```
cc   main.o   -o main
```
˵�� make �Զ�ʹ�� cc ���������� main �ļ���
���� main.o �ļ�����һ��Сʵ�����ɵģ���������ɾ������main�ļ���
```
rm main.o main
```
�ٴ����룺
```
make main
```
�ն˴�ӡ��
```
cc     main.c   -o main
```
��˵���� main.o ������ʱ��make �᳢��ֱ��ʹ��Դ�ļ�����������Ŀ���ļ���

ʵ���������ͼ��ʾ��
![5.1](https://dn-anything-about-doc.qbox.me/document-uid66754labid3113timestamp1498954083377.png/wm)

### 5.2 makefile include ʹ�ù���
makefile �п���ʹ�� include ָ����������һ���ļ���
�� make ʶ�� include ָ��ʱ������ͣ���뵱ǰ�� makefile �ļ�����ת������ include ָ�����ļ���֮���ټ�����ȡ���ļ���ʣ�����ݡ�

#### 5.2.1 ��д makefile ��Ҫ�������ļ�
makefile_dir Ŀ¼����һ����Ҫ���������ļ� inc_a���ļ��������£�
```
#this is a include file for makefile

vari_c="vari_c from inc_a"
```

#### 5.2.2 ��д������ makefile �ļ�
���� makefile_dir Ŀ¼�µ� makefile �ļ�����ǰĿ¼��
```
cp makefile_dir/makefile ./
```
makefile �������£�
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
#### 5.2.3 ���� make �ܷ���������
ִ��ָ�
```
make
```
�ն˴�ӡ��
```
original vari a
original vari b
vari_c from inc_a
```
�Ӵ�ӡ��Ϣ���Կ����� makefile �Ѿ��ɹ������� inc_a �ļ���������ȷ��ȡ���� vari_c ������
ֵ��һ����� include ָʾ����ָʾ���ļ����������κ� shell �ܹ�ʶ����ļ���������� include ������֧�ְ���ͨ������ļ��������ǽ��������ʵ���н�����֤��
#### 5.2.4 �½���һ���������ļ�
makefile_dir Ŀ¼����һ����Ҫ���������ļ� inc_b���ļ��������£�
```
#this is a include file for makefile

vari_d="vari_d from inc_b"
```

#### 5.2.5 ʹ��ͨ����� makefile ����ƥ����ļ�
�޸� makefile��ʹ��ͨ���ͬʱ���� inc_a �� inc_b �ļ���
�޸ĺ�� makefile �������£�
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
ִ�У�
```
make
```
�ն˴�ӡ����
```
original vari a
original vari b
vari_c from inc_a
vari_d from inc_b
```
˵���ļ� inc_a �� inc_b ��ͬʱ������ makefile �С�

#### 5.2.6 makefile include �ļ��Ĳ���·��
�� include ָʾ���������ļ�����������·�������ڵ�ǰ·����Ҳ�޷�Ѱ�ҵ�ʱ��make �ᰴ�������ȼ�Ѱ���ļ���
1. -I ָ����Ŀ¼
2. /usr/gnu/include
3. /usr/local/include
4. /usr/include

#### 5.2.7 ָ�� makefile �� include ·��
�޸� makefile������ָ�� inc_a �� inc_b �����·����

��ִ��һ�� make��
```
make
```
�ն˴�ӡ��
```
makefile:8: inc_*: No such file or directory
make: *** No rule to make target 'inc_*'.  Stop.
```
���Կ��� makefile �޷��ҵ� inc_a �� inc_b �ļ���
ʹ�á�-I��������ָ����Ѱ·����
```
make -I ./makefile_dir/
```
�ն���Ȼ��ӡ��
```
makefile:8: inc_*: No such file or directory
make: *** No rule to make target 'inc_*'.  Stop.
```
������ make ����Ѱ ��inc_*�� ������
�޸� makefile ���� ��inc_*�� ��Ϊ "inc_a" "inc_b"
```
include inc_a inc_b
```
ִ�У�
```
make -I ./makefile_dir/
```
�ն˴�ӡ��
```
original vari a
original vari b
vari_c from inc_a
vari_d from inc_b
```
�ɼ���ʹ��ͨ���������� include ��� -I ѡ����ܵõ�Ԥ��Ч����

#### 5.2.8 makefile include �Ĵ���ϸ��
�������о�һ�� make �� include ָʾ���Ĵ���ϸ�ڡ�
ǰ���ᵽ make ���� makefile ʱ���� include ָʾ������ͣ���뵱ǰ�ļ���ת������ include ָ�����ļ���֮��ż������뵱ǰ�ļ���
�����ļ� makefile_dir/makefile_b ����ǰĿ¼������Ϊ makefile��
```
cp makefile_dir/makefile_b ./makefile
```
�鿴 makefile �����ݣ�
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
���Կ��� makefile �����趨 vari_a �������ٰ��� c_inc �ļ���֮�����޸� vari_a ������
�鿴 c_inc �ļ����ݣ�
```
#this is a include file for include process

vari_a="vari_a from c_inc"
```
���Կ��� c_inc �ļ���Ҳ�趨�� vari_a ������
ִ�� make ������ vari_a ��������Ϊʲô��
```
make
```
�ն˴�ӡ��
```
vari_a from c_inc  @2nd ...
```
��˵�� vari_a �� include �����б��޸ĵ����������������ִ� " @2nd ..."�������Ԥ���� make ���� include ָʾ������Ϊһ�¡�

ʵ���������ͼ��ʾ��
![5.2A](https://dn-anything-about-doc.qbox.me/document-uid66754labid3113timestamp1498954124910.png/wm)
![5.2B](https://dn-anything-about-doc.qbox.me/document-uid66754labid3113timestamp1498954143968.png/wm)
![5.2C](https://dn-anything-about-doc.qbox.me/document-uid66754labid3113timestamp1498954158339.png/wm)
![5.2D](https://dn-anything-about-doc.qbox.me/document-uid66754labid3113timestamp1498954210478.png/wm)
![5.2E](https://dn-anything-about-doc.qbox.me/document-uid66754labid3113timestamp1498954223804.png/wm)

### 5.3 makefile �ļ���ͨ�ñ�������
#### 5.3.1 ���� MAKEFILES ����ָ�����ļ��Ƿ�����ȷ������
MAKEFILES ���������ж���ʱ������������include�����á�
�ñ����ڱ�չ��ʱ�Կո���Ϊ�ļ����ķָ�����
ɾ����ǰ makefile �ļ���
```
rm makefile
```
�½� makefile �������£�
```
#this makefile is test for include process

.PHONY:all clean

vari_a += " 2nd vari..."

all:
        @echo $(vari_a)

clean:
```
ִ�� make��
```
make
```
�ն˴�ӡ��
```
 2nd vari...
```
���ӻ������� MAKEFILES��
```
export MAKEFILES=./makefile_dir/c_inc
```
�ٴ�ִ�� make��
```
make
```
�ն˴�ӡ��
```
vari_a from c_inc  2nd vari...
```
�ɼ� make ���� MAKEFILES ���ļ��б������� makefile_dir/c_inc �ļ���

#### 5.3.2 ���� MAKEFILES ������ʹ������
��Ҫע�⣺
1. MAKEFILES ָ���ļ���Ŀ�겻����Ϊ make ���ռ�Ŀ�ꡣ
2. MAKEFILES �ǻ����������������е� makefile �������Ӱ�죬��˾�����Ҫʹ�øñ�����

�½�һ���ļ� aim_b_file���������£�
```
#this is aim_b file

.PHONY:aim_b

aim_b:
        @echo "now we exe aim_b"
```
���ļ���һ�� aim_b ����ִ�д˹���ʱ��ӡ��now we exe aim_b����
�޸� MAKEFILES ������
```
export MAKEFILES=./aim_b_file
```
ִ�� make��
```
make
```
�ն˴�ӡ��
```
 2nd vari...
```
�ɼ� make ��Ȼ�Ȱ��� aim_b_file �ļ�������Ȼ�� makefile �е� all ��Ϊ����Ŀ�ꡣ
����������֤ aim_b �����Ƿ��Ѿ����������������޸� makefile��Ϊ all ����һ��������
```
all: aim_b
```
������ִ�� all ����֮ǰ������ִ�� aim_b ����
ִ�� make��
```
make
```
�ն˴�ӡ��
```
now we exe aim_b
 2nd vari...
```
��ִ�У�
```
make aim_b
```
�ն˴�ӡ��
```
now we exe aim_b
```
��make�� �� ��make aim_b�� �Ĵ�ӡ��˵�� aim_b �Ѿ��ܹ�����ȷִ�У�������ȷ������ΪĬ�ϵ�Ŀ�����ֻ����ȷָ���˹���ʱ�Ż�ִ�����Ӧ�����

#### 5.3.3 ��ӡ MAKEFILE_LIST 
���� MAKEFILES ָ�����ļ�����������ָ�����ļ�����Ĭ�� makefile �ļ��Լ� include ָ�����ļ�������¼������
��ǰ·�����ܹ��� ./aim_b_file��./makefile��./makefile_dir/inc_a��./makefile_dir/inc_b��./makefile_dir/c_inc ��5���ļ���
��������ʹ�ò�ͬ�ķ�ʽ�����ǰ���������
./aim_b_file �Ѿ��������� MAKEFILES �����С�
./makefile ����ִ�� make ʱ���Զ����á�
�޸� makefile �� include ָʾ�������ļ�./makefile_dir/inc_a ��./makefile_dir/inc_b ��
���� all Ŀ���д�ӡ MAKEFILE_LIST �������޸ĺ�� makefile �������£�
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
ִ�� make��
```
make
```
�ն˴�ӡ��
```
now we exe aim_b
 2nd vari...
./aim_b_file makefile makefile_dir/inc_a makefile_dir/inc_b
```
�ڶ��д�ӡ����˵�� MAKEFILE_LIST �Ѿ�������./aim_b_file makefile makefile_dir/inc_a makefile_dir/inc_b��

ʵ���������ͼ��ʾ��
![5.3A](https://dn-anything-about-doc.qbox.me/document-uid66754labid3113timestamp1498954417212.png/wm)
![5.3B](https://dn-anything-about-doc.qbox.me/document-uid66754labid3113timestamp1498954466628.png/wm)
![5.3C](https://dn-anything-about-doc.qbox.me/document-uid66754labid3113timestamp1498954479052.png/wm)
![5.3D](https://dn-anything-about-doc.qbox.me/document-uid66754labid3113timestamp1498954491773.png/wm)

### 5.4 ������һ�� makefile
#### 5.4.1 ʹ�� make -f ������һ�� makefile
���ڿ��� makefile �ļ�Ϊ inc_test��
```
cp makefile inc_test
```
��ʹ�� make -f ����ָ����Ҫ��ȡ�� makefile �ļ�Ϊ inc_test��
```
make -f inc_test
```
�ն˴�ӡ��
```
now we exe aim_b
 2nd vari...
./aim_b_file inc_test makefile_dir/inc_a makefile_dir/inc_b
```
�ɼ�ԭ��Ĭ��ִ�е� makefile �ļ����滻���� inc_test �ļ����ұ� MAKEFILE_LIST ��ȷ��¼��

#### 5.4.2 �������� makefile ����������
makefile ������һ�� makefile ��ʱ���������й�����������
�����й����������ᷢ��ʲô״���أ�
�޸� aim_b_file ���� all ����
```
all:
        @echo "all in aim_b"
```
ִ�У�
```
make
```
�ն˴�ӡ��
```
makefile:10: warning: overriding commands for target `all'
./aim_b_file:9: warning: ignoring old commands for target `all'
now we exe aim_b
 2nd vari...
./aim_b_file makefile makefile_dir/inc_a makefile_dir/inc_b
```
�Ӵ�ӡ��־�п��Կ��� makefile ��д�� aim_b_file �ļ��е� all ����

#### 5.4.3 �á�����ƥ��ģʽ��������һ�� makefile
�������ʵ���п��Կ��������������ļ���ͬ���Ĺ���make �����Ĺ������д�ȶ���Ĺ���
���ڼ��������� makefile �ļ���AMake �� BMake�����Ƕ�������һ�� intro ���򣬵���Ϊ��ͬ��
�û�ϣ��ִ��������Ŀ�� AAim �� BAim ��ʱ��ֱ���� AMake �� BMake �� intro ����Ҫ���������أ�

�����޷��� include ָʾ�������������� makefile������������д�������Ϊ��
��ʱ��Ҫ�õ�������һ�� makefile �ļ��ɡ�
���巽�������ڶ�Ӧ�Ĺ��������µ��� make ��������Ҫ���ص� makefile �ļ�����Ŀ������

chapter2/makefile_dir/ Ŀ¼���µ� makefile_c AMake BMake �������ļ�������ʾ��������Ĺ��ܡ�
�ȿ��������ļ�����ǰĿ¼�£�
```
cp makefile_dir/makefile_c makefile
cp makefile_dir/AMake ./
cp makefile_dir/BMake ./
```
�鿴 makefile �ļ����������£�
```
#this is a makefile reload example main part

.PHONY:AAim BAim

AAim:
        make -f AMake intro

BAim:
        make -f BMake intro
```
��Ŀ��Ϊ AAim ʱ����ִ�С�make -f AMake intro����
Ҳ���ǻ����� AMake ��Ϊ makefile �ļ���ִ�� intro ����
BAim �Ĵ���ʽҲ���ơ�
���ڲ���һ��ִ��Ч����ִ�У�
```
make AAim
```
�ն˴�ӡ��
```
make -f AMake intro
make[1]: Entering directory '/root/study/make_example/chapter2'
Hello, this is AMake
make[1]: Leaving directory '/root/study/make_example/chapter2'
```
�ɼ� AMake �µ� intro �����ȷ��ִ�е��ˡ�
��ִ�� BAim ����
```
make BAim
```
�ն˴�ӡ��
```
make -f BMake intro
make[1]: Entering directory '/root/study/make_example/chapter2'
Hello, this is BMake
make[1]: Leaving directory '/root/study/make_example/chapter2'
```
BMake �Ĺ���Ҳ��˳��ִ�С�
���������ǻ��������ط�ʽ��

���������ڶ�һ������ϣ������δ�������Ҫִ����һ�� intro ���򣬴˹������� CMake �ļ��С�
Ϊ��ƥ���������е�δ�������������Ҫ�õ�ͨ�����%����

�޸� makefile ���ļ������롰����ƥ��ģʽ������
```
%:
        make -f CMake intro
```
���� makefile_dir/CMake �ļ���������ǰĿ¼�£�
```
cp makefile_dir/CMake ./
```
���ִ��һ������ AAA��
```
make AAA
```
�ն˴�ӡ��
```
make -f CMake intro
make[1]: Entering directory '/root/study/make_example/chapter2'
Hello, this is CMake
make[1]: Leaving directory '/root/study/make_example/chapter2'
```
˵������δ����Ĺ����������� CMake ��ִ���� intro ����

ʵ��Ч����ͼ��ʾ��
![5.4A](https://dn-anything-about-doc.qbox.me/document-uid66754labid3113timestamp1498954887794.png/wm)
![5.4B](https://dn-anything-about-doc.qbox.me/document-uid66754labid3113timestamp1498954961382.png/wm)
![5.4C](https://dn-anything-about-doc.qbox.me/document-uid66754labid3113timestamp1498954974201.png/wm)

## ����ʵ���ܽ�
��ʵ����֤�� makefile ���Զ��Ƶ�����һЩ����������ʹ�ã�include ָʾ����ʹ�ú����ƣ��Լ� makefile ���صļ��ɡ�

## �ߡ��κ�ϰ��
��

## �ˡ��ο�����
��
