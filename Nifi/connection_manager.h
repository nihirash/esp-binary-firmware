#ifndef CONNECTION_MANAGER_H
#define CONNECTION_MANAGER_H
#include "protocol.h"

// TCP
unsigned char get_total_sockets();
unsigned char get_free_sockets();

void open_tcp(char *addr, unsigned int port); 
void close_tcp(char n);
void close_tcp_all();

// UDP
unsigned char get_total_udp_sockets();
unsigned char get_free_udp_sockets();

void open_udp(unsigned int port);
void close_udp(char n);
void close_udp_all();

#endif
