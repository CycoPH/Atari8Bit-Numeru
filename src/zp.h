#ifndef _ZERO_PAGE_H_
#define _ZERO_PAGE_H_

#include "globals.h"

#define offsetof(type, member)  (size_t) (&((type*) 0)->member)
#define offsetof2(a,b) (size_t) &( ((a*)0) -> b)
#define array_offsetof(type, member, index) (offsetof(type, member) + sizeof( ((type *)0)->member[0]) * index)
#define access(member) (size_t) (&((_zp*) 0)->member)
// C <--> ASM interface
// Page Zero memory allocation
struct _zp {
	// ---- Zero Page ----
	unsigned char _Skip1[0x15];				// $00-$14 Don't touch

	unsigned char _15;						// $15
	unsigned char _16;						// $16
	unsigned char* ptrStoreTilesTop;		// ($17,$18) ptr to StoreTileTop
	unsigned char* ptrStoreTilesRight;		// ($19,$1A) ptr to StoreTileRight
	unsigned char* ptrStoreTilesBottom;		// ($1B,$1C) ptr to StoreTileBottom
	unsigned char* ptrStoreTilesLeft;		// ($1D,$1E) ptr to StoreTileLeft
	unsigned char* ptrPlayTilesTop;			// ($1F,$20) ptr to PlayTileTop
	unsigned char* ptrPlayTilesRight;		// ($21,$22) ptr to PlayTileTop
	unsigned char* ptrPlayTilesBottom;		// ($23,$24) ptr to PlayTileTop
	unsigned char* ptrPlayTilesLeft;		// ($25,$26) ptr to PlayTileTop
	unsigned char* ScreenPtr;				// $27,$28	Draw to screen ptr (used to actively)
	unsigned char* FromPtr;					// $29,$2A	(ptr) used as a source for copy
	unsigned char* ToPtr;					// $2B,$2C	(ptr) used as a dest for copy
	unsigned char LevelNr;					// $2D		Level Nr
	unsigned char ActiveTop;				// $2E		Top value of the current active tile
	unsigned char ActiveRight;				// $2F		
	unsigned char ActiveBottom;				// $30
	unsigned char ActiveLeft;				// $31
	unsigned char ActiveOffset;				// $32 - 0-8 9-17 index of where the active tile values are coming from 9-17 = storage
	unsigned char NumHorizontalMatches;		// $33 - How many and which of the 6 horizontal bridges match up
	unsigned char NumVerticalMatches;		// $34 - How many and which of the 6 vertical bridges match up
	unsigned char _35;						// $35		
	unsigned char _36;						// $36	
	unsigned char CursorPosition;			// $37 - Where is the interaction cursor 0 - 17
	unsigned char PrevCursorPosition;		// $38 - Where was the cursor before?
	unsigned char CursorX;					// $39
	unsigned char CursorY;					// $3A
	unsigned char CursorOffset;				// $3B - (0-9) offset into the playfield or the store of the current cursor position
	unsigned char CursorOnStore;			// $3C - if the cursor on the playfield or the store 0=playfield, 1=store
	unsigned char _3D;
	unsigned char _3E;
	unsigned char _3F;
	unsigned char _40;
	unsigned char soundr;					// = $41	NOISY I/0 FLAG. (ZERO IS QUIET)
	unsigned char critic;					// = $42	DEFINES CRITICAL SECTION (CRITICAL IF NON-Z)
	unsigned char _43;
	unsigned char Score[4];					// $44,$45,$46,$47 Score counter
	unsigned char LastScore[4];				// $48,$49,$4A,$4B Last score drawn
	unsigned char _4C;
 	unsigned char atract;					// = $4D	ATRACT FLAG
	unsigned char drkmsk;					// = $4E	DARK ATRACT MASK
    unsigned char colrsh;					// = $4F	ATRACT COLOR SHIFTER (EOR'ED WITH PLAYFIELD
	unsigned char WorkX;					// $50		Any temp X location
	unsigned char WorkY;					// $51		Any temp Y location
	unsigned char WorkI;					// $52		Any temp I variable
	unsigned char WorkW;					// $53		Any temp W variable
	unsigned char WorkH;					// $54		Any temp H variable
	unsigned char WorkVal;					// $55		Any "val" variable (just so that we have zero page access)
	unsigned char WorkTop;					// $56		Current tile top value
	unsigned char WorkRight;				// $57		Current tile right value
	unsigned char WorkBottom;				// $58		Current tile bottom value
	unsigned char WorkLeft;					// $59		Current tile left value
	unsigned char WorkBaseColors;			// $5A		0-15 which base tile to draw
	unsigned char From;						// $5B		general "from" value
	unsigned char To;						// $5C		general "to" value
	unsigned char ClockVBI;					// $5D
	unsigned char ClockSeconds;				// $5E
	unsigned char ClockMinutes;				// $5F
	unsigned char*  fkdef;					// = $60/$61	FUNCTION KEY DEFINITION TABLE
    unsigned char   palnts;					// = $62		PAL/NTSC INDICATOR (0 // = NTSC)
	unsigned char StopTheClock;				// $63
	unsigned char _64;						// $64
	unsigned char ByteParam0;				// $65		First byte parameter for a function call
	unsigned char ByteParam1;				// $66		Second byte parameter for a function call
	unsigned char _67;
	unsigned char VBICounter;				// $68	
	unsigned char VbiMode;					// $69		0 = start screen, 1 = game screen
    unsigned char   ramtop;					// = $6A		RAM SIZE DEFINED BY POWER ON LOGIC
	unsigned char _6B;						// $6B
	unsigned char _6C;						// $6C
	unsigned char SFX0;						// $6D - Sound effect 0
	unsigned char SFX1;						// $6E - Sound effect 1
	unsigned char SFX;						// $6F		
	unsigned char DifficultyLevel;			// $70 - 0 = all black 128 = 50/50 255 = all white
	unsigned char DifficultyNumbers;		// $71 - 2-9 >= 10 gives two color mode
	unsigned char DifficultyColor;			// $72 - 0 = Just one color, X is the chance of getting white 1 low, 255 high
	unsigned char DifficultRotation;		// $73 - 0 = no rotation, 1 = with rotation
	unsigned char DifficultyHint;			// $74 - 0 = no hint, 1 = show the color
	unsigned char DifficultyMenu;			// $75 - 0 = numbers, 1 = color, 2 = level, 3 = rotation
	unsigned char _76;
	unsigned char _77;
	unsigned char _78;
	unsigned char*  keydef;					// = $79/$7A	2-BYTE KEY DEFINITION TABLE ADDRESS
	unsigned char _7B;
	unsigned char   holdch;					// = $7C		CH IS MOVED HERE IN KGETCH BEFORE CNTL & SH
	unsigned char _7D;						// $7D
	unsigned char PrevJoystick0;			// $7E		previously processed joystick value
	unsigned char Joystick0;				// $7F		Last joystick 0 value, 0 then nothing

	// From $80-$FF CC65 will use some locations for its ZP values
	// RMT will use from $CB - $DD (19 bytes)
};
typedef struct _zp _zp;

#define ZP (*(struct _zp*)0x0000)

#endif