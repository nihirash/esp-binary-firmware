#ifndef NETMAN_H
#define NETMAN_H

void set_conf_byte(char b);
void get_conf_byte();

void netman_init();
void get_ap_list();
void get_current_ap();
void set_ap(char *ssid, char *pass);
void get_ips(char t);
void get_netstatus();

#endif
