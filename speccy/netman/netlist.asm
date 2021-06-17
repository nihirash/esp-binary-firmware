netList:
    ld de, buffer : call Nifi.getApList
    jp redrawNets

selectNetwork:
    call drawCursor
.loop
    call Keyboard.getC
    cp Keyboard.KEY_DN : jr z, keyDn
    cp Keyboard.KEY_UP : jr z, keyUp
    cp Keyboard.RETURN : jp z, select  
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
    call showbuffer
    jp selectNetwork

drawCursor:
    ld a, (position) : add 2
    ld l, a, a, 117o : jp Screen.fillLine

hideCursor:
    ld a, (position) : add 2
    ld l, a, a, 107o : jp Screen.fillLine

select:
    ld a, (offset), hl, position
    add a, (hl) ; A - network position
    ld b, a

    ld hl, buffer
.searchLoop
    push bc
    ld a, (hl) : cp #ff : jp z, appStart

    xor a : ld bc, #ff : cpir
    pop bc
    djnz .searchLoop

    ld (ssid_pointer), hl
    jp connectToSSID


showbuffer:
    ld de, #0201 : call Screen.gotoXY
    ld hl, buffer
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

ssid_pointer dw 0

pass_buffer ds 40

offset  db 0
position db 0