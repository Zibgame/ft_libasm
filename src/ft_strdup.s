; **************************************************************************** ;
;                                                                              ;
;                                                         :::      ::::::::    ;
;    ft_strdup.s                                        :+:      :+:    :+:    ;
;                                                     +:+ +:+         +:+      ;
;    By: zcadinot <zcadinot@student.42lehavre.      +#+  +:+       +#+         ;
;                                                 +#+#+#+#+#+   +#+            ;
;    Created: 2026/10/15 15:00:00 by zcadinot          #+#    #+#              ;
;    Updated: 2026/10/15 15:40:10 by zcadinot         ###   ########.fr        ;
;                                                                              ;
; **************************************************************************** ;

section .text
global ft_strdup
extern malloc
extern ft_strlen
extern ft_strcpy

ft_strdup:
	push rdi
	call ft_strlen
	mov rdi, rax
	inc rdi
	call malloc wrt ..plt
	cmp rax, 0
	je .end
	mov rdi, rax
	mov rsi, [rsp]
	call ft_strcpy

.end:
	add [rsp], 8
	ret
