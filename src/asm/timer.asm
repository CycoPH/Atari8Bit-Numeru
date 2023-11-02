	.local
ResetTimer:
	lda #0
	sta zpClockVbi
	sta zpClockSeconds
	sta zpClockMinutes
	rts

DrawTimer:
	ldx zpClockSeconds
	; 10s
	lda Div10Table,x	; 0 - 9
	tay
	lda NumbersV1,y
	sta TIME_SEC_OFFSET_10_TOP
	lda NumbersV2,y
	sta TIME_SEC_OFFSET_10_BOTTOM
	; 1s
	lda Modulus10Table,x
	tay
	lda NumbersV1,y
	sta TIME_SEC_OFFSET_1_TOP
	lda NumbersV2,y
	sta TIME_SEC_OFFSET_1_BOTTOM

	ldx zpClockMinutes
	; 10s
	lda Div10Table,x	; 0 - 9
	tay
	lda NumbersV1,y
	sta TIME_MIN_OFFSET_10_TOP
	lda NumbersV2,y
	sta TIME_MIN_OFFSET_10_BOTTOM
	; 1s
	lda Modulus10Table,x
	tay
	lda NumbersV1,y
	sta TIME_MIN_OFFSET_1_TOP
	lda NumbersV2,y
	sta TIME_MIN_OFFSET_1_BOTTOM	

	rts