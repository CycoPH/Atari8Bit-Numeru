	.local

; Reset the audio
; Write 0 to the audio channel registers
ResetAudio
	lda #0
	ldy #8
?resetAudioLoop:
	sta AUDF1,y
	dey
	bpl ?resetAudioLoop

	lda #255
	sta zpSFX0
	sta zpSFX1
	rts

InitMusic
	lda #0						;starting song line 0-255 to A reg
?PlayMusicFromLine	
	ldx #<RMT_SONG_DATA			;low byte of RMT module to X reg
	ldy #>RMT_SONG_DATA			;hi byte of RMT module to Y reg
	jmp RASTERMUSICTRACKER		;Init

;----------------------------------------------------------
PlayMusic:
	lda zpSFX1
	bmi ?NoSfx2					; -ve -> NoSfx2

	and #3						; Keep it to 3 sound effects
	tax
	inc SoundIndex,x			; Move to the next sound index value
	asl							; acc = sfx * 2
	tay							; Y = Instrument #
	asl							; SFX * 4
	sta zpSfx							
	; Get the offset into the sfx note table
	lda SoundIndex,x
	and #3
	cli
	adc zpSfx
	tax
	lda SoundTable,x			; Get the note to play (0..60)
	;##TRACE "SFX2 play ch1 note %d instr=%d" @a y
	ldx #3						; Channel #3
	jsr rmt_sfx					; play on channel 2

	lda #255
	sta zpSFX1

?NoSfx2
	lda zpSFX0
	;##TRACE "SFX1 effect#=%d" @a
	bmi ?noSoundEffect
	; Play a sound effect
	and #31						; Keep it to 32 sound effects
	tax
	inc SoundIndex,x			; Move to the next sound index value
	asl							; acc = sfx * 2
	tay
	asl							; SFX * 4
	sta zpSfx							
	; Get the offset into the sfx note table
	lda SoundIndex,x
	and #3
	cli
	adc zpSfx
	tax
	lda SoundTable,x			;Get the note to play (0..60)
								;Y = 2,4,..,16	instrument number * 2 (0,2,4,..,126)
	;lda #20					;A = 12			note (0..60)
	;!##TRACE "SFX1 play ch0 note %d instr=%d" @a y
	ldx #0						;X = 0			channel (0..3 or 0..7 for stereo module)
	jsr rmt_sfx					;RMT_SFX start tone (It works only if FEAT_SFX is enabled !!!)

	lda #$ff
	sta zpSFX0				;re-init value

?noSoundEffect	
	jsr RMT_PLAY
PlayMusicExit
	rts

;MusicDelay	.byte 1				; NTSC/PAL sound adjustment
;zpSFX0	.byte $FF			; This is the sound to be played
;zpSFX1	.byte $FF

; For each sound effect we have a progress counter
; Everytime a SFX is played we increase the progress counter by 1
; This is used as an index into the SoundTable which gives a slightly different
; sound to the SFX everytime it is played.
; Cycle after 4x being played
SoundIndex:			; 32 sound index pointers
	.byte 0,0,0
SoundTable
			; Old SFX tables for original instrument order
			.byte 10,5,20,15	; SFX 0
			.byte 10,5,20,15
			.byte 10,5,20,15
END_OF_MUSIC_CODE = *

; =============================================================================

.OPT NO SYMDUMP
.include "rmtplayr.asm"			; include RMT player routine
.OPT SYMDUMP

;* = MUSIC_DATA "Music"
.include "game-sounds.asm"

* = END_OF_MUSIC_CODE


