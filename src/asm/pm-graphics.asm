.local
InitPM
	; Set the PM size and position
	lda #0
	ldx #$C
?initLoop
	sta HPOSP0,x
	dex
	bpl ?initLoop

	; Clear the PM graphics area
	jsr ClearPMG

	; Set PM colors
	jsr SetCursorColorOk

	; Set priority of graphics
	lda #~00010001		; Overlaps of players have 3rd color + Player 0 - 3, playfield 0 - 3, BAK (background)
	sta GPRIOR

	; Set the start address of the PM graphics
	lda #>PM_SPRITE		; $A000
	sta PMBASE

	lda #3				; turn on missiles & players
	sta GRACTL			; no shadow for this one	

	rts

; ---------------------------------------------------------
; Clear the sprite graphics area to all 0
ClearPMG
	lda #0
	tax
?clearPMLoop
	;sta MISSILES,X
	sta PM0,x
	sta PM1,x
	sta PM2,x
	sta PM3,x
	inx
	bne ?clearPMLoop
	rts

; ---------------------------------------------------------
; Clear the 24 lines that the normal ball occupies
;MiniClearPMG
;	lda #0
;	ldx BallYPosition	; Hight offset into the sprite memory
;	ldy #23				; Line counter
;?miniClearLoop	
;	sta PM0,x
;	sta PM1,x
;	sta PM2,x
;	sta PM3,x
;	inx					; next line
;	dey					; dec line counter
;	bpl ?miniClearLoop
;	rts

; ---------------------------------------------------------
; Turn off the screen, interrupts, and
; reset all sprites to offscreen left
TurnOff	
	lda #0
	sta DMACTL
	sta SDMCTL
	sta NMIEN
	ldx #$C
?off
	sta HPOSP0,x
	dex
	bpl ?off
	rts

; ---------------------------------------------------------
TurnOn
	; Interrupts on
	lda #NMI_VBI|NMI_DLI
	sta NMIEN
	; Setup a narrow screen width: 32 chars per line
	lda #~111110		;10 - normal, 11-PM on, 1 - one line, 1-DMA on
	sta SDMCTL
	rts


; ---------------------------------------------------------
; Player X,Y positions
CursorPositionX:
	.byte 52, 76, 100, 132, 156, 180, 52, 76, 100, 132, 156, 180, 52, 76, 100, 132, 156, 180
CursorPositionY:
	.byte 80,80,80,80,80,80,128,128,128,128,128,128,176,176,176,176,176,176

DrawCursor:
	; Get the Y offset of the previous cursor position
	ldx zpPrevCursorPosition
	lda CursorPositionY,x
	sta zpWorkI					; WorkI = CursorPositionY[PrevCursorPosition]

	; Get the Y offset of the current cursor position
	ldx zpCursorPosition
	lda CursorPositionY,x
	sta zpWorkY					; WorkY = CursorPositionY[CursorPosition]

	cmp zpWorkI					; OldY == NewY => don't redraw in Y
	beq ?skipPMDraw
	;
	; Clear the old cursor position
	lda #0
	ldy #40
	ldx zpWorkI
?clearLoop:
	sta PM0,x
	sta PM1,x
	sta PM2,x
	inx
	dey
	bne ?clearLoop

	; Now draw the cursor into the new Y position

	ldy #40
	lda #255
	ldx zpWorkY
?fillLoop:
	sta PM0,x
	sta PM1,x
	sta PM2,x
	inx
	dey
	bne ?fillLoop

?skipPMDraw:	

	ldx zpCursorPosition
	lda CursorPositionX,x
	sta HPOSP0
	clc
	adc #8
	sta HPOSP1
	adc #4
	sta HPOSP2

	rts

SetCursorColorOk:
	lda #CURSOR_COLOR_OK			; Player/Missile colours
	sta PCOLOR0
	lda #CURSOR_COLOR_OK
	sta PCOLOR1
	lda #CURSOR_COLOR_OK
	sta PCOLOR2
	lda #CURSOR_COLOR_OK
	sta PCOLOR3
	rts

SetCursorColorBad:
	lda #CURSOR_COLOR_BAD			; Player/Missile colours
	sta PCOLOR0
	lda #CURSOR_COLOR_BAD
	sta PCOLOR1
	lda #CURSOR_COLOR_BAD
	sta PCOLOR2
	lda #CURSOR_COLOR_BAD
	sta PCOLOR3
	rts
