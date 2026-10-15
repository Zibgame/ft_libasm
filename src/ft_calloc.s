; **************************************************************************** ;
;                                                                              ;
;                                                         :::      ::::::::    ;
;    ft_calloc.s                                        :+:      :+:    :+:    ;
;                                                     +:+ +:+         +:+      ;
;    By: zcadinot <zcadinot@student.42lehavre.      +#+  +:+       +#+         ;
;                                                 +#+#+#+#+#+   +#+            ;
;    Created: 2026/10/15 15:10:00 by zcadinot          #+#    #+#              ;
;    Updated: 2026/10/15 16:53:39 by zcadinot         ###   ########.fr        ;
;                                                                              ;
; **************************************************************************** ;

section .text
global ft_calloc
extern malloc
extern __errno_location

ft_calloc:
    push rbx

    mov rax, rdi
    mul rsi
	cmp rdx, 0
	jne .overflow

    mov rbx, rax
    mov rdi, rax
    call malloc wrt ..plt

    cmp rax, 0
    je .end

    xor rdx, rdx

.loop:
    cmp rdx, rbx
    je .end

    mov byte [rax + rdx], 0
    inc rdx
    jmp .loop

.overflow:
    call __errno_location wrt ..plt
    mov dword [rax], 12
    xor eax, eax
    jmp .end

.end:
    pop rbx
    ret
