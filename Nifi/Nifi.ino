#include "configuration.h"

const char version_str[] = MAGIC_STR " " VERSION " " __DATE__ " " __TIME__;

#include "exchange.h"
#include "protocol.h"
#include "connection_manager.h"

void perform_reset() {
  close_tcp_all();
  close_udp_all();
  publish_byte(ERR_OK);
  publish_string(MAGIC_STR);
}

void setup() {
  exchange_init();
  netman_init();
}

void loop() {
  process_operation();
}
