; Using sbasm30312 (https://www.sbprojects.net/sbasm/)
        .cr 8048
        .tf PM2528MyTest.bin BIN
        .or $0000

;**********************
        .no $0000
RESET   
        JMP MainRoutine

;**********************
        .no $0003
EXTIRQ  
        RET
        

;**********************
        .no $0007
TIMIRQ  RET


;**********************
MainRoutine
        ; Setup
        ; From PM2528
        ANL        P1,#%11010011 ; clear stuff
        ANL        P2,#%01001111                              Select N2 / D201
        MOVD       P4,A                                       Set all outputs to 0 (eg: check for no key in keyboard-matrix)

.MainLoop
        MOV R0,#$0A

.mainloopInner
        CALL LoadRegistersForDisplaying
        CALL Update7SegmentDisplay

        MOV R1,#$32                     ; wait 500msecs
.delay
        CALL Delay10msecs
        DJNZ R1,.delay

        DJNZ R0,.mainloopInner
        JMP .Mainloop


LoadRegistersForDisplaying
        MOV A,R0
        DEC A
        CALL Lookup7SegmentCodeForDigit ; Input in A, result in A
        MOV R7,A
        MOV R6,A
        MOV R5,A
        MOV R4,A
        MOV R3,A
        MOV R2,A
        RET

;****************************************************************************************
        .in PM2528_DisplayRoutines.asm
        .in PM2528_HelperRoutines.asm