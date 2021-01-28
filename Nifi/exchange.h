#ifndef EXCHANGE_H
#define EXCHANGE_H
#include "configuration.h"
char receive_buffer[MAX_FRAME];

void exchange_init();
unsigned char get_byte();
void publish_byte(char b);

unsigned int get_word() {
  char c1 = get_byte();
  return c1 | get_byte() << 8;
}

char* get_string() {
  for(int i=0;;i++) {
    receive_buffer[i]=get_byte();
    if (receive_buffer[i] == 0) return receive_buffer;  
  }
}

void get_block(unsigned int len, unsigned char *receive_buffer) {
  for (int i=0;i<len;i++)
    receive_buffer[i]=get_byte();
    
  return;
}


void publish_word(unsigned int w) {
   publish_byte(w & 255);
   publish_byte((w >> 8) & 255);  
}

void publish_string(const char *str) {
  for (int i=0;str[i]!=0;i++)
    publish_byte(str[i]);

  publish_byte(0);
}

void publish_block(unsigned char *block, unsigned int len) {
  for (int i=0;i<len;i++)
    publish_byte(block[i]);
}

#endif
