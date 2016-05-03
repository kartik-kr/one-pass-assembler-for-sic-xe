%{
	#include<stdio.h>
	#include<stdlib.h>
	extern int yylex();
	extern FILE *yyin;
	extern FILE *yyout;
	extern int yylineno;
	extern int lineNum;
	FILE *symfile;
	int flag=0,flag1=0;
	int start1=0;
	int end1=0;
%}

%token LABEL START NUM WS NL OP END SLB RW RB BE CL
%%	
STMT:  X      {printf("\n\nValid\n\n");}
S: START WS NUM {flag=1;start1++;}
 |
 ;
E: B  {if(flag!=1&&flag1==1){printf("ERROR\n");exit(0);}}
;
B: LABEL WS OP WS LABEL
 | LABEL WS OP WS NUM
 | OP WS LABEL
 | OP WS NUM
 | LABEL WS OP WS SLB
 | OP WS SLB
 | END WS LABEL   {if(flag!=1){printf("ERROR NO START\n"); exit(0);}flag1=1;end1++;}
 | END         {if(flag!=1){printf("ERROR NO START\n"); exit(0);}flag1=1;end1++;}
 | END WS SLB  {if(flag!=1){printf("ERROR NO START\n"); exit(0);}flag1=1;end1++;}
 | SLB WS OP WS SLB
 | SLB WS OP WS LABEL
 | SLB WS OP WS NUM
 | SLB WS OP
 | OP
 | SLB BE
 | RW
 | RB
 | BE
 | SLB RW
 | SLB RB
 | LABEL RB
 | LABEL RW
 | LABEL CL
 | CL
 | SLB CL
 |
; 
C: WS LABEL WS OP WS LABEL
 | WS LABEL WS OP WS NUM
 | WS OP WS LABEL
 | WS OP WS NUM
 | WS LABEL WS OP WS SLB
 | WS OP WS SLB
 | WS END WS LABEL {end1++;}
 | WS END  {end1++;}
 | WS END WS SLB  {end1++;}
 | WS RW
 | WS RB
 | WS BE
 | WS LABEL CL
 | WS CL
 | WS SLB CL
 | WS SLB RW
 | WS SLB RB
 | WS LABEL RB
 | WS LABEL RW
 | WS SLB WS OP WS SLB
 | WS SLB WS OP WS LABEL
 | WS SLB WS OP WS NUM
 | WS SLB WS OP
 | WS OP
 | WS SLB BE
 | 
 ;
X: S NL X
 | E NL X
 | C NL X
 | 
;
%%


int main(){
FILE *myfile = fopen("test.txt","r");
//FILE *outfile = fopen("output.txt","w");
FILE *outfile = fopen("o1.txt","w");
symfile = fopen("data.h","w");
yyin = myfile;
yyout = outfile;
yyparse();
}
int yyerror(){

//printf("****Syntax Error****\nLine no : %d\t\tColumn no: %d\n",yylineno,lineNum);
if(start1==0)
{printf("NO START IN PROGRAM\n");
exit(0);
}
else if(start1>1)
{
printf("MULTIPLE START IN PROGRAM\n");
exit(0);
}
else if(end1==0)
{
printf("NO END IN PROGRAM\n");
exit(0);
}
//else if(end1>1)
//printf("MULTIPLE END IN PROGRAM\n");
else
{printf("***********SYNTAX ERROR*************\n");
exit(0);
}
}
