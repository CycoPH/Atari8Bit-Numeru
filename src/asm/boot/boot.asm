.include "OS.asm"
.include "PIA.asm"
.include "GTIA.asm"
.include "ANTIC.asm"

BASICF = $3f8

	.bank 0,0
	* = $2000
	.include "../fonts/game-font.asm"

	*=$6000 "Decompress, DL"
	.local

BOOT_PART:
	lda #>GameFont		; This is the gui font for the top of the screen
	sta CHBAS

	lda #$0C			; Luma mode 2
	sta COLOR1
	lda #$00
	sta COLOR2			; background color

	; Setup display list
	lda #<LoaderDisplayList
	sta SDLSTL
	lda #>LoaderDisplayList
	sta SDLSTL+1

	; Disable basic
	lda #$C0
	cmp RAMTOP
	beq ?RamOk
	sta RAMTOP
	sta RAMSIZ

	; turn off basic
	lda PORTB
	ora #$02
	sta PORTB

	; Check if BASIC ROM area is now writable
	lda $A000
	inc $A000
	cmp $A000
	beq ?RamNotOk		; No change so BASIC ROM is still there

	lda #1				; Set BASICF to non-zero, so BASIC remains OFF after RESET
	sta BASICF
?RamOk
	rts

?RamNotOk
	jsr WaitForVBI
	inc COLOR1			; Change the background color to indicate that something has gone wrong
	jmp ?RamNotOk

; Hang in this loop until one VBI has happend
WaitForVBI
	lda RTCLOK60
?wait
	cmp RTCLOK60
	beq ?wait
	rts	

	;*=$A000 "Boot Display List"
LoaderDisplayList
	.byte $70,$70,$70       	; 24 blank lines
	.byte $70,$70,$70,$70,$70,$70,$70,$70
	.byte DL_LMS|DL_TEXT_2, 
	.byte <GameScreen0, >GameScreen0 ; 1x mode 2 line + LMS + address
	.byte DL_TEXT_2, DL_TEXT_2, DL_TEXT_2, DL_TEXT_2, DL_TEXT_2	; 5 lines
	.byte DL_TEXT_2
	.byte $41,<LoaderDisplayList,>LoaderDisplayList 	; JVB ends display list

GameScreen0:
	.BYTE 128,0,0,128,0,128,0,128
	.BYTE 0,128,125,0,124,128,0,128
	.BYTE 128,127,0,128,128,125,0,128
	.BYTE 0,128,0,34,57,0,0,0
	.BYTE 0,0,0,0,0,0,0,0
	.BYTE 128,125,0,128,0,128,0,128
	.BYTE 0,128,126,128,127,128,0,128
	.BYTE 0,0,0,128,0,128,0,128
	.BYTE 0,128,0,48,37,52,37,50
	.BYTE 0,40,41,46,58,0,0,0
	.BYTE 128,253,125,128,0,128,0,128
	.BYTE 0,128,0,0,0,128,0,128
	.BYTE 128,0,0,128,128,127,0,128
	.BYTE 0,128,0,35,37,50,37,34
	.BYTE 53,51,0,0,0,0,0,0
	.BYTE 128,0,253,128,0,128,0,128
	.BYTE 0,128,0,0,0,128,0,128
	.BYTE 0,0,0,128,125,0,0,128
	.BYTE 0,128,0,0,0,0,0,0
	.BYTE 0,0,0,0,0,0,0,0
	.BYTE 128,0,0,128,0,128,128,252
	.BYTE 0,128,0,0,0,128,0,128
	.BYTE 128,125,0,128,253,125,0,128
	.BYTE 128,252,0,0,0,0,0,0
	.BYTE 0,0,0,0,0,0,0,0
	.BYTE 0,0,0,0,0,0,0,0
	.BYTE 0,0,0,0,0,0,0,0
	.BYTE 0,0,0,0,0,0,0,0
	.BYTE 0,0,0,0,0,0,0,0
	.BYTE 0,0,0,0,0,0,0,0
	.BYTE 0,0,0,0,0,0,33,34
	.BYTE 34,53,35,0,51,47,38,52
	.BYTE 55,33,50,37,0,35,47,46
	.BYTE 52,37,51,52,0,19,17,19
	.BYTE 20,0,0,0,0,0,0,0

; Setup the INITAD vector to call the code ASAP
	.bank 1
	* = $2e2 "Init Vector"
	.word BOOT_PART