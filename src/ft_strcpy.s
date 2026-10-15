; **************************************************************************** ;
;                                                                              ;
;                                                         :::      ::::::::    ;
;    ft_strcpy.s                                        :+:      :+:    :+:    ;
;                                                     +:+ +:+         +:+      ;
;    By: zcadinot <zcadinot@student.42lehavre.      +#+  +:+       +#+         ;
;                                                 +#+#+#+#+#+   +#+            ;
;    Created: 2026/10/15 10:38:55 by zcadinot          #+#    #+#              ;
;    Updated: 2026/10/15 16:37:42 by zcadinot         ###   ########.fr        ;
;                                                                              ;
; **************************************************************************** ;

section .text

global ft_strcpy

ft_strcpy:
xor rax, rax

.loop:
    mov dl, [rsi + rax]
    mov [rdi + rax], dl
    cmp byte [rsi + rax], 0
    je .end

    inc rax
    jmp .loop

.end:
    mov rax, rdi
    ret
