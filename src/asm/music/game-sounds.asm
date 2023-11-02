
.local
RMT_SONG_DATA
__start
    .byte "RMT4"
__song_info
    .byte $40            ; Track length = 64
    .byte $10            ; Song speed
    .byte $01            ; Player Frequency
    .byte $01            ; Format version
; ptrs to tables
__ptrInstrumentTbl
    .word __InstrumentsTable       ; start + $0010
__ptrTracksTblLo
    .word __TracksTblLo            ; start + $0016
__ptrTracksTblHi
    .word __TracksTblHi            ; start + $0017
__ptrSong
    .word __SongData               ; start + $00c4

; List of ptrs to instruments
__InstrumentsTable
    .word __Instrument_0		; action                          
    .word __Instrument_1		; rotate                          
    .word __Instrument_2		; end                             

__TracksTblLo
    .byte <__Track_00
__TracksTblHi
    .byte >__Track_00


; Instrument data

__Instrument_0
    .byte $0c,$0c,$16,$16,$00,$20,$00,$50,$00,$00,$00,$00,$00,$44,$18,$00
    .byte $22,$18,$00,$11,$18,$00,$00,$18,$00
__Instrument_1
    .byte $0c,$0c,$31,$31,$00,$00,$60,$00,$08,$02,$00,$00,$00,$77,$0a,$0c
    .byte $55,$0a,$00,$44,$0a,$00,$33,$0a,$00,$22,$0a,$00,$22,$0a,$00,$22
    .byte $0a,$00,$22,$0a,$00,$22,$0a,$00,$22,$0a,$00,$11,$0a,$00,$11,$0a
    .byte $00,$11,$0a,$00
__Instrument_2
    .byte $0c,$0c,$52,$52,$00,$00,$00,$00,$00,$00,$00,$00,$00,$33,$18,$20
    .byte $22,$18,$20,$11,$18,$20,$11,$18,$20,$66,$18,$20,$11,$18,$20,$aa
    .byte $18,$14,$44,$18,$14,$11,$18,$14,$11,$18,$18,$bb,$18,$18,$33,$18
    .byte $18,$22,$18,$18,$11,$18,$10,$11,$18,$10,$33,$18,$10,$11,$18,$10
    .byte $33,$10,$20,$aa,$18,$1c,$dd,$18,$10,$44,$18,$12,$22,$18,$14,$11
    .byte $18,$18,$00,$18,$1c

; Track data
__Track_00
    .byte $c1,$03,$7e,$d0,$07,$7e,$d0,$0b,$3e,$3b

; Song data
__SongData
__Line_00  .byte $ff,$ff,$ff,$ff
__Line_01  .byte $fe,$00,<__line_00,>__line_00
__Line_02  .byte $00,$ff,$ff,$ff
__Line_03  .byte $fe,$00,<__line_00,>__line_00

