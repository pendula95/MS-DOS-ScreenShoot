segment .code

install_tsr:
  mov byte [FuncID], 0
  mov cx, 0ffh
shearch_tsr:
  cmp cl, 080h
  je not_installed

  push cx             ;preservs registry as int 2Fh changes it
	push ds             ;preserWvs registry as int 2Fh changes it

	mov ah, cl
	mov al, 0
	int 2Fh

	pop ds             ;preservs registry as int 2h changes it
	pop cx             ;preservs registry as int 2h changes it

  cmp al, 0         ;this identifier is not used so save it
  je add_potential

  cmp dx, [password]

  je already_installed
  loop shearch_tsr
  jmp not_installed

add_potential:
  mov [FuncID], cl
  loop shearch_tsr
  jmp not_installed

already_installed:
  push di
  mov di, already_installed_message
  call print_str
  pop di
  ret

not_installed:
  cmp byte [FuncID], 0
  jne install_htsr
  push di
  mov di, too_many_tsr_message
  call print_str
  pop di
  ret

install_htsr:
  ;add my handlers
  call _novi_09
  call _new_2f

  ;start tsr
  mov ah, 31h
  mov dx, 00ffh
  int 21h
  ret

uninstall_tsr:
  mov byte [FuncID], 0
  mov cx, 0ffh
unshearch_tsr:
  cmp cl, 080h
  je not_uninstalled
  push cx             ;preservs registry as int 2Fh changes it
	push ds             ;preserWvs registry as int 2Fh changes it

	mov ah, cl
	mov al, 0
	int 2Fh

	pop ds             ;preservs registry as int 2h changes it
	pop cx             ;preservs registry as int 2h changes it


  cmp dx, [password]

  je uninstalled
  loop unshearch_tsr
  jmp not_uninstalled

uninstalled:
  mov ah, cl
  mov al, 1
	int 2Fh
  push di
  mov di, uninstalled_message
  call print_str
  pop di
  ret

not_uninstalled:
  push di
  mov di, not_installed_message
  call print_str
  pop di
  ret


segment .data

%include 'tsr.asm'

FuncID: db 0
myIDstring: db "ss.brainiac.com", 0
already_installed_message: db "Program already running!", 0
too_many_tsr_message: db "To many TSR!", 0
not_installed_message: db "Can't remove as it isn't installed", 0
uninstalled_message: db "Program uninstalled, terminated", 0
