    macro Print pointer
    ld hl, pointer : call Console.putStringZ
    endm

    module Console
BDOS = 5

; hl - ip addr
dispIP:
    dup 3
    ld a, (hl)
    call dispA
    push hl
    ld a, '.' : call putC
    pop hl
    inc hl
    edup
    ld a, (hl)
dispA:
	ld	c,-100
	call	.na1
	ld	c,-10
	call	.na1
	ld	c,-1
.na1	ld	b,'0'-1
.na2	inc	b
	add	a,c
	jr	c,.na2
	sub	c		;works as add 100/10/1
	push af		;safer than ld c,a
	ld	a,b		;char is in b
    push bc,de,hl
	call putC	;plot a char. Replace with bcall(_PutC) or similar.
    pop hl, de, bc
	pop af		;safer than ld a,c
	ret

newLine: 
    ld a, 13 : call putC
    ld a, 10
; A <- char
putC:
    ld e, a 
    ld c, 2
    jp BDOS

; HL <- String
putStringZ:
    ld a, (hl) : and a : ret z
    push hl : call putC : pop hl
    inc hl
    jr putStringZ

; HL - buffer
readString:
    ld (hl), 80
    ld de, hl
    push hl
    ld c, #0a
    call BDOS
    pop hl
    inc hl 
    ld a, (hl)
    inc a
    ld d, 0, e, a
    add hl, de
    xor a 
    ld (hl), a
    ret
    endmodule