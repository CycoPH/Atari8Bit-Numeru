#ifndef _ASM_INTERFACE_H
#define _ASM_INTERFACE_H

#include "asm-code.h"


#define SetupAsm() (asm("jsr %w", CODE_SETUPASM))

#define ReadJoystick() (asm("jsr %w", CODE_READJOYSTICK))

#define WaitForVbi() (asm("jsr %w", CODE_WAITFORVBI))
#define WaitForFireRelease() (asm("jsr %w", CODE_WAITFORFIRERELEASE))

#define CalcTileBackground() (asm("jsr %w", CODE_CALCTILEBACKGROUND))

#define DrawGameScreen() (asm("jsr %w", CODE_DRAWGAMESCREEN))

#define DrawActiveTile() (asm("jsr %w", CODE_DRAWACTIVETILE))
#define DrawCursor() (asm("jsr %w", CODE_DRAWCURSOR))
#define ClearCursor() (asm("jsr %w", CODE_CLEARPMG))

#define SetCursorColorOk() (asm("jsr %w", CODE_SETCURSORCOLOROK))
#define SetCursorColorBad() (asm("jsr %w", CODE_SETCURSORCOLORBAD))

#define DrawMatches() (asm("jsr %w", CODE_DRAWMATCHES))

#define ResetScore() (asm("jsr %w", CODE_RESETSCORE))
#define Add1ToScore() (asm("jsr %w", CODE_ADD1TOSCORE))
#define DrawScore() (asm("jsr %w", CODE_DRAWSCORE))

#define SwitchToGameScreen() (asm("jsr %w", CODE_SWITCHTOGAMESCREEN))
#define SwitchToTitleScreen() (asm("jsr %w", CODE_SWITCHTOTITLESCREEN))

#define RenderTitleScreenOptions() (asm("jsr %w", CODE_RENDERTITLESCREENOPTIONS))
#define DrawTitleScreen() (asm("jsr %w", CODE_DRAWTITLESCREEN))

#define DrawLevelDone() (asm("jsr %w", CODE_DRAWLEVELDONE))
#define RestoreLevelDone() (asm("jsr %w", CODE_RESTORELEVELDONE))

#define ResetTimer() (asm("jsr %w", CODE_RESETTIMER))

#endif