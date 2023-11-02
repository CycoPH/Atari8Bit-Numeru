#pragma once
#ifndef _GLOBALS_H_
#define _GLOBALS_H_

#include "constants.h"

extern byte LevelNr;
extern byte pos;
extern byte val;

// This is where the game is generated and what the target has to look like
extern byte GenTilesTop[NUM_SPOTS];
extern byte GenTilesLeft[NUM_SPOTS];
extern byte GenTilesRight[NUM_SPOTS];
extern byte GenTilesBottom[NUM_SPOTS];

// These are the tiles that can be selected and placed
extern byte StoreTilesTop[NUM_SPOTS];
extern byte StoreTilesLeft[NUM_SPOTS];
extern byte StoreTilesRight[NUM_SPOTS];
extern byte StoreTilesBottom[NUM_SPOTS];

// This is where the game is played
extern byte PlayTilesTop[NUM_SPOTS];
extern byte PlayTilesLeft[NUM_SPOTS];
extern byte PlayTilesRight[NUM_SPOTS];
extern byte PlayTilesBottom[NUM_SPOTS];

extern void generate(void);

#endif