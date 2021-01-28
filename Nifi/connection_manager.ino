#include "connection_manager.h"
#include "ESP8266WiFi.h"
#include "configuration.h"
#include "udp_wrapper.h"

WiFiClient pool[MAX_SOCKETS];
UdpWrapper udp_pool[MAX_UDP_SOCKETS];

// TCP
unsigned char get_total_sockets() {
  return MAX_SOCKETS;
}

unsigned char get_free_sockets() {
  int counter = 0;
  for (int i=0;i<MAX_SOCKETS;i++)
   if (pool[i].connected() || pool[i].available() > 0)
    counter++;
    
  return MAX_SOCKETS - counter;
}

void open_tcp(char *addr, unsigned int port) {
  if (get_free_sockets() == 0) {
    publish_byte(ERR_NO_FREE_CONN);
    
    return;
  }
  
  char i;
  
  for (i=0;i<MAX_SOCKETS;++i) {
    if (!pool[i].connected()) break;
  }

  char ipaddr[255];
  sprintf(ipaddr, "%u.%u.%u.%u", addr[0], addr[1], addr[2], addr[3]);

  if (pool[i].connect(ipaddr, port)) {
    pool[i].setNoDelay(IS_NO_DELAY);
    pool[i].setSync(IS_SYNC);
    
    publish_byte(ERR_OK);
    publish_byte(i + 1);

    return;
  }

  publish_byte(ERR_CONN_STATE);
}

void close_tcp_all() {
      for (int i = 0;i < MAX_SOCKETS; i++)
      if (pool[i].connected())  {
        pool[i].stop();
      }
}

void close_tcp(char n) {
  if (n == 0) {
    close_tcp_all();
    publish_byte(ERR_OK);

    return;
  }
  
  n--;

  if (pool[n].connected()) {
    pool[n].stop();

    publish_byte(ERR_OK);
    
    return;
  }

  publish_byte(ERR_CONN_STATE);
}

// UDP

unsigned char get_total_udp_sockets() {
  return MAX_UDP_SOCKETS;
}

unsigned char get_free_udp_sockets() {
  int counter = 0;
  for (int i=0;i<MAX_UDP_SOCKETS;i++)
    if (udp_pool[i].is_opened || udp_pool[i].udp.available() > 0)
      counter++;

  return MAX_UDP_SOCKETS - counter;
}

void open_udp(unsigned int port)
{
    if (get_free_udp_sockets() == 0) {
        publish_byte(ERR_NO_FREE_CONN);
    
        return;
    }
    
    // Unspecified port - random it
    if (port == 0xffff || port == 0) 
      port = random(16384, 32767);   
    
    char i;
    for (i=0;i<MAX_UDP_SOCKETS;i++)
      if (!udp_pool[i].is_opened) break;

    if (udp_pool[i].udp.begin(port)) {
      udp_pool[i].is_opened = true;
      udp_pool[i].port = port;
      udp_pool[i].is_parsed = false;
      
      publish_byte(ERR_OK);
      publish_byte(i + 1);

      return;
    }

    publish_byte(ERR_CONN_EXISTS);
}

void close_udp(char n) {
  n--;
  if (udp_pool[n].is_opened) {
    udp_pool[n].udp.stop();
    udp_pool[n].is_opened = false;
    publish_byte(ERR_OK);

    return;
  }

  publish_byte(ERR_CONN_STATE);
}

void close_udp_all() {
  for (int i=0;i<MAX_UDP_SOCKETS;i++) {
      udp_pool[i].udp.stop();
      udp_pool[i].is_opened = false;
    }
}
