    device	zxspectrum48
    SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION
    include "common/version.asm"
    org #8000
appStart:
    di
    xor a
    ld hl, buffer, (hl), a , de, buffer + 1, bc, #100 : ldir

    call prepareScreen
    
    ld de, #0200 : call Screen.gotoXY
    ld hl, .init_txt : call Screen.printZ 
    call Nifi.init
    
    ld hl, buffer : call Nifi.getVer
    ld hl, buffer : call Screen.printZ
    call Screen.nl
    call Screen.nl
    jp showCurrentConnectionInfo


.init_txt db "Initing Nifi...", 13
          db "Nifi version:", 13, 0

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

    include "common/zx-screen.asm"
    include "common/keyboard.asm"
    include "netman/curinfo.asm"
    include "netman/netlist.asm"
    include "netman/connect-to-ssid.asm"
   
   
  ;  include "common/nifi-emulator.asm"

    include "common/nifi.asm"
    include "uarts/mb03-uart.asm"
    include "utils/display-ip.asm"

buffer equ $
    savebin "netman.bin", appStart, $ - appStart