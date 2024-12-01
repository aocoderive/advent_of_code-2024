
#include <stdio.h>
#include <string.h>

int dostuff(char* lineptr);


int readlines(char filename_to_read_from[]){

  FILE* fileptr;
  int answer;
  int row = 0;
  char line[256]; //each line of input
  char* ptr;      //pointer to the line
  
  fileptr = fopen(filename_to_read_from, "r");
  //handle error: can't open file
  if (fileptr == NULL) {
    printf("could not open file :(\n");
    return(-1);
  }

  //read in input lines
  while (ptr != NULL) { //keep going till EOF
    ptr = fgets(line, sizeof(line), fileptr);
    //  printf("%s\n", line);
    dostuff(ptr);
  }
  
  printf("%d\n", answer);
  return(answer);
  
}


int dostuff(char* lineptr) {
  int answer;
  //  char* reline = lineptr;
  //  printf("%s", reline);
  
  return(answer);
}


int main (int argc, char* argv[]){
  //run with executable then input.txt
  
  
  char* filename;
  filename = argv[1];
  
  readlines(filename);

  return(0);

}
