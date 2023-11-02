#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <conio.h>
#include "globals.h"

byte pos;
byte val;
byte LevelNr;

byte GenTilesTop[NUM_SPOTS];
byte GenTilesRight[NUM_SPOTS];
byte GenTilesBottom[NUM_SPOTS];
byte GenTilesLeft[NUM_SPOTS];

// These are the tiles that can be selected and placed
byte StoreTilesTop[NUM_SPOTS];
byte StoreTilesRight[NUM_SPOTS];
byte StoreTilesBottom[NUM_SPOTS];
byte StoreTilesLeft[NUM_SPOTS];

// This is where the game is played
byte PlayTilesTop[NUM_SPOTS];
byte PlayTilesRight[NUM_SPOTS];
byte PlayTilesBottom[NUM_SPOTS];
byte PlayTilesLeft[NUM_SPOTS];

unsigned char* StoreTiles[4] = { &StoreTilesTop[0], StoreTilesRight, StoreTilesBottom, StoreTilesLeft };
unsigned char* PlayTiles[4] = { &PlayTilesTop[0], PlayTilesRight, PlayTilesBottom, PlayTilesLeft };


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
//  T   T   T
// LxR LxR LxR
byte PlayTop(int tileNr)
{
	if (PlayTilesTop[tileNr] == 128)
		return ' ';
	if (PlayTilesTop[tileNr] > 9)
		return 'A' + PlayTilesTop[tileNr];
	return '0' + PlayTilesTop[tileNr];
}
byte PlayBottom(int tileNr)
{
	if (PlayTilesBottom[tileNr] == 128)
		return ' ';
	if (PlayTilesBottom[tileNr] > 9)
		return 'A' + PlayTilesBottom[tileNr];
	return '0' + PlayTilesBottom[tileNr];
}

byte PlayLeft(int tileNr)
{
	if (PlayTilesLeft[tileNr] == 128)
		return ' ';
	if (PlayTilesLeft[tileNr] > 9)
		return 'A' + PlayTilesLeft[tileNr];
	return '0' + PlayTilesLeft[tileNr];
}

byte PlayRight(int tileNr)
{
	if (PlayTilesRight[tileNr] == 128)
		return ' ';
	if (PlayTilesRight[tileNr] > 9)
		return 'A' + PlayTilesRight[tileNr];
	return '0' + PlayTilesRight[tileNr];
}

byte StoreTop(int tileNr)
{
	if (StoreTilesTop[tileNr] == 128)
		return ' ';
	if (StoreTilesTop[tileNr] > 9)
		return 'A' + StoreTilesTop[tileNr];
	return '0' + StoreTilesTop[tileNr];
}
byte StoreBottom(int tileNr)
{
	if (StoreTilesBottom[tileNr] == 128)
		return ' ';
	if (StoreTilesBottom[tileNr] > 9)
		return 'A' + StoreTilesBottom[tileNr];
	return '0' + StoreTilesBottom[tileNr];
}

byte StoreLeft(int tileNr)
{
	if (StoreTilesLeft[tileNr] == 128)
		return ' ';
	if (StoreTilesLeft[tileNr] > 9)
		return 'A' + StoreTilesLeft[tileNr];
	return '0' + StoreTilesLeft[tileNr];
}
byte StoreRight(int tileNr)
{
	if (StoreTilesRight[tileNr] == 128)
		return ' ';
	if (StoreTilesRight[tileNr] > 9)
		return 'A' + StoreTilesRight[tileNr];
	return '0' + StoreTilesRight[tileNr];
}

byte GenTop(int tileNr)
{
	if (GenTilesTop[tileNr] == 128)
		return ' ';
	if (GenTilesTop[tileNr] > 9)
		return 'A' + GenTilesTop[tileNr];
	return '0' + GenTilesTop[tileNr];
}
byte GenBottom(int tileNr)
{
	if (GenTilesBottom[tileNr] == 128)
		return ' ';
	if (GenTilesBottom[tileNr] > 9)
		return 'A' + GenTilesBottom[tileNr];
	return '0' + GenTilesBottom[tileNr];
}

byte GenLeft(int tileNr)
{
	if (GenTilesLeft[tileNr] == 128)
		return ' ';
	if (GenTilesLeft[tileNr] > 9)
		return 'A' + GenTilesLeft[tileNr];
	return '0' + GenTilesLeft[tileNr];
}
byte GenRight(int tileNr)
{
	if (GenTilesRight[tileNr] == 128)
		return ' ';
	if (GenTilesRight[tileNr] > 9)
		return 'A' + GenTilesRight[tileNr];
	return '0' + GenTilesRight[tileNr];
}

void RenderGameArea()
{
	system("cls");
	// Top
	printf("\\%c/  \\%c/  \\%c/    ", PlayTop(0), PlayTop(1), PlayTop(2));
	printf("\\%c/  \\%c/  \\%c/    ", StoreTop(0), StoreTop(1), StoreTop(2));
	printf("\\%c/  \\%c/  \\%c/\n", GenTop(0), GenTop(1), GenTop(2));
	printf("%cX%c  %cX%c  %cX%c    ", PlayLeft(0), PlayRight(0), PlayLeft(1), PlayRight(1), PlayLeft(2), PlayRight(2));
	printf("%cX%c  %cX%c  %cX%c    ", StoreLeft(0), StoreRight(0), StoreLeft(1), StoreRight(1), StoreLeft(2), StoreRight(2));
	printf("%cX%c  %cX%c  %cX%c\n", GenLeft(0), GenRight(0), GenLeft(1), GenRight(1), GenLeft(2), GenRight(2));
	printf("/%c\\  /%c\\  /%c\\    ", PlayBottom(0), PlayBottom(1), PlayBottom(2));
	printf("/%c\\  /%c\\  /%c\\    ", StoreBottom(0), StoreBottom(1), StoreBottom(2));
	printf("/%c\\  /%c\\  /%c\\\n", GenBottom(0), GenBottom(1), GenBottom(2));
	// Mid
	printf("\\%c/  \\%c/  \\%c/    ", PlayTop(3), PlayTop(4), PlayTop(5));
	printf("\\%c/  \\%c/  \\%c/    ", StoreTop(3), StoreTop(4), StoreTop(5));
	printf("\\%c/  \\%c/  \\%c/\n", GenTop(3), GenTop(4), GenTop(5));
	printf("%cX%c  %cX%c  %cX%c    ", PlayLeft(3), PlayRight(3), PlayLeft(4), PlayRight(4), PlayLeft(5), PlayRight(5));
	printf("%cX%c  %cX%c  %cX%c    ", StoreLeft(3), StoreRight(3), StoreLeft(4), StoreRight(4), StoreLeft(5), StoreRight(5));
	printf("%cX%c  %cX%c  %cX%c\n", GenLeft(3), GenRight(3), GenLeft(4), GenRight(4), GenLeft(5), GenRight(5));
	printf("/%c\\  /%c\\  /%c\\    ", PlayBottom(3), PlayBottom(4), PlayBottom(5));
	printf("/%c\\  /%c\\  /%c\\    ", StoreBottom(3), StoreBottom(4), StoreBottom(5));
	printf("/%c\\  /%c\\  /%c\\\n", GenBottom(3), GenBottom(4), GenBottom(5));
	// Bottom
	printf("\\%c/  \\%c/  \\%c/    ", PlayTop(6), PlayTop(7), PlayTop(8));
	printf("\\%c/  \\%c/  \\%c/    ", StoreTop(6), StoreTop(7), StoreTop(8));
	printf("\\%c/  \\%c/  \\%c/\n", GenTop(6), GenTop(7), GenTop(8));
	printf("%cX%c  %cX%c  %cX%c    ", PlayLeft(6), PlayRight(6), PlayLeft(7), PlayRight(7), PlayLeft(8), PlayRight(8));
	printf("%cX%c  %cX%c  %cX%c    ", StoreLeft(6), StoreRight(6), StoreLeft(7), StoreRight(7), StoreLeft(8), StoreRight(8));
	printf("%cX%c  %cX%c  %cX%c\n", GenLeft(6), GenRight(6), GenLeft(7), GenRight(7), GenLeft(8), GenRight(8));
	printf("/%c\\  /%c\\  /%c\\    ", PlayBottom(6), PlayBottom(7), PlayBottom(8));
	printf("/%c\\  /%c\\  /%c\\    ", StoreBottom(6), StoreBottom(7), StoreBottom(8));
	printf("/%c\\  /%c\\  /%c\\\n", GenBottom(6), GenBottom(7), GenBottom(8));
}
	


int main()
{
	generate();
	RenderGameArea();
}
