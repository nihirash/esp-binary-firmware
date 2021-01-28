#include "protocol.h"
#include "exchange.h"
#include "connection_manager.h"
#include "netman.h"
#include "network.h"

#define current_caps (CAP_RESOLVE_VIA_DNS | CAP_TCP_ACTIVE | CAP_DHCP)

void get_features() {
  switch(get_byte()) {
    case BLOCK_CAP_FLAGS:
      publish_byte(ERR_OK);
      publish_word(current_caps);
      break;
     case BLOCK_POOL_SIZE:
      publish_byte(ERR_OK);
      publish_byte(get_total_sockets());
      publish_byte(get_total_udp_sockets()); 
      publish_byte(get_free_sockets());
      publish_byte(get_free_udp_sockets()); 
      break;
     case BLOCK_MAX_FRAME:
      publish_byte(ERR_OK);
      publish_word(MAX_FRAME);
      publish_word(MAX_FRAME);  
      break;
    default:
      publish_byte(ERR_INV_PARAM);
  }
}

void process_operation() {
  switch(get_byte()) {
    
    case OP_Reset:
      perform_reset();
      break;
    // INFO
    case OP_GET_FEATURES:
      get_features();
      break;
      
    case OP_GET_IP:
      get_ips(get_byte());
      break;
    
    case OP_GET_NETSTATE:
      get_netstatus();
      break;
    // GENERAL
    case OP_RESOLVE_DNS:
      resolve_request(get_string());
      break;
    // UDP  
    case OP_OPEN_UDP:
      open_udp(get_word());
      break;

    case OP_CLOSE_UDP:
      close_udp(get_byte());
      break;

    case OP_STATUS_UDP:
      udp_status(get_byte());
      break;

    case OP_SEND_DATAGR:
      upd_send(get_byte());
      break;

    case OP_RECV_DATAGR:
      udp_recv(get_byte(), get_word());
      break;
      
    // TCP
    case OP_OPEN_TCP:
      char ip[4];
      for (char i=0;i<4;++i) ip[i] = get_byte();
      
      open_tcp(
        ip,
        get_word()
        );
      break;

    case OP_CLOSE_TCP:
      close_tcp(get_byte());
      break;

    case OP_STATUS_TCP:
      tcp_status(get_byte());
      break;

    case OP_SEND_TCP:
      tcp_send(get_byte(), get_word());
      break;

    case OP_RECV_TCP:
      tcp_recv(get_byte(), get_word());
      break;
    // WIFI
    case OP_GET_AP_LIST:
      get_ap_list();
      break;
      
    case OP_SET_AP:
      char ssid[255];
      char passwd[255];
      strcpy(ssid, get_string());
      strcpy(passwd, get_string());
      set_ap(ssid, passwd);
      break;
      
    case OP_GET_AP:
      get_current_ap();
      break;
    // MODEM
    case OP_VERSION_STR:
      publish_byte(ERR_OK);
      publish_string(version_str);
      break;

    default:
      publish_byte(ERR_NOT_IMP);
  }
}
