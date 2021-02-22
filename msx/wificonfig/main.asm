    output "iwconfig.com"
    org #100
    jp start
    include "driver/uart.asm"
    include "driver/nifi.asm"
    include "driver/console.asm"
start:
;; INIT!!
    Print hello
    call Nifi.init
    Print ok
    
;; Get version
    Print firmwareVer
    ld hl, buff : call Nifi.getVer
    and a : jp nz, .err
    Print buff
    call Console.newLine
    call Console.newLine

;; Get current SSID
    Print connectedTo
    ld hl, buff : call Nifi.getAp
    jr z, .ok
    Print notConnected
    jr .list
.ok
    Print buff
    call Console.newLine
    
    Print loc_ip
    ld a, Nifi.IP_LOCAL : call Nifi.getIp
    ld (buff), hl, (buff + 2), de
    ld hl, buff : call Console.dispIP
    
    Print rem_ip
    ld a, Nifi.IP_REMOTE : call Nifi.getIp
    ld (buff), hl, (buff + 2), de
    ld hl, buff : call Console.dispIP

    Print dns_ip
    ld a, Nifi.IP_DNS1 : call Nifi.getIp
    ld (buff), hl, (buff + 2), de
    ld hl, buff : call Console.dispIP

.list
    call Console.newLine

;; List available networks
    Print availableAPS
    ld hl, netList : call Nifi.getApList
    and a : jr nz, .err

    ld hl, netList
.loop
    call Console.putStringZ
    push hl : call Console.newLine : pop hl
    inc hl : ld a, (hl) : cp #ff : jr nz, .loop

;; Try connect to AP
    Print ssid_req
    ld hl, buff : call Console.readString
    ld a, (buff + 1) : and a :  jr z, .exit
    Print pass_req
    ld hl, buff2 : call Console.readString

    Print connecting
    Print buff + 2
    call Console.newLine

    ld hl, buff + 2, de, buff2 + 2 : call Nifi.setAp
    and a : jr nz, .err
    Print ok
.exit
    rst 0

.err
    Print err
    rst 0

hello db "Nifi configuration utility 0.1",13,10
      db "(c) 2021 Alexander Sharihin", 13,10,13,10
      db "Initing your modem...",0

ok db "[DONE]", 13,10, 0
err db "[ERROR]", 13, 10, 0
    
firmwareVer  db "Firmware version: ", 0
connectedTo  db "Currently connected to: ", 0
notConnected db "<NOT CONNECTED>", 0
availableAPS db 13,10, "Available Access Points: ", 13, 10, 13, 10, 0
connecting   db 13,10, "Connecting to: ", 0

loc_ip       db 13,10, "Local IP: ", 0
rem_ip       db 13,10, "Remote IP: ", 0
dns_ip       db 13,10, "DNS IP: ", 0

ssid_req     db 13,10, "Empty SSID to exit"
             db 13,10, "Enter SSID: ", 0
pass_req     db 13,10, "Password: ", 0


buff ds 40
buff2 ds 40

netList equ $