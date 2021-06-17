showCurrentConnectionInfo:
    call Nifi.getNetState : cp Nifi.NETSTATE_OPEN : jp z, connected
    ld hl, .disconnected : call Screen.printZ
    jr changeApQuestion

.disconnected db "Network is disconnected", 13, 0

connected:
    ld hl, .avail : call Screen.printZ
    ld de, buffer : call Nifi.getAp
    ld hl, buffer : call Screen.printZ 
    ld hl, .ip    : call Screen.printZ

    ld a, Nifi.IP_LOCAL : call Nifi.getIp
    ld (ipAddr), hl, (ipAddr + 2), de : ld hl, ipAddr : call dispIP
    jr changeApQuestion

.avail db "Network is available", 13, 13
       db "Current AP: ", 13, 0
.ip    db 13,13
       db "Your IP Address:", 13, 0 

changeApQuestion:
    ld hl, .changeAP : call Screen.printZ
.loop
    call Keyboard.getC
    cp 'n' : jp z, appStart
    cp 'N' : jp z, appStart
    cp 'y' : jp z, netList
    cp 'Y' : jp z, netList
    jr .loop



.changeAP db 13, 13, "Do you want change AP?", 0
ipAddr ds 4
