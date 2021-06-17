connectToSSID:
    call prepareScreen
    ld de, #0200          : call Screen.gotoXY
    ld hl, .connectingTo  : call Screen.printZ
    ld hl, (ssid_pointer) : call Screen.printZ
    ld hl, .enterPass     : call Screen.printZ
    xor a 
    ld hl, passInput.buffer, (hl), a, de, passInput.buffer + 1, bc, 32 : ldir
    call passInput
    ld hl, (ssid_pointer), de, passInput.buffer
    call Nifi.setAp
    jp #8000

.connectingTo db "You're connecting to: ", 13, 0
.enterPass    db 13, 13
              db "Enter password:", 13, 0


passInput:
    ld de, #0600   : call Screen.gotoXY
    ld hl, .buffer 
.passOutputLoop
    ld a, (hl) : and a : jr z, .cursor
    push hl
    ld a, '*' : call Screen.putC
    pop hl
    inc hl
    jr .passOutputLoop
.cursor
    ld a, '_'      : call Screen.putC
    ld a, ' '      : call Screen.putC


    call Keyboard.getC

    cp Keyboard.RETURN : ret z
    cp Keyboard.BACKSPACE : jr z, .backspace

    cp 32 : jr c, passInput

    push af
    xor a
    ld hl, .buffer, bc, 32    
    cpir 
    xor a : ld (hl), a
    pop af
    dec hl
    ld (hl), a
    jr passInput
.backspace
    xor a
    ld hl, .buffer, bc, 32    
    cpir 
    dec hl 
    xor a : ld (hl), a : dec hl : ld (hl), a
    jr passInput

        dw 0 ; padding
.buffer ds 32