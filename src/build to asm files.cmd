@echo off
if exist "gen_asm\" (
	cd gen_asm
	del *.asm
	cd ..
) else (
	mkdir gen_asm
)


::atasm -gout\boot_part1.lst -Iasm -Iasm/includes -Iasm/boot -oout/boot_part1.xex -lout\boot_part1.lab asm\boot\boot_part1.asm
::atasm -gout\boot_part2.lst -Iasm -Iasm/includes -Iasm/boot -oout/boot_part2.xex -lout\boot_part2.lab asm\boot\boot_part2.asm

@echo Compiling the C code
c:\progs\cc65\bin\cl65 -S -C ./atari.cfg -t atari -T -Cl -Oirs -O -vm -v -o gen_asm\numeru.asm numeru.c
@if %errorlevel% neq 0 goto error

 c:\progs\cc65\bin\cl65 -S -C ./atari.cfg -t atari -T -Cl -Oirs -O -vm -v -o gen_asm\generator.asm generator.c
@if %errorlevel% neq 0 goto error

goto end
:error
@echo Got a compile error!
pause
exit /b %errorlevel%
:end
exit /b %errorlevel%
