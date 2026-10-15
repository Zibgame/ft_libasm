; **************************************************************************** ;
;                                                                              ;
;                                                         :::      ::::::::    ;
;    ft_strcpy.s                                        :+:      :+:    :+:    ;
;                                                     +:+ +:+         +:+      ;
;    By: zcadinot <zcadinot@student.42lehavre.      +#+  +:+       +#+         ;
;                                                 +#+#+#+#+#+   +#+            ;
;    Created: 2026/10/15 10:38:55 by zcadinot          #+#    #+#              ;
;    Updated: 2026/10/15 12:44:17 by zcadinot         ###   ########.fr        ;
;                                                                              ;
; **************************************************************************** ;

section .text

global ft_strcpy

ft_strcpy:
xor rax, rax

.loop:
    cmp byte [rsi + rax], 0
    je .end
    mov [rdi + rax], [rsi + rax]
    inc rax
    je .loop

.end:
    ret
