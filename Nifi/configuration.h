#ifndef CONFIGURATION_H
#define CONFIGURATION_H

#define MAGIC_STR "NiFi"
#define VERSION "0.1"

// UART
#define BAUDRATE 115200
//#define ENABLE_FLOW
#define CTS_PIN 5
#define RTS_PIN 4

# define DEFAULT_CTS_HIGH  LOW
# define DEFAULT_CTS_LOW  HIGH

# define DEFAULT_RTS_HIGH  LOW
# define DEFAULT_RTS_LOW  HIGH

// Exchange props
#define MAX_FRAME 512

// TCP
#define IS_NO_DELAY true
#define IS_SYNC true
#define MAX_SOCKETS 8

// UDP
#define MAX_UDP_SOCKETS 4
#endif
