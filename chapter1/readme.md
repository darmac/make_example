## һ��ʵ�����
��ʵ����� makefile �Ļ�������

### 1.1 ʵ������
1. makefile ��������
2. makefile ʱ���������ԡ�
3. ��֤ makefile �����ļ���ִ��˳��
4. ������PHONY�͡�-�����ܲ��ԡ�
5. makefile �ļ���������ʽ����
6. ��дһ�γ���� makefile �ļ���

### 1.2 ʵ��֪ʶ�� 
1. makefile �Ļ����������
2. make ����Ŀ������ݣ�ʱ�����
3. makefile Ŀ��������ִ��˳��Ϊ�������ҡ�
4. makefile �����ĸ�ֵ��ʹ�á�
5. .PHONY�����ã�����αĿ�ꡣ
6. ��-�������ã���make���Ը�����Ĵ���
7. make��Ѱmakefile����������"GNUmakefile" > "makefile" > "Makefile"��
8. makefile�����ڵ������Ҳ��������make����ʽ����ʵ�ִ�����롣

### 1.3 ʵ�黷��
Ubuntuϵͳ, GNU gcc���ߣ�GNU make����

### 1.4 �ʺ���Ⱥ
���γ��Ѷ�Ϊ�򵥣��������ż���γ̣��ʺ��д����д�������û�����Ϥ������make��һ���÷���

### 1.5 �����ȡ
git clone https://github.com/darmac/make_example.git

## ����ʵ��ԭ��
���� makefile �Ļ��������һЩ�򵥵����ԡ�

## ��������׼��
����ʵ��¥�γ̼��ɡ�

## �ġ���Ŀ�ļ��ṹ
main.c����Ҫ�� C ����Դ���롣
makefile��make�����ļ���

## �塢ʵ�鲽��

### 5.1 makefile ��������
#### 5.1.1 ץȡԴ����
ʹ������ cmd ��ȡ GitHub Դ���룺
```
cd ~/Code/
git clone https://github.com/darmac/make_example.git
```
#### 5.1.2 ��д main.c Դ�ļ�
ʵ���н��á�hello world������������֤ makefile �Ļ�����������ȱ�дһ��С���� main.c ��
Դ���������� main.c �ļ����������£�
```
#include <stdio.h>

int main(void)
{
    printf("hello world!\n");
    return 0;
}
```
#### 5.1.3 ��Ϥ makefile �Ļ�������
makefile ��Ϊ���Զ�������롢�������̶����ڵġ�
makefile �Ļ�����д�������£�
```
TARGET... : PREREQUISITES...
COMMAND
```
TARGET������Ŀ��,����Ϊ�ļ���������
PREREQUISITES����������
COMMAND��������,������[TAB]��ʼ,��shellִ��

#### 5.1.4 ��д�򵥵� makefile �ļ����� main.c �ı���
Դ���������� makefile �ļ����������£�
```
  1 #this is a makefile example
  2 
  3 main:main.o
  4     gcc -o main main.o
  5 
  6 main.o:main.c
  7     gcc -c main.c
```
line1����#��Ϊע�ͷ��ţ������ע���ı���
line3 - line4������Ŀ�� main �������ļ� main.o ������ command��
line6 - line7������Ŀ�� main.o �ı���command��

#### 5.1.5 ����make����
make ���ߵĻ���ʹ�÷���Ϊ��make TARGET ��
���ն��������
```
make main.o
```
���Կ���shell��ִ�У�
```
gcc -c main.c
```
���������룺
```
make main
```
���Կ���shellִ�У�
```
gcc -o main main.o
```
ִ��main�ļ���
```
./main
```
�ն˻��ӡ��
```
hello world!
```
˵����������ִ�С�
#### 5.1.6 �Զ��������ռ�Ŀ��
����� main.o �� main �ļ���
```
rm main.o main
```
�������ǵġ��ռ���Ŀ���� main �ļ���ʵ�������ǲ��������м�Ŀ�ꡰmain.o����
���ڳ���ֻ����һ�� make �����������Ҫ���ռ�Ŀ�ꡣ
```
make main
```
�ն˻��ӡ�� make ʵ��ִ�е����
```
gcc -c main.c
gcc -o main main.o
```
�ɼ� make ���������� makefile �� main �������ļ� main.o������������ main �ļ���
#### 5.1.7 �� make�Զ�Ѱ��Ŀ��
�ٴ������ main.o �� main �ļ���
```
rm main.o main
```
��ִ�� make����������Ŀ�꣺
```
make
```
�ն˴�ӡ�� make ��ִ�������һ����
```
gcc -c main.c
gcc -o main main.o
```
������ΪĬ������£�make ���Ե�һ��������Ϊ�䡰�ռ�Ŀ�ꡱ��
�������ǳ����޸� makefile����Ŀ�� ��main��֮ǰ������һ������
```
dft_test:middle_file
	mv middle_file dft_test
middle_file:
	touch middle_file
```
ִ�У�
```
make
```
���Կ����ն�ӡ����
```
touch middle_file
mv middle_file dft_test
```
��ǰ�ļ����»���һ�� dft_test �ļ���
### 5.2 makefile ʱ���������ԡ�
### 5.2.1 �ļ���ʱ���������
make��ִ������ʱ���������ļ���ʱ�����
1. �������ļ������ڻ��������ļ���ʱ�����Ŀ���ļ��£���ִ�������ļ���Ӧ�����
2. �������ļ���ʱ�����Ŀ���ļ��ϣ�����������ļ���Ӧ�����
#### 5.2.2 �ļ�ʱ�������
��ԭ makefile �ļ��������� v1.0 ������
```
git checkout makefile
patch -p2 < v1.0.patch
```
��ʱ makefile �ļ��������£�
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
������ܴ��ڵ��м��ļ���
```
rm main.o testa testb
```
ִ�� make��
```
make
```
�ն˻������
```
gcc -c main.c
touch testa
touch testb
gcc -o main main.o
```
make ��ֱ����� main.o testa testb �������м��ļ�������֤�� 5.2.1 ��˵���ĵ�һ�����ԡ�
����ɾ�� testb �ļ����ٿ��� make �����ִ�У�
```
rm testb
make
```
�ն˴�ӡ��
```
touch testb
gcc -o main main.o
```
�ɼ� make �ֱ�ִ���� testb �� main ��������main.o �� testa �����Ӧ������û�б�ִ�е���
����֤�� 5.2.1 ��˵���ĵڶ������ԡ�
### 5.3 ʵ�� makefile �����ļ���ִ��˳��
������ʵ����Կ��� make Ŀ���ļ��������ļ��ǰ��մ����ҵ�˳�����ɵġ�
��Ӧ����main����
```
main:main.o testa testb
    gcc -o main main.o
```
make ����˳��ֱ�ִ�� main.o testa testb ����Ӧ�Ĺ���
�������ǵ��� main.o testa testb ��˳��
�޸� makefile �ļ��� main ���������˳��
```
  3 main:testb testa main.o
```
����ϴα�������в������м��ļ���
```
rm main.o testa testb
```
ִ�� make��
```
make
```
�ն������´�ӡ��
```
touch testa
touch testb
gcc -c main.c
gcc -o main main.o
```
�ɼ� make ��ȷ�ǰ��մ����ҵĹ���ֱ�ִ�������ļ���Ӧ�����
### 5.4 ������PHONY�͡�-�����ܲ��ԡ�
#### 5.4.1 makefile �ı�������
makefile Ҳ����ʹ�ñ������������� C �����еĺ궨�塣
��������ֱ��ʹ�á�vari=string����д�������壬���ԡ�$(vari)����ʽ��ʹ�á�
�����ñ���������Ŀ��������ʹ makefile �������õ���չ�ԡ�
#### 5.4.2 �� makefile ����ӱ�����ʹ��
�Ȼ�ԭ makefile �ļ��� v1.0 �������������һ�α�����м��ļ���
```
git checkout makefile
patch -p2 < v1.0.patch
rm main.o testa testb
```
��Ŀ�� ��main��֮ǰ����һ��������depen����
```
depen=main.o testa testb
```
�޸� main Ŀ���������������
```
main:$(depen)
```
ִ�� make ��
```
make
```
�ն˴�ӡ��
```
gcc -c main.c
touch testa
touch testb
gcc -o main main.o
```
�ɼ� makefile �����ܹ�����ִ�С�
֮�� main Ŀ����������б仯ʱ��ֻ���޸ġ�depen���������ɡ�

#### 5.4.3 Ϊ makefile ��� clean ����
ÿ�β��� makefile ��ʱ�����Ƕ�Ҫ����м��ļ���Ϊ��ʹ�ñ��빤�̸����Զ����������� makefile ����ӹ��������Զ������
�� makefile ���޸� depen ���������� clean ������
```
depen=clean main.o testa testb
```
���� clean ���������
```

clean:
    rm main.o testa testb
```
��ǰĿ¼���Ǵ��� main.o testa testb �����м��ļ��ģ�ִ�� make ����Ч����
```
make
```
���Կ����ն˴�ӡ��
```
rm main.o testa testb
gcc -c main.c
touch testa
touch testb
gcc -o main main.o
```
˵������ make ����������ϴα�����м��ļ����ؽ���

#### 5.4.4 �� clean ����Ҳʹ�ñ���
makefile �ж����� depen �������������������
�������� clean ����û��ʹ���������������� makefile ��ά�������鷳��������������ʱ����Ҫͬʱ�޸� depen ������ clean ����
��ˣ������� clean ����� rm ����Ҳʹ�� depen ������
�޸� clean �����µ� rm �����У�
```
rm $(depen)
```
�ٴ�ִ�� make �²»ᷢ��ʲô��
```
make
```
�ն˴�ӡ��
```
rm clean main.o testa testb
rm: cannot remove 'clean': No such file or directory
makefile:18: recipe for target 'clean' failed
make: *** [clean] Error 1
```
ԭ������Ϊ depen ����ָ�� clean Ϊ�������� rm ����Ҳ����ͼɾ�� clean �ļ�ʱ���ִ���
�� make ��ִ�������й����г��ִ������˳�ִ�С�
#### 5.4.5 �� clean �������� make Ҳ�ܼ���ִ��
rm ĳ�������ڵ��ļ��Ǻܳ����Ĵ����ڴ󲿷����������Ҳ������������Ϊ������������
����� make ������������أ�
������Ҫ�õ���-�����š�
��-������ make ���Ը�ָ��Ĵ���
�޸� makefile �е� clean ����
```
clean:
    -rm $(depen)
```
�ٴ�ִ�� make��
```
make
```
�ն˴�ӡ��
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
������Ч��������Ȼ rm ָ�������make ȴ��Ȼ�����������ǵ��ռ�Ŀ�꣺main �ļ���

#### 5.4.6 ʹ��αĿ��
ǰ���ᵽ makefile �����ļ���ʱ�������Ŀ���ļ��ɣ����Ӧ����������ִ�С�
�������ڶ�����һ�� clean ���򣬵�����ļ�����������һ�� clean �ļ��ᷢ��ʲô���ĳ�ͻ�أ�
���ڵ�ǰĿ¼���½�һ�� clean �ļ���
```
touch clean
```
��ִ�� make ���
```
make
```
�ն˴�ӡ��
```
gcc -o main main.o
```
�������� clean �ļ��Ѿ����ڣ�make ������ִ�� clean Ŀ���Ӧ�Ĺ����ˡ�
��ʵ���� clean ��һ��αĿ�꣬���ǲ��������������� clean �ļ����κι�����
��ʱ��Ҫʹ�á�.PHONY��������αĿ�ꡣ
�޸� makefile �ڱ��� depen ֮ǰ����һ��αĿ��������
```
.PHONY: clean
```
ִ�� make��
```
make
```
�ն˴�ӡ��
```
rm clean main.o testa testb
gcc -c main.c
touch testa
touch testb
gcc -o main main.o
```
makefile ���ܵõ�����ִ���ˣ��������̶��������ǵ�Ԥ�ڡ�
���ڼ����������� testa testb����Ϊʵ���� main �ļ�������Ҫ�õ��������ļ���
�޸� makefile �� depen ������
```
depen=clean main.o
```
ִ�� make��
```
make
```
�ն˴�ӡ��
```
rm clean main.o
rm: cannot remove 'clean': No such file or directory
makefile:20: recipe for target 'clean' failed
make: [clean] Error 1 (ignored)
gcc -c main.c
gcc -o main main.o
```
�����Ѿ��������������Ķ��� main �ļ������������ˡ�
### 5.5 makefile �ļ���������ʽ����
#### 5.5.1 make Ĭ�ϵ��õ��ļ���
����Ϊֹ������д���Զ�������򶼷��� makefile �У�ͨ��ʵ��Ҳ������ȷ�˽⵽ make ���߻��Զ����� makefile �ļ���
�Ƿ��ļ�����������Ϊ��makefile���أ�
���ǵģ�GNU make �ᰴĬ�ϵ����ȼ����ҵ�ǰ�ļ��е��ļ������ҵ����ȼ�Ϊ��
��GNUmakefile��> ��makefile��> ��Makefile��
#### 5.5.2 ���� make ���õ��ļ����ȼ�
�½� GNUmakefile �ļ�������������ݣ�
```
#this is a GNUmakefile

.PHONY: all

all:
        @echo "this is GNUmakefile"
```
�½� Makefile �ļ�������������ݣ�
```
#this is a Makefile

.PHONY: all

all:
        @echo "this is Makefile"
```
�鿴���µ�ǰĿ¼�ļ�������Ӧ�������� makefile �ܹ�ʶ�𵽵��ļ���
```
ls *file* -hl
```
�ն˴�ӡ��
```
-rw-r--r-- 1 root root  71 Jun 25 12:22 GNUmakefile
-rw-r--r-- 1 root root 192 Jun 25 09:18 makefile
-rw-r--r-- 1 root root  65 Jun 25 12:23 Makefile
```
ִ��һ�� make �����ĸ��ļ������ã�
```
make
```
�ն˴�ӡ��
```
this is GNUmakefile
```
˵�� make ���õ��� GNUmakefile��
ɾ�� GNUmakefile ��ִ��һ�� make��
```
rm GNUmakefile
make
```
�ն˴�ӡ��
```
rm clean main.o
rm: cannot remove 'clean': No such file or directory
makefile:20: recipe for target 'clean' failed
make: [clean] Error 1 (ignored)
gcc -c main.c
gcc -o main main.o
```
˵�� make ���õ��� makefile��
ɾ�� makefile��ִ�� make��
```
rm makefile
make
```
�ն˴�ӡ��
```
this is Makefile
```
˵�� Makefile �������������ȼ�����ļ���
*���飺�Ƽ��� makefile ���� Makefile ��������������ʹ�� GNUmakefile����Ϊ GNUmakefile ֻ�ܱ� GNU �� make ����ʶ�𵽡�*
### 5.6 ��дһ�γ���� makefile �ļ���
#### 5.6.1 С�ͼ������˵��
���������Ѿ������� makefile �Ļ������򣬿��Գ����Լ�дһ�� makefile ���й��̹���
�� make_example/chapter0 Ŀ¼����һ�μ򵥵ļ�����ʾ����������ҪΪ������һ�� makefile �ļ���
�л��� chapter0 Ŀ¼���鿴Ŀ¼�µ��ļ���
```
cd ../chapter0
ls
```
�ն˴�ӡ��
```
add_minus.c  add_minus.h main.c  multi_div.c  multi_div.h  readme.md  v1.0.patch  v2.0.patch  v3.0.patch
```
�򵥽���һ�³��������
1. add_minus.c Ҫ�󱻱���ɾ�̬���ӿ� libadd_minus.a��
2. multi_div.c Ҫ�󱻱���ɶ�̬���ӿ� libmulti_div.so��
3. main.c ����Ҫ��Դ�ļ���������������������ļ��е� API��main.c Ҫ�󱻱���Ϊ main.o ��
4. ��main.o libadd_minus.a libmulti_div.so ���ӳɿ�ִ���ļ� main��
5. ÿ�α���ǰҪ����ϴα���ʱ�������ļ���

���ϲ��� v3.0 �����ӿ��ļ�·����export �������� LD_LIBRARY_PATH Ϊ��ǰ·����
```
patch -p2 < v3.0.patch
export LD_LIBRARY_PATH=$PWD
```
#### 5.6.2 makefile �ļ�ʾ��
����� 5.6.1 ��Ҫ����� makefile �ļ����������ʾ��������
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
## ����ʵ���ܽ�
��ʵ������� makefile �Ļ��������һЩ�򵥵����ԡ�

## �ߡ��κ�ϰ��
��

## �ˡ��ο�����
��
