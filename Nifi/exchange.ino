#include "exchange.h"
#include "configuration.h"

void exchange_init()
{
  Serial.begin(BAUDRATE);
}

unsigned char get_byte()
{
  while(Serial.available() < 1) yield();

  return Serial.read();
}

void publish_byte(char b)
{
  while(Serial.availableForWrite() < 1) yield();
  
  Serial.write(b);
}
