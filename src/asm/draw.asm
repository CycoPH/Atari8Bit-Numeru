; Location where in the screen the play tiles can be drawn
PlayTileOffsetL:
	.byte <(GameScreen+1), <(GameScreen+7), <(GameScreen+13)
	.byte <(GameScreen+1+40*6), <(GameScreen+7+40*6), <(GameScreen+13+40*6)
	.byte <(GameScreen+1+40*12), <(GameScreen+7+40*12), <(GameScreen+13+40*12)

PlayTileOffsetH:
	.byte >(GameScreen+1), >(GameScreen+7), >(GameScreen+13)
	.byte >(GameScreen+1+40*6), >(GameScreen+7+40*6), >(GameScreen+13+40*6)
	.byte >(GameScreen+1+40*12), >(GameScreen+7+40*12), >(GameScreen+13+40*12)

; Location where in the screen the store tiles can be drawn
StoreTileOffsetL:
	.byte <(GameScreen+21), <(GameScreen+27), <(GameScreen+33)
	.byte <(GameScreen+21+40*6), <(GameScreen+27+40*6), <(GameScreen+33+40*6)
	.byte <(GameScreen+21+40*12), <(GameScreen+27+40*12), <(GameScreen+33+40*12)

StoreTileOffsetH:
	.byte >(GameScreen+21), >(GameScreen+27), >(GameScreen+33)
	.byte >(GameScreen+21+40*6), >(GameScreen+27+40*6), >(GameScreen+33+40*6)
	.byte >(GameScreen+21+40*12), >(GameScreen+27+40*12), >(GameScreen+33+40*12)

; ---------------------------------------------------------
; Take the each of the numbers and check if its >= 10
; if it is then the background is marked as white
; zpWorkBaseColors will be 0-15 to indicate the color layout
; Input: zpWorkTop, zpWorkRight, zpWorkBottom, zpWorkLefty
; Ouput: zpWorkBaseColors (0-15)
CalcTileBackground:
	; Calc what background the tile will have
	lda #0
	sta zpWorkBaseColors

	; Check the top color
	lda zpWorkTop
	cmp #10
	bcc ?isBelow10Top
	; Set top color as white (bit 1)
	lda #1
	ora zpWorkBaseColors	
	sta zpWorkBaseColors
?isBelow10Top

	; Check the right color
	lda zpWorkRight
	cmp #10
	bcc ?isBelow10Right
	; Set Right color as white (bit 2)
	lda #2
	ora zpWorkBaseColors	
	sta zpWorkBaseColors
?isBelow10Right

	; Check the bottom color
	lda zpWorkBottom
	cmp #10
	bcc ?isBelow10Bottom
	; Set bottom color as white (bit 4)
	lda #4
	ora zpWorkBaseColors	
	sta zpWorkBaseColors
?isBelow10Bottom

	; Check the left color
	lda zpWorkLeft
	cmp #10
	bcc ?isBelow10Left
	; Set left color as white (bit 8)
	lda #8
	ora zpWorkBaseColors	
	sta zpWorkBaseColors
?isBelow10Left
	rts

; ---------------------------------------------------------
; DrawActiveTile()
; DrawPlayTile(@Y)
; DrawStoreTile(@Y)
;
; Input:
;	@Y = tile index
; Clobbers:
;	@A, @X, @y
;	zpFrom, zpTo, zpScreen
;	zpWorkTop, zpWorkRight, zpWorkBottom, zpWorkLeft
;	zpzpWorkBaseColors, zpWorkY

; C interface
	.local
DrawActiveTile:
	lda #<(GameGui+17)
	sta zpToL
	sta zpScreenPtrL
	lda #>(GameGui+17)
	sta zpToH
	sta zpScreenPtrH

	; Get the 4 numbers of the tile
	lda zpActiveTop
	bmi ?drawBlankTile
	sta zpWorkTop
	lda zpActiveRight
	sta zpWorkRight
	lda zpActiveBottom
	sta zpWorkBottom
	lda zpActiveLeft
	sta zpWorkLeft

	jmp ?drawTileCommon

DrawPlayTile:
	; Y = tile #

	; Get where to draw the tile
	lda PlayTileOffsetL,y
	sta zpToL
	sta zpScreenPtrL
	lda PlayTileOffsetH,y
	sta zpToH
	sta zpScreenPtrH				; (To) = (ScreenPtr) = PlayTileOffset[TileNr]

	; Get the 4 numbers of the tile
	lda (zpPlayTilesTop),y
	bmi ?drawBlankTile
	sta zpWorkTop
	lda (zpPlayTilesRight),y
	sta zpWorkRight
	lda (zpPlayTilesBottom),y
	sta zpWorkBottom
	lda (zpPlayTilesLeft),y
	sta zpWorkLeft

	jmp ?drawTileCommon

	; =================================
?drawBlankTile:	
	; Draw a blank tile
	lda #5
	sta zpWorkY
	
	lda #0
	tay
	
	ldx #5			; 5 chars per line
?innerClearLoop:
	sta (zpTo),y
	iny
	sta (zpTo),y
	iny
	sta (zpTo),y
	iny
	sta (zpTo),y
	iny
	sta (zpTo),y
	iny

	; Move draw ptr to next line
	clc
	lda zpTo
	adc #35
	sta zpTo
	bcc ?noHighBitClear
	inc zpTo+1
?noHighBitClear

	lda #0

	dex
	bne ?innerClearLoop

	rts

; =============================================================================
DrawStoreTile:
	; Y = tile #

	; Get where to draw the tile
	lda StoreTileOffsetL,y
	sta zpToL
	sta zpScreenPtrL
	lda StoreTileOffsetH,y
	sta zpToH
	sta zpScreenPtrH

	; Get the 4 numbers of the tile
	lda (zpStoreTilesTop),y
	bmi ?drawBlankTile
	sta zpWorkTop
	lda (zpStoreTilesRight),y
	sta zpWorkRight
	lda (zpStoreTilesBottom),y
	sta zpWorkBottom
	lda (zpStoreTilesLeft),y
	sta zpWorkLeft

?drawTileCommon:

	jsr CalcTileBackground			; Top,Left,Rigth,Bottom -> zpWorkBaseColors index

	; zpWorkBaseColors = 0-15 which is the base 5x5 tile to draw (no numbers yet)
	lda zpWorkBaseColors
	asl				; Val = Val * 2
	tax
	lda Tiles,x
	sta zpFromL
	lda Tiles+1,x
	sta zpFromH		; (zpFrom) = Tiles[WorkVal]

	; Draw the 5x5 files
	lda #5
	sta zpWorkY		; Line counter

	ldy #0			; Index runner to access src and dest memory locations

?dawNextLine
	ldx #5			; 5 chars per line

?drawInnerLoop;
	lda (zpFrom),y
	sta (zpTo),y
	iny
	dex
	bne ?drawInnerLoop

	dec zpWorkY
	lda zpWorkY
	beq ?finishedTileBackgroundDraw

	; Move (To) to the next line
	clc
	lda zpTo
	adc #35
	sta zpTo
	bcc ?noHighStop
	inc zpTo+1
?noHighStop
	jmp ?dawNextLine

?finishedTileBackgroundDraw:
	; Now reset the draw ptr
	; and draw the numbers onto the tile

	; Top number
	ldx zpWorkTop
	ldy #2
	lda NumbersV1,x
	sta (zpScreenPtr),y
	ldy #(2+40)
	lda NumbersV2,x
	sta (zpScreenPtr),y

	; Left number
	ldx zpWorkLeft
	ldy #80
	lda NumbersH1,x
	sta (zpScreenPtr),y
	iny
	lda NumbersH2,x
	sta (zpScreenPtr),y

	; Right number
	iny
	iny
	ldx zpWorkRight
	lda NumbersH1,x
	sta (zpScreenPtr),y
	iny
	lda NumbersH2,x
	sta (zpScreenPtr),y

	; Bottom number
	ldx zpWorkBottom
	ldy #122
	lda NumbersV1,x
	sta (zpScreenPtr),y
	ldy #(122+40)
	lda NumbersV2,x
	sta (zpScreenPtr),y

	rts

; =============================================================================
DrawGameScreen:
	lda #8
	sta zpWorkI
	
?nextTileLoop:
	ldy zpWorkI
	jsr DrawPlayTile

	ldy zpWorkI
	jsr DrawStoreTile

	dec zpWorkI
	lda zpWorkI
	bpl ?nextTileLoop

	rts

; =============================================================================
DrawMatches:
	ldx #66		; The horizontal bridge
	ldy #63		; Horizontal blank

	; 0R-1L
	lda zpNumHorizontalMatches
	and #MATCH_H_0R1L
	beq ?noHorizontal0
	stx [GameScreen+6+40*2]	; 6,2 = 66
	bne ?stepH1
?noHorizontal0:
	sty [GameScreen+6+40*2]	; 6,2 = 63

	; 1R-2L
?stepH1:
	lda zpNumHorizontalMatches
	and #MATCH_H_1R2L
	beq ?noHorizontal1
	stx [GameScreen+12+40*2]	; 12,2
	bne ?stepH2
?noHorizontal1:
	sty [GameScreen+12+40*2]	; 12,2

	; 3R-4L
?stepH2:
	lda zpNumHorizontalMatches
	and #MATCH_H_3R4L
	beq ?noHorizontal2
	stx [GameScreen+6+40*8]
	bne ?stepH3
?noHorizontal2:
	sty [GameScreen+6+40*8]

	; 4R-5L
?stepH3:
	lda zpNumHorizontalMatches
	and #MATCH_H_4R5L
	beq ?noHorizontal3
	stx [GameScreen+12+40*8]
	bne ?stepH4
?noHorizontal3:
	sty [GameScreen+12+40*8]

	; 6R-7L
?stepH4:
	lda zpNumHorizontalMatches
	and #MATCH_H_6R7L
	beq ?noHorizontal4
	stx [GameScreen+6+40*14]
	bne ?stepH5
?noHorizontal4:
	sty [GameScreen+6+40*14]

	; 7R-8L
?stepH5:
	lda zpNumHorizontalMatches
	and #MATCH_H_7R8L
	beq ?noHorizontal5
	stx [GameScreen+12+40*14]
	bne ?doVertical
?noHorizontal5:
	sty [GameScreen+12+40*14]

; ---------------------------
; Draw the vertical match bridges
?doVertical:
	ldx #65		; The vertical bridge
	ldy #64		; Vertical blank

	; 0B-3T
	lda zpNumVerticalMatches
	and #MATCH_V_0B3T
	beq ?noVertical0
	stx [GameScreen+3+40*5]
	bne ?stepV1
?noVertical0:
	sty [GameScreen+3+40*5]

	; 1B-4T
?stepV1:
	lda zpNumVerticalMatches
	and #MATCH_V_1B4T
	beq ?noVertical1
	stx [GameScreen+9+40*5]
	bne ?stepV2
?noVertical1:
	sty [GameScreen+9+40*5]

?stepV2:
	lda zpNumVerticalMatches
	and #MATCH_V_2B5T
	beq ?noVertical2
	stx [GameScreen+15+40*5]
	bne ?stepV3
?noVertical2:
	sty [GameScreen+15+40*5]

?stepV3:
	lda zpNumVerticalMatches
	and #MATCH_V_3B6T
	beq ?noVertical3
	stx [GameScreen+3+40*11]
	bne ?stepV4
?noVertical3:
	sty [GameScreen+3+40*11]

?stepV4:
	lda zpNumVerticalMatches
	and #MATCH_V_4B7T
	beq ?noVertical4
	stx [GameScreen+9+40*11]
	bne ?stepV5
?noVertical4:
	sty [GameScreen+9+40*11]

?stepV5:
	lda zpNumVerticalMatches
	and #MATCH_V_5B8T
	beq ?noVertical5
	stx [GameScreen+15+40*11]
	bne ?stepV6
?noVertical5:
	sty [GameScreen+15+40*11]

?stepV6:
	rts

; =============================================================================
; Location where in the screen the store tiles can be drawn
	.local
TitleTileOffsetL:
	.byte <(TitleScreen+22+40*6), <(TitleScreen+28+40*6), <(TitleScreen+34+40*6)
	.byte <(TitleScreen+22+40*12), <(TitleScreen+28+40*12), <(TitleScreen+34+40*12)
	.byte <(TitleScreen+22+40*18), <(TitleScreen+28+40*18), <(TitleScreen+34+40*18)

TitleTileOffsetH:
	.byte >(TitleScreen+22+40*6), >(TitleScreen+28+40*6), >(TitleScreen+34+40*6)
	.byte >(TitleScreen+22+40*12), >(TitleScreen+28+40*12), >(TitleScreen+34+40*12)
	.byte >(TitleScreen+22+40*18), >(TitleScreen+28+40*18), >(TitleScreen+34+40*18)

DrawTitleTile:
	; Y = tile #

	; Get where to draw the tile
	lda TitleTileOffsetL,y
	sta zpToL
	sta zpScreenPtrL
	lda TitleTileOffsetH,y
	sta zpToH
	sta zpScreenPtrH

	; Get the 4 numbers of the tile
	lda (zpStoreTilesTop),y
	sta zpWorkTop
	lda (zpStoreTilesRight),y
	sta zpWorkRight
	lda (zpStoreTilesBottom),y
	sta zpWorkBottom
	lda (zpStoreTilesLeft),y
	sta zpWorkLeft

?drawTileCommon:

	jsr CalcTileBackground			; Top,Left,Rigth,Bottom -> zpWorkBaseColors index

	; zpWorkBaseColors = 0-15 which is the base 5x5 tile to draw (no numbers yet)
	lda zpWorkBaseColors
	asl				; Val = Val * 2
	tax
	lda Tiles,x
	sta zpFromL
	lda Tiles+1,x
	sta zpFromH		; (zpFrom) = Tiles[WorkVal]

	; Draw the 5x5 files
	lda #5
	sta zpWorkY		; Line counter

	ldy #0			; Index runner to access src and dest memory locations

?dawNextLine
	ldx #5			; 5 chars per line

?drawInnerLoop;
	lda (zpFrom),y
	sta (zpTo),y
	iny
	dex
	bne ?drawInnerLoop

	dec zpWorkY
	lda zpWorkY
	beq ?finishedTileBackgroundDraw

	; Move (To) to the next line
	clc
	lda zpTo
	adc #35
	sta zpTo
	bcc ?noHighStop
	inc zpTo+1
?noHighStop
	jmp ?dawNextLine

?finishedTileBackgroundDraw:
	; Now reset the draw ptr
	; and draw the numbers onto the tile

	; Top number
	ldx zpWorkTop
	ldy #2
	lda NumbersV1,x
	sta (zpScreenPtr),y
	ldy #(2+40)
	lda NumbersV2,x
	sta (zpScreenPtr),y

	; Left number
	ldx zpWorkLeft
	ldy #80
	lda NumbersH1,x
	sta (zpScreenPtr),y
	iny
	lda NumbersH2,x
	sta (zpScreenPtr),y

	; Right number
	iny
	iny
	ldx zpWorkRight
	lda NumbersH1,x
	sta (zpScreenPtr),y
	iny
	lda NumbersH2,x
	sta (zpScreenPtr),y

	; Bottom number
	ldx zpWorkBottom
	ldy #122
	lda NumbersV1,x
	sta (zpScreenPtr),y
	ldy #(122+40)
	lda NumbersV2,x
	sta (zpScreenPtr),y

	rts

DrawTitleScreen:
	lda #8
	sta zpWorkI
	
; Draw the 9 tiles of the title screen
?nextTileLoop:
	ldy zpWorkI
	jsr DrawTitleTile

	dec zpWorkI
	lda zpWorkI
	bpl ?nextTileLoop

	rts

MenuInverse:
	.byte 0,0,0,0

MenuNoYes:
	.byte 46,47,0,0		; NO
	.byte 57,37,51,0	; YES

RenderTitleScreenOptions:
	lda #0
	sta MenuInverse
	sta MenuInverse+1
	sta MenuInverse+2
	sta MenuInverse+3

	; Set the menu number that will be in inverse
	lda #128
	ldx zpDifficultyMenu
	sta MenuInverse,X

	; Render the number range 2-9
	ldy #0							; menu 0
	ldx zpDifficultyNumbers
	dex
	lda Modulus10Table,x
	clc
	adc #17
	eor MenuInverse,y
	sta [TitleScreen+13+40*18]

	lda #31 ; ->
	eor MenuInverse,y
	sta [TitleScreen+12+40*18]

	lda #17 ; 0
	eor MenuInverse,y
	sta [TitleScreen+11+40*18]

	; Color YES/NO
	ldy #1							; Menu 1
	lda zpDifficultyColor			;
	asl
	asl
	tax
	lda MenuNoYes,x
	eor MenuInverse,y
	sta [TitleScreen+11+40*19]
	lda MenuNoYes+1,x
	eor MenuInverse,y
	sta [TitleScreen+12+40*19]
	lda MenuNoYes+2,x
	eor MenuInverse,y
	sta [TitleScreen+13+40*19]

	; Draw the difficulty level (1,2,3,4,5,6,7,8)
	ldy #2							; menu 2
	ldx zpDifficultyLevel
	lda Modulus10Table,x
	clc
	adc #17
	eor MenuInverse,y
	sta [TitleScreen+11+40*20]
	
	lda #0
	eor MenuInverse,y
	sta [TitleScreen+12+40*20]
	sta [TitleScreen+13+40*20]

	; Rotation YES/NO
	ldy #3							; Menu 3
	lda zpDifficultRotation			;
	asl
	asl
	tax
	lda MenuNoYes,x
	eor MenuInverse,y
	sta [TitleScreen+11+40*21]
	lda MenuNoYes+1,x
	eor MenuInverse,y
	sta [TitleScreen+12+40*21]
	lda MenuNoYes+2,x
	eor MenuInverse,y
	sta [TitleScreen+13+40*21]

	rts


; =========================================================================
; Draw level done
; 20x13 block to 20,5 on the game screen
	.local
DrawLevelDone:
	lda #<LevelDoneBitmap
	sta zpFromL
	lda #>LevelDoneBitmap
	sta zpFromH

?draw20x13:
	lda #<(GameScreen+20+5*40)
	sta zpToL
	lda #>(GameScreen+20+5*40)
	sta zpToH

	lda #12
	sta zpWorkH

?nextLine:
	ldy #0
	ldx #19
?nextChar:
	lda (zpFrom),y
	sta (zpTo),y
	iny
	dex
	bpl ?nextChar

	; Move draw ptr to next line
	clc
	lda zpTo
	adc #40
	sta zpTo
	bcc ?noHighBitClear
	inc zpTo+1
?noHighBitClear:

	clc
	lda zpFrom
	adc #20
	sta zpFrom
	bcc ?noHighBitClearFrom
	inc zpFrom+1
?noHighBitClearFrom:

	dec zpWorkH
	lda zpWorkH
	bpl ?nextLine

	rts

RestoreLevelDone:
	lda #<RestoreLevelDoneBitmap
	sta zpFromL
	lda #>RestoreLevelDoneBitmap
	sta zpFromH
	jmp ?draw20x13