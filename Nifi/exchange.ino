#include "exchange.h"
#include "configuration.h"
#include "ESP8266WiFi.h"

void exchange_init()
{
  Serial.begin(BAUDRATE);
  #ifdef ENABLE_FLOW
  PIN_FUNC_SELECT(PERIPHS_IO_MUX_MTCK_U, FUNC_UART0_CTS);
  U0C0 |= 0x08000;
  #endif

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
