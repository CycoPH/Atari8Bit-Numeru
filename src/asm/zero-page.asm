zpStoreTilesTop			= $17	; ptr to StoreTilesTop[]
zpStoreTilesRight		= $19	; ptr to StoreTilesRight[]
zpStoreTilesBottom		= $1B	; ptr to StoreTilesBottom[]
zpStoreTilesLeft		= $1D	; ptr to StoreTilesLeft[]

zpPlayTilesTop			= $1F	; ptr to PlayTilesTop[]
zpPlayTilesRight		= $21	; ptr to PlayTilesRight[]
zpPlayTilesBottom		= $23	; ptr to PlayTilesBottom[]
zpPlayTilesLeft			= $25	; ptr to PlayTilesLeft[]

zpScreenPtrL			= $27
zpScreenPtrH			= $28
zpScreenPtr				= $27

zpFromL					= $29
zpFromH					= $2A
zpFrom					= $29

zpToL					= $2B
zpToH					= $2C
zpTo					= $2B

zpLevelNr				= $2D

zpActiveTop				= $2E	; Active tile's top number
zpActiveRight			= $2F	; Active tile's right number
zpActiveBottom			= $30	; Active tile's bottom number
zpActiveLeft			= $31	; Active tile's left number

zpNumHorizontalMatches	= $33	; How many and which of the 6 horizontal bridges match up
zpNumVerticalMatches	= $34	; How many and which of the 6 vertical bridges match up

zpCursorPosition		= $37	; Where is the interaction cursor 0 - 17
zpPrevCursorPosition	= $38	; Where was the cursor before

zpScore					= $44	; $44-$47 Score/Step counter
zpLastScore				= $48	; $48-$4B Last drawn score value

zpWorkX					= $50	; WorkX - general X value in a function
zpWorkY					= $51	; WorkY - general Y value in a function
zpWorkI					= $52	; Any temp I variable
zpWorkW					= $53	; Any temp W variable
zpWorkH					= $54	; Any temp H variable
zpWorkVal				= $55	; Any "val" variable (just so that we have zero page access)

zpWorkTop				= $56	; The 4 numbers to use for the current tile
zpWorkRight				= $57
zpWorkBottom			= $58
zpWorkLeft				= $59
zpWorkBaseColors		= $5A	; 0-15 which base tile to draw

zpClockVbi				= $5D	; 0-50/60 to make 1 second
zpClockSeconds			= $5E	; 0-60 to make 1 minute
zpClockMinutes			= $5F	; 0-99 and stop counting there

zpStopTheClock			= $63	; 1 then the clock stops running

zpVBICounter			= $68	; Every VBI we count up. Is used to seed the RNG

zpSFX0					= $6D	; Sound Effect 0
zpSFX1					= $6E	; Sound Effect 1
zpSFX					= $6F

zpDifficultyLevel		= $70	; 0 = black 255 = white 128 = 50/50
zpDifficultyNumbers		= $71	; 2-9 >= 10 then subtract 9
zpDifficultyColor		= $72	; 0 = no 1 = yes
zpDifficultRotation		= $73	; 0 = no 1 = yes
zpDifficultyMenu		= $75	; 0 = level, 1 = numbers, 2 = color, 3 = rotation

zpPrevJoystick0			= $7E	; Previously processed joystick value
zpJoystick0				= $7F	; The last joystick state. 0 = nothing