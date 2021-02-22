#include "netman.h"
#include "exchange.h"
#include "protocol.h"
#include "network.h"
#include "ESP8266WiFi.h"

static char confByte;

void set_conf_byte(char b)  {
  if (b & 0xfc) {
    publish_byte(ERR_INV_PARAM);
    
    return;
  }

  if (b==0) {
    WiFi.disconnect(true);
    delay(1000);
    WiFi.begin();
    WiFi.config(0U, 0U, 0U);
  }
  confByte = b;

  publish_byte(ERR_OK);
}

void get_conf_byte() {
  publish_byte(ERR_OK);
  
  publish_byte(confByte);  
}


void netman_init() {
  WiFi.mode(WIFI_STA);
}

void get_ap_list() {    
    int n = WiFi.scanNetworks();
    if (n == 0) {
      publish_byte(ERR_NO_NETWORK);
      
      return;
    }
    
    publish_byte(ERR_OK);
    for (int i = 0;i < n; ++i) {
      publish_string(WiFi.SSID(i).c_str());
    }

    publish_byte(0xff);
}

void get_current_ap() {
    if (WiFi.status() != WL_CONNECTED) {
      publish_byte(ERR_NO_NETWORK);
      
      return;
    }
    
    publish_byte(ERR_OK);
    publish_string(WiFi.SSID().c_str());
}

void set_ap(char *ssid, char *pass) {
    int counter = 0;
    WiFi.disconnect();
    
    for (int i=0;i<1000;i++) yield();
    
    WiFi.begin(ssid, pass);
    
    while(WiFi.status() != WL_CONNECTED && counter < 10) {
      yield();
      delay(1000);
      ++ counter;
    }
  
    if (WiFi.status() == WL_CONNECTED) 
      publish_byte(ERR_OK); 
    else 
      publish_byte(ERR_AUTH_FAILED);
}

void get_ips(char t) {
  if (t < 1 || t > 6) {
    publish_byte(ERR_INV_PARAM);
    
    return;
  }

  if (WiFi.status() != WL_CONNECTED) {
    publish_byte(ERR_NO_NETWORK);

    return;
  }
  
  publish_byte(ERR_OK);
  IPAddress ip;
  switch(t) {
    
    case IP_LOCAL:
       ip = WiFi.localIP();
       break;
       
    case IP_REMOTE:
    case IP_GATEWAY:
      ip = WiFi.gatewayIP();
      break;
      
    case IP_MASK:
      ip = WiFi.subnetMask();
      break;
      
    case IP_DNS1:
      ip = WiFi.dnsIP(0);
      break;
      
    case IP_DNS2:
      ip = WiFi.dnsIP(1);
      break; 
      
    default:
      ip = IPAddress(0);
  }

  publish_byte(ip[0]);
  publish_byte(ip[1]);
  publish_byte(ip[2]);
  publish_byte(ip[3]);
}

void get_netstatus() {
  publish_byte(ERR_OK);
  
  switch(WiFi.status()) {
    case WL_IDLE_STATUS:
      publish_byte(NETWORK_OPENING);
      return;
      
    case WL_CONNECTED:
      publish_byte(NETWORK_OPEN);
      return;

    case WL_CONNECT_FAILED:
    case WL_CONNECTION_LOST:
    case WL_NO_SSID_AVAIL:
    case WL_DISCONNECTED:
      publish_byte(NETWORK_CLOSED);
      return;  
      
    default:
      publish_byte(NETWORK_UNKNOWN);
  }
}
