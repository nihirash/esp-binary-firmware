    module Nifi

IP_LOCAL = 1
IP_REMOTE = 2
IP_MASK = 3
IP_GATEWAY = 4
IP_DNS1 = 5
IP_DNS2 = 6

NETSTATE_CLOSED = 0
NETSTATE_OPENING = 1
NETSTATE_OPEN = 2
NETSTATE_CLOSING = 3
NETSTATE_UNKNOWN = 255

CONN_STATE_UNKNOWN = 0     ; Read like "closed"
CONN_STATE_ESTABLISHED = 4 ; Really we don't care about other statuses    

init:
    ld b, 100
    ei
.loop
    halt
    djnz .loop
    ret

getVer:
    ld de, .ver
    ex hl, de
    ld bc, .ver_len
    ldir
    ret
.ver db "NiFi simple emulator", 0
.ver_len = $ - .ver

resolveDNS:
getIp:
    xor a : and a
    ld l, 192
    ld h, 168
    ld e, 1
    ld d, 123
    ret

getNetState:
    ld a, NETSTATE_OPEN
    ret

getAp:
    ld hl, fake_ap
    ld bc, 32
    ldir
    xor a : and a
    ret

setAp:
    ld de, fake_ap
    ld bc, 32
    ldir
    xor a : and a
    ret


getApList:
    ld hl, fake_ap_list
    ld bc, fake_ap_list_len
    ldir
    xor a : and a 
    ret



fake_ap db "Some SSID", 0
        ds 32 - ($ - fake_ap)

;; Currently just junk for interface development
fake_ap_list 
        db "Some awesome network", 0
        db "Aeroporty", 0
        db "ssid3", 0
        db "ssid4", 0
        db "ssid5", 0
        db "ssid6", 0
        db "ssid7", 0
        db "ssid8", 0
        db "ssid9", 0
        db "ssid10", 0
        db "ssid11", 0
        db "ssid12", 0
        db "ssid13", 0
        db "ssid14", 0
        db "ssid15", 0
        db "ssid16", 0
        db "ssid17", 0
        db "ssid18", 0
        db "ssid19", 0
        db "ssid20", 0
        db "ssid21", 0
        db "ssid22", 0
        db "ssid23", 0
        db "ssid24", 0
        db #ff
fake_ap_list_len = $ - fake_ap_list
    endmodule