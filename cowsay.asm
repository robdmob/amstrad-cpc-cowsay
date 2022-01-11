LINEWIDTH equ 36

read "firmware.asm"
;write "../ROM/COWSAY.ROM"
write direct -1,5
limit #ffff
org #c000
checksum reset

	db 1,1,0,0 
	dw name_table

	jp init_rom
	jp cowsay
	jp cowthink
	jp fortune

name_table:
	str "Cowsay ROM"
	str "COWSAY"
	str "COWTHINK"
	str "FORTUNE"
	db 0

init_rom:
	push hl
	push de

	ld hl,rom_message
	call print_text

	pop de
	pop hl
	scf
	ret

;---- |COWSAY ----------------------------------------------------------------------------------------------

cowsay:
	ld b,a
	call SCR_GET_MODE
	ccf
	ret nc
	ld a,b
	call bubble
	ld hl,cowsay_header
	call print_text
	ld hl,footer
	call print_text
	scf
	ret

;---- |COWTHINK ----------------------------------------------------------------------------------------------

cowthink:
	ld b,a
	call SCR_GET_MODE
	ccf
	ret nc
	ld a,b
	call bubble
	ld hl,cowthink_header
	call print_text
	ld hl,footer
	call print_text
	scf
	ret

;---- |FORTUNE ----------------------------------------------------------------------------------------------

fortune:
	ld b,a
	call get_fortune
	dec b
	jp nz,print_text

	ld e,(ix)
	ld d,(ix+1)
	push de
	pop ix
	ld b,(ix)
	ld e,(ix+1)
	ld d,(ix+2)
fortune_loop:
	ld a,(hl)
	or a
	jr z,fortune_end
	cp ' '
	jr nc,not_control
	ld a,' '
not_control:
	ld (de),a
	inc de
	inc hl
	djnz fortune_loop
fortune_end
	ld a,(ix)
	sub b	
	ld (ix),a
	ret

;---- COWSAY/COWTHINK SHARED ----------------------------------------------------------------------------------------------

;	HL - string pointer
;	D - string length position
;	C - line length - string length to console width
;	B - line position C to 0
	
bubble:
	dec a
	jr z,bubble_get_string
	call get_fortune
	ld d,h
	ld e,l
	ld b,255

bubble_measure_loop:
	ld a,(hl)
	inc hl
	inc b
	or a
	jr nz,bubble_measure_loop
	ex de,hl
	ld a,b
	jr bubble_width

bubble_get_string:
	ld l,(ix)
	ld h,(ix+1)
	push hl
	pop ix
	ld a,(ix)
	ld l,(ix+1)
	ld h,(ix+2)

bubble_width:
	ld d,a
	cp LINEWIDTH
	jr c,bubble_start
	ld a,LINEWIDTH

bubble_start:
	ld c,a	
	call rep_char

bubble_line_start:
	ld a,'|'
	call TXT_OUTPUT
	ld a,' '
	call TXT_OUTPUT
	ld b,c	

bubble_print_loop:
	ld a,(hl)
	inc hl
	cp 13
	jp z,bubble_line_end
	call TXT_OUTPUT
	dec d
	jr z,bubble_line_end
	djnz bubble_print_loop

	inc b

bubble_line_end:
	ld a,' '
	call TXT_OUTPUT
	djnz bubble_line_end

	ld a,'|'
	call TXT_OUTPUT

	ld a,c
	cp LINEWIDTH
	jr nz,call_crlf
	call SCR_GET_MODE
call_crlf:
	call nz,crlf
	ld a,d
	or a
	jp nz,bubble_line_start

;---- TEXT THINGS -----------------------------------------------------------------------------------------

rep_char:
	ld b,c
	inc b
	inc b
	ld a,' '
	call TXT_OUTPUT
	ld a,'-'
rep_char_loop:
	call TXT_OUTPUT
	djnz rep_char_loop
crlf:
	ld a,10
	call TXT_OUTPUT
	ld a,13
	jp TXT_OUTPUT

;---- SHARED ----------------------------------------------------------------------------------------------

get_fortune:
	call KL_TIME_PLEASE
	ld a,%00000011
	and h
	ld h,a
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	ex de,hl
	ld hl,fortune_data_start-fortune_data_end
	add hl,de
	jr nc,num_ok
	ld a,%00000001
	and d
	ld d,a
num_ok:
	ld hl,fortune_data_start
	add hl,de
find_start:
	ld a,(hl)
	or a
	jr z,found_start
	dec hl
	jr find_start
found_start:
	inc hl
	ret

print_text:
	ld a,(hl)
	or a
	ret z
	cp 13
	jr nz,skip_lf
	call TXT_OUTPUT
	ld a,10
skip_lf
	call TXT_OUTPUT
	inc hl
	jr print_text

;---- DATA ----------------------------------------------------------------------------------------------

rom_message:
	db " Fortune & Cowsay ROM ",164,"2022 Rob Dixon",13,10,0

cowsay_header:
	db "        \    __ ",13
	db "         \",0

cowthink_header:
	db "        o    __ ",13
	db "         o",0

footer:
  	db "  (oo)\_______",13
	db "            (__)\       )\/\",13
	db "                ||----w |",13
	db "                ||     ||",13,0


;---- FORTUNE DATA ----------------------------------------------------------------------------------------------

fortune_data_start:

incbin "fortunes.bin"

fortune_data_end:
	ds #ffff-fortune_data_end,#ff
	db checksum()