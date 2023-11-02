DetectPALorNTSC
	lda PAL
	cmp #$F		; Check for NTSC
	bne ?isPAL
	; NTSC

	lda #$0C			; Luma mode 2
	sta COLOR1
	lda #$00
	sta COLOR2			; background color
	rts
	
	; PAL
?isPAL
	lda #$0C			; Luma mode 2
	sta COLOR1
	lda #$00
	sta COLOR2			; background color

	rts