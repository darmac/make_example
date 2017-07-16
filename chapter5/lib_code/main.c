#include <stdio.h>

extern int foo(void);

int main(void)
{
	int i = foo();
	printf("get i=%d\n",i);

	return 0;
}
