;****************************************************************************************
SevenSegmentDisplayBitPatterns
        .db %01111111   (blank)
        .db %01000000   '0'
        .db %01111001   '1'
        .db %00100100   '2'
        .db %00110000   '3'
        .db %00011001   '4'
        .db %00010010   '5'
        .db %00000010   '6'
        .db %01111000   '7'
        .db %00000000   '8'
        .db %00010000   '9'
        .db %00001000   'A'
        .db %00000011   'b'
        .db %01000110   'C'
        .db %00100001   'd'
        .db %00000110   'E'
        .db %00001110   'F'

        .db %00111111   'G'
        .db %00111111   'H'
        .db %00111111   'I'
        .db %00111111   'J'
        .db %00111111   'K'
        .db %00111111   'L'
        .db %00111111   'M'
        .db %00111111   'N'
        .db %00111111   'O'
        .db %00111111   'P'
        .db %00111111   'Q'
        .db %00111111   'R'
        .db %00111111   'S'
        .db %00111111   'T'
        .db %00111111   'U'
        .db %00111111   'V'
        .db %00111111   'W'
        .db %00111111   'X'
        .db %00111111   'Y'
        .db %00111111   'Z'

PgStart .EQ SevenSegmentDisplayBitPatterns/$100  ; Make sure the patterns fit in one page, due to the MOVP A,@A instruction
PgEnd   .EQ *-1/$100
        .DO PgStart!=PgEnd
        .ER F,Length of SevenSegmentDisplayBitPatterns crosses page-boundary
        .FI

;**********************
Lookup7SegmentCodeForDigit
        INC        A
        ANL        A,#%00001111
        ADD        A,#SevenSegmentDisplayBitPatterns\256 ; offset of current page
        MOVP       A,@A
        RET

;**********************
Update7SegmentDisplay
        MOV        A,#%10111111                                   Select N2, /PS2, Digit 0
        OUTL       P2,A
        MOV        A,R7
        CALL Update7SegmentDigit
        MOV        A,#10101111b                                  Select N2, /PS2, Digit 1
        OUTL       P2,A
        MOV        A,R6
        CALL Update7SegmentDigit
        MOV        A,#%10011111
        OUTL       P2,A                                           Select N2, /PS2, Digit 2,3
        MOV        A,R5
        CALL Update7SegmentDigit
        MOV        A,R4
        CALL Update7SegmentDigit
        MOV        A,#%10001111                                  Select N2, /PS2, Digit 4,5
        OUTL       P2,A                                           Select N2, /PS2, Digit 2,3
        MOV        A,R3
        CALL Update7SegmentDigit
        MOV        A,R2
        CALL Update7SegmentDigit
        ANL        P2,#%00001111                                  Deselect all IO-expanders (D170x, N2)
        RET


;**********************
Update7SegmentDigit
        MOV R1,#$08
.loopDigit
        MOVD P4,A
        RR   A
        DJNZ R1,.loopDigit
        RET


