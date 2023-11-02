#include <atari.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "atari_fn.h"
#include <peekpoke.h>

#include "globals.h"
#include "zp.h"
#include "asm-interface.h"
#include "generator.h"


// Place items in Zero-page
#pragma bss-name (push,"ZEROPAGE")
#pragma data-name (push,"ZEROPAGE")
byte pos;
#pragma bss-name (pop)
#pragma data-name (pop)
#pragma zpsym ("pos")

byte val;

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

byte SavedTop;
byte SavedRight;
byte SavedBottom;
byte SavedLeft;
byte SavedSource;	// 0 = playfield, 1 = store
byte SavedOffset;	// 0-9 of which value was saved

void wait()
{
	WaitForVbi();
	ReadJoystick();
}

void SaveUnderCursor()
{
	if (ZP.CursorOnStore) 
	{
		SavedTop = StoreTilesTop[ZP.CursorOffset];
		SavedRight = StoreTilesRight[ZP.CursorOffset];
		SavedBottom = StoreTilesBottom[ZP.CursorOffset];
		SavedLeft = StoreTilesLeft[ZP.CursorOffset];
	}
	else
	{
		SavedTop = PlayTilesTop[ZP.CursorOffset];
		SavedRight = PlayTilesRight[ZP.CursorOffset];
		SavedBottom = PlayTilesBottom[ZP.CursorOffset];
		SavedLeft = PlayTilesLeft[ZP.CursorOffset];

	}

	SavedSource = ZP.CursorOnStore;
	SavedOffset = ZP.CursorOffset;
}

void RestoreUnderCursor()
{
	if (SavedSource) 
	{
		// Store
		StoreTilesTop[SavedOffset] = SavedTop;
		StoreTilesRight[SavedOffset] = SavedRight;
		StoreTilesBottom[SavedOffset] = SavedBottom;
		StoreTilesLeft[SavedOffset] = SavedLeft;
		asm("ldy %v", SavedOffset);
		asm("jsr %w", CODE_DRAWSTORETILE);
	}
	else {
		// Playfield
		PlayTilesTop[SavedOffset] = SavedTop;
		PlayTilesRight[SavedOffset] = SavedRight;
		PlayTilesBottom[SavedOffset] = SavedBottom;
		PlayTilesLeft[SavedOffset] = SavedLeft;
		asm("ldy %v", SavedOffset);
		asm("jsr %w", CODE_DRAWPLAYTILE);
	}
}

void UpdateWithActive()
{
	if (ZP.CursorOnStore)
	{
		StoreTilesTop[ZP.CursorOffset] = ZP.ActiveTop;
		StoreTilesRight[ZP.CursorOffset] = ZP.ActiveRight;
		StoreTilesBottom[ZP.CursorOffset] = ZP.ActiveBottom;
		StoreTilesLeft[ZP.CursorOffset] = ZP.ActiveLeft;

		asm("ldy %w", offsetof(_zp, CursorOffset));
		asm("jsr %w", CODE_DRAWSTORETILE);
	}
	else
	{
		// On the playfield, set the action value and draw
		PlayTilesTop[ZP.CursorOffset] = ZP.ActiveTop;
		PlayTilesRight[ZP.CursorOffset] = ZP.ActiveRight;
		PlayTilesBottom[ZP.CursorOffset] = ZP.ActiveBottom;
		PlayTilesLeft[ZP.CursorOffset] = ZP.ActiveLeft;

		asm("ldy %w", offsetof(_zp, CursorOffset));
		asm("jsr %w", CODE_DRAWPLAYTILE);
	}

}

void UpdateCursorInfo()
{
	// Check if the cursor is on the playfield
	if (ZP.CursorX < 3)
	{
		ZP.CursorOnStore = 0;
		ZP.CursorOffset = ZP.CursorY * 3 + ZP.CursorX;
	}
	else
	{
		ZP.CursorOnStore = 1;
		ZP.CursorOffset = ZP.CursorY * 3 + ZP.CursorX - 3;
	}

	ZP.CursorPosition = (byte)((byte)(ZP.CursorY*6) + ZP.CursorX);
	DrawCursor();
}

void MoveCursor()
{
	// Joystick direction moved the cursor to a new location
	if (ZP.Joystick0 & JOYSTICK_LEFT)
	{
		if (ZP.CursorX == 0)
			ZP.CursorX = 5;
		else
			--ZP.CursorX;
	}
	else if (ZP.Joystick0 & JOYSTICK_RIGHT)
	{
		if (ZP.CursorX == 5)
			ZP.CursorX = 0;
		else
			++ZP.CursorX;
	}
	if (ZP.Joystick0 & JOYSTICK_UP)
	{
		if (ZP.CursorY == 0)
			ZP.CursorY = 2;
		else
			--ZP.CursorY;
	}
	else if (ZP.Joystick0 & JOYSTICK_DOWN)
	{
		if (ZP.CursorY == 2)
			ZP.CursorY = 0;
		else
			++ZP.CursorY;
	}

	UpdateCursorInfo();
}

// Check the play field for 12 matching combinations
byte CheckForLevelDone()
{
	ZP.NumHorizontalMatches = 0;
	// 0R-1L  Bit 0
	if (PlayTilesTop[0] < 128 && PlayTilesTop[1] < 128)
	{
		if (PlayTilesRight[0] == PlayTilesLeft[1])
			ZP.NumHorizontalMatches |= MATCH_H_0R1L;
	}

	// 1R-2L		Bit 1
	if (PlayTilesTop[1] < 128 && PlayTilesTop[2] < 128)
	{
		if (PlayTilesRight[1] == PlayTilesLeft[2])
			ZP.NumHorizontalMatches |= MATCH_H_1R2L;
	}

	// 3R-4L		Bit 2
	if (PlayTilesTop[3] < 128 && PlayTilesTop[4] < 128)
	{
		if (PlayTilesRight[3] == PlayTilesLeft[4])
			ZP.NumHorizontalMatches |= MATCH_H_3R4L;
	}

	// 4R-5L		Bit 3
	if (PlayTilesTop[4] < 128 && PlayTilesTop[5] < 128)
	{
		if (PlayTilesRight[4] == PlayTilesLeft[5])
			ZP.NumHorizontalMatches |= MATCH_H_4R5L;
	}

	// 6R-7L		Bit 4
	if (PlayTilesTop[6] < 128 && PlayTilesTop[7] < 128)
	{
		if (PlayTilesRight[6] == PlayTilesLeft[7])
			ZP.NumHorizontalMatches |= MATCH_H_6R7L;
	}

	// 7R-8L		Bit 5
	if (PlayTilesTop[7] < 128 && PlayTilesTop[8] < 128)
	{
		if (PlayTilesRight[7] == PlayTilesLeft[8])
			ZP.NumHorizontalMatches |= MATCH_H_7R8L;
	}

	ZP.NumVerticalMatches = 0;
	
	// 0B-3T  Bit 0
	if (PlayTilesTop[0] < 128 && PlayTilesTop[3] < 128)
	{
		if (PlayTilesBottom[0] == PlayTilesTop[3])
			ZP.NumVerticalMatches |= MATCH_V_0B3T;
	}

	// 1B-4T		Bit 1
	if (PlayTilesTop[1] < 128 && PlayTilesTop[4] < 128)
	{
		if (PlayTilesBottom[1] == PlayTilesTop[4])
			ZP.NumVerticalMatches |= MATCH_V_1B4T;
	}

	// 2B-5T		Bit 2
	if (PlayTilesTop[2] < 128 && PlayTilesTop[5] < 128)
	{
		if (PlayTilesBottom[2] == PlayTilesTop[5])
			ZP.NumVerticalMatches |= MATCH_V_2B5T;
	}

	// 3B-6T		Bit 3
	if (PlayTilesTop[3] < 128 && PlayTilesTop[6] < 128)
	{
		if (PlayTilesBottom[3] == PlayTilesTop[6])
			ZP.NumVerticalMatches |= MATCH_V_3B6T;
	}

	// 4B-7T		Bit 4
	if (PlayTilesTop[4] < 128 && PlayTilesTop[7] < 128)
	{
		if (PlayTilesBottom[4] == PlayTilesTop[7])
			ZP.NumVerticalMatches |= MATCH_V_4B7T;
	}

	// 5B-8T		Bit 5
	if (PlayTilesTop[5] < 128 && PlayTilesTop[8] < 128)
	{
		if (PlayTilesBottom[5] == PlayTilesTop[8])
			ZP.NumVerticalMatches |= MATCH_V_5B8T;
	}

	DrawMatches();

	return (ZP.NumHorizontalMatches == 63 && ZP.NumVerticalMatches == 63) ? 1 : 0;
}

byte PlayTheGame()
{
	byte mode = MODE_SELECT_TILE;
	SetCursorColorOk();

	// Stay in this loop until the level is solved or the player pressed ESC
	ZP.ActiveTop = 128;

	ResetTimer();
	ZP.StopTheClock = 0;		// Start the clock from counting

	//ZP.ActiveTop = StoreTilesTop[0];
	//ZP.ActiveRight = StoreTilesRight[0];
	//ZP.ActiveBottom = StoreTilesBottom[0];
	//ZP.ActiveLeft = StoreTilesLeft[0];

	// Give the cursor two different Y positions
	// This makes sure that it is redrawn
	ZP.PrevCursorPosition = 17;
	ZP.CursorPosition = 3;	// top left in the store area
	ZP.CursorX = 3;
	ZP.CursorY = 0;
	UpdateCursorInfo();

	// Reset the match indicators
	ZP.NumVerticalMatches = 0;
	ZP.NumHorizontalMatches = 0;
	DrawMatches();

	ClearCursor();			// Remove the display
	DrawActiveTile();
	DrawCursor();

	POKE(CODE_CH, 255);
	WaitForFireRelease();

	while(1)
	{
		// Check if ESC was pressed
		if (PEEK(CODE_CH) == 28)
		{
			// Yes then clear the key press and exit the game loop
			POKE(CODE_CH, 255);
			return 1;
		}

		wait();
		if (ZP.Joystick0)
		{
			// Some action on the joystick
			if (ZP.Joystick0 != ZP.PrevJoystick0)
			{
				// Joystick if different to what we processed before
				ZP.PrevCursorPosition = ZP.CursorPosition;
				ZP.PrevJoystick0 = ZP.Joystick0;

				// Check the game mode
				if (mode == MODE_SELECT_TILE)
				{
					// Waiting to select a tile
					// Move the cursor OR select a tile
					if (ZP.Joystick0 & JOYSTICK_FIRE)
					{
						// Select the current item from the current cursor position
						if (ZP.CursorOnStore)
						{
							// In the store
							if (StoreTilesTop[ZP.CursorOffset] == 128)
							{
								// Blank spot
							}
							else 
							{
								// Pickup a store tile
								ZP.ActiveTop = StoreTilesTop[ZP.CursorOffset];
								ZP.ActiveRight = StoreTilesRight[ZP.CursorOffset];
								ZP.ActiveBottom = StoreTilesBottom[ZP.CursorOffset];
								ZP.ActiveLeft = StoreTilesLeft[ZP.CursorOffset];
								ZP.ActiveOffset = ZP.CursorOffset + 9;
								DrawActiveTile();
								mode = MODE_PLACE_TILE;

								// Clear the selected store entry
								StoreTilesTop[ZP.CursorOffset] = 128;
								asm("ldy %w", offsetof(_zp, CursorOffset));
								asm("jsr %w", CODE_DRAWSTORETILE);

								// Place the cursor @ 1x1 in the play field
								// Draw it and save the value under it
								ZP.CursorX = 1;
								ZP.CursorY = 1;
								UpdateCursorInfo();

								SaveUnderCursor();
								UpdateWithActive();

								ZP.SFX0 = SOUND_ACTION;
							}
						}
						else
						{
							// In the play field
							if (PlayTilesTop[ZP.CursorOffset] == 128) 
							{
								// Blank play field stop can't be selected
							}
							else
							{
								// Selecting a tile already in the play field
								ZP.ActiveTop = PlayTilesTop[ZP.CursorOffset];
								ZP.ActiveRight = PlayTilesRight[ZP.CursorOffset];
								ZP.ActiveBottom = PlayTilesBottom[ZP.CursorOffset];
								ZP.ActiveLeft = PlayTilesLeft[ZP.CursorOffset];
								ZP.ActiveOffset = ZP.CursorOffset + 9;
								DrawActiveTile();
								mode = MODE_PLACE_TILE;

								// Clear the selected play entry
								PlayTilesTop[ZP.CursorOffset] = 128;
								asm("ldy %w", offsetof(_zp, CursorOffset));
								asm("jsr %w", CODE_DRAWPLAYTILE);
								CheckForLevelDone();

								SaveUnderCursor();
								UpdateWithActive();

								ZP.SFX0 = SOUND_ACTION;
							}
						}

						if (mode == MODE_PLACE_TILE)
						{
							// Something was selected!
							// While the fire button is down you can press
							// left-right to rotate the tile
							ZP.PrevJoystick0 = 0;
							do {
								wait();
								if (ZP.Joystick0 != ZP.PrevJoystick0)
								{
									ZP.PrevJoystick0 = ZP.Joystick0;

									if ((ZP.Joystick0 & JOYSTICK_ROTATE_LEFT) == JOYSTICK_ROTATE_LEFT)
									{
										RotateActiveCCW();
										DrawActiveTile();
										UpdateWithActive();

										Add1ToScore();
										DrawScore();

										ZP.SFX1 = SOUND_ROTATE;
									}
									else if ((ZP.Joystick0 & JOYSTICK_ROTATE_RIGHT) == JOYSTICK_ROTATE_RIGHT)
									{
										RotateActiveCW();
										DrawActiveTile();
										UpdateWithActive();

										Add1ToScore();
										DrawScore();

										ZP.SFX1 = SOUND_ROTATE;
									}
								}
							}
							while(ZP.Joystick0 & JOYSTICK_FIRE);
						}
					}
					else if (ZP.Joystick0 & JOYSTICK_MOVEMENT)
					{
						MoveCursor();
					}
				}
				else if (mode == MODE_PLACE_TILE)
				{
					if (ZP.Joystick0 & JOYSTICK_MOVEMENT)
					{
						RestoreUnderCursor();
						MoveCursor();
						SaveUnderCursor();
						UpdateWithActive();
						if (ZP.CursorOnStore && SavedTop < 128)
						{
							SetCursorColorBad();
						}
						else 
							SetCursorColorOk();
					}
					if (ZP.Joystick0 & JOYSTICK_FIRE)
					{
						ZP.SFX0 = SOUND_ACTION;
						// Save in play field or store
						if (ZP.CursorOnStore)
						{
							// Want to put back some value
							// Check if the current slot is empty
							if (SavedTop == 128)
							{
								// Yes empty, then save the values there
								// and clear active
								StoreTilesTop[ZP.CursorOffset] = ZP.ActiveTop; 
								StoreTilesRight[ZP.CursorOffset] = ZP.ActiveRight;
								StoreTilesBottom[ZP.CursorOffset] = ZP.ActiveBottom;
								StoreTilesLeft[ZP.CursorOffset] = ZP.ActiveLeft;
								asm("ldy %w", offsetof(_zp, CursorOffset));
								asm("jsr %w", CODE_DRAWSTORETILE);

								mode = MODE_SELECT_TILE;
								ZP.ActiveTop = 128;
								DrawActiveTile();

								Add1ToScore();
								DrawScore();
							}
							else {
								// Unable to put back tile here
								SetCursorColorBad();
							}
							CheckForLevelDone();
						}
						else 
						{
							// Place the active data in the play field
							if (SavedTop < 128) 
							{
								// There is tile data here already
								// Move it to the first empty slot in the store
								for (ZP.WorkI = 0; ZP.WorkI < NUM_SPOTS; ++ZP.WorkI)
								{
									if (StoreTilesTop[ZP.WorkI] == 128) {
										// The spot is empty
										// Move the current values there
										StoreTilesTop[ZP.WorkI] = SavedTop;
										StoreTilesRight[ZP.WorkI] = SavedRight;
										StoreTilesBottom[ZP.WorkI] = SavedBottom;
										StoreTilesLeft[ZP.WorkI] = SavedLeft;

										asm("ldy %w", offsetof(_zp, WorkI));
										asm("jsr %w", CODE_DRAWSTORETILE);
										break;
									}
								}
							}
							// Save in play field
							PlayTilesTop[ZP.CursorOffset] = ZP.ActiveTop; 
							PlayTilesRight[ZP.CursorOffset] = ZP.ActiveRight;
							PlayTilesBottom[ZP.CursorOffset] = ZP.ActiveBottom;
							PlayTilesLeft[ZP.CursorOffset] = ZP.ActiveLeft;
							asm("ldy %w", offsetof(_zp, CursorOffset));
							asm("jsr %w", CODE_DRAWPLAYTILE);

							mode = MODE_SELECT_TILE;
							ZP.ActiveTop = 128;
							DrawActiveTile();

							Add1ToScore();
							DrawScore();

							if (CheckForLevelDone())
							{
								ZP.SFX1 = SOUND_END;
								ZP.StopTheClock = 1;
								return 0;
							}
						}
					}
				}
			}
		}
		else {
			ZP.PrevJoystick0 = ZP.Joystick0;
		}
	}
}

void MenuOptionUp()
{
	if (ZP.DifficultyMenu == 0)
		ZP.DifficultyMenu = 4;
	--ZP.DifficultyMenu;
}

void MenuOptionDown()
{
	ZP.DifficultyMenu = (++ZP.DifficultyMenu) & 3;
}

void MenuIncDifficultyLevel()
{
	++ZP.DifficultyLevel;
	if (ZP.DifficultyLevel == 10)
		ZP.DifficultyLevel = 1;
}

void MenuIncDifficultyNumbers()
{
	++ZP.DifficultyNumbers;
	if (ZP.DifficultyNumbers == 11)
		ZP.DifficultyNumbers = 2;
}

void MenuSwopColor()
{
	++ZP.DifficultyColor;
	if (ZP.DifficultyColor > 1)
		ZP.DifficultyColor = 0;
}

void MenuSwopRotation()
{
	++ZP.DifficultRotation;
	if (ZP.DifficultRotation > 1)
		ZP.DifficultRotation = 0;
}

void TitleScreen()
{
	byte prevConsol = 0;

	ZP.DifficultyMenu = MENU_OPTION_DIFFICULTY;
	GenerateLevel();
	DrawTitleScreen();
	RenderTitleScreenOptions();
	SwitchToTitleScreen();
	ResetScore();

	// Check SELECT, OPTION, START keys
	// Check FIRE button
	while(1)
	{
		POKE(CODE_CONSOL, 8);
		wait();
		if (ZP.Joystick0)
		{
			// Some action on the joystick
			if (ZP.Joystick0 != ZP.PrevJoystick0)
			{
				ZP.SFX0 = SOUND_ACTION;

				// Joystick if different to what we processed before
				ZP.PrevJoystick0 = ZP.Joystick0;

				if (ZP.Joystick0 & JOYSTICK_FIRE)
				{
					return;
				}

				if (ZP.Joystick0 & JOYSTICK_RIGHT)
				{
					switch (ZP.DifficultyMenu)
					{
						case 0:
							MenuIncDifficultyNumbers();
							break;
						case 1:
							MenuSwopColor();
							break;
						case 2:
							MenuIncDifficultyLevel();
							break;
						case 3:
						{
							MenuSwopRotation();
							break;
						}
					}
				}
				else if (ZP.Joystick0 & JOYSTICK_LEFT)
				{
					switch (ZP.DifficultyMenu)
					{
						case 0:
							--ZP.DifficultyNumbers;
							if (ZP.DifficultyNumbers == 1)
								ZP.DifficultyNumbers = 10;
							break;
						case 1:
							MenuSwopColor();
							break;
						case 2:
							--ZP.DifficultyLevel;
							if (ZP.DifficultyLevel == 0)
								ZP.DifficultyLevel = 9;
							break;
						case 3:
							MenuSwopRotation();
							break;
					}
				}
				else if (ZP.Joystick0 & JOYSTICK_UP)
				{
					MenuOptionUp();
				}
				else if (ZP.Joystick0 & JOYSTICK_DOWN)
				{
					MenuOptionDown();
				}
				GenerateLevel();
				DrawTitleScreen();
				RenderTitleScreenOptions();
			}
		}
		else {
			ZP.PrevJoystick0 = ZP.Joystick0;
			// Check keyboard
			ZP.WorkVal = PEEK(CODE_CONSOL) ^ 7;

			if (ZP.WorkVal != prevConsol)
			{
				prevConsol = ZP.WorkVal;
				if (ZP.WorkVal & CODE_CONSOLE_SELECT)
				{
					MenuOptionDown();
					RenderTitleScreenOptions();
				}
				if (ZP.WorkVal & CODE_CONSOLE_OPTION)
				{
					switch (ZP.DifficultyMenu)
					{
						case 0:
							MenuIncDifficultyNumbers();
							break;
						case 1:
							MenuSwopColor();
							break;
						case 2:
							MenuIncDifficultyLevel();
							break;
						case 3:
							MenuSwopRotation();
							break;
					}
					GenerateLevel();
					DrawTitleScreen();
					RenderTitleScreenOptions();
				}
			}
		}
	}
}

void PlayTheLevel()
{
	byte wantToQuit;
	while(1)
	{
		GenerateLevel();
		GenerateHint();
		DrawGameScreen();
		SwitchToGameScreen();
		wantToQuit = PlayTheGame();
		if (wantToQuit)
			return;

		WaitForFireRelease();
		DrawLevelDone();
		while(1)
		{
			wait();
			if (ZP.Joystick0 & JOYSTICK_FIRE)
				break;
			if (PEEK(CODE_CH) == 28)
			{
				// Yes then clear the key press and exit the game loop
				POKE(CODE_CH, 255);
				return;
			}
		}
		RestoreLevelDone();
		WaitForFireRelease();
	}
}

void main()
{
	SetupAsm();
	ZP.LevelNr = 1;
	ZP.DifficultyLevel = 1;
	ZP.DifficultyNumbers = 2;
	ZP.DifficultyColor = 1;
	ZP.DifficultRotation = 0;
	ZP.DifficultyHint = 1;

	ZP.ptrStoreTilesTop = StoreTilesTop;
	ZP.ptrStoreTilesRight = StoreTilesRight;
	ZP.ptrStoreTilesBottom = StoreTilesBottom;
	ZP.ptrStoreTilesLeft = StoreTilesLeft;
	ZP.ptrPlayTilesTop = PlayTilesTop;
	ZP.ptrPlayTilesRight = PlayTilesRight;
	ZP.ptrPlayTilesBottom = PlayTilesBottom;
	ZP.ptrPlayTilesLeft = PlayTilesLeft;

	ResetScore();
	
	while(1)
	{
		TitleScreen();
		PlayTheLevel();
	}
}