//---- Clib.c ----
#include "Clib.h"
#include <stdio.h>
#include <string.h>
 void func1(char* str){
     int count = (int)strlen(str);
     for(int i=0; i<count; i++){
         if('a' <= str[i] && str[i] <= 'z'){
             str[i] = str[i] - ('a' - 'A');
         }
     }
}