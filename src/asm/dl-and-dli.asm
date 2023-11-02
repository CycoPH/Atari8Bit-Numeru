GameDisplayList:
	.byte $70,$70,$70       	; 24 blank lines
	.byte DL_LMS|DL_TEXT_2, <GameGui, >GameGui
	.byte DL_TEXT_2, DL_TEXT_2, DL_TEXT_2, DL_TEXT_2, DL_TEXT_2
	; Game screen section
	; New memory address + DLI
	.byte DL_LMS|DL_TEXT_2 
GameScreenAddr:					; Write the game screen address into this location
	.byte <GameScreen, >GameScreen ; 1x mode 2 line + LMS + address
	.byte DL_TEXT_2, DL_TEXT_2, DL_TEXT_2, DL_TEXT_2, DL_TEXT_2	; 5 lines
	.byte DL_TEXT_2, DL_TEXT_2, DL_TEXT_2, DL_TEXT_2, DL_TEXT_2 ; 5 lines
	.byte DL_TEXT_2, DL_TEXT_2, DL_TEXT_2, DL_TEXT_2, DL_TEXT_2, 
	.byte DL_TEXT_2, DL_TEXT_2
	.byte $41,<GameDisplayList,>GameDisplayList ; JVB ends display list

TitleDisplayList:
	.byte $70,$70,$70       	; 24 blank lines
	.byte DL_LMS|DL_TEXT_2, <TitleScreen, >TitleScreen
	.byte DL_TEXT_2, DL_TEXT_2, DL_TEXT_2, DL_TEXT_2, DL_TEXT_2
	.byte DL_TEXT_2 
	.byte DL_TEXT_2, DL_TEXT_2, DL_TEXT_2, DL_TEXT_2, DL_TEXT_2	; 5 lines
	.byte DL_TEXT_2, DL_TEXT_2, DL_TEXT_2, DL_TEXT_2, DL_TEXT_2 ; 5 lines
	.byte DL_TEXT_2, DL_TEXT_2, DL_TEXT_2, DL_TEXT_2, DL_TEXT_2, 
	.byte DL_TEXT_2, DL_TEXT_2
	.byte $41,<TitleDisplayList,>TitleDisplayList ; JVB ends display list