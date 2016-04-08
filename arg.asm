;org 100h

segment .code
_arg:
    cld
    mov     di, 81h                     ; start of command line PSP.
    mov     al, ' '                     ; String always starts with ' ' so we need to ignor it
call ignor_char                         ; First char that is not ' '

  mov si, di                            ;puts si on start of command line
  mov al, cr                            ;NEW LINE
repne scasb                             ;finde NEW LINE in command line
  mov byte [di-1], 0                    ;terminates command line with 0
  mov di, argument1                     ;start in di
  mov bx, 0                             ;counter for -start

check:
  cmp bx, 6
  je get_path                      ;if -start shearch for rest of the path
  mov byte ah, [di]
  cmp byte [si], ah                     ;comapre -start and command line
  jne stop_arg                          ;if not same, maybe it is stop command, check
  inc di
  inc si
  inc bx
  jmp check

get_path:
  mov byte ah, [si]
  cmp ah, ' '             ;checks for ' ' after start
  jne error

;ignors all spaces after -start
  mov     di, si                     ; sets start for chearch
  mov     al, ' '                     ; ignor char ' '
  call ignor_char
  mov si, di

  mov byte ah, [si]
  cmp ah, 0             ;checks if path is valid
  je error
  mov word [path], si
  mov ah, 09h
  call install_tsr
  jmp end

stop_arg:
  mov di, argument2             ;checks 'op'
  ;inc si
  check1:
  mov byte ah, [si]
  cmp ah, 0
  je stop
  mov byte ah, [di]
  cmp ah, 0
  je error
  cmp byte ah, [si]
  jne error
  inc di
  inc si
  jmp check1

error:
  mov di, error_message
  call print_str
  jmp end

stop:
  call uninstall_tsr
  ;mov di, stop_message
  ;call print_str
  jmp end

end:
  ret

segment .data

%include 'tsrF.asm'

argument1: db '-start', 0
argument2: db 'op', 0 ; -stop
error_message: db "Usage:", cr, lf, "  programname.COM -start filename", cr, lf, "  programname.COM -stop", 0
stop_message: db 'Program stoped', 0
path: dw 0
