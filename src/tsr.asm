
segment .code

KBD   equ 60h
F10_CODE equ 44h 				;f10 dugme
_novi_09:
	cli									;disables interupts
	xor ax, ax
	mov es, ax
	mov bx, [es:09h*4]
	mov [old_int9_off], bx							;saves old vector interupt so we can put it back
	mov bx, [es:09h*4+2]
	mov [old_int9_seg], bx							;saves old vector interupt so we can put it back

; adds our interupt
	mov dx, tast_int
	mov [es:09h*4], dx									;ofset of programm
	mov ax, cs
	mov [es:09h*4+2], ax								;code segment
	push ds														; saves DS as INT 0x08 changes it to DS = 0x0040
	pop gs
	sti
	ret				;enable interupts


; installs old interupt 0x09
_stari_09:
	cli								;disables interupts
	xor ax, ax
	mov es, ax
	;mov bx, [es:09h*4+2]			;gets segment of old handler so it can be used to find location of tsr
	;push ds								;saves ds for later
	;mov ds, bx
	mov ax, [old_int9_seg]
	mov [es:09h*4+2], ax
	mov dx, [old_int9_off]
	mov [es:09h*4], dx
	;pop ds
	sti									;enables interupts
	ret

tast_int:
  pusha
  in al, KBD
  cmp al, F10_CODE
  je ispis_f1
  jmp kraj

ispis_f1:
	pusha
  call _ss
	popa
  jmp kraj

kraj:
  ;jump to old handle for 09h
  popa
  push cs        ;impotant gets old value of ds as it ws changed
  pop ds         ;impotant gets old value of ds as it ws changed
  push word [old_int9_seg]
  push word [old_int9_off]
  retf

  popa
  ;iret

_new_2f:
	cli
	xor ax, ax
	mov es, ax
	mov bx, [es:2Fh*4]
	mov [old_int2f_off], bx
	mov bx, [es:2Fh*4+2]
	mov [old_int2f_seg], bx

; Modifikacija u tabeli vektora prekida tako da pokazuje na nasu rutinu
	mov dx, hadnle_f
	mov [es:2Fh*4], dx
	mov ax, cs
	mov [es:2Fh*4+2], ax
	sti
	ret

old_2f:
	cli
	xor ax, ax
	mov es, ax
	;mov bx, [es:09h*4+2]			;gets segment of old handler so it can be used to find location of tsr
	;push ds								;saves ds for later
	;mov ds, bx
	mov ax, [old_int2f_seg]
	mov [es:2Fh*4+2], ax
	mov dx, [old_int2f_off]
	mov [es:2Fh*4], dx
	;pop ds
	sti
	ret

hadnle_f:

	push cs
	pop ds

  cmp     ah, [FuncID]
  je      match								; IDS match its us

  ; jump to old int
  push word [old_int2f_seg]
  push word [old_int2f_off]
  retf

; Now decode the function value in AL:

match:
  cmp     al, 0           ; it is install call
  je     verify
  cmp     al, 1          ;it is remove call
  je     remove
iret

verify:
  mov     al, 0FFh
  mov 	dx, [password]		;set password of our tsr
iret

remove:
  ;remove
	;-stop
	call _stari_09
	call old_2f

iret                    ;Return to caller.


segment .data

old_int9_seg: dw 0
old_int9_off: dw 0
old_int2f_seg: dw 0
old_int2f_off: dw 0
password: dw 56h
