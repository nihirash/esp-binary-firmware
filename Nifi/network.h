#ifndef NETWORK_H
#define NETWORK_H

#include "connection_manager.h"
#include "configuration.h"

extern WiFiClient pool[MAX_SOCKETS];

void resolve_request(char *domain);

// TCP
void tcp_status(char n);
void tcp_send(char n, unsigned int bs);
void tcp_recv(char n, unsigned int bs);

// UDP
void udp_status(char n);
void udp_send(char n);
void udp_recv(char n, unsigned int bs);
#endif
