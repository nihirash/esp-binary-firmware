#include "exchange.h"
#include "configuration.h"
#include "ESP8266WiFi.h"

void exchange_init()
{
  Serial.begin(BAUDRATE, SERIAL_8N1);
  #ifdef ENABLE_FLOW
  pinMode(RTS_PIN, OUTPUT);
  pinMode(CTS_PIN, INPUT);
  digitalWrite(RTS_PIN, DEFAULT_RTS_LOW);
  #endif

}

unsigned char get_byte()
{
  #ifdef ENABLE_FLOW
  digitalWrite(RTS_PIN, DEFAULT_RTS_HIGH);
  #endif
  
  while(Serial.available() < 1) yield();
  
  #ifdef ENABLE_FLOW
  digitalWrite(RTS_PIN, DEFAULT_RTS_LOW);
  #endif
  
  return Serial.read();
}

void publish_byte(char b)
{
  while(Serial.availableForWrite() < 1) yield();
  #ifdef ENABLE_FLOW
  while (digitalRead(CTS_PIN) == DEFAULT_CTS_LOW) yield();
  #endif
  Serial.write(b);
  Serial.flush();
}
