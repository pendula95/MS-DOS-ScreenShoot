org 100h

cr equ 0Dh
lf equ 0Ah

segment .code

main:
  pusha
  call _arg                   ;reads command lines
  popa
  ;pusha
  ;call _ss                    ;fills string with char from screen and makes a txt file
  ;popa
  ret

segment .data


%include "arg.asm"              ;script for command line arguments
%include "ss.asm"               ;script for taking ss and making file
%include "helper.asm"
