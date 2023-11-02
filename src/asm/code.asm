;
; Memory location
;
.include "ANTIC.asm"
.include "GTIA.asm"
.include "OS.asm"
.include "PIA.asm"
.include "POKEY.asm"
.include "zero-page.asm"
.include "constants.asm"

; =============================================================================
; Memory layout
; $2000 - $23FF		Game Font


; =============================================================================
	* = $2000
GameFont = *
	; Data
;.include "game-font.asm"			; $2000 - $23FF
	* = $2400
.include "title-screen.asm"
.include "gui.asm"
.include "game-screen.asm"
.include "tiles.asm"
.include "level-done.asm"
	; Code
.include "colors.asm"
.include "vbi.asm"
.include "draw.asm"
.include "pm-graphics.asm"
.include "score-manager.asm"
.include "dl-and-dli.asm"
.include "timer.asm"

	.local
SetupAsm:
	; Wait for 1 second more just to show the nice loading screen
	ldx #60
?waitForABit:
	jsr WaitForVBI
	dex
	bpl ?waitForABit

	jsr DetectPALorNTSC

	lda #1
	sta KBCODE				; Reset POKEY

	jsr ResetAudio

	lda #255
	sta 731				; NOCLIK = set to !0 to turn of the keyboard sound

	; The game is loaded and we need to setup some things
	; Init POKEY
	lda #3				; Enable keyboard debounce/scanning
	sta SKCTL
	lda #0
	sta AUDCTL
	;sta SDMCTL			; disable screen

	jsr WaitForVBI

	jsr TurnOff
	jsr InitPM

	; Setup display list in shadow reg, VBI will activate it
	lda #<TitleDisplayList
	sta SDLSTL
	lda #>TitleDisplayList
	sta SDLSTL+1

	ldx #>VBI
	ldy #<VBI
	lda #7
	jsr SETVBV

	lda #>GameFont		; This is the gui font for the top of the screen
	sta CHBAS

	jsr TurnOn

	jsr WaitForVBI

	jsr InitMusic
	rts

; ---------------------------------------------------------
SwitchToGameScreen:
	jsr WaitForVBI
	jsr TurnOff
	jsr ClearPMG

	; Setup display list in shadow reg, VBI will activate it
	lda #<GameDisplayList
	sta SDLSTL
	lda #>GameDisplayList
	sta SDLSTL+1

	jsr TurnOn
	rts

; ---------------------------------------------------------
SwitchToTitleScreen:
	jsr WaitForVBI
	jsr TurnOff
	jsr ClearPMG

	; Setup display list in shadow reg, VBI will activate it
	lda #<TitleDisplayList
	sta SDLSTL
	lda #>TitleDisplayList
	sta SDLSTL+1

	jsr TurnOn
	rts	

; ---------------------------------------------------------
; Ready the joystick 0 value
; bit 0 = up
; bit 1 = down
; bit 2 = left
; bit 3 = right
; bit 4 = fire
	OldJoystickValue: .byte 0
ReadJoystick:
 	lda     STRIG0			; Joystick 0 tigger
	asl     a
	asl     a
	asl     a
	asl     a
	ora     STICK0			; add position information
	eor     #$1F
	cmp     OldJoystickValue
	beq		?NoJoystickChange
	sta		OldJoystickValue
	ldx 	#0
	stx		ATRACT			; Disable "attract mode"
?NoJoystickChange:
	sta		zpJoystick0
	rts 

; ---------------------------------------------------------
; Hang in this loop until one VBI has happend
WaitForVBI:
	lda RTCLOK60
?wait
	cmp RTCLOK60
	beq ?wait
	rts

; ---------------------------------------------------------
WaitForFireRelease:
	; DEBUG
	;inc COLBK
	lda STRIG0
	beq WaitForFireRelease
	rts

; =============================================================================
; Binary to decimal conversion
; =============================================================================

; 100 entries that map an index 0-99 to 10x0, 10x1, 10x2, ..., 10x9
; Divide by 10 table
; 100 bytes
Div10Table .rept 100
	.byte [*-Div10Table]/10
	.endr

; 100 entries that map an index to the 1s counter
; entry = i % 10
; ATASM does not have a modulus operator
; 100 bytes
Modulus10Table .rept 100
	.byte [*-Div10Table]%%10
	.endr

.include "music.asm"