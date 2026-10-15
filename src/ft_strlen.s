; **************************************************************************** ;
;                                                                              ;
;                                                         :::      ::::::::    ;
;    ft_strlen.s                                        :+:      :+:    :+:    ;
;                                                     +:+ +:+         +:+      ;
;    By: zcadinot <zcadinot@student.42lehavre.      +#+  +:+       +#+         ;
;                                                 +#+#+#+#+#+   +#+            ;
;    Created: 2026/10/15 10:38:55 by zcadinot          #+#    #+#              ;
;    Updated: 2026/10/15 12:06:44 by zcadinot         ###   ########.fr        ;
;                                                                              ;
; **************************************************************************** ;

section .text
global ft_strlen

ft_strlen:
    xor rax, rax

.loop:
    cmp byte [rdi + rax], 0
    je .end
    inc rax
    jmp .loop

.end:
    ret
