
; This driver works with 16c550 uart that's support AFE
    module Uart
; Make init shorter and readable:-)
    macro outp port, value
    ld a, value
    out (port), a
    endm

; Internal port constants
RBR_THR = #80
IER     = RBR_THR + 1
IIR_FCR = RBR_THR + 2
LCR     = RBR_THR + 3
MCR     = RBR_THR + 4
LSR     = RBR_THR + 5
MSR     = RBR_THR + 6
SR      = RBR_THR + 7

init:
    outp MCR,     #0d  // Assert RTS
    outp IIR_FCR, #87  // Enable fifo 8 level, and clear it
    outp LCR,     #83  // 8n1, DLAB=1
    outp RBR_THR, #01  // 115200 (divider 2)
    outp IER,     #00  // (divider 0). Divider is 16 bit, so we get (#0002 divider)

    outp LCR,     #03 // 8n1, DLAB=0
    outp IER,     #00 // Disable int
    outp MCR,     #2f // Enable AFE
    ret
    
; Flag C <- Data available
isAvailable:
    in a, (LSR)
    rrca
    ret

; Non-blocking read
; Flag C <- is byte was readen
; A <- byte
read:
    in a, (LSR)
    rrca
    ret nc
    in a, (RBR_THR)
    scf 
    ret

; Tries read byte with timeout
; Flag C <- is byte read
; A <- byte
readTimeout:
    ld b, 10
.wait
    call isAvailable : jr c, read
    halt
    djnz .wait
    or a
    ret

; Blocking read
; A <- Byte
readB:
    in a, (LSR)
    rrca
    jr nc, readB
    in a, (RBR_THR)
    ret

; Blocking read word
; HL <- Word
readBHL:
    call readB : ld l, a
    call readB : ld h, a
    ret

; Blocking read double word
; HLDE <- Word
readBHLDE:
    call readB : ld l, a
    call readB : ld h, a
    call readB : ld e, a
    call readB : ld d, a
    ret 

; A -> byte to send
write:
    push af
.wait
    in a, (LSR)
    and #20
    jr z, .wait
    pop af
    out (RBR_THR), a
    ret

; HL - pointer
writeString:
    ld a, (hl) : call write
    and a : ret z
    inc hl
    jr writeString

writeHL:
    ld a, l : call write
    ld a, h : jp write

    endmodule