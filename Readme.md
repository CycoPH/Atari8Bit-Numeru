# Numeru
by [Peter Hinz 2023 aka RetroCoder](https://github.com/CycoPH)

## Game idea
Match the numbers, and colors, on the edges of the tiles by arranging the 9 tiles into the 3x3 grid. Once you have 12 matches the level is complete.

Each level is unique never to be repeated.

## Interaction
Use the joystick in port 1 to select your difficulty level. Up/Down selects the menu option; left/right changes the options.
Press *FIRE* to play in the selected difficulty level.

You can change the numbers on the tiles. 0 and 1 are the default (Easy). Try 0 to 9 for a little bit of a challenge.
The color option switches between black or black and white tiles. The introduction of color makes the game a little easier
until it gets more challenging quickly.
Difficulty level adjusts the number of white sections, the higher the number the more white, the more difficult.
Rotation is the kicker. If it is turned on the level generator will randomly rotate the tiles and you will have to rotate
them to find the matches.

The play field is divided into two areas. Left the 9 areas where you will place your tiles. Right the 9 tiles to be placed.

Use the joystick to move the selection cursor onto a tile.
Press FIRE to select the tile. It will show in the action box at the top.
Move the cursor to the location you would like to place the tile and press fire to place it.
If you want to rotate the numbers on the tile hold FIRE and press LEFT or RIGHT.

Press the ESC key to give up on a level and return to the start screen.

# Enjoy the race against the clock

# How to build it yourself
This is a 3 day project. I wanted to figure out how to write a C program for the Atari 8-bit machines. First the logic was developed in Visual Studio (project is included).
Then the generator code was ported over to cc65.

I'm a fan of the ATASM assembler so I wanted to find an easy way to join the C and assembler code. I know use the assembler from the cc65 project would have been easier but hey some fun was needed here.

Check out the magic in the `buid.cmd` file.

1. The *out* folder is cleared or created
2. The boot header, to switch off Basic, is assembled.
3. The `code.asm` file is assembled. This created the `asm-code.h` to be included into the C project.
4. CL65 is used to compile the C project.
5. `bin\joinexe` is used to join the `boot.xex`, `asm-code.xex` and `c-part.xex` files into the final `numeru.xex` file.

# Used technology
- [Atasm](https://github.com/CycoPH/atasm)
- [RMT](https://github.com/VinsCool/RASTER-Music-Tracker)
- [Atari FontMaker](https://github.com/matosimi/atari-fontmaker)
- [rmt2atasm](https://github.com/CycoPH/rmt2atasm)
- [CC65](https://cc65.github.io/)

# Aim of this repo
First a foremost is to make the source to Numeru available.
I had fun writing it and maybe someone else can learn from it.

# What you can find here
/Fonts - AtariFontMaker file for the font for this project
/src - Atari source of the Numeru game
/x86 - Visual Studio project showing how the level generator was developed.
