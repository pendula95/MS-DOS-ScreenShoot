
segment .code


;set string start to di
;set ignor char to al
ignor_char:
  mov     cx, 0080h                   ; max REPx counts
  repe scasb
  dec di
  ret

  ;set string to di
print_str:
  mov ah, 0eh                      ; stampanje karaktera
  mov al, [di]                     ; karakter koji treba stampati
  int 10h                          ; intereput za ekran
  inc di
  cmp al, 0
  jne print_str
  ret

segment .data

string1 dw 0
string2 dw 0
