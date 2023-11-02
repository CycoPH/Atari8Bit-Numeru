; =============================================================================
PLAYER 			= $4000		; Where is the RMT player to be located
MUSIC_DATA 		= $4400		; Where are the music and the sound effects located

STEREOMODE	= 0

PM_SPRITE = $A000
PM0 			= PM_SPRITE + $400
PM1 			= PM0 + $100
PM2 			= PM1 + $100
PM3 			= PM2 + $100

CURSOR_COLOR_OK		= $86
CURSOR_COLOR_BAD	= $22

MATCH_H_0R1L 	= 1
MATCH_H_1R2L 	= 2
MATCH_H_3R4L 	= 4
MATCH_H_4R5L 	= 8
MATCH_H_6R7L 	= 16
MATCH_H_7R8L 	= 32

MATCH_V_0B3T 	= 1
MATCH_V_1B4T 	= 2
MATCH_V_2B5T 	= 4
MATCH_V_3B6T 	= 8
MATCH_V_4B7T 	= 16
MATCH_V_5B8T 	= 32
