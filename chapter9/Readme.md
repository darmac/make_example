## һ��ʵ�����
����ʵ�齫���� make �ı��������񣬱������滻���ã����������������б�����Ŀ��ָ��������ʹ�ü��Զ���������ʹ�á�

### 1.1 ʵ������
1. ��ͬ�ı������͸�ֵ���
2. �������滻���ã����������������б�����ʹ��
3. Ŀ��ָ��������ʹ��
4. �Զ���������ʹ��

### 1.2 ʵ��֪ʶ�� 
1. �����Ķ��弰չ��ʱ����
2. �ݹ�չ������ʹ�á�=���� define ���壬��ʹ��ʱչ����
3. �ݹ�չ�������Ķ�������д˳���޹أ���Ҳ��������ڵ��Ժͺ����ظ����õ����⡣
4. ֱ��չ������ʹ�á�:=�����壬�� make ���뵱ǰ��ʱ����չ����
5. += ���������ԶԱ�������׷�ӣ�չ����ʽ�����ԭʼ�ĸ�ֵ��ʽһ�¡�
6. ?= �����������ڱ���δ����ʱ���и�ֵ��
7. �������滻���ÿ��Խ�����չ�������ݽ����ַ����滻��
8. ϵͳ���������� makefile ��˵�ǿɼ��ģ����ļ��е�ͬ�������Ḳ�ǻ�������������ʹ�� -e ѡ����⸲�ǡ�
9. �����б����� makefile �е���ͨ�������и��ߵ����ȼ�������ʹ�� override �ؼ��ַ�ֹ makefile �е�ͬ��������������ָ���������ǡ�
10. Ŀ��ָ���������ڰ������������ڵ������Ŀɼ��������ھֲ����������ȼ�������ͨ������
11. �Զ����������Ը��ݾ���Ŀ����������Զ�������Ӧ���ļ��б�

### 1.3 ʵ�黷��
Ubuntuϵͳ, GNU gcc���ߣ�GNU make����

### 1.4 �ʺ���Ⱥ
���γ��Ѷ�Ϊ�еȣ��ʺ��Ѿ������˽� makefile �����ѧԱ����ѧϰ��

### 1.5 �����ȡ
����ͨ�����������ȡ���룺
```bash
$ git clone https://github.com/darmac/make_example.git
```

## ����ʵ��ԭ��
���� makefile �Ļ����������������ʵ�飬ѧϰ���������ʹ�÷�ʽ��

## ��������׼��
����ʵ��¥�γ̼��ɡ�

## �ġ���Ŀ�ļ��ṹ
```bash
.

```

## �塢ʵ�鲽��

### 5.1 make �ĵݹ�ִ��ʾ��
#### 5.1.1 ץȡԴ����
ʹ������ cmd ��ȡ GitHub Դ���벢������Ӧ�½ڣ�
```bash
cd ~/Code/
git clone https://github.com/darmac/make_example.git
cd make_example/chapter9
```

#### 5.1.2 �ݹ�չ��ʽ����
makefile ��������һ�����֣�����һ���ı��ַ��������������ֶ��巽ʽ���ݹ�չ��ʽ������ֱ��չ��ʽ������������ makefile �Ķ���׶α�չ�����ַ�����
�ݹ�չ��ʽ��������ͨ����=���͡�define�����ж��壬�ڱ�����������У������������Ķ��岻������չ���������ڱ���������ʹ�õ�ʱ�Ž���չ����
chapter9/style/ Ŀ¼�µ� makefile �ļ���ʾ�˵ݹ�չ��ʽ�����Ķ����ʹ�÷�ʽ��
�ļ��������£�
```
#this makefile is for recursively vari test

.PHONY:recur loop

a1 = abc
a2 = $(a3)
a3 = $(a1)

b1 = $(b2)
b2 = $(b1)

recur:
	@echo "a1:"$(a1)
	@echo "a2:"$(a2)
	@echo "a3:"$(a3)

loop:
	@echo "b1:"$(b1)
	@echo "b2:"$(b2)
```
�ļ��� recur �����õ�3��������a1 ��ֱ�Ӷ����ַ�����a2 ���ú���Ŷ��嵽�� a3��a3 ������ a1��
loop �����õ� b1��b2 2�������������໥���á�
���� style Ŀ¼������ recur ����
```bash
cd style;make recur
```
�ն˴�ӡ��
```bash
a1:abc
a2:abc
a3:abc
```
�ɼ� a1 a2 a3 ��ֵ��һ�µģ�������չ���붨��˳���޹ء�
�ٲ��� loop ���
```bash
make loop
```
�ն˴�ӡ��
```bash
makefile:9: *** Recursive variable 'b1' references itself (eventually).  Stop.
```
make ��Ϊ�������������޵ݹ�������˳���
��������Կ��Կ����ݹ�չ��ʽ���ŵ㣺�˱��������ñ����Ķ���˳���޹ء�ȱ�����ǣ���������ڻ�������ʱ���ܵ������޵ݹ顣
����֮�⣬�ݹ�չ��ʽ���������к������ã�ÿ�����øñ������ᵼ�º�������ִ�У�Ч�ʽϵ͡�

#### 5.1.3 ֱ��չ��ʽ����
ֱ��չ��ʽ����ͨ����:=�����ж��壬���������������úͺ��������ö����ڶ���ʱ��չ����
�ļ� direct.mk �� makefile �еġ�=���滻Ϊ��:=��������ִ�� recur �� loop ����
```bash
make -f direct.mk recur;make -f direct.mk loop
```
�ն˴�ӡ��
```bash
a1:abc
a2:
a3:abc
b1:
b2:
```
�Ӳ��Խ�����Կ��������� a2��b1 ����������δ����ı�������˱�չ��Ϊ�ա�
ʹ��ֱ��չ��ʽ�������Ա������޵ݹ�����ͺ����ظ�չ��������Ч�����⣬���Ҹ�����һ��ĳ�������߼������ڵ������⣬����Ƽ��û�����ʹ��ֱ��չ��ʽ������

#### 5.1.4 ����׷�Ӻ�������ֵ
ʹ�� += ��ֵ���ſ��ԶԱ�������׷�ӣ�����׷��ʱ�ĸ�ֵ������������ʱһ�£���׷�ӵ���δ�����������Ĭ���Եݹ�չ��ʽ�����и�ֵ��
ʹ�� ?= ��ֵ���ſ��ԶԱ�������������ֵ��������δ���������Ա������и�ֵ�����򲻸ı�����ĵ�ǰ���塣
append.mk �ļ���ʾ��׷�Ӹ�ֵ��������ֵ��ʹ�÷�ʽ���������£�
```
#this makefile is for += test

.PHONY:dir recur

a1 := aa1
a1 += _a1st
a2 := _a2
a1 += $(a2)
a1 += $(a3)
a3 += $(a1)

b1 = bb1
b1 += _b1st
b2 = _b2
b1 += _b2
b1 += $(b3)
b3 += $(b1)

c1 += $(c2)
c2 += $(c1)

d1 ?= dd1
d2 = dd2
d2 ?= dd3

dir:
	@echo "a1:"$(a1)

recur:
	@echo "b1:"$(b1)

def:
	@echo "c1:"$(c1)


cond:
	@echo "d1:"$(d1)
	@echo "d2:"$(d2)
```
dir �� recur ������ʾ�˵ݹ�չ��ʽ������ֱ��չ��ʽ����ʹ��׷�Ӹ�ֵ������
def ������ʾ��δ�������׷�Ӹ�ֵ��Ĭ�Ϸ��
cond ��ʾ��������ֵ��ʹ�á�
�ֱ�ִ����������
```bash
make -f append.mk dir;make -f append.mk recur;make -f append.mk def;make -f append.mk cond
```
�ն˴�ӡ��
```bash
a1:aa1 _a1st _a2
append.mk:16: *** Recursive variable 'b1' references itself (eventually).  Stop.
append.mk:19: *** Recursive variable 'c1' references itself (eventually).  Stop.
d1:dd1
d2:dd2
```
�����з���ÿһ�д�ӡ����ԭ��

### 5.2 �������滻
#### 5.2.1 �滻����
�����Ѿ�����ı���������ʹ�á��滻���á�����ָ�����ַ��������滻��
�滻���õĸ�ʽΪ $(VAR:A=B)�������Խ����� VAR ������ A ��β���ַ��滻Ϊ B ��β���ַ���
Ҳ����ʹ��ģʽ���Ž����� A ģʽ���ַ��滻Ϊ B ģʽ��
chapter9/rep/makefile ��ʾ�˱������滻���ã��������£�
```
.PHONY:all

vari_a := fa.o fb.o fc.o f.o.o
vari_b := $(vari_a:.o=.c)
vari_c := $(vari_a:%.o=%.c)
vari_d := $(vari_a:f.o%=f.c%)

all:
	@echo "vari_a:" $(vari_a)
	@echo "vari_b:" $(vari_b)
	@echo "vari_c:" $(vari_c)
	@echo "vari_d:" $(vari_d)

```
�ļ��зֱ�Բ�ͬ�ı��������滻���ú�ģʽ�滻���ã����� rep Ŀ¼�����ԣ�
```bash
cd ../rep;make
```
�ն˴�ӡ��
```bash
vari_a: fa.o fb.o fc.o f.o.o
vari_b: fa.c fb.c fc.c f.o.c
vari_c: fa.c fb.c fc.c f.o.c
vari_d: fa.o fb.o fc.o f.c.o
```
vari_b �е� .o ��׺���滻���� .c ��׺��f.o.o ���滻δ f.o.c�������ֻ�к�׺�ᱻ�滻���ַ������������ֱ��ֲ��䡣
vari_c ����ʹ��ģʽ�����滻��׺������� vari_b һ�¡�
vari_d ʹ��ģʽ���Ž�ǰ׺ f.o �滻Ϊ f.c��

#### 5.2.2 ����������ʹ��
���� makefile ��˵��ϵͳ�µĻ����������ǿɼ��ġ����ļ��еı������뻷��������һ�£�Ĭ�������ļ��еı�����
�ļ� envi.mk ��ʾ�˱��� CC �뻷������ CC ������ͻʱ��ִ�������
```

.PHONY:all

CC := abc

all:
	@echo $(CC)

```
�ļ�����һ�� CC ��������ֵΪ abc��ִ���ռ�Ŀ��ʱ��ӡ CC ���������ݡ�
������ export һ���������� CC����ִ�� envi.mk �۲����������Ƿ�������
```bash
export CC=def;echo $CC;make -f envi.mk
```
�ն˴�ӡ��
```bash
def
abc
```
˵�� makefile �Զ���������ȼ����ڻ�������������Ҳ������ makefile ��ȡ�� CC �����Ķ�������޸� PATH �������忴���ᷢ��ʲô״����

#### 5.2.3 ��ֹ��������������
����ʹ�� -e ѡ���ֹ����������ͬ���������ǣ�������ʵ����� -e ѡ�
```bash
make -f envi.mk -e
```
�ն˴�ӡ��
```bash
def
```

#### 5.2.4 �����б���
�뻷��������ͬ����ִ�� make ʱָ���������б����Ḳ�� makefile ��ͬ���ı������壬
���ϣ������������������Ҫʹ�� override �ؼ��֡�
override.mk �ļ���ʾ�������в����ĸ��Ǻ� override �ؼ��ֵ�ʹ�ã�
```
.PHONY:all

vari_a = abc
vari_b := def

override vari_c = hij
override vari_d := lmn

vari_c += xxx
vari_d += xxx

override vari_c += zzz
override vari_d += zzz

all:
	@echo "vari_a:" $(vari_a)
	@echo "vari_b:" $(vari_b)
	@echo "vari_c:" $(vari_c)
	@echo "vari_d:" $(vari_d)
	@echo "vari_e:" $(vari_e)
```
vari_a �͡�vari_c �ǵݹ�չ��ʽ������vari_b �͡�vari_d ��ֱ��չ��ʽ������vari_e ��δ���������
���ڴ������д��� vari_a �� vari_e ���鿴�������յ�չ��ֵ��
```bash
make -f override.mk vari_a=va vari_b=vb vari_c=vc vari_d=vd vari_e=ve
```
�ն˴�ӡ��
```bash
vari_a: va
vari_b: vb
vari_c: hij zzz
vari_d: lmn zzz
vari_e: ve
```
�Ӵ�ӡ���Կ����������ַ��ı���������Ҫʹ�� override ָʾ�����ܷ�ֹ�����ж����ͬ���������ǡ�
ͬʱ���� override ����ı����ڽ����޸�ʱҲ��ѽʹ�� override�������޸Ĳ�����Ч����֤�������£�
```bash
make -f override.mk
```
�ն˴�ӡ��
```bash
vari_a: abc
vari_b: def
vari_c: hij zzz
vari_d: lmn zzz
vari_e:
```
�ɼ�������û�д���������� vari_c �� vari_d ��Ȼ�޷�׷�Ӳ��� override ָʾ��ʱ�� ��+= zzz����

### 5.3 Ŀ��ָ��������ģʽָ������
makefile �ж���ı���ͨ��ʱ�������ļ���Ч��������ȫ�ֱ�����������ͨ�ı����������⣬����һ��Ŀ��ָ��������������Ŀ�������������Ŀ�������Ŀɼ��������Ŀ��������Ҳ������Ŀ��������Ĺ���
Ŀ��ָ�����������Զ�����ģʽĿ���У���Ϊģʽָ��������
��Ŀ����ʹ�õı�������ȫ���ж��壬����Ŀ���ж���ʱ��Ŀ�궨�����ȼ����ߣ�����ע�⣺Ŀ��ָ��������ȫ�ֱ������������������ǵ�ֵ����Ӱ�졣
chapter9/target/makefile ��ʾ��Ŀ��ָ���������÷����������£�
```bash
.PHONY:all

vari_a=abc
vari_b=def

all:vari_a:=all_target

all:pre_a pre_b file_c
	@echo $@ ":" $(vari_a)
	@echo $@ ":" $(vari_b)

pre_%:vari_b:=pat
	pre_%:
	@echo $@ ":" $(vari_a)
	@echo $@ ":" $(vari_b)

file_%:
	@echo $@ ":" $(vari_a)
	@echo $@ ":" $(vari_b)
```
makefile �ж����� vari_a �� vari_b ����ȫ�ֱ�����Ŀ�� all ָ����һ��ͬ���� vari_a ������ģʽĿ�� pre_% ָ����һ��ͬ���� vari_b������
ÿ��Ŀ��Ĺ����ж���ӡ�����ܿ����� vari_a �� vari_b ��ֵ����ҿ��Ը���ǰ�������Ĺ����Ʋ�ÿ��Ŀ��ֱ���ӡʲô��Ϣ��
���� target Ŀ¼��ִ�� make��
```bash
cd ../target;make
```
�ն˴�ӡ��
```bash
pre_a : all_target
pre_a : pat
pre_b : all_target
pre_b : pat
file_c : all_target
file_c : def
all : all_target
all : def
```
�����ռ�Ŀ�� all ָ���� vari_a Ϊ��all_target�������������Ŀ���ؽ������� vari_a ����Ŀ��ָ����������ʽ���֡�vari_b ����ģʽĿ�� pre_% �б����壬��˶� pre_a �� pre_b ��˵��vari_b Ϊ��pat�������� file_% �� all Ŀ����ԣ�vari_b ��ȫ�ֱ�����չ����Ϊ��def����

����Ҳ���Ե����� pre_a �� file_c ΪĿ�꣬����������ʲô����
```bash
make pre_a
```
�ն˴�ӡ��
```bash
pre_a : abc
pre_a : pat
```
��ִ�У�
```bash
make file_c
```
�ն˴�ӡ��
```bash
file_c : abc
file_c : def
```
���ڴ�ʱ���Ǵ��� all Ŀ����������У����� all ָ���� vari_a ����ʧЧ��ȡ����֮����ԭ�е�ֵ "abc"���� pre_% ָ���� vari_b ���������Զ� pre_a ��˵��vari_b ������Ȼ�� "pat"��
#### 5.4 �Զ�������
��ģʽ�����У�һ��ģʽĿ�����ƥ������ͬ��Ŀ�������������ؽ������о�����Ҫָ��һ��ȷ�е�Ŀ������Ϊ�˷����ȡ�����еľ����Ŀ�����������makefile ����Ҫ�õ��Զ����������Զ���������ȡֵ�Ǹ��ݾ�����ִ�еĹ����������ģ�ȡ������ִ�й����Ŀ��������ļ�����
�ܹ��������Զ���������
$@��Ŀ������
$%����Ŀ����Ϊ��̬�⣬����þ�̬���һ����Ա��������Ϊ��
$<����һ������������
$?�����б�Ŀ���ļ��µ��������б�
$^�������������б��������������
$+����������������������������б�
$*��ģʽ�����̬ģʽ�����еľ���Ҳ����%��������Ĳ���

chapter9/auto/makefile ��ʾ�������Զ����������÷����ļ��������£�
```bash
# $@ $^ $% $< $? $* $+

.PHONY:clean

PRE:=pre_a pre_b pre_a pre_c

all:$(PRE) lib -ladd
	@echo "$$""@:"$@
	@echo "$$""^:"$^
	@echo "$$""+:"$+
	@echo "$$""<:"$<
	@echo "$$""?:"$?
	@echo "$$""*:"$*
	@echo "$$""%:"$%
	@touch $@

$(PRE):pre_%:depen_%
	@echo "$$""*(in $@):"$*
	touch $@

depen_%:
	@echo "use depen rule to build:"$@
	touch $@

lib:libadd.a(add.o minus.o)

libadd.a(add.o minus.o):add.o minus.o
	@echo "$$""%(in $@):" $%
	$(AR) r $@ $%
	
clean:
	$(RM) pre_* depen_* *.a *.o lib all

```
�ռ�Ŀ�� all ����������� pre_a pre_b pre_c lib �Ϳ��ļ� libadd.a�������ظ�������һ�� pre_a �����
ģʽ���� pre_% ���þ�̬ģʽ�����ڶ�Ӧ�� depen_% ���򣬴�ӡƥ�䵽�ľ���������Ŀ���ļ������ļ������ӡ $% ��������� libadd.a��

���ڽ��� auto Ŀ¼��ִ�� make��
```bash
cd ../auto;make
```
�ն˴�ӡ��
```bash
makefile:17: target 'pre_a' given more than once in the same rule
use depen rule to build:depen_a
touch depen_a
$*(in pre_a):a
touch pre_a
use depen rule to build:depen_b
touch depen_b
$*(in pre_b):b
touch pre_b
use depen rule to build:depen_c
touch depen_c
$*(in pre_c):c
touch pre_c
cc    -c -o add.o add.c
cc    -c -o minus.o minus.c
$%(in libadd.a): add.o
ar r libadd.a add.o
ar: creating libadd.a
make: Warning: Archive 'libadd.a' seems to have been created in deterministic mode. 'add.o' will always be updated. Please consider passing the U flag to ar to avoid the problem.
$%(in libadd.a): minus.o
ar r libadd.a minus.o
make: Warning: Archive 'libadd.a' seems to have been created in deterministic mode. 'minus.o' will always be updated. Please consider passing the U flag to ar to avoid the problem.
$@:all
$^:pre_a pre_b pre_c lib libadd.a
$+:pre_a pre_b pre_a pre_c lib libadd.a
$<:pre_a
$?:pre_a pre_b pre_c lib libadd.a
$*:
$%:

```
make �����ؽ� pre_a pre_b pre_c ���������ӡƥ�䵽�ľ� a b c���������ؽ� lib ����libadd.a ���ؽ������д�ӡ $% ���Ӵ�ӡ�ʹ��������Կ��� $% չ�����Ϊ add.o ��һ���ļ�������̬�ļ�Ŀ������ݸ������ļ��б�չ����Ρ����make ִ���ռ�Ŀ�� all �������б��ֱ��ӡ���Զ��������������� all �ļ���
������ϸ�۲첻ͬ�������Զ��������ı仯���������ǳ��ν����ռ�Ŀ�꣬��� $? �õ����������б���ȫ���������ʹ�� touch ������� pre_a pre_b �ٴβ��ԣ�
```bash
touch pre_a pre_b;make
```
�ն˴�ӡ��
```bash
makefile:17: target 'pre_a' given more than once in the same rule
make: Warning: Archive 'libadd.a' seems to have been created in deterministic mode. 'add.o' will always be updated. Please consider passing the U flag to ar to avoid the problem.
$%(in libadd.a): add.o
ar r libadd.a add.o
make: Warning: Archive 'libadd.a' seems to have been created in deterministic mode. 'add.o' will always be updated. Please consider passing the U flag to ar to avoid the problem.
make: Warning: Archive 'libadd.a' seems to have been created in deterministic mode. 'minus.o' will always be updated. Please consider passing the U flag to ar to avoid the problem.
$%(in libadd.a): minus.o
ar r libadd.a minus.o
make: Warning: Archive 'libadd.a' seems to have been created in deterministic mode. 'minus.o' will always be updated. Please consider passing the U flag to ar to avoid the problem.
$@:all
$^:pre_a pre_b pre_c lib libadd.a
$+:pre_a pre_b pre_a pre_c lib libadd.a
$<:pre_a
$?:pre_a pre_b lib libadd.a
$*:
$%:
```
��ӡ�еľ��沿����ʱ���Ժ��ԣ����Դ˲��ָ���Ȥ���Բ��� GNU make �ֲᾲ̬�����һ�¡�
���ڴ�ӡ�� $? ����Ϊ pre_a pre_b lib libadd.a��pre_a pre_b Ϊ�ֶ����µĲ��֣��� lib �� libadd.a �ĸ��������ɾ�̬����������������
�����߸��Զ�����������ֱ�������⣬��������������� D ���� F �ַ���ȡĿ¼�����ļ�����
�磺$(@D) ��ʾĿ���ļ���Ŀ¼����$(@F) ��ʾĿ���ļ����ļ����������÷��ǳ��򵥣�Ҳ���������е��Զ�����������������ʵ����ԡ�

## ����ʵ���ܽ�
������ʵ������� make �ı��������񣬱������滻���ã����������������б�����Ŀ��ָ��������ʹ�ü��Զ���������ʹ�á�

## �ߡ��κ�ϰ��
���������ʵ������Զ���������Ŀ¼�����ļ����Ļ�ȡ��

## �ˡ��ο�����
��
