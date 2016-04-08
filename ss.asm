
video_s	equ 0B800h
start	equ 0

segment .code

_ss:

  mov ax, video_s           ;start of video memory
  mov es, ax
  mov bx, start             ;first char of screen
  mov cx, 0                 ;counter for new line
  mov si, ekran            ;string to store content of screen

loop_screen:
  cmp cx, 80
  je add_new_line
  cmp bx, 4000
  je file_action
  mov al, [es:bx]
  mov byte [si], al
  inc si
  add bx, 2
  inc cx
  jmp loop_screen

add_new_line:
  mov cx, 0
  mov byte [si], cr
	inc si
	mov byte [si], lf
	inc si
  jmp loop_screen

file_action:
  call create_file
  call write_string
  call close_file
  ret

create_file:
  mov  ah, 3Ch
  mov  cx, 000h     ;file atrributes
  mov  dx, [path]
  int  21h
  mov [handler], ax
  ret

write_string:
  mov  ah, 40h
  mov  bx, [handler]
  mov  cx, 2050  ;STRING LENGTH.
  mov  dx, ekran
  int  21h
  ret

close_file:
  mov  ah, 03Eh
  mov  bx, [handler]
  int  21h
  ret


segment .data

ekran: resb 2051
;path: db "radi.txt", 0
handler: dw 0
