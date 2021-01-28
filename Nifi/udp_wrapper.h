#ifndef UDP_WRAPPER_H
#define UDP_WRAPPER_H
#include "WiFiUdp.h"
#include "ESP8266WiFi.h"

class UdpWrapper {
  public:
    // Fields
    bool is_opened;
    bool is_parsed;
    unsigned int port;
    WiFiUDP udp;
    // Constructor
    UdpWrapper() {
      is_opened = false;
      is_parsed = false;
      udp = WiFiUDP();
    }

};

#endif
