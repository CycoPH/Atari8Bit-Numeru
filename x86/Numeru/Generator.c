#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "globals.h"

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

byte Number()
{
	return rand() % 20;
}

// Rotate clock-wise T->R->B->L->T
void RotateStoreCW(byte tileNr)
{
	byte temp;
	temp = StoreTilesTop[tileNr];
	StoreTilesTop[tileNr] = StoreTilesLeft[tileNr];
	StoreTilesLeft[tileNr] = StoreTilesBottom[tileNr];
	StoreTilesBottom[tileNr] = StoreTilesRight[tileNr];
	StoreTilesRight[tileNr] = temp;
}

void MoveStore()
{
	byte from;
	byte to;

	from = (byte)rand() % NUM_SPOTS;
	to = (byte)rand() % NUM_SPOTS;

	if (from == to)
		return;

	val = StoreTilesTop[from];
	StoreTilesTop[from] = StoreTilesTop[to];
	StoreTilesTop[to] = val;

	val = StoreTilesLeft[from];
	StoreTilesLeft[from] = StoreTilesLeft[to];
	StoreTilesLeft[to] = val;

	val = StoreTilesRight[from];
	StoreTilesRight[from] = StoreTilesRight[to];
	StoreTilesRight[to] = val;

	val = StoreTilesBottom[from];
	StoreTilesBottom[from] = StoreTilesBottom[to];
	StoreTilesBottom[to] = val;
}

// ============================================================================
// Generate the level
void generate(void)
{
	byte i;
	byte j;
	srand(LevelNr);			// Seed it with some 

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
		StoreTilesTop[i] = GenTilesTop[i];
		StoreTilesLeft[i] = GenTilesLeft[i];
		StoreTilesRight[i] = GenTilesRight[i];
		StoreTilesBottom[i] = GenTilesBottom[i];
	}

	// Rotate the items in the store
	for (i = 0; i < NUM_SPOTS; ++i)
	{
		// 1 in 4 chance to rotate the tile
		val = (byte)rand() % 7;
		for (j = val; j > 0; --j)
		{
			RotateStoreCW(i);
		}
	}

	for (i = 0; i < 64; ++i)
	{
		MoveStore();
	}

	for (i = 0; i < NUM_SPOTS; ++i)
	{
		PlayTilesTop[i] = 128;
		PlayTilesLeft[i] = 128;
		PlayTilesRight[i] = 128;
		PlayTilesBottom[i] = 128;
	}
}