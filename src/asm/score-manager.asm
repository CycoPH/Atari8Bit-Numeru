; 32-bit score counter

; --------------------------------------------------------
; DRAW SCORE
; 0 1 2 3 4 5 6
; 16 is for base color
; 144 is for highlighted color
DrawScore:
	ldx zpScore
	cpx zpLastScore
	beq ?noDrawScore0
	; 10s
	stx zpLastScore
	lda Div10Table,x	; 0 - 9
	tay
	lda NumbersV1,y
	sta STEPS_TAKEN_OFFSET_10_TOP
	lda NumbersV2,y
	sta STEPS_TAKEN_OFFSET_10_BOTTOM
	; 1s
	lda Modulus10Table,x
	tay
	lda NumbersV1,y
	sta STEPS_TAKEN_OFFSET_1_TOP
	lda NumbersV2,y
	sta STEPS_TAKEN_OFFSET_1_BOTTOM

?noDrawScore0:
	ldx zpScore+1
	cpx zpLastScore+1
	beq ?noDrawScore1
	stx zpLastScore+1
	; 1000s
	lda Div10Table,x
	tay
	lda NumbersV1,y
	sta STEPS_TAKEN_OFFSET_1000_TOP
	lda NumbersV2,y
	sta STEPS_TAKEN_OFFSET_1000_BOTTOM
	; 100s
	lda Modulus10Table,x
	tay
	lda NumbersV1,y
	sta STEPS_TAKEN_OFFSET_100_TOP
	lda NumbersV2,y
	sta STEPS_TAKEN_OFFSET_100_BOTTOM

?noDrawScore1
	ldx zpScore+2
	cpx zpLastScore+2
	beq ?noDrawScore2
	stx zpLastScore+2
	; 100000s
	lda Div10Table,x
	tay
	lda NumbersV1,y
	sta STEPS_TAKEN_OFFSET_100000_TOP
	lda NumbersV2,y
	sta STEPS_TAKEN_OFFSET_100000_BOTTOM
	; 10000s
	lda Modulus10Table,x
	tay
	lda NumbersV1,y
	sta STEPS_TAKEN_OFFSET_10000_TOP
	lda NumbersV2,y
	sta STEPS_TAKEN_OFFSET_10000_BOTTOM
?noDrawScore2	

	rts

; --------------------------------------------------------
Add1ToScore:
	lda #1
	; Note fall through to add routine

; --------------------------------------------------------
; ADD SCORE
; Add Acc to the "score"
Add2Score:
	;!##TRACE "add score xy=%d,%d,%d,%d + %d" db(score) db(score+1) db(score+2) db(score+3) @a
	clc					; a = a + score[0] 
	adc zpScore
	cmp #100			; if a >= 100
	bcc ?below100Lo		; set carry
	sbc #100			; a = a - 100
?below100Lo:		
	sta zpScore			; store the remainder in score
	bcc ?endScoreAdd	; if no carry is set then no overflow past 100

	; There was overflow past 100 add 1 to the next byte of the score
	lda zpScore+1		; a = score[1]
	adc #0				; a = a + 1
	cmp #100			; if a >= 100
	bcc ?below100Hi		;
	sbc #100
?below100Hi		
	sta zpScore+1
	bcc ?endScoreAdd	; if no carry is set then no overflow past 100

	; There was overflow past 100 add 1 to the next byte of the score
	lda zpScore+2		; a = score[1]
	adc #0				; a = a + 1
	cmp #100			; if a >= 100
	bcc ?below100_B2	;
	sbc #100
?below100_B2
	sta zpScore+2
	bcc ?endScoreAdd	; if no carry is set then no overflow past 100

	inc zpScore+3
?endScoreAdd
	rts

	; --------------------------------------------------------
ResetScore:
	lda #0
	sta zpScore
	sta zpScore+1
	sta zpScore+2
	sta zpScore+3
	jmp DrawScore
