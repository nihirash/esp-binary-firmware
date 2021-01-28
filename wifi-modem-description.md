# Wifi modem protocol description

Protocol should have version and feature control, modular design and should be applied for different retro-computers as hardware TCP stack.

Currently main transport is UART. UART selected cause there is already existing solutions for ESP+Uart.

Resulting firmware should be used as dropin replacement for AT-commands firmware.

Exchange should be based on binary protocol to minimize parsing process and make it quicker.

## Exchange description 

All exchange should be implemented in `request->response` paradigm. 

Data flow is pull-based(if we talking about modem side) to prevent losing data. 

### Request description

Basic request can be present in next view:
 
 * One byte: command

 * Optional parameters:
  
   + All strings are zero terminated

   + IP addresses present as 4 bytes(lexical ordered B0.B1.B2.B3, currently IPv4 only)

   + Ports present as 2 bytes

   + All multibyte data are big-endian

Commands without parameters contains only one byte. 

### Response description

Basic response can be present in next view:

 * One byte: error code(zero for success)

 * Optional result artifacts(basic rules are the same as for request)

### Error codes

Based on UNAPI TCP/IP.


| Code    | Description                          |
|---------|--------------------------------------|
| 0       | Operation completed succefully       |
| 1       | Not implemented                      |
| 2       | No network connection available      |
| 3       | No incoming data available           |
| 4       | Invalid input parameter              |
| 5       | Another query is already in progress |
| 6       | Invalid IP address                   |
| 7       | No DNS servers are configured        |
| 8       | Error returned by DNS server         |
| 9       | No free connections available        |
| 10      | Connection already exists            |
| 11      | Connection does not exists           |
| 12      | Invalid connection state             |
| 13      | Insufficient output buffer space     |
| 14      | Datagram is too large                |
| 15      | Invalid operation                    |
| 16      | Auth failed                          |

## Commands description

### 0x00 - Reset

Return modem to initial state(close all connections wait for new commands).

Driver should begin work with this command. If there isn't right response - retry this operation.

Always should be succefull.

Return:

 * Success status code
 * "NiFi" magic zero-terminated string

### 0x01 - Get information about the TCP/IP capabilities and features

Parameters:

 * Index of information block to retrieve:
 
   + 1: Capabilities flags
   + 2: Connection pool size and status
   + 3: Maximum datagram size allowed
  
Response:

 * Wrong block: `Invalid input parameter` error(code 4)

 * 1 - Capabilities(success error code and 2 bytes response):
   
   + Bit 0: Send ICMP echo messages (PINGs) and retrieve the answers
   + Bit 1: Resolve host names by querying a local hosts file or database
   + Bit 2: Resolve host names by querying a DNS server
   + Bit 3: Open TCP connections in active mode
   + Bit 4: Open TCP connections in passive mode, with specified remote socket
   + Bit 5: Open TCP connections in passive mode, with unsepecified remote socket
   + Bit 6: Send and receive TCP urgent data
   + Bit 7: Explicitly set the PUSH * Bit when sending TCP data
   + Bit 8: Send data to a TCP connection before the ESTABLISHED state is reached
   + Bit 9: Discard data in the output buffer of a TCP connection
   + Bit 10: Open UDP connections
   + Bit 11: Open raw IP connections
   + Bit 12: Explicitly set the TTL and ToS for outgoing datagrams
   + Bit 13: Explicitly set the automatic reply to PINGs on or off
   + Bit 14: Automatically obtain the IP addresses, by using DHCP or an equivalent protocol (deprecated)
   + Bit 15: Get the TTL and ToS for outgoing datagrams
    
 * 2: Connection pool size and status

   + Success status code
   + One byte: Maximum TCP simultaneous connections supported
   + One byte: Maximum UDP simultaneous connections supported
   + One byte: Free connections currently available(TCP)
   + One byte: Same for UDP

 * 3: Maximum datagram size allowed

   + Success status code
   + Two bytes: Maximum incoming datagram size supported
   + Two bytes: Maximum outgoing datagram size supported

### 0x02 - Get IP address

Parameters:
 
 * Index of address to obtain

   + 1: Local IP address
   + 2: Peer IP address
   + 3: Subnet mask
   + 4: Default gateway
   + 5: Primary DNS server IP address
   + 6: Secondary DNS server IP address

Response:
  
  * Wrong address index - code 4(inv. parameter)

  * If not configured - success and four zeros

  * Other conditions: success and 4 bytes in lexical order(B0.B1.B2.B3) 

### 0x03 - Get network state

No input parametes.

Response:

 * Always success
 
 * One byte status:

  + 0: Closed

  + 1: Opening

  + 2: Open

  + 3: Closing

  + 255: Unknown

### 0x6 - Resolve host name

Parameters:

 * Zero-terminated domain name

Result:

 * Error code

 * If no error lexical order 4 bytes for IP.

### 0x8 - Open a UDP connection

Parameters:

 * Two bytes - port

Response:

 * Error code

 * If no error - connection number

### 0x9 - Close a UDP connection

Parameters:

 * One byte - connection number

Response:

 * Error code

### 0x0A - Get status for UDP connection

Parameters:

 * One byte - connection number

Response:

 * Error code

 * If no error:

  + Two bytes - local port

  + Two bytes - size of incoming data

### 0x0B - Send datagram 

Parameters:

 * One byte - connection number

 * Dest. ip address(4 bytes. lexical order)

 * Dest. port(2 bytes)

 * Data len(2 bytes)

 * Data block

Response:

 * Error code

### 0x0C - Receive datagram

Parameters:

 * One byte - connection number

 * Maximum size to receive

Response:

 * Error code. Next fields only if no error

 * Source IP(4 bytes lexical order)

 * Source port(2 bytes)

 * Data size(actual)

 * Data block

### 0x0D - Open a TCP connection

Parameters:

 * Remote IP address(4 bytes lexical order)

 * Remote port(2 bytes)

Response:

 * Error code

 * IF NO ERROR HAPPENS: connection number

### 0x0E - Close a TCP connection

Parameters:

 * Connection number(if zero - close all connections)

Response:

 * Error code

### 0x10 - Get the state of a TCP connection

Parameters:

 * Connection number

Result:

 * Error code

 * Connection state:

   + 0: Unknown

   + 1: LISTEN

   + 2: SYN-SENT

   + 3: SYN-RECEIVED

   + 4: ESTABLISHED

   + 5: FIN-WAIT-1

   + 6: FIN-WAIT-2

   + 7: CLOSE-WAIT

   + 8: CLOSING

   + 9: LAST-ACK

   + 10: TIME-WAIT

 * Two bytes - total available bytes

### 0x11 - Send data a TCP connection

Parameters:

 * Connection number

 * Data length

 * Data block

Response:

 * Error code

### 0x12 - Receive data from a TCP connection

Parameters:
  
  * Connection number

  * Length of the data to be obtained

Response:

  * Error code. If error happens only error code will be sent.

  * 2 bytes data length

  * Data block


### 0x19 - Enable or disable the automatic IP addresses retrieval

Parameters:

 * Byte - get(0) or set(1) configuration

 * If set(1) - byte, where 
 
    + bit 0 - Set to automatically retrieve local IP address, subnet mask and default gateway
    
    + bit 1 - Set to automatically retrieve DNS servers addresses

Response:

 * Error code

 * If no error - configuration byte

### 0x1A - Manually configure an IP address

Parameters:

 *  Index of address to set:

  + 1: Local IP address

  + 2: Peer IP address

  + 3: Subnet mask

  + 4: Default gateway

  + 5: Primary DNS server IP address

  + 6: Secondary DNS server IP address

Response:

 * Error code

### 0x30 - Get WiFi AP list

No parameters

Response:

 * Error code

 * List of Zero-terminated strings(ends with zero) - AP names

### 0x31 - Connect to AP

Parameters:

 * Zero-terminated string - access point name

 * Zero-terminated string - password(if absent send empty string)

Response:

 * Error code

### 0x32 - Get Current AP

No parameters.

Response:

 * Error code
 
 * If no error - zero-terminated string
 
### 0xFF - Get build information

No parameters.

Response:

 * Error code(always success)
 
 * Zero-terminated string containing version and build time