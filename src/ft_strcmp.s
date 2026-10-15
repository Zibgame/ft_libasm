; **************************************************************************** ;
;                                                                              ;
;                                                         :::      ::::::::    ;
;    ft_strcmp.s                                        :+:      :+:    :+:    ;
;                                                     +:+ +:+         +:+      ;
;    By: zcadinot <zcadinot@student.42lehavre.      +#+  +:+       +#+         ;
;                                                 +#+#+#+#+#+   +#+            ;
;    Created: 2026/10/15 10:38:55 by zcadinot          #+#    #+#              ;
;    Updated: 2026/10/15 13:51:20 by zcadinot         ###   ########.fr        ;
;                                                                              ;
; **************************************************************************** ;

section .text
global ft_strcmp

ft_strcmp:
    xor rcx, rcx

.loop:
    movzx eax, byte [rdi + rcx]
    movzx edx, byte [rsi + rcx]
    cmp eax, edx 
    jne .end

    cmp eax, 0
    je .end

	inc rcx
    jmp .loop

.end:
    sub eax, edx
    ret
