    DEVICE ZXSPECTRUM48
    org #8000
; This sample downloads from gopher server screen snapshot directly to screen
; REQUIRES BE CONNECTED TO AP
start:
    call Nifi.init ; Flushing uart, closing all connections

    ld hl, host : call Nifi.resolveDns : jr nz, error ; domain name to ip-address
    ; L.H.E.D - ip addr. It still in registers no need to store/restore it.
    ld bc, 70 : call Nifi.openTcp  : jp nz, error ; BC - port. gopher is 70.

    ld  (socket), a, hl, request, bc, request_size : call Nifi.writeTcp : jp nz, error ; Sending request to server as one packet

.loop
    ld a, (socket) : call Nifi.statusTcp
    cp Nifi.CONN_STATE_ESTABLISHED  : jr nz, .exit ; When connection will be closed - all data is received

    ld a, b : or c : jr z, .loop ; BC - avail. data. If nothing here - wait for data

    ld hl, (pointer), a, (socket) ; In BC already exists count of avail. data. If we need less data - just specify it in BC
    call Nifi.readTcp 
    ld hl, (pointer) : add hl, bc : ld (pointer), hl ; Moving our pointer upper for loading next bytes
    jp .loop ; Until de... until connect won't be closed
.exit
    ; Connection already closed - we haven't need do something special
    ret
error:
    ld hl, err : call printZ
    jr $

pointer dw #4000

ipaddr ds 4
socket db 0

request db "/me.scr",13,10
request_size = $ - request
host db "nihirash.net", 0
err db "ERROR HAPPENS", 0
putC:
    rst #10
    ret

printZ:
    ld a, (hl) : and a :ret z
    push hl
    call putC
    pop hl
    inc hl
    jr printZ

    include "uno-uart.asm"
    include "nifi.asm"

    savetap "test.tap", start