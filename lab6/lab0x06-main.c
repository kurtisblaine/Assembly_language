#include <stdio.h> 
#include "Lab0x06.h"
#include <ctype.h>
#include <stdbool.h>
#define MAX 1000


int main(){

int i = 0;
int result = 0;
int *pointer;
int length = 0;
int userIn[MAX];
char newLine;
bool quit = false;
for(int i = 0; i <= MAX; i++) userIn[i] == 0;

printf("Enter a bunch of numbers that you want added.\nFollow that by \"enter\" to let me know when you're finished\n");

do{
	scanf("%d%c", &userIn[i], &newLine);
	i++;
	
}while(newLine != '\n');

pointer = userIn;
length = i;

result = _sumAndPrintList(pointer, length);

printf("Your final result is %d\n", result);
printf("\nExiting...\n");

return 0;
}

