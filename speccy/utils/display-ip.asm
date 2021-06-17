dispIP:
    dup 3
    ld a, (hl)
    call dispA
    push hl
    ld a, '.' : call Screen.putC
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
	call Screen.putC	;plot a char. Replace with bcall(_PutC) or similar.
    pop hl, de, bc
	pop af		;safer than ld a,c
	ret