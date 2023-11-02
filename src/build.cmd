@echo off
if exist "out\" (
	cd out
	del *.o
	del *.xex
	cd ..
) else (
	mkdir out
)


atasm -gout\boot.lst -Iasm -Iasm/includes -Iasm/boot -oout/boot.xex -lout\boot.lab asm\boot\boot.asm

atasm -gout\asm-code.lst -Iasm -Iasm/includes -Iasm/fonts -Iasm/music -oout/asm-code.xex -hcasm-code.h -lasm-code.lab asm\code.asm
@if %errorlevel% neq 0 goto error

@echo Compiling the C code
c:\progs\cc65\bin\cl65 -Ln out/numeru.lbl --lib-path C:\progs\cc65\lib -C ./atari.cfg -t atari -T -Cl -Oirs -O -vm -v --mapfile out/numeru.map -o out\c-part.xex numeru.c generator.c asm\ataristd.s
@if %errorlevel% neq 0 goto error


@echo Joining all the parts!
bin\joinxex out/boot.xex out/asm-code.xex out/c-part.xex -j -oout/numeru.xex
::bin\joinxex out/boot_part1.xex out/boot_part2.xex out/fixed.xex out/main.xex -j -oout/numeru.xex
goto end
:error
@echo Got a compile error!
pause
exit /b %errorlevel%
:end
start out\numeru.xex

