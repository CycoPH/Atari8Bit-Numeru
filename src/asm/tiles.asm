; All 5x5 game tiles
; there are 16 variations. 1x for each black & white color variation
; 0 = all black
; 1 = top white
; 2 = right white
; 4 = bottom white
; 8 = left right
; 15 = all white

Tile0:
	.BYTE 71,0,0,0,72,0,71,0
	.BYTE 72,0,0,0,1,0,0,0
	.BYTE 72,0,71,0,72,0,0,0
	.BYTE 71

Tile1:
	.BYTE 126,128,128,128,127,0,126,128
	.BYTE 127,0,0,0,2,0,0,0
	.BYTE 72,0,71,0,72,0,0,0
	.BYTE 71

Tile2:
	.BYTE 71,0,0,0,124,0,71,0
	.BYTE 124,128,0,0,3,128,128,0
	.BYTE 72,0,126,128,72,0,0,0
	.BYTE 126

Tile3:
	.BYTE 126,128,128,128,200,0,126,128
	.BYTE 200,128,0,0,4,128,128,0
	.BYTE 72,0,126,128,72,0,0,0
	.BYTE 126

Tile4:
	.BYTE 71,0,0,0,72,0,71,0
	.BYTE 72,0,0,0,5,0,0,0
	.BYTE 124,128,125,0,124,128,128,128
	.BYTE 125

Tile5:
	.BYTE 126,128,128,128,127,0,126,128
	.BYTE 127,0,0,0,6,0,0,0
	.BYTE 124,128,125,0,124,128,128,128
	.BYTE 125

Tile6:
	.BYTE 71,0,0,0,124,0,71,0
	.BYTE 124,128,0,0,7,128,128,0
	.BYTE 124,128,199,128,124,128,128,128
	.BYTE 199

Tile7:
	.BYTE 126,128,128,128,200,0,126,128
	.BYTE 200,128,0,0,8,128,128,0
	.BYTE 124,128,199,128,124,128,128,128
	.BYTE 199

Tile8:
	.BYTE 125,0,0,0,72,128,125,0
	.BYTE 72,0,128,128,9,0,0,128
	.BYTE 127,0,71,0,127,0,0,0
	.BYTE 71

Tile9:
	.BYTE 199,128,128,128,127,128,199,128
	.BYTE 127,0,128,128,10,0,0,128
	.BYTE 127,0,71,0,127,0,0,0
	.BYTE 71

Tile10:
	.BYTE 125,0,0,0,124,128,125,0
	.BYTE 124,128,128,128,11,128,128,128
	.BYTE 127,0,126,128,127,0,0,0
	.BYTE 126

Tile11:
	.BYTE 199,128,128,128,200,128,199,128
	.BYTE 200,128,128,128,12,128,128,128
	.BYTE 127,0,126,128,127,0,0,0
	.BYTE 126

Tile12:
	.BYTE 125,0,0,0,72,128,125,0
	.BYTE 72,0,128,128,13,0,0,128
	.BYTE 200,128,125,0,200,128,128,128
	.BYTE 125

Tile13:
	.BYTE 199,128,128,128,127,128,199,128
	.BYTE 127,0,128,128,14,0,0,128
	.BYTE 200,128,125,0,200,128,128,128
	.BYTE 125

Tile14:
	.BYTE 125,0,0,0,124,128,125,0
	.BYTE 124,128,128,128,15,128,128,128
	.BYTE 200,128,199,128,200,128,128,128
	.BYTE 199

Tile15:
	.BYTE 199,128,128,128,200,128,199,128
	.BYTE 200,128,128,128,129,128,128,128
	.BYTE 200,128,199,128,200,128,128,128
	.BYTE 199

Tiles:
	.WORD Tile0,Tile1,Tile2,Tile3
	.WORD Tile4,Tile5,Tile6,Tile7
	.WORD Tile8,Tile9,Tile10,Tile11
	.WORD Tile12,Tile13,Tile14,Tile15

; Chars to draw to get a number onto the screen
; Vertical layout (top + bottom)
NumbersV1:
	.byte 75			; 0 - vertical
	.byte 79			; 1
	.byte 83			; 2
	.byte 87			; 3
	.byte 91			; 4
	.byte 95			; 5
	.byte 99			; 6
	.byte 103			; 7
	.byte 107			; 8
	.byte 111			; 9
	; Now the inverse of the numbers
	.byte 203			; 0
	.byte 207			; 1
	.byte 211			; 2
	.byte 215			; 3
	.byte 219			; 4
	.byte 223			; 5
	.byte 227			; 6
	.byte 231			; 7
	.byte 235			; 8
	.byte 239			; 9
NumbersV2:
	.byte 76			; 0 - vertical
	.byte 80			; 1
	.byte 84			; 2
	.byte 88			; 3
	.byte 92			; 4
	.byte 96			; 5
	.byte 100			; 6
	.byte 104			; 7
	.byte 108			; 8
	.byte 112			; 9
	; Now the inverse of the numbers
	.byte 204			; 0
	.byte 208			; 1
	.byte 212			; 2
	.byte 216			; 3
	.byte 220			; 4
	.byte 224			; 5
	.byte 228			; 6
	.byte 232			; 7
	.byte 236			; 8
	.byte 240			; 9

; Horizontal layout (left + right)
NumbersH1:
	.byte 73			; 0 - horizontal
	.byte 77			; 1
	.byte 81			; 2
	.byte 85			; 3
	.byte 89			; 4
	.byte 93			; 5
	.byte 97			; 6
	.byte 101			; 7
	.byte 105			; 8
	.byte 109			; 9
	; Now the inverse of the numbers
	.byte 201			; 0
	.byte 205			; 1
	.byte 209			; 2
	.byte 213			; 3
	.byte 217			; 4
	.byte 221			; 5
	.byte 225			; 6
	.byte 229			; 7
	.byte 233			; 8
	.byte 237			; 9

NumbersH2:
	.byte 74			; 0 - horizontal
	.byte 78			; 1
	.byte 82			; 2
	.byte 86			; 3
	.byte 90			; 4
	.byte 94			; 5
	.byte 98			; 6
	.byte 102			; 7
	.byte 106			; 8
	.byte 110			; 9
	; Now the inverse of the numbers
	.byte 202			; 0
	.byte 206			; 1
	.byte 210			; 2
	.byte 214			; 3
	.byte 218			; 4
	.byte 222			; 5
	.byte 226			; 6
	.byte 230			; 7
	.byte 234			; 8
	.byte 238			; 9
