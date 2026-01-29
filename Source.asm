INCLUDE Irvine32.inc
INCLUDE macros.inc
INCLUDELIB winmm.lib
INCLUDELIB user32.lib 

PlaySound PROTO, pszSound:PTR BYTE, hmod:DWORD, fdwSound:DWORD
GetAsyncKeyState PROTO, nVirtKey:WORD  ; ADD THIS LINE
.data
bossground db "========================",0
bossground1 db "=============",0
bossground2 db "===",0
groundboss db "=========================================================================",0
ground BYTE "========================================================================================================================",0
ground1 BYTE "=                                                                                                                     =",0




cloud1 BYTE "***",0
cloud2 BYTE "*****",0
cloud3 BYTE "*******",0

cloudY BYTE 10

powerUpActive BYTE 0  
powerTimer   DWORD 1000

powerX db 10 dup(?)
powerY db 10 dup(?)
powerCount db 0


lives DWORD 3
strlives BYTE "Lives: ",0

pip db "==="
pipe db "|"
pipeX BYTE 10 dup(0)
pipeY BYTE 10 dup(0)
pipeheight db 10 dup(0)
pipeCount db 0


platform db "************",0

pbool db 10 dup(1)
coinbool db 10 dup(1)

block db "?=====?========",0
blockX db 10 dup(?)
blockY db 10 dup(?)
blockCount db 0

strScore BYTE "Your score is: ",0
score DWORD 0


;=========== BULLET SYSTEM =============
bulletActive BYTE 0          ; 1=bullet active, 0=inactive
bulletX BYTE 10              ; Bullet X position
bulletY BYTE 28              ; Bullet Y position
bulletSpeed BYTE 3           ; Pixels per frame (rightward)
bulletMaxX BYTE 120          ; Screen edge

;=========== GOOMBAS =============
enemie BYTE 'G'

MAX_ENEMIES EQU 10
enemieX     BYTE MAX_ENEMIES dup(110)    ; X positions
enemieY     BYTE MAX_ENEMIES dup(28)     ; Y positions
enemieDir   BYTE MAX_ENEMIES dup(0)      ; Directions (0=left, 1=right)
enemyActive BYTE MAX_ENEMIES dup(1)      ; 1=active, 0=dead
enemyCount  BYTE 3                       ; Current enemy count


;=========== GOOMBAS =============
Koopas BYTE 'K'

MAX_KOOPAS EQU 10
KoopasX     BYTE MAX_ENEMIES dup(110) 
KoopasY     BYTE MAX_ENEMIES dup(28)  
KoopasDir   BYTE MAX_ENEMIES dup(0)   
KoopasActive BYTE MAX_ENEMIES dup(1)  
KoopasCount  BYTE 3 

;=========== GOOMBAS =============
Shell BYTE 'S'

MAX_SHELL EQU 10
shellX     BYTE MAX_ENEMIES dup(110) 
shellY     BYTE MAX_ENEMIES dup(28)  
shellActive BYTE MAX_ENEMIES dup(1)  
shellDir BYTE MAX_SHELL dup(0) 
shellCount  BYTE 0 
shellSpeed BYTE 2          

;=========== FLAG =============
flagX BYTE 115
flagY BYTE 28
flag BYTE '|'

xPos BYTE 10
yPos BYTE 10

coinCount BYTE 0

coinxPos BYTE 200 dup(?)
coinyPos BYTE 200 dup(?)

inputChar BYTE ?
lastKey BYTE 0

velocityX SDWORD 0
velocityY SDWORD 0
gravity   SDWORD 1
groundY   BYTE 28

maxJumps BYTE 3       ; allow up to triple jump
jumpCount BYTE 0

platCount db 2
platX db 20,20
platY db 26,20

enemySpeedCounter db 0
KoopasSpeedCounter db 0
enemySpeedLimit db 2

scoreBuffer BYTE 20 dup(0)
newline BYTE 13,10
tempBuffer BYTE 1000 dup(0)  ; Buffer to read existing scores
scoreArray DWORD 100 dup(0)  ; Array to store scores
nameArray BYTE 100 dup(20 dup(0))  ; Array to store names (100 names, 20 chars each)
scoreCount DWORD 0
; ===== PIT SYSTEM =====
MAX_PITS EQU 3
pitX      BYTE MAX_PITS dup(0)     ; Pit start X
pitWidth  BYTE MAX_PITS dup(0)     ; Pit width
pitActive BYTE MAX_PITS dup(1)     ; 1=active pit
pitCount  BYTE 0

    ; Sound flags
    SND_SYNC        EQU 0h
    SND_ASYNC       EQU 1h
    SND_NODEFAULT   EQU 2h
    SND_LOOP        EQU 8h
    SND_NOSTOP      EQU 10h
    SND_FILENAME    EQU 20000h

    bgMusic db "background.wav",0
    coinSound db "Coin.wav",0
    deathSound db "death.wav",0
    levelSound db "levelComplete.wav",0
    introSound db "theme.wav",0

    bossbgcolor textequ <0>
    myFile BYTE "File.txt",0
    hFile DWORD ?
    count DWORD 0


    
    bossX WORD 60          ; Start in middle
    bossY WORD 10          ; Air position (row 10)
    direction BYTE 1       ; Start moving right
    leftX WORD 48           ; Left boundary
    rightX WORD 90        ; Right boundary
    speed WORD 1           ; Movement speed (1 pixel per frame)

    frameCount WORD 0
    fireballActive BYTE 0
    fireballX WORD ?
    fireballY WORD ?
    fireballSpeed WORD 4

    msgTitle      BYTE "=== SUPER MARIO BROS ===",0
    msgPressEnter BYTE "Press ENTER to continue...",0
    blankPress    BYTE "                           ",0
    msgName       BYTE "Enter Your Name: ",0

    frameTop BYTE  "+------------------------------------+",0
    frameMid BYTE  "|                                    |",0
    frameBot BYTE  "+------------------------------------+",0

    nameIN BYTE 200 DUP(0)      ; buffer for user’s name

    VK_A EQU 41h     ; A key
    VK_W EQU 57h     ; W key  
    VK_D EQU 44h     ; D key
    VK_F EQU 46h     ; F key (bullet)
    VK_P EQU 50h     ; P key (pause)
    VK_X EQU 58h     ; X key (exit)

    ResumeMsg db " Resume ",0
    ExitMsg db " Exit ",0
.code
main PROC

    call startScreen
    bgColor textEQU <3>

    mov eax, white+(bgColor*16)
    call SetTextColor

    call Clrscr
    
Level1:
    ; ================== LEVEL 1 =====================
    
; ===== Draw ground =====
    call DrawMap
    call DrawFlag
    call initEnemies
    call initKoopas
    call initPipes
    mov dl,20
    mov dh,26
    call Gotoxy
    mov edx,OFFSET platform
    call WriteString

    mov dl,20
    mov dh,20
    call Gotoxy
    mov edx,OFFSET platform
    call WriteString

    call DrawClouds

    call DrawPlayer
    call Randomize


	call coinPos
	call drawCoin

    call DrawBlock
    call DrawPipe
    call PlayBackgroundMusic
gameLoop:
   

	mov eax, white+(bgColor*16)
    call SetTextColor

    call HandleInput
   
    ; ===== ERASE PLAYER =====
    call UpdatePlayer

    ; ===== ERASE ENEMIE =====
   
    cmp enemieX, 0
    jl skipEraseEnemy
    cmp enemieX, 115
    jg skipEraseEnemy
   
    call updateEnemie
    call updateKoopas
    call updateShell

    skipEraseEnemy:
    ; ===== ERASE BULLET =====
    call updateBulletpos

    call enemieCollisionDir
    call KoopasCollisionDir
    jg skip

    call bulletEnemyCollision
    call bulletKoopasCollision
    skip:
    ; ===== APPLY PHYSICS =====
    mov eax, velocityY
    add eax, gravity
    mov velocityY, eax

    movsx eax, yPos
    add eax, velocityY
    mov yPos, al

    movsx eax, xPos
    add eax, velocityX
    mov xPos, al

   call GroundCollision


skipInput:
    call coinCollision
    call blockCollision
    call collideplatform
    call pipecollide
    call powerplayerCollision
    

    ; Power-up timer (add after aboveGround:)
    cmp powerUpActive, 1
    jne skipTimer
    dec powerTimer
    jnz skipTimer
    mov powerUpActive, 0
    skipTimer:

; ===================================== FLAG =====================================
    ;===== IF FROM TOP =======
    mov al, xPos
    cmp al, flagX  
    jl skipLevel1
    
    mov al, yPos
    mov bl,flagY
    sub bl,5
    cmp al, bl
    jne skipLevel1

  call PlayLevelSound
    add score,5000
    call updateScore
    
    jmp level

;===== IF FROM MIDDLE =====
skipLevel1:
    mov al, xPos
    cmp al, flagX  
    jl skipLevel2
    
    mov al, yPos
    mov bl,flagY
    sub bl,3
    cmp al, bl
    jne skipLevel2

    call PlayLevelSound
    add score,2000
    call updateScore
    jmp level

;===== IF ON GROUND =======
skipLevel2:
    mov al, xPos
    cmp al, flagX  
    jl skipLevel
    
    mov al, yPos
    cmp al, flagY 
    jne skipLevel

   ; call PlayLevelSound
    add score,100
    call updateScore
    jmp level

    level:
    mov xPos, 10
    mov yPos, 28
    mov velocityX, 0
    mov velocityY, 0
    mov jumpCount, 0
    mov enemieX, 120
    mov enemieY, 28
    
    call Clrscr
    mov eax, white+(bgColor*16)
    call SetTextColor
    
    mov dl, 35
    mov dh, 15
    call Gotoxy
    mWrite "BOSS LEVEL!"
    
    mov eax, 2000   
    call Delay
    call StopBackgroundMusic
    
    jmp BossLevel1

    skipLevel:
    mov al,enemieX
    cmp al,2
    jg skipEnemie
    jl skipEnemie
    
    ; ===== DRAW ENEMIE =====
    mov enemieDir,1
    
    skipEnemie:
    mov al,enemieX
    cmp al,115
    jg skipEnemiedraw
    cmp al,0
    jl skipEnemiedraw
    call DrawEnemie
    call DrawKoopas

    skipEnemiedraw:
    ; ===== DRAW PLAYER =====
    call DrawPlayer
    
    
    call enemiePlayer
    call KoopasPlayer
    cmp lives,0
    je GameOver
    call enemiePlayerCollide
    call KoopasPlayerCollide
    call ShellPlayerCollide  
    call DrawShell

    ; ===== SHOW SCORE =====
    mov dl,0
    mov dh,0
    call Gotoxy
    mov edx,OFFSET strScore
    call WriteString

    mov eax,score
    call WriteInt
    
    ; ===== SHOW LIVES =====
    mov dl,70
    mov dh,0
    call Gotoxy
    mov edx,OFFSET strlives
    call WriteString

    mov eax,lives
    call WriteInt
    
    mov eax, 50
    call Delay
    jmp gameLoop

    handlepause:
    call pauseScreen
    cmp al, 2               ; Check if user chose exit (option 2)
    je exitGame
    
    ; If resumed (option 1), redraw the screen
    mov eax, white+(bgColor*16)
    call SetTextColor

    call Clrscr
    call RedrawGame
    jmp gameLoop            ; Resume the game












                      ; ====================== Level 2 ===========================
Level2:

call Clrscr
    ; ===== Draw ground =====
        call DrawMap
        call DrawFlag
        mov dl,20
        mov dh,26
        call Gotoxy
        mov edx,OFFSET platform
        call WriteString

        mov dl,20
        mov dh,20
        call Gotoxy
        mov edx,OFFSET platform
        call WriteString

    
         mov xPos,20
         mov yPos,25
        call DrawPlayer
        call Randomize

	    call coinPos
	    call drawCoin
    
    gameLoop2:
    
	     mov eax, white+(bgColor*16)
        call SetTextColor

        call HandleInput
   
        ; ===== ERASE PLAYER =====
        call UpdatePlayer

        ; ===== ERASE ENEMIE =====
        call updateEnemie

        ; ===== ERASE BULLET =====
        call updateBulletpos


        call enemieCollisionDir
        jg skip2

    

        skip2:
        ; ===== APPLY PHYSICS =====
        mov eax, velocityY
        add eax, gravity
        mov velocityY, eax

        movsx eax, yPos
        add eax, velocityY
        mov yPos, al

        movsx eax, xPos
        add eax, velocityX
        mov xPos, al
        
        
        ; ===== GROUND COLLISION =====
        mov al, yPos
        cmp al, groundY
        jle aboveGround2
            mov al, groundY
            mov yPos, al
            mov velocityY, 0
            mov velocityX, 0
            mov jumpCount, 0        ; reset jumps on landing
        aboveGround2:

        
    skipInput2:
        call coinCollision
        call collideplatform


        mov al,enemieX
        cmp al,2
        jg skipEnemie2
        jl skipEnemie2
    
        ; ===== DRAW ENEMIE =====
        mov enemieDir,1
    
        skipEnemie2:
            mov al,enemieX
            cmp al,115
            jg skipEnemiedraw2
            cmp al,0
            jl skipEnemiedraw2
            call DrawEnemie
            call DrawKoopas

        skipEnemiedraw2:
        ; ===== DRAW PLAYER =====
        call DrawPlayer

        call enemiePlayer
        cmp lives,0
        je GameOver
        
; ===================================== FLAG =====================================
    ;===== IF FROM TOP =======
    mov al, xPos
    cmp al, flagX  
    jl skipLevel5
    
    mov al, yPos
    mov bl,flagY
    sub bl,5
    cmp al, bl
    jne skipLevel5

    call PlayLevelSound
    add score,5000
    call updateScore
    
    jmp bosslevel

;===== IF FROM MIDDLE =====
skipLevel5:
    mov al, xPos
    cmp al, flagX  
    jl skipLevel4
    
    mov al, yPos
    mov bl,flagY
    sub bl,3
    cmp al, bl
    jne skipLevel4

    ;call PlayLevelSound
    add score,2000
    call updateScore
    jmp bosslevel

;===== IF ON GROUND =======
skipLevel4:
    mov al, xPos
    cmp al, flagX  
    jl skipLevel9
    
    mov al, yPos
    cmp al, flagY 
    jne skipLevel9

   ; call PlayLevelSound
    add score,100
    call updateScore
    jmp bosslevel

    bosslevel:
    mov xPos, 10
    mov yPos, 28
    mov velocityX, 0
    mov velocityY, 0
    mov jumpCount, 0
    mov enemieX, 120
    mov enemieY, 28
    
    call Clrscr
    mov eax, white+(bgColor*16)
    call SetTextColor
    
    mov dl, 35
    mov dh, 15
    call Gotoxy
    mWrite "BOSS LEVEL!"
    
    mov eax, 2000   
    call Delay
    call StopBackgroundMusic
    jmp BossLevel1

    skipLevel9:
        ; ===== SHOW SCORE =====
        mov dl,0
        mov dh,0
        call Gotoxy
        mov edx,OFFSET strScore
        call WriteString
        mov eax,score
        call WriteInt
    
        ; ===== SHOW LIVES =====
        mov dl,70
        mov dh,0
        call Gotoxy
        mov edx,OFFSET strlives
        call WriteString
        mov eax,lives
        call WriteInt


        mov eax, 50
        call Delay
        jmp gameLoop2

        handlepause2:
        call pauseScreen
        cmp al, 2               ; Check if user chose exit (option 2)
        je exitGame
    
        ; If resumed (option 1), redraw the screen
        mov eax, white+(bgColor*16)
        call SetTextColor

        call Clrscr
        call RedrawGame
        jmp gameLoop2           ; Resume the game

Bosslevel1:
    call clrscr
    
    call DrawBosslevel
    call Drawplayer
    call initpits

   
   mov eax, 8+(bgcolor*16)
    call setTextColor
    mov dl,48
    mov dh,20
    call Gotoxy
    mov edx,OFFSET groundboss
    call WriteString

    sub flagY,9
    call DrawFlag

    bossloop:
     mov eax, white+(bgColor*16)
        call SetTextColor

        mov velocityX, 0  
        mov velocityY, 0       
        call HandleInput

        ; ===== ERASE PLAYER =====
        call UpdatePlayer

        call EraseBoss
        call EraseFireball
        
        ; ===== ERASE BULLET =====
        call updateBulletpos
        call HandleBossShot    ; Update fireball
    
        call UpdateBoss        ; Movement
         
        jg skip3

    

        skip3:
        ; ===== APPLY PHYSICS =====
        mov eax, velocityY
        add eax, gravity
        mov velocityY, eax

        
        movsx eax, yPos
        add eax, velocityY
        mov yPos, al

        movsx eax, xPos
        add eax, velocityX
        mov xPos, al
        
      

        ; ===== GROUND COLLISION =====
        
        mov al, yPos
        cmp al, 19               ; Check if below platform level
        jle aboveGround3

            ; ===== CHECK IF MARIO IS ON A PLATFORM =====
            movzx eax, xPos
    
            ; Platform 1: bossground (X: 0-25)
            cmp al, 0
            jb checkPlatform2
            cmp al, 25
            jbe onPlatform
            

        checkPlatform2:
            ; Platform 2: bossground1 (X: 30-42)
            cmp al, 30
            jb checkPlatform3
            cmp al, 52
            jbe onPlatform
            
        checkPlatform3:
            ; Platform 3: bossground2 (X: 45-47)
            cmp al, 45
            jb notOnPlatform
            cmp al, 120
            jbe onPlatform
    
        notOnPlatform:
            ; Mario is NOT on a platform - let him fall!
            jmp aboveGround3

        onPlatform:
            ; Mario IS on a platform - stop falling
            mov al, 19
            mov yPos, al
            mov velocityY, 0
            
            mov jumpCount, 0

        aboveGround3:

        
        
        
    skipInput3:
    
        call pitCollision
        call fireballPlayerCollision
        cmp lives,0
        jne skipDelay

        mov eax,300
        call Delay
        jmp GameOver

        skipDelay:
        call collideplatform

        skipEnemiedraw3:
        ; ===== DRAW PLAYER =====
        call DrawFireball      ; Draw '*' if active
        call DrawBoss 
        call DrawBossPlayer


        
        ; ===================================== FLAG =====================================
            ;===== IF FROM TOP =======
        mov al, xPos
        cmp al, flagX  
        jl skipLevel10
    
        mov al, yPos
        mov bl,flagY
        sub bl,5
        cmp al, bl
        jne skipLevel10

        call PlayLevelSound
        add score,5000
        call updateScore
       jmp victorylevel
        
    ;===== IF FROM MIDDLE =====
    skipLevel10:
        mov al, xPos
        cmp al, flagX  
        jl skipLevel11
    
        mov al, yPos
        mov bl,flagY
        sub bl,3
        cmp al, bl
        jne skipLevel11

        ;call PlayLevelSound
        add score,2000
        call updateScore
        jmp victorylevel

    ;===== IF ON GROUND =======
    skipLevel11:
        mov al, xPos
        cmp al, flagX  
        jl skipLevel12
    
        mov al, yPos
        cmp al, flagY 
        jne skipLevel12

       call PlayLevelSound
        add score,100
        call updateScore
       jmp victorylevel

       victorylevel:
        mov xPos, 10
        mov yPos, 28
        mov velocityX, 0
        mov velocityY, 0
        mov jumpCount, 0
        mov enemieX, 120
        mov enemieY, 28
    
        call Clrscr
        mov eax, white+(bgColor*16)
        call SetTextColor
    
        mov dl, 35
        mov dh, 15
        call Gotoxy
        mWrite "Victory!!!!!"
    
        mov eax, 2000   
        call Delay
        call StopBackgroundMusic
        jmp Victory


        skipLevel12:
        ; ===== SHOW SCORE =====
        mov dl,0
        mov dh,0
        call Gotoxy
        mov edx,OFFSET strScore
        call WriteString
        mov eax,score
        call WriteInt
    
        ; ===== SHOW LIVES =====
        mov dl,70
        mov dh,0
        call Gotoxy
        mov edx,OFFSET strlives
        call WriteString
        mov eax,lives
        call WriteInt


        mov eax, 50
        call Delay
        jmp bossloop

        handlepause3:
        call pauseScreen
        cmp al, 2               ; Check if user chose exit (option 2)
        je exitGame
    
        ; If resumed (option 1), redraw the screen
        mov eax, white+(black*16)
        call SetTextColor

        call Clrscr
        jmp redrawgame
        jmp bossloop

        
    Victory:

    jmp exitGame
    GameOver:

    call Clrscr
    call PlayDeathSound
    mov eax, Red + (bgColor * 16)
    call SetTextColor
    mov dl, 35
    mov dh, 15
    call Gotoxy
    mWrite "GAME OVER!"

    mov eax, 2000
    call Delay
    
exitGame:
call fileHandling
    exit
    
main ENDP






; ===== DRAW PLAYER =====
DrawBossPlayer PROC
    cmp powerUpActive, 1
    je drawTall
    
    ; Normal X
    mov eax, blue+(bgColor*16)
    call SetTextColor

    mov dl, xPos
    mov dh, yPos
    call Gotoxy
    mov al, "X"
    call WriteChar
    jmp donePlayer
    
drawTall:
    ; TALL 1x3
    mov eax, yellow+(bgColor*16)
    call SetTextColor
    movzx ebx, xPos
    
    mov dl, bl
    mov dh, yPos
    sub dh,2
    inc dh
    call Gotoxy
    mov al, "X"  ; Body
    call WriteChar
    inc dh
    call Gotoxy
    mov al, "X"  ; Feet
    call WriteChar
donePlayer:
    mov eax, white+(bgColor*16)
    call SetTextColor
    ret
DrawBossPlayer ENDP

DrawPipe PROC
    mov eax, green + (green * 16)
    call SetTextColor
    
    movzx ecx, pipeCount
    test ecx, ecx
    jz doneDrawPipes
    
    mov esi, OFFSET pipeX
    mov edi, OFFSET pipeY
    mov ebx, OFFSET pipeheight

pipeLoop:
    mov dl, [esi]           ; X coordinate
    mov dh, [edi]           ; Y coordinate (bottom)
    movzx eax, byte ptr [ebx] ; height into EAX (not EDX!)
    
    test eax, eax
    jz pipeNext
    
    push ecx                ; save pipe counter
    mov ecx, eax            ; height into ECX for loop
    
heightLoop:
    call Gotoxy             ; position cursor at DL, DH
    mov al, pipe            ; character to draw
    call WriteChar
    dec dh                  ; move up one row
    loop heightLoop         ; loop uses ECX
    
    pop ecx                 ; restore pipe counter
    mov dl, [esi]
    mov dh, [edi]
    movzx eax, byte ptr [ebx]
    sub dh, al
    sub dl, 2
    call Gotoxy
    mov edx, OFFSET pip
    call WriteString

pipeNext:
    inc esi
    inc edi
    inc ebx
    loop pipeLoop

   

doneDrawPipes:
    mov eax, white + (bgColor * 16)
    call SetTextColor
    ret
DrawPipe ENDP


; ===== DRAW SHELL =====
drawShell PROC
    mov eax, red + (black * 16)
    call SetTextColor

    mov esi, OFFSET shellX
    mov edi, OFFSET shellY
    mov ebx, OFFSET shellActive
    movzx ecx, shellCount
    test ecx, ecx
    jz noShells

shellLoop:
    cmp byte ptr [ebx], 0
    je skipShell
    
    mov dl, [esi]
    mov dh, [edi]
    call Gotoxy
    mov al, 'S'         
    call WriteChar
    
skipShell:
    inc esi 
    inc edi
    inc ebx
    loop shellLoop
    
noShells:
    mov eax, white+(bgColor*16)
    call SetTextColor
    ret
drawShell ENDP





DrawFlag PROC
    mov eax, red+(bgColor*16)
    call SetTextColor

    mov cx,5
    mov bl,flagY
    L1:
    mov dl,flagX
    mov dh,bl
    call Gotoxy
    mov al,flag
    call WriteChar
    dec bl
    loop l1

    inc flagX
    mov dl,flagX
    inc bl
    mov dh,bl
    call Gotoxy
    mov al,"="
    call WriteChar

    mov eax, white+(bgColor*16)
    call SetTextColor

    ret
DrawFlag ENDP



DrawClouds PROC

    mov eax, white+(white*16)
    call SetTextColor

    mov dl,20
    mov dh,cloudY
    call Gotoxy
    mov edx, OFFSET cloud1
    call WriteString

    mov dl,18
    mov dh,cloudY
    inc dh
    call Gotoxy
    mov edx, OFFSET cloud3
    call WriteString


    mov dl,30
    mov dh,12
    call Gotoxy
    mov edx, OFFSET cloud1
    call WriteString

    mov dl,28
    mov dh,12
    inc dh
    call Gotoxy
    mov edx, OFFSET cloud3
    call WriteString

    mov dl,50
    mov dh,15
    call Gotoxy
    mov edx, OFFSET cloud1
    call WriteString

    mov dl,48
    mov dh,15
    inc dh
    call Gotoxy
    mov edx, OFFSET cloud3
    call WriteString

    mov dl,100
    mov dh,12
    call Gotoxy
    mov edx, OFFSET cloud1
    call WriteString

    mov dl,98
    mov dh,12
    inc dh
    call Gotoxy
    mov edx, OFFSET cloud3
    call WriteString

    ret
DrawClouds ENDP












; ===== ERASE ENEMIE =====
updateEnemie PROC
mov eax, white+(bgColor*16)
    call SetTextColor
    movzx ecx, enemyCount
    mov esi, OFFSET enemieX
    mov edi, OFFSET enemieY
     mov ebx, OFFSET enemyActive  

enemyEraseLoop:
    cmp byte ptr [ebx], 0         
    je nextEnemyErase      

    cmp byte ptr [esi], 0
    jl nextEnemyErase
    cmp byte ptr [esi], 115
    jg nextEnemyErase
    
    mov dl, byte ptr [esi]       ; dl = X position
    mov dh, byte ptr [edi]       ; dh = Y position
    call Gotoxy
    mov al, ' '
    call WriteChar
    
nextEnemyErase:
    inc esi                      ; Next enemy X
    inc edi                      ; Next enemy Y
    inc ebx                      ; Next enemy active
    loop enemyEraseLoop
    ret
updateEnemie ENDP


; ===== DRAW ENEMIE =====
DrawEnemie PROC
    movzx ecx, enemyCount
    mov esi, OFFSET enemieX
    mov edi, OFFSET enemieY
    mov ebx, OFFSET enemyActive   
    
enemyDrawLoop:
    cmp byte ptr [ebx], 0  
    je nextEnemyDraw              

    mov al, [esi]                   ; X pos
    cmp al, 0
    jl nextEnemyDraw
    cmp al, 115
    jg nextEnemyDraw
    
    movzx edx, byte ptr [esi]       ; dl = X
    mov dh, byte ptr [edi]          ; dh = Y
    call Gotoxy
    mov al, 'G'
    call WriteChar
nextEnemyDraw:
    add esi, 1                      ; Next X
    add edi, 1                      ; Next Y
    add ebx, 1                      ; Next Dir
    loop enemyDrawLoop
    ret
DrawEnemie ENDP


; ===== ERASE Koopas =====
updateKoopas PROC
mov eax, white+(bgColor*16) 
    call SetTextColor
    movzx ecx, KoopasCount
    mov esi, OFFSET KoopasX
    mov edi, OFFSET KoopasY
    mov ebx, OFFSET KoopasActive  

enemyEraseLoop:
    cmp byte ptr [ebx], 0         
    je nextEnemyErase      

    cmp byte ptr [esi], 0
    jl nextEnemyErase
    cmp byte ptr [esi], 115
    jg nextEnemyErase
    
    mov dl, byte ptr [esi]       ; dl = X position
    mov dh, byte ptr [edi]       ; dh = Y position
    call Gotoxy
    mov al, ' '
    call WriteChar
    
nextEnemyErase:
    inc esi                      ; Next enemy X
    inc edi                      ; Next enemy Y
    inc ebx                      ; Next enemy active
    loop enemyEraseLoop
    ret
updateKoopas ENDP


; ===== DRAW Koopas =====
DrawKoopas PROC
    movzx ecx, KoopasCount
    mov esi, OFFSET KoopasX
    mov edi, OFFSET KoopasY
    mov ebx, OFFSET KoopasActive   
    
enemyDrawLoop:
    cmp byte ptr [ebx], 0  
    je nextEnemyDraw              

    mov al, [esi]                   ; X pos
    cmp al, 0
    jl nextEnemyDraw
    cmp al, 115
    jg nextEnemyDraw
    
    movzx edx, byte ptr [esi]       ; dl = X
    mov dh, byte ptr [edi]          ; dh = Y
    call Gotoxy
    mov al, Koopas
    call WriteChar
nextEnemyDraw:
    add esi, 1                      ; Next X
    add edi, 1                      ; Next Y
    add ebx, 1                      ; Next Dir
    loop enemyDrawLoop
    ret
DrawKoopas ENDP

; ===== DRAW PLAYER =====
DrawPlayer PROC
    mov eax,blue+(bgColor*16)
    call setTextColor

    cmp powerUpActive, 1
    je drawTall
    
    
    mov dl, xPos
    mov dh, yPos
    call Gotoxy
    mov al, "X"
    call WriteChar
    jmp donePlayer
    
drawTall:
    ; TALL 1x3
    
    movzx ebx, xPos
    
    mov dl, bl
    mov dh, yPos
    sub dh,2
    inc dh
    call Gotoxy
    mov al, "X"  ; Body
    call WriteChar
    inc dh
    call Gotoxy
    mov al, "X"  ; Feet
    call WriteChar
donePlayer:
    mov eax, white+(bgColor*16)
    call SetTextColor
    ret
DrawPlayer ENDP

UpdatePlayer PROC
mov eax, white+(bgColor*16) 
    call SetTextColor
    cmp powerUpActive, 1
    je eraseTall
    
    ; Erase normal
    mov dl, xPos
    mov dh, yPos
    call Gotoxy
    mov al, " "
    call WriteChar
    ret
    
eraseTall:
    mov dh, yPos
    mov dl, xPos
    sub dh,2

    inc dh
    call Gotoxy
    mov al, ' '
    call WriteChar

    inc dh
    call Gotoxy
    mov al, ' '
    call WriteChar
    ret
UpdatePlayer ENDP



DrawBosslevel PROC
    
    mov eax, 8+(bgcolor*16)
    call setTextColor
    mov eax, 28      
    mov ecx, 9      
    
bossLoop:
    
    mov dl, 0        
    mov dh, al       
    call Gotoxy
    mov edx, OFFSET bossground
    call WriteString
    
    dec eax          
    loop bossLoop    

    mov eax, 28      
    mov ecx, 9      
    
bossLoop1:
    mov dl, 30        
    mov dh, al       
    call Gotoxy
    mov edx, OFFSET bossground1
    call WriteString
    
    dec eax          
    loop bossLoop1

    mov eax, 28      
    mov ecx, 9      
    
bossLoop2:
    mov dl, 45        
    mov dh, al       
    call Gotoxy
    mov edx, OFFSET bossground2
    call WriteString
    
    dec eax          
    loop bossLoop2

    mov yPos,al
    mov groundY,al
    ret
DrawBosslevel ENDP


; ===== DRAW COIN =====
drawCoin PROC
    mov eax, yellow + (bgColor * 16)
    call SetTextColor

    mov esi,offset coinxPos
    mov edi,offset coinyPos
    movzx ecx,coinCount

    coinLoop:
    mov dl, [esi]
    mov dh, [edi]
    call Gotoxy
    mov al, "O"
    call WriteChar
    inc esi 
    inc edi
    loop coinLoop
    
    mov eax, white+(bgColor*16)   ; Reset color
    call SetTextColor

    ret
drawCoin ENDP

; ===== COIN POSITION =====
coinPos PROC
    mov coinCount,0
    mov coinyPos, 25
    mov coinxPos, 54
    inc coinCount

    mov coinyPos+1, 24
    mov coinxPos+1, 40
    inc coinCount

    ret
coinPos ENDP

coinCollision PROC 
    
    mov esi,offset coinxPos
    mov edi,offset coinyPos
    movzx ecx,coinCount

    coinLoop:
    mov eax,0
    mov ebx,0

     ; Check X overlap: |playerX - coinX| <= 1
    mov al, xPos
    sub al, [esi]
    cmp al, -1
    jl skipCoin
    cmp al, 0
    jg skipCoin

    ; Check Y overlap: |playerY - coinY| <= 1
    mov al, yPos
    sub al, [edi]
    cmp al, -1
    jl skipCoin
    cmp al, 0
    jg skipCoin
    
    mov byte ptr [esi],255
    mov byte ptr [edi],255
    
    mov dl, [esi]              ; Use ORIGINAL position (before 255)
    mov dh, [edi]
    call Gotoxy
    mov al, ' '
    call WriteChar

  call PlayCoinSound
    add score,200
    call updateScore
    jmp nextCoin

    skipCoin:
    inc esi 
    inc edi
    loop coinLoop
    nextCoin:
    
    ret
coinCollision ENDP

updateScore PROC
mov eax, white+(bgColor*16) 
    call SetTextColor
    mov dl,0
    mov dh,0
    call Gotoxy
    mov edx,OFFSET strScore
    call WriteString
    mov eax,score
    call WriteInt
    ret
updateScore ENDP

; ===== PIPE COLLISION =====
; ===== PLAYER LANDS ON TOP OF PIPE =====
pipecollide PROC
    movzx ecx, pipeCount
    test ecx, ecx
    jz noPipes        ; No pipes = exit
    
    mov esi, OFFSET pipeX
    mov edi, OFFSET pipeY
    mov ebx, 0        ; Pipe index counter
    
pipeLoop:
    
    ; ===== X COLLISION: Player over pipe base =====
    movzx eax, xPos
    movzx edx, byte ptr [esi]    ; pipeX
    sub edx,3
    cmp eax, edx
    jb nextPipe                  ; Player left of pipe

    add edx,6
    cmp eax, edx
    ja nextPipe                  ; Player left of pipe

    ; ===== CALCULATE PIPE TOP Y =====
    movzx edx, byte ptr [edi]    ; pipe bottom Y (28)
    mov al, pipeheight[ebx]      ; pipe height (2 or 3)
    sub dl, al                  
    
    ; ===== Y COLLISION: Player falling onto pipe top =====
    mov al, yPos
    cmp al, dl                   ; playerY >= pipeTopY?
    jb nextPipe                  ; Too high, no collision
    
    ; ===== LAND ON PIPE TOP! =====
    dec dl
    mov yPos, dl                 ; SNAP player to pipe top exactly
    mov velocityY, 0             ; Stop falling
    mov velocityX, 0             ; Stop horizontal (optional)
    mov jumpCount, 0          
    jmp donePipe                 ; Exit after landing
    
nextPipe:
    inc esi                      ; Next pipeX
    inc edi                      ; Next pipeY
    inc ebx                      ; Next pipe index
    loop pipeLoop
    
noPipes:
donePipe:
    ret
pipecollide ENDP


; ===== PLATFORM COLLISION =====
collideplatform PROC
    
    mov esi, OFFSET platX
    mov edi, OFFSET platY

    movzx ecx, platCount     

platLoop:
    movzx eax, xPos
    movzx ebx, byte ptr [esi] 
    cmp eax, ebx
    jb skipPlatform
    mov edx, ebx
    add edx, 11               
    cmp eax, edx
    ja skipPlatform

    movsx eax, yPos           
    mov ebx, velocityY 
    add eax, ebx       

    movsx edx, byte ptr [edi] 

    mov ebp, velocityY
    cmp ebp, 0
    jle skipPlatform 

    
    cmp eax, edx
    jle skipPlatform  

    mov dl, byte ptr [edi]
    dec dl                
    mov yPos, dl
    mov dword ptr velocityY, 0
    mov velocityX, 0
    mov velocityY, 0
    mov jumpCount, 0

    jmp done

skipPlatform:
    inc esi
    inc edi
loop platLoop

mov eax,ebp
mov ebx,esp
done:
ret
collideplatform ENDP

startScreen PROC
    call Clrscr
    call PlayLevelSound
    ; ====== Title fade-in effect ======
    mov ecx, 15 
    
fadeLoop:
    mov eax,  Red+(15 * 16) 
    call SetTextColor

    mov dl, 30
    mov dh, 5
    call Gotoxy
    mov edx, OFFSET msgTitle
    call WriteString

    mov eax, 40
    call Delay

    loop fadeLoop


    ; ====== ASCII Frame ======
    mov eax, Yellow + (Blue * 16)
    call SetTextColor

    mov edx, OFFSET frameTop
    mov dl, 20
    mov dh, 7
    call Gotoxy
    call WriteString

    mov edx, OFFSET frameMid
    mov dl, 20
    mov dh, 8
    call Gotoxy
    call WriteString

    mov dl, 20
    mov dh, 9
    call Gotoxy
    call WriteString


    ; ====== Name input ======
    mov eax, LightGreen + (black * 16)
    call SetTextColor

    mov dl, 30
    mov dh, 12
    call Gotoxy
    mov edx, OFFSET msgName
    call WriteString

    mov edx, OFFSET nameIN
    mov ecx, 200
    call ReadString


    ; ====== Blinking PRESS ENTER ======
pressLoop:
    ; show text
    mov eax, LightCyan + (Black * 16)
    call SetTextColor

    mov dl, 30
    mov dh, 15
    call Gotoxy
    mov edx, OFFSET msgPressEnter
    call WriteString
    mov eax, 350
    call Delay


    ; hide text
    mov dl, 30
    mov dh, 15
    call Gotoxy
    mov edx, OFFSET blankPress
    call WriteString
    mov eax, 300
    call Delay


    call ReadKey
    cmp al, 13     
    jne pressLoop

    ret
startScreen ENDP


pauseScreen PROC
    call Clrscr
    mov eax, Red + (blue * 16)
    call SetTextColor

    mov dl, 45
    mov dh, 10
    call Gotoxy
    mov edx, OFFSET ResumeMsg
    call WriteString

    mov dl, 47
    mov dh, 14
    call Gotoxy
    mov edx, OFFSET ExitMsg
    call WriteString

waitKey:
    call ReadKey
    cmp al, 'r'
    je resumeGame
    cmp al, 'e'
    je exitGame
    jmp waitKey

resumeGame:
    ret                    ; Just return to game loop!

exitGame:
    jmp exitGame           ; Your existing exit label
pauseScreen ENDP

exitGame PROC
    mov eax, 0        ; Exit code 0
    call ExitProcess  ; Call Windows API to exit program
exitGame ENDP

RedrawGame PROC
; Redraw ground
    mov dl,0
    mov dh,29
    call Gotoxy
    mov edx,OFFSET ground
    call WriteString

    ; Redraw platforms
    mov dl,20
    mov dh,26
    call Gotoxy
    mov edx,OFFSET platform
    call WriteString

    mov dl,20
    mov dh,20
    call Gotoxy
    mov edx,OFFSET platform
    call WriteString
    
    call DrawCoin
    call DrawBlock
    ret
    RedrawGame Endp



; ===== ENEMY MOVEMENT =====
enemieCollisionDir PROC
    inc enemySpeedCounter
    mov al, enemySpeedCounter
    cmp al, enemySpeedLimit
    jb skipAllEnemies
    
    mov enemySpeedCounter, 0
    movzx ecx, enemyCount
    mov esi, OFFSET enemieX
    mov edi, OFFSET enemieY
    mov ebx, OFFSET enemieDir
    push ebp
    mov ebp, OFFSET enemyActive   
    
enemyMoveLoop:
    cmp byte ptr [ebp], 0         
    je nextEnemyMove              
    
    mov al, [ebx]                   
    cmp al, 0
    je moveLeftEnemy
    cmp al, 1
    je moveRightEnemy
    jmp nextEnemyMove
    
moveLeftEnemy:
    ; ===== PIPE COLLISION CHECK FOR THIS ENEMY =====
    push ecx 
    push esi 
    push edi              ; Save registers
    movzx edx, byte ptr [esi]     ; EDX = THIS enemy's X
    movzx ecx, pipeCount
    
pipeLeftLoop:
    mov al,pipeX[ecx-1]
    inc al
    cmp dl, al          ; THIS enemyX == pipeX?
    jne nextPipeLeft
    
    mov al, pipeY[ecx-1]          ; pipe bottom Y
    sub al, pipeheight[ecx-1]     ; pipe top Y
    cmp byte ptr [edi], al        ; enemyY in pipe range?
    jae pipeHitLeft               ; Yes = collision!
    
nextPipeLeft:
    loop pipeLeftLoop
    pop edi 
    pop esi 
    pop ecx               ; Restore
    jmp checkScreenLeft           ; No pipe collision
    
pipeHitLeft:
    pop edi 
    pop esi 
    pop ecx 
    mov byte ptr [ebx], 1         ; Turn RIGHT
    inc byte ptr [esi]            ; Move right
    jmp nextEnemyMove
    
checkScreenLeft:
    cmp byte ptr [esi], 2
    jne decEnemyX
    mov byte ptr [ebx], 1
    inc byte ptr [esi]
    jmp nextEnemyMove
    
decEnemyX:
    dec byte ptr [esi]
    jmp nextEnemyMove
    
moveRightEnemy:
    ; ===== PIPE COLLISION CHECK FOR THIS ENEMY =====
    push ecx 
    push esi 
    push edi
    movzx edx, byte ptr [esi]     ; EDX = THIS enemy's X  
    movzx ecx, pipeCount
    
pipeRightLoop:
    mov al,pipeX[ecx-1]
    dec al
    cmp dl, al          ; THIS enemyX == pipeX?
    jne nextPipeRight
    
    mov al, pipeY[ecx-1]          ; pipe bottom Y
    sub al, pipeheight[ecx-1]     ; pipe top Y
    cmp byte ptr [edi], al        ; enemyY in pipe range?
    jae pipeHitRight
    
nextPipeRight:
    loop pipeRightLoop
    pop edi 
    pop esi 
    pop ecx 
    jmp checkScreenRight
    
pipeHitRight:
pop edi 
    pop esi 
    pop ecx 
    mov byte ptr [ebx], 0         ; Turn LEFT
    dec byte ptr [esi]            ; Move left
    jmp nextEnemyMove
    
checkScreenRight:
    cmp byte ptr [esi], 115
    jne incEnemyX
    mov byte ptr [ebx], 0
    dec byte ptr [esi]
    jmp nextEnemyMove
    
incEnemyX:
    inc byte ptr [esi]
    
nextEnemyMove:
    inc esi
    inc edi
    inc ebx
    inc ebp
    dec ecx
    jnz enemyMoveLoop
    
    pop ebp
skipAllEnemies:
    mov eax, 1
    ret
enemieCollisionDir ENDP

; ===== INPUT HANDLER =====
HandleInput PROC
    mov velocityX, 0      ; Friction (horizontal only)

    ; A - Left
    INVOKE GetAsyncKeyState, VK_A
    test ax, 8000h
    jz checkW
    mov velocityX, -2

checkW:
    INVOKE GetAsyncKeyState, VK_W
    test ax, 8000h
    jz checkD

call jump
checkD:
    INVOKE GetAsyncKeyState, VK_D
    test ax, 8000h
    jz checkP
    mov velocityX, 2       ; Overrides A

checkP:
    INVOKE GetAsyncKeyState, VK_P     
    test ax, 8000h
    jz checkX
    call pauseScreen     ; Your pause handler

checkX:
    INVOKE GetAsyncKeyState, VK_X   
    test ax, 8000h
    jz checkF
    jmp exitGame          ; Exit game

checkF:
    INVOKE GetAsyncKeyState, VK_F
    test ax, 8000h
    jz doneInput
    cmp bulletActive, 0
    jne doneInput
    mov bulletActive, 1
    mov al, xPos
    inc al
    mov bulletX, al
    mov al, yPos
    mov bulletY, al

doneInput:
    ret
HandleInput ENDP

; ===== GROUND COLLISION ONLY =====
GroundCollision PROC
    mov al, yPos
    cmp al, groundY
    jle doneGround
    
    mov al, groundY
    mov yPos, al
    mov velocityY, 0
    mov jumpCount, 0  ; Keep velocityX for walking!

doneGround:
    ret
GroundCollision ENDP

; ===== KOOPAS MOVEMENT WITH PIPE COLLISION =====
KoopasCollisionDir PROC
    inc KoopasSpeedCounter
    mov al, KoopasSpeedCounter
    cmp al, enemySpeedLimit
    jb skipAllEnemies
    
    mov KoopasSpeedCounter, 0
    movzx ecx, KoopasCount
    mov esi, OFFSET KoopasX
    mov edi, OFFSET KoopasY
    mov ebx, OFFSET KoopasDir
    push ebp
    mov ebp, OFFSET KoopasActive   
    
koopaMoveLoop:
    cmp byte ptr [ebp], 0         
    je nextKoopaMove              
    
    mov al, [ebx]                   
    cmp al, 0
    je moveLeftKoopa
    cmp al, 1
    je moveRightKoopa
    jmp nextKoopaMove
    
moveLeftKoopa:
    ; ===== PIPE COLLISION CHECK FOR THIS KOOPA =====
    push ecx                       ; Save ECX only
    push edi                       ; Save EDI only
    movzx edx, byte ptr [esi]      ; EDX = THIS koopa's X (ESI safe)
    movzx ecx, pipeCount           ; New pipe loop counter
    
pipeLeftLoop:
    test ecx, ecx
    jz noPipeLeftK                 ; No pipes = no collision

    mov al,pipeX[ecx-1]
    inc al
    cmp dl, al          ; THIS koopaX == pipeX?
    jne nextPipeLeftK
    
    mov al, pipeY[ecx-1]          ; pipe bottom Y
    sub al, pipeheight[ecx-1]     ; pipe top Y
    cmp byte ptr [edi], al        ; koopaY in pipe range?
    jae pipeHitLeftK              ; Yes = collision!
    
nextPipeLeftK:
    loop pipeLeftLoop
noPipeLeftK:
    pop edi                        ; Restore EDI
    pop ecx                        ; Restore ECX
    jmp checkScreenLeftK          ; No pipe collision
    
pipeHitLeftK:
    pop edi                        ; Restore EDI
    pop ecx                        ; Restore ECX
    mov byte ptr [ebx], 1         ; Turn RIGHT
    inc byte ptr [esi]            ; Move right
    jmp nextKoopaMove
    
checkScreenLeftK:
    cmp byte ptr [esi], 2
    jne decKoopaX
    mov byte ptr [ebx], 1
    inc byte ptr [esi]
    jmp nextKoopaMove
    
decKoopaX:
    dec byte ptr [esi]
    jmp nextKoopaMove
    
moveRightKoopa:
    ; ===== PIPE COLLISION CHECK FOR THIS KOOPA =====
    push ecx                       ; Save ECX only
    push edi                       ; Save EDI only
    movzx edx, byte ptr [esi]      ; EDX = THIS koopa's X (ESI safe)
    movzx ecx, pipeCount           ; New pipe loop counter
    
pipeRightLoop:
    test ecx, ecx
    jz noPipeRightK               ; No pipes = no collision
    
    mov al,pipeX[ecx-1]
    dec al
    cmp dl, al          ; THIS koopaX == pipeX?
    jne nextPipeRightK
    
    mov al, pipeY[ecx-1]          ; pipe bottom Y
    sub al, pipeheight[ecx-1]     ; pipe top Y
    cmp byte ptr [edi], al        ; koopaY in pipe range?
    jae pipeHitRightK
    
nextPipeRightK:
    loop pipeRightLoop
noPipeRightK:
    pop edi                        ; Restore EDI
    pop ecx                        ; Restore ECX
    jmp checkScreenRightK
    
pipeHitRightK:
    pop edi                        ; Restore EDI
    pop ecx                        ; Restore ECX
    mov byte ptr [ebx], 0         ; Turn LEFT
    dec byte ptr [esi]            ; Move left
    jmp nextKoopaMove
    
checkScreenRightK:
    cmp byte ptr [esi], 115
    jne incKoopaX
    mov byte ptr [ebx], 0
    dec byte ptr [esi]
    jmp nextKoopaMove
    
incKoopaX:
    inc byte ptr [esi]
    
nextKoopaMove:
    inc esi
    inc edi
    inc ebx
    inc ebp
    dec ecx
    jnz koopaMoveLoop
    
    pop ebp
skipAllEnemies:
    mov eax, 1
    ret
KoopasCollisionDir ENDP


    DrawMap PROC
    mov dl,0
    mov dh,29
    call Gotoxy
    mov edx,OFFSET ground
    call WriteString

    mov eax,28
    mov ebx,0

    l1:
        mov dl,bl
        mov dh,al
        call Gotoxy
        mov edx,OFFSET ground1
        call WriteString
        dec al
        cmp al,2
    jne l1

        mov dl,0
        mov dh,1
        call Gotoxy
        mov edx,OFFSET ground
        call WriteString

    ret
    DrawMap ENDP



KoopasPlayer PROC
    movzx ecx, KoopasCount
    mov esi, OFFSET KoopasX
    mov edi, OFFSET KoopasY
    mov ebx, OFFSET KoopasActive    
    
collideLoop:
    cmp byte ptr [ebx], 0
    je nextCollide
    
    ; ===== X COLLISION =====
    movzx eax, xPos
    movzx edx, byte ptr [esi]
    sub eax, edx            
    cmp eax, -1
    jl nextCollide
    cmp eax, 1
    jg nextCollide
    
    ; ===== Y COLLISION =====
    movzx eax, yPos
    movzx edx, byte ptr [edi]
    sub eax, edx   
    
    cmp eax, 0
    jl nextCollide     
    
    cmp eax, 0
    jne nextCollide    
    
    mov edx, velocityY
    cmp edx, 2        
    jge nextCollide   
    
hitPlayer:
    dec lives
    call updateLives
    
    ; Knockback
    mov al, xPos
    mov dl, byte ptr [esi]
    cmp al, dl
    jl movePlayerLeft
    
movePlayerRight:
    add al, 5
    mov xPos, al
    jmp endCollide
    
movePlayerLeft:
    sub al, 5
    mov xPos, al
    jmp endCollide
    
nextCollide:
    inc esi
    inc edi
    inc ebx
    loop collideLoop
    
endCollide:
    ret
KoopasPlayer ENDP

enemiePlayer PROC
    movzx ecx, enemyCount
    mov esi, OFFSET enemieX
    mov edi, OFFSET enemieY
    mov ebx, OFFSET enemyActive    
    
collideLoop:
    cmp byte ptr [ebx], 0
    je nextCollide
    
    ; ===== X COLLISION =====
    movzx eax, xPos
    movzx edx, byte ptr [esi]
    sub eax, edx                    ; eax = xPos - enemyX
    cmp eax, -1
    jl nextCollide
    cmp eax, 1
    jg nextCollide
    
    ; ===== Y COLLISION =====
    movzx eax, yPos
    movzx edx, byte ptr [edi]
    sub eax, edx                    ; eax = yPos - enemyY
    
    ; If yPos - enemyY is NEGATIVE, player is ABOVE enemy (stomp zone)
    cmp eax, 0
    jl nextCollide                  ; Player above = skip damage
    
    ; If exactly 0, they're at same Y level = side collision = damage
    cmp eax, 0
    jne nextCollide                 ; Only damage if exactly same level
    
    ; Additional safety: Don't damage if player is falling fast
    mov edx, velocityY
    cmp edx, 2                      ; If falling with velocity > 2
    jge nextCollide                 ; Skip (they're stomping)
    
hitPlayer:
    dec lives
    call updateLives
    
    ; Knockback
    mov al, xPos
    mov dl, byte ptr [esi]
    cmp al, dl
    jl movePlayerLeft
    
movePlayerRight:
    add al, 5
    mov xPos, al
    jmp endCollide
    
movePlayerLeft:
    sub al, 5
    mov xPos, al
    jmp endCollide
    
nextCollide:
    inc esi
    inc edi
    inc ebx
    loop collideLoop
    
endCollide:
    ret
enemiePlayer ENDP

    updateLives PROC
    mov eax, white+(bgColor*16) 
    call SetTextColor
    mov dl,70
    mov dh,0
    call Gotoxy
    mov edx,OFFSET strlives
    call WriteString
    mov eax,lives
    call WriteInt
    ret
    updateLives ENDP





   




enemiePlayerCollide PROC
    movzx ecx, enemyCount
    mov esi, OFFSET enemieX
    mov edi, OFFSET enemieY
    mov ebx, OFFSET enemyActive
    
enemyStompLoop:
    cmp byte ptr [ebx], 0    
    je nextStomp
    
    
    movzx edx, xPos
    movzx eax, byte ptr [esi] 
    sub edx, eax
    cmp edx, -1
    jl nextStomp
    cmp edx, 1
    jg nextStomp
    
    
    movzx eax, yPos
    movzx edx, byte ptr [edi]
    dec edx
    sub eax, edx
    cmp eax, 0
    jl nextStomp
    cmp eax, 1
    jg nextStomp
    
    
    mov velocityY, -3
    mov byte ptr [ebx], 0
    mov byte ptr [esi], 255
    mov byte ptr [edi], 255
    add score, 100
    call updateScore
    
nextStomp:
    inc esi
    inc edi
    inc ebx
    loop enemyStompLoop
    ret
enemiePlayerCollide ENDP

; Add to your KoopasPlayerCollide procedure:
KoopasPlayerCollide PROC
    movzx ecx, KoopasCount
    mov esi, OFFSET KoopasX
    mov edi, OFFSET KoopasY
    mov ebx, OFFSET KoopasActive
    
enemyStompLoop:
    cmp byte ptr [ebx], 0    
    je nextStomp
    
    movzx edx, xPos
    movzx eax, byte ptr [esi] 
    sub edx, eax
    cmp edx, -1
    jl nextStomp
    cmp edx, 1
    jg nextStomp
    
    movzx eax, yPos
    movzx edx, byte ptr [edi]
    dec edx
    sub eax, edx
    cmp eax, 0
    jl nextStomp
    cmp eax, 1
    jg nextStomp
    
    ; ===== CREATE SHELL =====
    movzx edx, shellCount
    mov al, [esi]
    mov shellX[edx], al
    mov al, [edi]
    mov shellY[edx], al
    mov shellActive[edx], 1
    inc shellCount
    
    mov velocityY, -3
    mov byte ptr [ebx], 0
    mov byte ptr [esi], 255
    mov byte ptr [edi], 255

    add score, 100
    call updateScore
    
nextStomp:
    inc esi
    inc edi
    inc ebx
    loop enemyStompLoop
    ret
KoopasPlayerCollide ENDP

; ===== SHELL AND PLAYER COLLISION =====
ShellPlayerCollide PROC
    movzx ecx, shellCount
    test ecx, ecx
    jz noShells
    
    mov esi, OFFSET shellX
    mov edi, OFFSET shellY
    mov ebx, OFFSET shellActive
    
shellStompLoop:
    cmp byte ptr [ebx], 0    
    je nextShell
    
    ; ===== X COLLISION =====
    movzx edx, xPos
    movzx eax, byte ptr [esi] 
    sub edx, eax
    cmp edx, -1
    jl nextShell
    cmp edx, 1
    jg nextShell
    
    ; ===== Y COLLISION (from above = stomp) =====
    movzx eax, yPos
    movzx edx, byte ptr [edi]
    dec edx                  ; Check if player is above shell
    sub eax, edx
    cmp eax, 0
    jl nextShell             ; Player not above
    cmp eax, 1
    jg nextShell
    
    ; ===== STOMP SHELL - KICK IT! =====
    mov velocityY, -3        ; Player bounces up
    
    ; Determine kick direction based on player position
    mov al, xPos
    mov dl, byte ptr [esi]
    cmp al, dl
    jl kickRight
    
kickLeft:
    mov byte ptr [ebx], 0  ; Set direction to LEFT
    jmp nextShell
    
kickRight:
    mov byte ptr [ebx], 1  ; Set direction to RIGHT
    jmp nextShell

nextShell:
    inc esi
    inc edi
    inc ebx
    loop shellStompLoop
    
noShells:
    ret
ShellPlayerCollide ENDP
; Add this to your code:

UpdateShell PROC
mov eax, white+(bgColor*16) 
    call SetTextColor
    movzx ecx, shellCount
    test ecx, ecx
    jz noShells
    
    mov esi, OFFSET shellX
    mov edi, OFFSET shellY
    mov ebx, OFFSET shellDir
    mov edx, OFFSET shellActive
    
shellMoveLoop:
    cmp byte ptr [edx], 0
    je nextShell
    
    mov al, [ebx]  ; Get direction
    cmp al, 2      ; Stopped?
    je nextShell
    
    cmp al, 0      ; Moving left?
    je moveShellLeft
    
moveShellRight:
    mov al,shellspeed
    add byte ptr [esi], al
    cmp byte ptr [esi], 115
    jge stopShell
    jmp nextShell
    
moveShellLeft:
    mov al,shellspeed
    sub byte ptr [esi], al
    cmp byte ptr [esi], 2
    jle stopShell
    jmp nextShell
    
stopShell:
    mov byte ptr [ebx], 2  ; Stop moving
    
nextShell:
    inc esi
    inc edi
    inc ebx
    inc edx
    loop shellMoveLoop
    
noShells:
    ret
UpdateShell ENDP
initEnemies PROC
    
    mov enemieX[0], 80
    mov enemieY[0], 28
    mov enemieDir[0], 1
    
    mov enemieX[1], 110
    mov enemieY[1], 28
    mov enemieDir[1], 0
    
    mov enemieX[2], 115
    mov enemieY[2], 28
    mov enemieDir[2], 0
    
    mov ecx, MAX_ENEMIES
    mov edi, OFFSET enemyActive
initActiveLoop:
    mov byte ptr [edi], 1
    inc edi
    loop initActiveLoop
    ret
initEnemies ENDP



initKoopas PROC
    
    mov KoopasX[0], 50
    mov KoopasY[0], 28
    mov KoopasDir[0], 1
    
    mov KoopasX[1], 100
    mov KoopasY[1], 28
    mov KoopasDir[1], 0
    
    mov KoopasX[2], 15
    mov KoopasY[2], 28
    mov KoopasDir[2], 0
    
    mov ecx, MAX_Koopas
    mov edi, OFFSET KoopasActive
initActiveLoop:
    mov byte ptr [edi], 1
    inc edi
    loop initActiveLoop
    ret
initKoopas ENDP

initPipes PROC
mov pipeX[0],48
mov pipeY[0],28
mov pipeheight[0],2

mov pipeX[1],13
mov pipeY[1],28
mov pipeheight[1],3

mov pipeCount,2
ret
initPipes ENDP

; ===== BULLET vs ENEMY COLLISION =====
call bulletEnemyCollision

bulletEnemyCollision PROC
    cmp bulletActive, 0
    je noBulletCollision
    
    movzx ecx, enemyCount
    mov esi, OFFSET enemieX
    mov edi, OFFSET enemieY
    mov ebx, OFFSET enemyActive
    
bulletEnemyLoop:
    cmp byte ptr [ebx], 0
    je nextBulletEnemy
    
    movzx edx, bulletX
    movzx eax, byte ptr [esi]
    sub edx, eax
    cmp edx, -1
    jl nextBulletEnemy
    cmp edx, 1
    jg nextBulletEnemy
    
    movzx edx, bulletY
    movzx eax, byte ptr [edi]
    sub edx, eax
    cmp edx, -1
    jl nextBulletEnemy
    cmp edx, 1
    jg nextBulletEnemy
    
    mov byte ptr [ebx], 0
    mov byte ptr [esi], 255
    mov byte ptr [edi], 255
    mov bulletActive, 0
    
    add score, 150         
    call updateScore
    
    jmp bulletDone2
    
nextBulletEnemy:
    inc esi
    inc edi
    inc ebx
    loop bulletEnemyLoop
    
noBulletCollision:
bulletDone2:
    ret
bulletEnemyCollision ENDP

call bulletKoopasCollision

bulletKoopasCollision PROC
    cmp bulletActive, 0
    je noBulletCollision
    
    movzx ecx, KoopasCount
    mov esi, OFFSET KoopasX
    mov edi, OFFSET KoopasY
    mov ebx, OFFSET KoopasActive
    
bulletEnemyLoop:
    cmp byte ptr [ebx], 0
    je nextBulletEnemy
    
    movzx edx, bulletX
    movzx eax, byte ptr [esi]
    sub edx, eax
    cmp edx, -1
    jl nextBulletEnemy
    cmp edx, 1
    jg nextBulletEnemy
    
    movzx edx, bulletY
    movzx eax, byte ptr [edi]
    sub edx, eax
    cmp edx, -1
    jl nextBulletEnemy
    cmp edx, 1
    jg nextBulletEnemy
    
    mov byte ptr [ebx], 0
    mov byte ptr [esi], 255
    mov byte ptr [edi], 255
    mov bulletActive, 0
    
    add score, 150         
    call updateScore
    
    jmp bulletDone2
    
nextBulletEnemy:
    inc esi
    inc edi
    inc ebx
    loop bulletEnemyLoop
    
noBulletCollision:
bulletDone2:
    ret
bulletKoopasCollision ENDP

; ===== UPDATE BULLET POSITION =====
updateBulletPos PROC
mov eax, white+(bgColor*16) 
    call SetTextColor
    cmp bulletActive, 0
    je bulletInactive
    
    ; Move bullet right
    mov al, bulletX
    add al, bulletSpeed
    mov bulletX, al
    
    ; Check screen edge
    cmp al, bulletMaxX
    jg deactivateBullet
    
    ; Erase old position
    mov dl, bulletX
    sub dl, bulletSpeed
    mov dh, bulletY
    call Gotoxy
    mov al, ' '
    call WriteChar
    
    ; Draw new position
    mov eax, blue + (bgColor * 16)
    call SetTextColor
    mov dl, bulletX
    mov dh, bulletY
    call Gotoxy
    mov al, '*'
    call WriteChar
    jmp bulletDone
    
deactivateBullet:
    mov bulletActive, 0
    mov dl, bulletX
    mov dh, bulletY
    call Gotoxy
    mov al, ' '
    call WriteChar
    
bulletInactive:
bulletDone:
    mov eax, white + (bgColor * 16)
    call SetTextColor
    ret
updateBulletPos ENDP

DrawBlock PROC
mov eax,brown+(black*16)
call SetTextColor

mov blockCount,0
mov blockX[0],62
mov blockY[0],26

mov dl,blockX[0]
mov dh,blockY[0]
call Gotoxy
mov edx,offset block
call WriteString

mov blockX[1],40
mov blockY[1],20

mov dl,blockX[1]
mov dh,blockY[1]
call Gotoxy
mov edx,offset block
call WriteString

mov blockCount,2
mov eax, white + (bgColor * 16)
call SetTextColor
ret
DrawBlock ENDP

blockCollision PROC
    movzx ecx, blockCount
    test ecx, ecx
    jz noBlocks
    
    mov esi, OFFSET blockX
    mov edi, OFFSET blockY
    
    mov ebp,0
blockLoop:
    ; ===== X RANGE CHECK =====
    movzx eax, xPos
    movzx ebx, byte ptr [esi]
    cmp al, bl
    jb nextBlock
    
    movzx ebx, byte ptr [esi]
    add bl, 15
    cmp al, bl
    ja nextBlock
    
    ; ===== BOTTOM COLLISION ONLY (head hitting block from below) =====
    mov edx, velocityY      
    test edx, edx             
    jge nextBlock             
    
    movzx eax, yPos           
    movzx ebx, byte ptr [edi] 
    dec bl
    cmp al, bl                
    ja nextBlock         
    
        ; ====== POWER UP LOGIC ======
    movzx eax,byte ptr [esi]
    movzx ebx,byte ptr [edi]

    cmp pbool[ebp],1
    jne skipPower

    cmp al,xPos
    jne skipPower

    dec bl

    movzx edx,powerCount
    mov powerX[edx],al
    mov powerY[edx],bl
    inc powerCount

    mov dl,al
    mov dh,bl
    call Gotoxy
    mov eax,'P'
    call WriteChar
    mov pbool[ebp],0

    skipPower:
    cmp coinbool[ebp],1
    jne skipCoin
    ; ======== COIN LOGIC ========
     movzx eax,byte ptr [esi]
    add al,6
    cmp al,xpos
    jne skipCoin

   
    dec bl
    mov coinxPos[2],al
    mov coinyPos[2],bl
    mov coinCount,3
    call drawcoin
    mov coinbool[ebp],0

    mov eax, white+(bgColor*16)   ; Reset color
    call SetTextColor

skipCoin:
; ===== HEAD HIT! =====
    inc bl                    
    mov yPos, bl
    mov velocityY, 0          
    jmp doneCollision         
    
nextBlock:
    inc ebp
    inc esi
    inc edi
    dec ecx
    jnz blockLoop
    
doneCollision:
noBlocks:
    ret
blockCollision ENDP



jump PROC
    mov al, yPos
    cmp al, 18
    je resetJumpCount

    cmp al, 19
    jne checkDoubleJump 

resetJumpCount:
    mov jumpCount, 0 

checkDoubleJump:
    mov dl, jumpCount

    cmp dl, maxJumps 
    jae doneJump
    
    inc jumpCount
    mov velocityY, -3
    
    ret
doneJump:
    ret
jump ENDP

powerplayerCollision PROC 
    movzx ecx, powerCount
    test ecx, ecx
    jz noPower
    
    mov esi, OFFSET powerX
    mov edi, OFFSET powerY
    
powerLoop:
    ; X collision (±1)
    movzx eax, byte ptr [esi]
    movzx ebx, xPos
    sub eax, ebx
    cmp eax, 1
    jg nextPower
    cmp eax, -1
    jl nextPower
    
    ; Y collision
    movzx eax, byte ptr [edi]
    movzx ebx, yPos
    cmp eax, ebx
    jne nextPower
    
    ; *** POWER-UP! ***
    mov powerUpActive, 1
    mov powerTimer, 1000
    add score, 1000
    call updateScore
    
    ; Erase P
    mov dl, byte ptr [esi]
    mov dh, byte ptr [edi]
    call Gotoxy
    mov al, ' '
    call WriteChar

    dec powerCount
    
nextPower:
    inc esi
    inc edi
    loop powerLoop
noPower:
    ret
powerplayerCollision ENDP
fileHandling PROC
    mov scoreCount, 0
    
    ; ===== READ EXISTING FILE =====
    mov edx, OFFSET myFile
    call OpenInputFile
    cmp eax, INVALID_HANDLE_VALUE
    je noFile
    
    mov hFile, eax
    mov edx, OFFSET tempBuffer
    mov ecx, LENGTHOF tempBuffer - 1
    call ReadFromFile
    mov tempBuffer[eax], 0  ; Null terminate
    
    mov eax, hFile
    call CloseFile
    
    ; ===== PARSE EXISTING SCORES =====
    mov esi, OFFSET tempBuffer
    mov edi, 0  ; Index counter
    
parseLoop:
    cmp byte ptr [esi], 0
    je doneParsing
    
    ; Read name
    push edi
    mov ecx, 20
    imul edi, ecx
    lea edi, nameArray[edi]
    
readName:
    mov al, [esi]
    cmp al, ' '
    je doneReadingName
    cmp al, 0
    je doneReadingName
    cmp al, 13
    je doneReadingName
    cmp al, 10
    je doneReadingName
    
    mov [edi], al
    inc esi
    inc edi
    jmp readName
    
doneReadingName:
    mov byte ptr [edi], 0
    pop edi
    
    ; Skip space
    cmp byte ptr [esi], ' '
    jne skipSpace
    inc esi
skipSpace:
    
    ; Read score (convert ASCII to number)
    push edi
    xor eax, eax
    xor ebx, ebx
    
readScore:
    mov bl, [esi]
    cmp bl, '0'
    jb doneReadingScore
    cmp bl, '9'
    ja doneReadingScore
    
    sub bl, '0'
    imul eax, 10
    add eax, ebx
    inc esi
    jmp readScore
    
doneReadingScore:
    pop edi
    mov ebx, 4
    push eax
    mov eax, edi
    imul eax, ebx
    lea ebx, scoreArray[eax]
    pop eax
    mov [ebx], eax
    
    inc edi
    
    ; Skip newline
skipNewline:
    cmp byte ptr [esi], 13
    je skipCR
    cmp byte ptr [esi], 10
    je skipLF
    jmp continueparse
skipCR:
    inc esi
    jmp skipNewline
skipLF:
    inc esi
    jmp skipNewline
    
continueparse:
    jmp parseLoop
    
doneParsing:
    mov scoreCount, edi
    
noFile:
    ; ===== ADD NEW SCORE =====
    mov eax, scoreCount
    
    ; Copy name
    push eax
    mov ecx, 20
    imul eax, ecx
    lea edi, nameArray[eax]
    mov esi, OFFSET nameIN
    mov ecx, 20
    rep movsb
    pop eax
    
    ; Store score
    mov ebx, 4
    imul eax, ebx
    lea edi, scoreArray[eax]
    mov eax, score
    mov [edi], eax
    
    inc scoreCount
    
    ; ===== BUBBLE SORT (ASCENDING) =====
    mov ecx, scoreCount
    dec ecx
    cmp ecx, 0
    jle skipSort
    
outerLoop:
    push ecx
    xor esi, esi
    
innerLoop:
    ; Compare scores
    mov eax, esi
    shl eax, 2
    lea edi, scoreArray[eax]
    
    mov eax, [edi]
    mov ebx, [edi+4]
    
    cmp eax, ebx
    jle noSwap
    
    ; Swap scores
    mov [edi], ebx
    mov [edi+4], eax
    
    ; Swap names
    push esi
    mov eax, esi
    mov ebx, 20
    imul eax, ebx
    lea edi, nameArray[eax]
    lea esi, nameArray[eax+20]
    
    mov ecx, 20
swapLoop:
    mov al, [edi]
    mov bl, [esi]
    mov [edi], bl
    mov [esi], al
    inc edi
    inc esi
    loop swapLoop
    
    pop esi
    
noSwap:
    inc esi
    pop ecx
    push ecx
    cmp esi, ecx
    jl innerLoop
    
    pop ecx
    dec ecx
    jnz outerLoop
    
skipSort:
    ; ===== WRITE ALL TO FILE =====
    mov edx, OFFSET myFile
    call CreateOutputFile
    mov hFile, eax
    
    xor esi, esi
    
writeLoop:
    cmp esi, scoreCount
    jge doneWrite
    
    ; Write name
    push esi
    mov eax, esi
    mov ebx, 20
    imul eax, ebx
    lea edx, nameArray[eax]
    
    mov ecx, 0
    mov edi, edx
nameLen:
    cmp byte ptr [edi], 0
    je gotLen
    inc ecx
    inc edi
    jmp nameLen
gotLen:
    mov eax, hFile
    call WriteToFile
    pop esi
    
    ; Write space
    push esi
    mov eax, hFile
    mov al, ' '
    push eax
    mov edx, esp
    mov ecx, 1
    mov eax, hFile
    call WriteToFile
    add esp, 4
    pop esi
    
    ; Write score
    push esi
    mov eax, esi
    shl eax, 2
    lea edi, scoreArray[eax]
    mov eax, [edi]
    
    mov edi, OFFSET scoreBuffer + 19
    mov byte ptr [edi], 0
    dec edi
    mov ebx, 10
    
convLoop:
    xor edx, edx
    div ebx
    add dl, '0'
    mov [edi], dl
    dec edi
    test eax, eax
    jnz convLoop
    
    inc edi
    mov ecx, OFFSET scoreBuffer + 19
    sub ecx, edi
    mov eax, hFile
    mov edx, edi
    call WriteToFile
    pop esi
    
    ; Write newline
    push esi
    mov eax, hFile
    mov edx, OFFSET newline
    mov ecx, 2
    call WriteToFile
    pop esi
    
    inc esi
    jmp writeLoop
    
doneWrite:
    mov eax, hFile
    call CloseFile
    
ret
fileHandling ENDP
 PlayBackgroundMusic PROC
    mov eax, SND_FILENAME
    or eax, SND_ASYNC
    or eax, SND_LOOP
    INVOKE PlaySound, ADDR bgMusic, NULL, eax
    ret
PlayBackgroundMusic ENDP

; ===== STOP BACKGROUND MUSIC =====
StopBackgroundMusic PROC
    INVOKE PlaySound, NULL, NULL, 0
    ret
StopBackgroundMusic ENDP
; ===== PLAY INTRO SOUND =====
PlayIntroSound PROC
    mov eax, SND_FILENAME
    or eax, SND_ASYNC
    or eax, SND_NODEFAULT
    INVOKE PlaySound, ADDR introSound, NULL, eax
    ret
PlayIntroSound ENDP

; ===== PLAY COIN SOUND (WITHOUT STOPPING BACKGROUND MUSIC) =====
PlayCoinSound PROC
    mov eax, SND_FILENAME
    or eax, SND_ASYNC
    INVOKE PlaySound, ADDR coinSound, NULL, eax
    
    mov eax, 500
    call Delay
    
    ; Restart background music
    call PlayBackgroundMusic

    ret
PlayCoinSound ENDP
EraseBoss PROC
    movzx edx, bossX
    mov ax,bossY
    mov dh, al
    call Gotoxy
    mov al, ' '          ; Erase with space
    call WriteChar
    ret
EraseBoss ENDP
EraseFireball PROC
    cmp fireballActive, 0
    je noFireball
    mov ax,fireballX
    mov dl, al
    mov ax,fireballY
    mov dh, al
    call Gotoxy
    mov al, ' '
    call WriteChar
noFireball:
    ret
EraseFireball ENDP
; ===== PLAY DEATH SOUND =====
PlayDeathSound PROC
    ; Stop background music first, then play death sound
    call StopBackgroundMusic
    mov eax, 500
    call Delay
    
    mov eax, SND_FILENAME
    or eax, SND_SYNC        ; Use SYNC to wait for death sound to finish
    INVOKE PlaySound, ADDR deathSound, NULL, eax
    ret
PlayDeathSound ENDP

; ===== PLAY LEVEL SOUND =====
PlayLevelSound PROC
    ; Stop background music first
    call StopBackgroundMusic
    mov eax, 500
    call Delay
    
    mov eax, SND_FILENAME
    or eax, SND_ASYNC
    INVOKE PlaySound, ADDR levelSound, NULL, eax
    ret
PlayLevelSound ENDP
pitCollision PROC
    movzx ecx, pitCount
    test ecx, ecx           
    jz pitDone              
    
    mov ebx, 0               ; Pit index

pitLoop:
    movzx eax, xPos          ; Current X
    movzx edx, pitX[ebx]     ; Pit start
    cmp eax, edx
    jb nextPit

    movzx edx, pitWidth[ebx]
    movzx esi, pitX[ebx]
    add esi, edx             ; Pit end
    cmp eax, esi
    ja nextPit

    ; EARLY DEATH CHECK - falling into pit
    mov al, yPos
    add al, 3                ; Predict next few frames (velocityY builds)
    cmp al, 22               ; Die when approaching pit bottom
    jb nextPit

    mov lives, 0             ; Instant death
    jmp pitDone

nextPit:
    inc ebx
    loop pitLoop           
    
pitDone:
    ret
pitCollision ENDP
initPits PROC
    mov pitX[0], 25
    mov pitWidth[0], 6
    mov pitActive[0], 1
    
    mov pitX[1], 43  
    mov pitWidth[1], 2
    mov pitActive[1], 1
    
    mov pitCount, 2
    ret
initPits ENDP



HandleBossShot PROC
    inc frameCount
    mov ax, frameCount[0]
    test al, 1       
    jnz noShoot
    
    mov fireballActive, 1
    mov ax, bossX
    mov fireballX, ax
    mov ax, bossY
    mov fireballY, ax
noShoot:
    
    cmp fireballActive, 30
    je done

    mov ax,fireballSpeed
    add fireballY, ax
    cmp fireballY, 20      
    jl done
    mov fireballActive, 0
done:
    ret
HandleBossShot ENDP

DrawBoss PROC
    push eax
    push edx
    
    mov eax, red+(bgColor*16)
    call SetTextColor
    
    ; Get boss position
    mov ax, bossX
    mov dl, al                 ; X position
    mov ax, bossY
    mov dh, al                 ; Y position
    
    call Gotoxy
    mov al, 'B'
    call WriteChar
    
    mov eax, white+(bgColor*16)
    call SetTextColor
    
    pop edx
    pop eax
    ret
DrawBoss ENDP
DrawFireball PROC
    cmp fireballActive, 0
    je done
    
    push eax
    push edx
    
    mov eax, yellow+(bgColor*16)
    call SetTextColor
    
    ; Get fireball position
    mov ax, fireballX
    mov dl, al                 ; X position
    mov ax, fireballY
    mov dh, al                 ; Y position
    
    call Gotoxy
    mov al, '*'
    call WriteChar
    
    mov eax, white+(bgColor*16)
    call SetTextColor
    
    pop edx
    pop eax
done:
    ret
DrawFireball ENDP
UpdateBoss PROC
    push eax
    push ebx
    
    ; Move boss based on direction
    movzx eax, speed           ; Load speed (WORD)
    movsx ebx, direction       ; Load direction with sign extension
    imul eax, ebx              ; eax = speed * direction
    add bossX, ax              ; Update bossX
    
    ; Check right boundary
    mov ax, bossX
    cmp ax, rightX
    jle checkLeft              ; If bossX <= rightX, check left
    
    ; Hit right boundary - turn around
    mov ax, rightX
    mov bossX, ax
    mov direction, -1          ; Move left
    jmp doneBoss
    
checkLeft:
    ; Check left boundary
    mov ax, bossX
    cmp ax, leftX
    jge doneBoss               ; If bossX >= leftX, done
    
    ; Hit left boundary - turn around
    mov ax, leftX
    mov bossX, ax
    mov direction, 1           ; Move right
    
doneBoss:
    pop ebx
    pop eax
    ret
UpdateBoss ENDP
call bulletKoopasCollision

FireballPlayerCollision PROC
    cmp fireballActive, 0
    je noFireballCollision
    
    ; X collision check (±2 for better detection)
    movzx eax, xPos
    mov dx, fireballX          ; fireballX is a WORD
    movzx edx, dl              ; Get low byte (X position)
    sub eax, edx
    cmp eax, -2
    jl noFireballCollision
    cmp eax, 2
    jg noFireballCollision
    
    ; Y collision check (±2 for better detection)
    movzx eax, yPos
    mov dx, fireballY          ; fireballY is a WORD
    movzx edx, dl              ; Get low byte (Y position)
    sub eax, edx
    cmp eax, -2
    jl noFireballCollision
    cmp eax, 2
    jg noFireballCollision
    
    ; ===== HIT! =====
    mov fireballActive, 0
    
    ; Erase fireball
    mov ax, fireballX
    mov dl, al
    mov ax, fireballY
    mov dh, al
    call Gotoxy
    mov al, ' '
    call WriteChar
    
    dec lives 
    call updateLives
    
    ; Optional: Add knockback like in enemiePlayer
    mov al, xPos
    mov dl, byte ptr fireballX
    cmp al, dl
    jl movePlayerLeft
    
movePlayerRight:
    add al, 5
    mov xPos, al
    jmp fireballDone
    
movePlayerLeft:
    sub al, 5
    mov xPos, al
    
noFireballCollision:
fireballDone:
    ret
FireballPlayerCollision ENDP


END main

