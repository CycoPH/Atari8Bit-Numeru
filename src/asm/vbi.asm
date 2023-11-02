; Vertical blank interrups

; =========================================================
; Vertical blank interrupt
; Fired 50/60 times a second


VBINTSCDelay .byte 6

; Vertical Blank Interrupt entry point
VBI
	inc zpVBICounter

	lda zpStopTheClock			; if StopTheClock != 0 then dont count
	bne ?clockOk
	; No the VBI->seconds->minute timer
	inc zpClockVbi

	lda PAL
	cmp #$F
	bne ?clockPAL
	; Clock in NTSC 60/sec
	lda zpClockVbi
	cmp #60
	bcs ?resetClockVbi
	jmp ?clockOk
	; Clock in PAL 50/sec
?clockPAL:
	lda zpClockVbi
	cmp #60
	bcs ?resetClockVbi
	jmp ?clockOk

?resetClockVbi:
	lda #0
	sta zpClockVbi	; Reset the VBI/sec counter

	inc zpClockSeconds
	lda zpClockSeconds
	cmp #60
	bcc ?clockOk
	; Seconds rolled over
	lda #0
	sta zpClockSeconds

	; Inc the number of minutes
	inc zpClockMinutes
	lda zpClockMinutes
	cmp #100
	bcc ?clockOk
	lda #99
	sta zpClockMinutes
	lda #59
	sta zpClockSeconds
	
?clockOk:
	jsr DrawTimer

	; Check for PAL/NTSC slowdown
	lda PAL
	cmp #$F
	bne ?doSomeMusicAction	; -> When PAL
	; NTSC
	dec VBINTSCDelay
	bne ?doSomeMusicAction
	; 1 in 6 we skip the Music player
	lda #6
	sta VBINTSCDelay
	;!##TRACE "skip Frame=%d" db($14)
	jmp ?noMusic

?doSomeMusicAction:
	jsr PlayMusic

	

?noMusic:
	; End the Vertical Blank Interrupt
	JMP	XITVBV
