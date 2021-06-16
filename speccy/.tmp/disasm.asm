L0010:       equ  0010h
L0097:       equ  0097h
L0C0A:       equ  0C0Ah
L0D6E:       equ  0D6Eh
L0ECD:       equ  0ECDh
L15EF:       equ  15EFh
L16B0:       equ  16B0h
L1A1B:       equ  1A1Bh
L1B8A:       equ  1B8Ah
L3B3B:       equ  3B3Bh
L5C0B:       equ  5C0Bh
L5C16:       equ  5C16h
L5C3A:       equ  5C3Ah
L5C45:       equ  5C45h
L81FA:       equ  81FAh


             org 1300h


1300 L1300:
1300 CD 8A 1B     CALL L1B8A  
1303 76           HALT        
1304 FD CB 01 AE  RES  5,(IY+1) 
1308 FD CB 30 4E  BIT  1,(IY+48) 
130C C4 CD 0E     CALL NZ,L0ECD 
130F 3A 3A 5C     LD   A,(L5C3A) 
1312 3C           INC  A      
1313 F5           PUSH AF     
1314 21 00 00     LD   HL,0000h 
1317 FD 74 37     LD   (IY+55),H 
131A FD 74 26     LD   (IY+38),H 
131D 22 0B 5C     LD   (L5C0B),HL 
1320 21 01 00     LD   HL,0001h 
1323 22 16 5C     LD   (L5C16),HL 
1326 CD B0 16     CALL L16B0  
1329 FD CB 37 AE  RES  5,(IY+55) 
132D CD 6E 0D     CALL L0D6E  
1330 FD CB 02 EE  SET  5,(IY+2) 
1334 F1           POP  AF     
1335 47           LD   B,A    
1336 FE 0A        CP   0Ah    
1338 38 02        JR   C,L133C 
133A C6 07        ADD  A,07h  
133C L133C:
133C CD EF 15     CALL L15EF  
133F 3E 20        LD   A,20h  
1341 D7           RST  10h    
1342 78           LD   A,B    
1343 11 91 13     LD   DE,1391h 
1346 CD 0A 0C     CALL L0C0A  
1349 CD 3B 3B     CALL L3B3B  
134C 00           NOP         
134D CD 0A 0C     CALL L0C0A  
1350 ED 4B 45 5C  LD   BC,(L5C45) 
1354 CD 1B 1A     CALL L1A1B  
1357 3E 3A        LD   A,3Ah  
1359 D7           RST  10h    
135A FD 4E 0D     LD   C,(IY+13) 
135D 06 00        LD   B,00h  
135F CD 1B 1A     CALL L1A1B  
1362 CD 97 00     CALL L0097  


             org 81C1h


81C1 L81C1:
81C1 F6 E0        OR   E0h    
81C3 FE FF        CP   FFh    
81C5 20 33        JR   NZ,L81FA 
81C7 1E 14        LD   E,14h  
81C9 06 EF        LD   B,EFh  
81CB ED 78        IN   A,(C)  
81CD F6 E0        OR   E0h    
81CF FE FF        CP   FFh    
81D1 20 27        JR   NZ,L81FA 
81D3 1E 19        LD   E,19h  
81D5 06 DF        LD   B,DFh  
81D7 ED 78        IN   A,(C)  
81D9 F6 E0        OR   E0h    
81DB FE FF        CP   FFh    
81DD 20 1B        JR   NZ,L81FA 
81DF 1E 1E        LD   E,1Eh  
81E1 06 BF        LD   B,BFh  
81E3 ED 78        IN   A,(C)  
81E5 F6 E0        OR   E0h    