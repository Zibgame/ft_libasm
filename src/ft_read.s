; **************************************************************************** ;
;                                                                              ;
;                                                         :::      ::::::::    ;
;    ft_read.s                                          :+:      :+:    :+:    ;
;                                                     +:+ +:+         +:+      ;
;    By: zcadinot <zcadinot@student.42lehavre.      +#+  +:+       +#+         ;
;                                                 +#+#+#+#+#+   +#+            ;
;    Created: 2026/10/15 14:40:00 by zcadinot          #+#    #+#              ;
;    Updated: 2026/10/15 14:48:13 by zcadinot         ###   ########.fr        ;
;                                                                              ;
; **************************************************************************** ;

section .text
global ft_read
extern __errno_location

ft_read:
	mov rax, 0
	syscall
	cmp rax, 0
	jl .error ; jl = rax < 0
	ret

.error:
	neg rax
	push rax
	call __errno_location wrt ..plt ; RAX = adresse de errno du thread courant
	pop rdx
	mov [rax], edx
	mov rax, -1
	ret
