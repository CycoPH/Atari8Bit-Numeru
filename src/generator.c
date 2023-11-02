#include <atari.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "atari_fn.h"
#include <peekpoke.h>
#include "globals.h"
#include "zp.h"
#include "asm-interface.h"

#define val ZP.WorkVal
#define LevelNr ZP.LevelNr

// 12 numbers are single use numbers
// 12 numbers are double use numbers
// Each tile has 4 spots Top, Left, Right, Bottom (TLRB)
// Arrange the tiles in a 3x3 grid:
//    0T       1T       2T
// 0L .. 0R 1L .. 1R 2L .. 2R
//    0B       1B       2B
//    3T       4T       5T
// 3L .. 3R 4L .. 4R 5L .. 5R
//    3B       4B       5B
//    6T       7T       8T
// 6L .. 6R 7L .. 7R 8L .. 8R
//    6B       7B       8B
//
// 0T,1T,2T, 0L,3L,6L, 6B,7B,8B, 2R,5R,8R can all be assigned a single RNG value
// Inner connections like 0R-1L, 1R-2L will each get assigned the same value (one per connection)
// 24 random numbers in total

// Match-up information
// We count the number of matches: 6 horizontal and 6 vertical
// Horizontal:
//	0R-1L		Bit 0
//	1R-2L		Bit 1
//	3R-4L		Bit 2
//	4R-5L		Bit 3
//	6R-7L		Bit 4
//	7R-8L		Bit 5
// Vertical
//	0B-3T		Bit 0
//	1B-4T		Bit 1
//	2B-5T		Bit 2
//	3B-6T		Bit 3
//	4B-7T		Bit 4
//	5B-8T		Bit 5
byte MapDifficultyLevel[10] = {0,16,32,48,64,80,96,112,128,192};
byte Number()
{
	byte level = (ZP.DifficultyNumbers);
	byte q;
	
	q = rand() % level;
	if (ZP.DifficultyColor == 0)
		return q;
	if ((byte)rand() < MapDifficultyLevel[ZP.DifficultyLevel])
		return q + 10;
	return q;
}

void RotateActiveCW() 
{
	ZP.ByteParam0 = ZP.ActiveTop;
	ZP.ActiveTop = ZP.ActiveLeft;
	ZP.ActiveLeft = ZP.ActiveBottom;
	ZP.ActiveBottom = ZP.ActiveRight;
	ZP.ActiveRight = ZP.ByteParam0;
}

void RotateActiveCCW() 
{
	ZP.ByteParam0 = ZP.ActiveTop;
	ZP.ActiveTop = ZP.ActiveRight;
	ZP.ActiveRight = ZP.ActiveBottom;
	ZP.ActiveBottom = ZP.ActiveLeft;
	ZP.ActiveLeft = ZP.ByteParam0;
}

// Rotate clock-wise T->R->B->L->T
void RotateStoreCW(byte tileNr)
{
	ZP.ByteParam1 = tileNr;
	ZP.ByteParam0 = StoreTilesTop[ZP.ByteParam1];

	ZP.WorkVal = StoreTilesLeft[ZP.ByteParam1];
	StoreTilesTop[ZP.ByteParam1] = ZP.WorkVal;

	ZP.WorkVal = StoreTilesBottom[ZP.ByteParam1];
	StoreTilesLeft[ZP.ByteParam1] = ZP.WorkVal;

	ZP.WorkVal = StoreTilesRight[ZP.ByteParam1];
	StoreTilesBottom[ZP.ByteParam1] = ZP.WorkVal; 

	StoreTilesRight[ZP.ByteParam1] = ZP.ByteParam0;
}

void MoveStore()
{
	ZP.From = (byte)rand() % (byte)NUM_SPOTS;
	ZP.To = (byte)rand() % (byte)NUM_SPOTS;

	if (ZP.From == ZP.To)
		return;

	val = StoreTilesTop[ZP.From];
	ZP.WorkI = StoreTilesTop[ZP.To];
	StoreTilesTop[ZP.From] = ZP.WorkI;
	StoreTilesTop[ZP.To] = val;

	val = StoreTilesLeft[ZP.From];
	ZP.WorkI = StoreTilesLeft[ZP.To];
	StoreTilesLeft[ZP.From] = ZP.WorkI;
	StoreTilesLeft[ZP.To] = val;

	val = StoreTilesRight[ZP.From];
	ZP.WorkI = StoreTilesRight[ZP.To];
	StoreTilesRight[ZP.From] = ZP.WorkI;
	StoreTilesRight[ZP.To] = val;

	val = StoreTilesBottom[ZP.From];
	ZP.WorkI =StoreTilesBottom[ZP.To];
	StoreTilesBottom[ZP.From] = ZP.WorkI;
	StoreTilesBottom[ZP.To] = val;
}

// ============================================================================
// Generate the hint information
void GenerateHint(void)
{
	byte x,y,i = 0;
	byte line = 47;

	for (y = 0; y < 3; ++y) 
	{
		for (x = 0; x < 3; ++x) 
		{
			if (ZP.DifficultyHint)
			{
				ZP.WorkTop = GenTilesTop[i];
				ZP.WorkRight = GenTilesRight[i];
				ZP.WorkBottom = GenTilesBottom[i];
				ZP.WorkLeft = GenTilesLeft[i];
				CalcTileBackground();
			}
			else
				ZP.WorkBaseColors = 255;

			POKE(CODE_GAMEGUI + line + x, ZP.WorkBaseColors+1);
			++i;
		}
		line += 40;
	}	
}

// ============================================================================
// Generate the level
void GenerateLevel(void)
{
	byte i;
	byte j;
	//srand(LevelNr);			// Seed it with some 
	srand(ZP.VBICounter);

	// Generate the 12 numbers on the outside of the tiles
	GenTilesTop[0] = Number();
	GenTilesTop[1] = Number();
	GenTilesTop[2] = Number();

	GenTilesLeft[0] = Number();
	GenTilesLeft[3] = Number();
	GenTilesLeft[6] = Number();

	GenTilesBottom[6] = Number();
	GenTilesBottom[7] = Number();
	GenTilesBottom[8] = Number();

	GenTilesRight[2] = Number();
	GenTilesRight[5] = Number();
	GenTilesRight[8] = Number();

	// Generate the 12 numbers that are on the inside of the tiles
	// and each number is used twice
	GenTilesRight[0] = GenTilesLeft[1] = Number();
	GenTilesRight[1] = GenTilesLeft[2] = Number();
	GenTilesRight[3] = GenTilesLeft[4] = Number();
	GenTilesRight[4] = GenTilesLeft[5] = Number();
	GenTilesRight[6] = GenTilesLeft[7] = Number();
	GenTilesRight[7] = GenTilesLeft[8] = Number();

	GenTilesBottom[0] = GenTilesTop[3] = Number();
	GenTilesBottom[1] = GenTilesTop[4] = Number();
	GenTilesBottom[2] = GenTilesTop[5] = Number();
	GenTilesBottom[3] = GenTilesTop[6] = Number();
	GenTilesBottom[4] = GenTilesTop[7] = Number();
	GenTilesBottom[5] = GenTilesTop[8] = Number();

	// Transfer the generated items to the store
	for (i = 0; i < NUM_SPOTS; ++i)
	{
		val = GenTilesTop[i];
		StoreTilesTop[i] = val;

		val = GenTilesLeft[i];
		StoreTilesLeft[i] = val;

		val = GenTilesRight[i];
		StoreTilesRight[i] = val;

		val = GenTilesBottom[i];
		StoreTilesBottom[i] = val;
	}

	// Rotate the items in the store
	if (ZP.DifficultRotation)
	{
		for (i = 0; i < NUM_SPOTS; ++i)
		{
			// 1 in 4 chance to rotate the tile
			val = (byte)rand() % 7;
			for (j = val; j > 0; --j)
			{
				RotateStoreCW(i);
			}
		}
	}

	// Shuffle the store tiles
	for (i = 0; i < 64; ++i)
	{
		MoveStore();
	}

	// Mark the Play tiles as empty
	for (i = 0; i < NUM_SPOTS; ++i)
	{
		PlayTilesTop[i] = 128;
		PlayTilesLeft[i] = 128;
		PlayTilesRight[i] = 128;
		PlayTilesBottom[i] = 128;
	}
}