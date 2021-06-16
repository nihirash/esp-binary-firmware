    device	zxspectrum48
    SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION
    include "common/version.asm"
    org #8000
start:
    call prepareScreen
    call showNetList
    call selectNetwork
    jr $

selectNetwork:
    call drawCursor
.loop
    call Keyboard.getC
    cp Keyboard.KEY_DN : jr z, keyDn
    cp Keyboard.KEY_UP : jr z, keyUp
    jr .loop

keyUp:
    call hideCursor
    ld hl, position
    ld a, (hl) : and a : jr z, .scrollUp
    dec (hl)
    jr selectNetwork
.scrollUp
    ld a, (offset) : and a : jr z, redrawNets
    ld hl, (offset) : or a : ld de, 20 : sbc hl, de : ld (offset), hl
    ld a, 19 : ld (position), a
    jr redrawNets


keyDn:
    call hideCursor
    ld hl, position
    ld a, (hl) : cp 19 : jr nc, .scrollDn
    inc (hl)
    jr selectNetwork
.scrollDn
    xor a : ld (hl), a
    ld hl, (offset)
    ld de, 20
    add hl, de
    ld (offset), hl
redrawNets:
    call prepareScreen
    call showNetList
    jp selectNetwork

drawCursor:
    ld a, (position) : add 2
    ld l, a, a, 117o : jp Screen.fillLine

hideCursor:
    ld a, (position) : add 2
    ld l, a, a, 107o : jp Screen.fillLine

prepareScreen:
    call Screen.init
    ld a, 127o, l, 0 : call Screen.fillLine
    ld l, 23 : call Screen.fillLine
    
    ld hl, .netMan : call Screen.printZ 
    ld de, #1700 : call Screen.gotoXY
    ld hl, .copy : jp Screen.printZ
.netMan db "  Network Manager for NiFi "
    db VERSION_STRING
    db 13
    db 0
.copy db " 2021 (c) Alexander Sharihin ", 0

showNetList:
    ld de, #0201 : call Screen.gotoXY
    ld hl, netlist
    ld a, (offset)
    and a : jr z, .render
    ld b, a
.skipLines
    ld a, (hl) : cp #ff : ret z
    push bc
    xor a : ld bc, 32 : cpir
    pop bc
    djnz .skipLines
.render
    ld b, 21
.loop
    dec b : ret z
    ld a, (hl) : cp #ff : ret z
    push bc
    call Screen.printZ : inc hl
    push hl : call Screen.nl : ld a, ' ' : call Screen.putC : pop hl
    pop bc
    jr .loop

    include "common/zx-screen.asm"
    include "common/keyboard.asm"
   ; include "common/nifi.asm"
offset  db 0
position db 0

;; Currently just junk for interface development
netlist db "ssid1", 0
net2    db "ssid2", 0
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
end     db #ff

    savesna "test.sna", start