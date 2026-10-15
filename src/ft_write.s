; **************************************************************************** ;
;                                                                              ;
;                                                         :::      ::::::::    ;
;    ft_write.s                                         :+:      :+:    :+:    ;
;                                                     +:+ +:+         +:+      ;
;    By: zcadinot <zcadinot@student.42lehavre.      +#+  +:+       +#+         ;
;                                                 +#+#+#+#+#+   +#+            ;
;    Created: 2026/10/15 14:10:00 by zcadinot          #+#    #+#              ;
;    Updated: 2026/10/15 14:23:58 by zcadinot         ###   ########.fr        ;
;                                                                              ;
; **************************************************************************** ;

section .text
global ft_write
extern __errno_location

ft_write:
	mov rax, 1
	syscall
	cmp rax, 0
	jl .error
	jmp .end

.error:
	neg rax
	push rax
	call __errno_location wrt ..plt ; retourn la valeur de l'endroit ou est stocker erno dans le thread courant
	pop rdx
	mov [rax], edx
	mov rax, -1
	jmp .end

.end:
	ret
