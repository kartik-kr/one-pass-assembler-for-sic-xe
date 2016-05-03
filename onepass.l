%{
   #include<stdio.h>
    #include<string.h>
    #include<stdlib.h>
    #include<math.h>
    #include"data_structures.h"
    #include"data.h"
    int quotient,contFlag,endFlag,opValue,i,opInfo,temp,startTRecord,colCount=0,t1,t2,temp1,x=0,cou,p,z,reswFlag=0,resbFlag=0;
    int BYTEFLAG=0,lctrFlag=1;
    char arr[15];
    char rsub[5]; 
    char resw[5];
    char dum[7];
    char dum1[9];
    FILE *output;
%}

%%
"START" {   

	strcpy(rsub,"RSUB");
        strcpy(resw,"RESW");				
	for(i=0;i<6;i++){
		dum[i]='0';
       }
		dum[i]='\0';
            fprintf(yyout,"H^%s",Name);
            fprintf(yyout,"%06X^",(unsigned int)startAddr);
            fprintf(yyout,"%06X^\n",(unsigned int)progSize);
		fprintf(output,"0000\t\t");
		fprintf(output,"%s\t\t",Name);
		fprintf(output,"%s\t\t",yytext);  //c
		fprintf(output,"%06X\t\t",(unsigned int)startAddr);//c
		fprintf(output,"\n");//c
            LOCCTR = startAddr;
            colCount=0;
        }
"END"   {          
			fprintf(yyout,"\nE^%06X^",(unsigned int)startAddr);
                                    endFlag = 1;
			fprintf(output,"%04X\t\t",(unsigned int)LOCCTR);
			fprintf(output,"%s\t\t",yytext); //c                         
        }
[0-9]+ {
			if(reswFlag==1){
				fprintf(output,"%04X\t\t",(unsigned int)LOCCTR);
				fprintf(output,"RESW\t\t");
				fprintf(output,"%s\t\t\n",yytext);
				LOCCTR+=3*(atoi(yytext));
				reswFlag=0;
			}
			if(resbFlag==1){
                                fprintf(output,"%04X\t\t",(unsigned int)LOCCTR);
                                fprintf(output,"RESB\t\t");
                                fprintf(output,"%s\t\t\n",yytext);
                                LOCCTR+=atoi(yytext);
                                resbFlag=0;
                        }


	}


"X""'"[a-zA-Z0-9]+"'"|"C""'"[a-zA-Z0-9]+"'"	{    if(BYTEFLAG==1){
						fprintf(output,"%04X\t\t",(unsigned int)LOCCTR);
						fprintf(output,"BYTE\t\t");
						fprintf(output,"%s\t\t\n",yytext);
                                                LOCCTR += (yyleng-3);
                                                BYTEFLAG=0;
                                            }                                             
                                                
                                             //fprintf(output,"%s\t\t",yytext);
									}
[a-zA-Z0-9\#\,\+]+   { 
			
			if((x=(strcmp(yytext,"BYTE"))==0)||(x=(strcmp(yytext,"RESW"))==0)||(x=(strcmp(yytext,"RESB"))==0)||(x=(strcmp(yytext,"RSUB"))==0))
                            {  } 
			else{ 	if(lctrFlag==1 && endFlag!=1)
					fprintf(output,"%04X\t\t",(unsigned int)LOCCTR);
				lctrFlag=!lctrFlag;
				fprintf(output,"%s\t\t",yytext);
				} //c
                    if(endFlag==1){
                             for(i=0;i<siz;i++){
                                        if(strcmp(yytext,tab[i].label)==0){
                                                temp = tab[i].val;
                                                break;
                                            }
                                        }
			 
                      //      fprintf(yyout,"\nE^%06X^",temp);
		//	fprintf(output,"%s\n",yytext);

		        
                            endFlag=0;
                    
                    }
		else if(x=(strcmp(yytext,"RSUB"))==0){
			fprintf(output,"%04X\t\t",(unsigned int)LOCCTR);
			fprintf(output,"RSUB\t\t");
			fprintf(output,"\t\t4F0000\n");
			if(colCount+6>=59){
                        colCount = 0;
                        startTRecord = LOCCTR;

                    }
                    if(colCount==0)
                            fprintf(yyout,"\nT^%06X^",(unsigned int)startTRecord);

			fprintf(yyout,"4F0000^");
			LOCCTR+=3;
			colCount += 6;
		}
	

		else if(x=(strcmp(yytext,"RESW"))==0){

			reswFlag=1;
			
			}
		else if(x=(strcmp(yytext,"RESB"))==0){

                        resbFlag=1;


                        }
		else if(x=(strcmp(yytext,"BYTE"))==0){

                        BYTEFLAG=1;

                        }



                else if((opValue=sOpTab(yytext))!=-1 && (opInfo = searchOpTab(yytext))>0){
                    
                    contFlag = 1;
                    t1 = opValue;
                    
                    t2 = opInfo;
			// fprintf(output,"%04X\t\t",LOCCTR);
                    LOCCTR += opInfo;
			 //c
			//fprintf(output,"%s\t\t",yytext); //c
                    if(colCount+(2*t2)>=59){
                        colCount = 0;
                        startTRecord = LOCCTR;
                            
                    }
                    if(colCount==0)
                            fprintf(yyout,"\nT^%06X^",startTRecord);
			//fprintf(output,"%06X\n",startTRecord); //c
                }
                else{
                    if(yytext[0] == '#'){
                        temp = t1;
                        contFlag=0;

              for(i=0;i<6;i++){      //c begin
                        dum[i]='0';
               }
                       dum[i]='\0';   // c end
 
                        i=5;         //change begin
     


			 quotient = atoi(++yytext);   //part1

  		  while(quotient!=0){
        		 temp1 = quotient % 16;

     			 //To convert integer into character
    			  if( temp1 < 10)
          		 temp1 =temp1 + 48;
    			  else
       			  temp1 = temp1 + 55;

    			  dum[i--]= temp1;
     		 quotient = quotient / 16;
 		 }		 




                  quotient = temp|0x01;  //part2
			i=1;

                  while(quotient!=0){
                         temp1 = quotient % 16;

                         //To convert integer into character
                          if( temp1 < 10)
                         temp1 =temp1 + 48;
                          else
                          temp1 = temp1 + 55;

                          dum[i--]= temp1;
                 quotient = quotient / 16;
                 }
			fprintf(yyout,"%s^",dum); //change end 


                       // fprintf(yyout,"%-3X%03X^",temp|0x01,atoi(++yytext));
                        colCount +=6;
			fprintf(output,"%s\n",dum); //c
                                         }
                  else if(t2==1){
                        
                        temp = t1;
                        contFlag=0;
                        fprintf(yyout,"%-2X^",temp);
			fprintf(output,"%-2X\n",temp); //c

                        colCount += 2;
                    }
                   else if(t2 == 2 && yyleng==3){
                        temp = t1;
                        contFlag=0;
                        colCount += 4;
                        fprintf(yyout,"%-2X%X%X^",temp,searchRegTab(yytext[0]),searchRegTab(yytext[2]));
		 	fprintf(output,"%-2X%X%X\n",temp,searchRegTab(yytext[0]),searchRegTab(yytext[2])); //c
                    }
                   else if(t2==2 && yyleng==1){
                        temp = t1;
                        contFlag=0;
                        colCount += 4;
                        fprintf(yyout,"%-2X%02X^",temp,searchRegTab(yytext[0]));
			 fprintf(output,"%-2X%02X\n",temp,searchRegTab(yytext[0])); //c

                   }
                   else if(t2==3){
                    for(i=0;i<6;i++){    //change begin
			dum[i]='0';
			}
			dum[2]='2';
			dum[i]='\0'; 

                for(i=0;i<siz;i++){             // moved above
                            if((strcmp(yytext,tab[i].label))==0 && contFlag==1){
                             temp = t1;
                              contFlag=0;
                             break;
                            }
                        }


                     quotient =(tab[i].val-LOCCTR);
            i=5;         //change begin          	 

		if(quotient<0)//code for converting -ve decimal to hex
		{
			 cou=0;
			 p=abs(quotient);
			while(p!=0 || cou<3){

                         temp1 = p % 16;
	   		if(cou==0)
				temp1=16-temp1;
			else
				temp1=15-temp1;
		
                         //To convert integer into character
                          if( temp1 < 10)
			{	
                        	 temp1 =temp1 + 48;
			}
                          else
	
                          {    
					temp1 = temp1 + 55;
			}
                          dum[i--]= temp1;
                         p = p / 16;
			cou++;
                 }
	
	}


		else
		{
			while(quotient!=0){
                         temp1 = quotient % 16;

                         //To convert integer into character
                          if( temp1 < 10)
                         temp1 =temp1 + 48;
                          else
                          temp1 = temp1 + 55;

                          dum[i--]= temp1;
                 quotient = quotient / 16;
                 }
		}
		


                  quotient = temp|0x03;  //part2
                        i=1;

                  while(quotient!=0){
                         temp1 = quotient % 16;

                         //To convert integer into character
                          if( temp1 < 10)
                         temp1 =temp1 + 48;
                          else
                          temp1 = temp1 + 55;

                          dum[i--]= temp1;
                 quotient = quotient / 16;
                 }
                        fprintf(yyout,"%s^",dum); //change end 		
			










                   /* for(i=0;i<10;i++){     //moved above
                            if((strcmp(yytext,tab[i].label))==0 && contFlag==1){
                             temp = t1;
                              contFlag=0;
                             break;
                            }
                        } */
                       // fprintf(yyout,"%-3X%03X^",temp|0x03,abs(tab[i].val-LOCCTR));
			
		fprintf(output,"%s\n",dum); 

                        colCount += 6;
                    }
                   else if(t2==4){

			for(i=0;i<8;i++){
				dum1[i]='0';
				}
			dum1[i]='\0';
			dum1[2]='1';

			
                         for(i=0;i<siz;i++){
                            if((strcmp(yytext,tab[i].label))==0 && contFlag==1){
                             temp = t1;
                              contFlag=0;
                             break;
                            }
                        }



		        //change begin



                         quotient = tab[i].val;  //part1
			i=7;
                  while(quotient!=0){
                         temp1 = quotient % 16;

                         //To convert integer into character
                          if( temp1 < 10)
                         temp1 =temp1 + 48;
                          else
                          temp1 = temp1 + 55;

                          dum1[i--]= temp1;
                 quotient = quotient / 16;
                 }




                  quotient = temp|0x03;  //part2
                        i=1;

                  while(quotient!=0){
                         temp1 = quotient % 16;

                         //To convert integer into character
                          if( temp1 < 10)
                         temp1 =temp1 + 48;
                          else
                          temp1 = temp1 + 55;

                          dum1[i--]= temp1;
                 quotient = quotient / 16;
                 }



			fprintf(yyout,"%s^",dum1);
			
                        
                       // fprintf(yyout,"%-3X%05X^",temp|0x03,tab[i].val);
			 fprintf(output,"%s\n",dum1);  //c

                        colCount += 8;
                    }
                    
                    
               
             }}
             
\n  {contFlag=0;}
[ ]+    ;   
%%

main(){

output = fopen("output.txt","w"); //c
yyout = fopen("objcode.txt","w");
yyin = fopen("o1.txt","r");
yylex();
printf("\n\t------------------------------------------\n");
printf("\tObject Code Generated in \"objcode.txt\" \n");
printf("\t------------------------------------------\n");

printf("\t------------------------------------------\n");
printf("\tOutput listing in \"output.txt \"\n");
printf("\t------------------------------------------\n");

}

int yywrap(){return 1;}

