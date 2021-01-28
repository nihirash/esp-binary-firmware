#ifndef PROTOCOL_H
#define PROTOCOL_H

enum ErrorCodes {
    ERR_OK,          
    ERR_NOT_IMP,    
    ERR_NO_NETWORK,   
    ERR_NO_DATA,    
    ERR_INV_PARAM,    
    ERR_QUERY_EXISTS, 
    ERR_INV_IP,       
    ERR_NO_DNS,       
    ERR_DNS,        
    ERR_NO_FREE_CONN, 
    ERR_CONN_EXISTS,  
    ERR_NO_CONN,    
    ERR_CONN_STATE,   
    ERR_BUFFER,       
    ERR_LARGE_DGRAM,  
    ERR_INV_OPER,
    ERR_AUTH_FAILED
};

enum CapabilitiesSet {
   CAP_SEND_ICMP                 = 1,
   CAP_RESOLVE_VIA_HOSTS         = 2,
   CAP_RESOLVE_VIA_DNS           = 4,
   CAP_TCP_ACTIVE                = 8,
   CAP_TCP_PASSIVE_REMOTE_SOCKET = 16,
   CAP_TCP_PASSIVE               = 32,
   CAP_TCP_URGENT                = 64,
   CAP_TCP_PUSH_BIT              = 128,
   CAP_TCP_SEND_BEFORE_ESTABLISH = 256,
   CAP_DISCARD_DATA_TCP          = 512,
   CAP_OPEN_UPD                  = 1024,
   CAP_OPEN_RAW_IP               = 2048,
   CAP_SET_TTL_TOS               = 4096,
   CAP_SET_AUTOREPLY_PING        = 8192,
   CAP_DHCP                      = 16384,
   CAP_GET_TTL_TOS_FOR_SENDING   = 32768 
};

enum IpAddresses {
    IP_LOCAL = 1,
    IP_REMOTE = 2,
    IP_MASK = 3,
    IP_GATEWAY = 4,
    IP_DNS1 = 5,
    IP_DNS2 = 6
};

enum FeatureBlocks {
  BLOCK_CAP_FLAGS  = 1,
  BLOCK_POOL_SIZE  = 2,
  BLOCK_MAX_FRAME  = 3
};


enum NetworkState {
  NETWORK_CLOSED  = 0,
  NETWORK_OPENING = 1,
  NETWORK_OPEN    = 2,
  NETWORK_CLOSING = 3,
  NETWORK_UNKNOWN = 255
};

enum TCPState {
  TCP_STATE_UNKNOWN = 0,
  TCP_STATE_LISTEN = 1,
  TCP_STATE_ESTABLISHED = 4
};

enum ProtocolOperations {
  OP_Reset        = 0x00,
  OP_GET_FEATURES = 0x01,
  OP_GET_IP       = 0x02,
  OP_GET_NETSTATE = 0x03,
  OP_RESOLVE_DNS  = 0x06,
  OP_OPEN_UDP     = 0x08,
  OP_CLOSE_UDP    = 0x09,
  OP_STATUS_UDP   = 0x0A,
  OP_SEND_DATAGR  = 0x0B,
  OP_RECV_DATAGR  = 0x0C,
  OP_OPEN_TCP     = 0x0D,
  OP_CLOSE_TCP    = 0x0E,
  OP_STATUS_TCP   = 0x10,
  OP_SEND_TCP     = 0x11,
  OP_RECV_TCP     = 0x12,
  OP_CONF_AUTO_IP = 0x19,
  OP_CONF_IP      = 0x1A,
  OP_GET_AP_LIST  = 0x30,
  OP_SET_AP       = 0x31,
  OP_GET_AP       = 0x32,
  OP_VERSION_STR  = 0xff
};

void process_operation();
#endif
