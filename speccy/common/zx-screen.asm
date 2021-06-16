    module Screen
font = #3d00 ; Rom's font

init:
    xor a : out (#fe), a
    ld hl, #4000, de, #4001, bc, #17FF, (hl), a : ldir
    ld a, 107o, hl, #5800, de, #5801, bc, #2ff, (hl), a : ldir
    ld hl, 0, (coords), hl
    ret

gotoXY:
    ld (coords), de
    ret

; A - attribute
; L - line
fillLine:
    ld h, 0
    dup 5
    add hl, hl
    edup
    ld de, #5800
    add hl, de
    ld de, hl
    inc de
    ld (hl), a, bc, 31
    ldir
    ret

printZ:
    ld a, (hl) : and a : ret z
    push hl
    call putC
    pop hl
    inc hl
    jr printZ

putC:
    cp 13 : jp z, nl
    cp 32 : ret c
    sub 32
    ld l, a
    ld h, 0
    dup 3 ; *8
    add hl, hl
    edup
    ld bc, font
    add hl, bc
    ld de, (coords)
    ld a, d
    and 7

    dup 3
    rrca
    edup
    or e
    ld e, a
    
    ld a, d
    and 24
    or 64
    ld d, a
    ld b, 8
.loop
    ld a, (hl), (de), a
    inc hl
    inc d
    djnz .loop

    ld hl, (coords)
    inc hl
    ld (coords), hl
    ld a, l
    cp 32 : ret c
nl:
    ld hl, (coords)
    inc h
    ld l, 0
    ld (coords), hl
    ret

deToCoords:
    ld a, d
    and 7
    dup 3
    rrca
    edup
    or e
    ld e,a, a, d
    and 24
    or 64
    ld d, a
    ret

coords dw 0
    endmodule