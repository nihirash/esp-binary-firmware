#include "netman.h"
#include "exchange.h"
#include "protocol.h"
#include "network.h"
#include "ESP8266WiFi.h"
#include "connection_manager.h"
#include "utils.h"
#include "configuration.h"

unsigned char frame[MAX_FRAME];

void resolve_request(char *domain) {
  IPAddress addr;

  int err = WiFi.hostByName(domain, addr, 10000);

  if (addr[0] == 0 && 
      addr[1] == 0 && 
      addr[2] == 0 && 
      addr[3] == 0) {
    publish_byte(ERR_DNS);

    return;
  }

  publish_byte(ERR_OK);
  publish_byte(addr[0]);
  publish_byte(addr[1]);
  publish_byte(addr[2]);
  publish_byte(addr[3]);
}

// TCP
void tcp_status(char n) 
{
  n--;
  if (pool[n].connected() || pool[n].available()) {
    publish_byte(ERR_OK);
    publish_byte(TCP_STATE_ESTABLISHED);
    publish_word(pool[n].available());

    return;
  } 

    publish_byte(ERR_OK);
    publish_byte(TCP_STATE_UNKNOWN);
    publish_word(0);
}

void tcp_send(char n, unsigned int bs) {
  
  n--;
  if (!pool[n].connected()) {
    publish_byte(ERR_NO_CONN);

    return;
  }

  publish_byte(ERR_OK);
  while(bs > 0) {
    int to_load = min(bs, MAX_FRAME);
    
    get_block(to_load, frame);
    pool[n].write(frame, to_load);
    bs-=to_load;
  }
}

void tcp_recv(char n, unsigned int bs) {
  n--;
  if (!pool[n].connected() && pool[n].available() == 0) {
    publish_byte(ERR_NO_CONN);
    
    return;
  }

  publish_byte(ERR_OK);
  
  unsigned int to_send = min(min(bs, pool[n].available()), MAX_FRAME);
  unsigned int actually = pool[n].read(frame, to_send);
  publish_word(actually);
  publish_block(frame, actually);
}

// UDP
void udp_status(char n) {
  n--;
  if (!udp_pool[n].is_opened) {
    publish_byte(ERR_NO_CONN);
    
    return;
  }
  
  if (!udp_pool[n].is_parsed) {
    udp_pool[n].udp.parsePacket();
    udp_pool[n].is_parsed = true;
  
  }
  
  int avail = udp_pool[n].udp.available();
  if (avail == 0) udp_pool[n].is_parsed = false;
  
  publish_byte(ERR_OK);
  publish_word(udp_pool[n].port);
  publish_word(avail);
}

void upd_send(char n) {
  n--;

  char ipaddr[20];
  sprintf(ipaddr,"%u.%u.%u.%u", get_byte(), get_byte(), get_byte(), get_byte());
  unsigned int port = get_word();
  
  if (!udp_pool[n].is_opened) {
    publish_byte(ERR_NO_CONN);

    return;
  }

  unsigned int bs = get_word();
  if (bs > MAX_FRAME) {
    publish_byte(ERR_LARGE_DGRAM);
    
    return;
  }
  
  publish_byte(ERR_OK);
  get_block(bs, frame);
  udp_pool[n].udp.beginPacket(ipaddr, port);
  udp_pool[n].udp.write(frame, bs);
  udp_pool[n].udp.endPacket();
}

void udp_recv(char n, unsigned int bs) {
  n--;
  if (!udp_pool[n].is_opened) {
    publish_byte(ERR_NO_CONN);

    return;
  }
  if (!udp_pool[n].is_parsed)
    udp_pool[n].udp.parsePacket();
    
  // Next packets should be parsed
  udp_pool[n].is_parsed = false;
  
  unsigned int avail = udp_pool[n].udp.available();
  if (avail == 0) {
    publish_byte(ERR_NO_DATA);

    return;
  }

  IPAddress rIp = udp_pool[n].udp.remoteIP();
  unsigned int rPort = udp_pool[n].udp.remotePort();
  publish_byte(rIp[0]);
  publish_byte(rIp[1]);
  publish_byte(rIp[2]);
  publish_byte(rIp[3]);
  
  publish_word(rPort);
  
  unsigned int to_send = min(min(bs, avail), MAX_FRAME);
  unsigned int actually = udp_pool[n].udp.read(frame, to_send);
  publish_word(actually);
  publish_block(frame, actually);
}
