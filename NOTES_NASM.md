# Notes NASM x86-64 pour libasm

Cette fiche concerne NASM en syntaxe Intel, au format ELF 64 bits sous Linux :

```make
NASMFLAGS = -f elf64
```

## 1. Structure minimale d'un fichier `.s`

```nasm
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
```

- `section .text` : contient les instructions exécutables.
- `global ft_strlen` : rend le symbole visible depuis les autres fichiers.
- `ft_strlen:` : début de la fonction.
- `.loop:` : label local appartenant au dernier label non local.
- `ret` : retourne à la fonction appelante.

Les labels doivent de préférence se terminer par `:`.

## 2. Ordre des opérandes

NASM utilise la syntaxe Intel :

```nasm
instruction destination, source
```

Exemples :

```nasm
mov rax, rdi        ; rax reçoit la valeur de rdi
add rax, 5          ; rax = rax + 5
mov byte [rdi], 0   ; écrit un octet zéro à l'adresse contenue dans rdi
```

On ne peut généralement pas utiliser deux opérandes mémoire dans une même instruction :

```nasm
; mov [rdi], [rsi]  ; incorrect
mov al, [rsi]
mov [rdi], al
```

## 3. Les tailles

| Taille | NASM | Exemple de registre | Taille en bits |
|---|---|---|---:|
| Octet | `byte` | `al` | 8 |
| Mot | `word` | `ax` | 16 |
| Double mot | `dword` | `eax` | 32 |
| Quadruple mot | `qword` | `rax` | 64 |

Exemples :

```nasm
cmp byte [rdi], 0
mov dword [rdi], 42
mov qword [rdi], rax
```

NASM peut parfois déduire la taille grâce au registre. Lorsqu'il ne le peut pas, il faut
écrire explicitement `byte`, `word`, `dword` ou `qword`.

## 4. Les différentes parties d'un registre

```text
RAX : 64 bits
EAX : 32 bits bas de RAX
 AX : 16 bits bas de RAX
 AL :  8 bits bas de RAX
 AH :  8 bits hauts de AX
```

Le même principe existe pour `rbx`, `rcx` et `rdx` :

| 64 bits | 32 bits | 16 bits | 8 bits bas |
|---|---|---|---|
| `rax` | `eax` | `ax` | `al` |
| `rbx` | `ebx` | `bx` | `bl` |
| `rcx` | `ecx` | `cx` | `cl` |
| `rdx` | `edx` | `dx` | `dl` |
| `rsi` | `esi` | `si` | `sil` |
| `rdi` | `edi` | `di` | `dil` |
| `rbp` | `ebp` | `bp` | `bpl` |
| `rsp` | `esp` | `sp` | `spl` |
| `r8` | `r8d` | `r8w` | `r8b` |

Écrire dans un registre 32 bits remet automatiquement à zéro ses 32 bits supérieurs :

```nasm
mov eax, 1          ; rax vaut maintenant exactement 1
```

Écrire seulement dans `al` ou `ax` ne remet pas le reste de `rax` à zéro.

## 5. Arguments des fonctions C

Sous Linux x86-64, les fonctions C utilisent la convention System V AMD64.

Les six premiers arguments entiers ou pointeurs sont placés dans :

| Argument | Registre | Exemple |
|---:|---|---|
| 1 | `rdi` | `ft_strlen(const char *str)` : `str` |
| 2 | `rsi` | `ft_strcpy(dst, src)` : `src` |
| 3 | `rdx` | `ft_write(fd, buf, count)` : `count` |
| 4 | `rcx` | quatrième argument d'une fonction normale |
| 5 | `r8` | cinquième argument |
| 6 | `r9` | sixième argument |

Les arguments suivants se trouvent sur la pile.

Exemples :

```c
size_t ft_strlen(const char *str);
```

```text
rdi = str
```

```c
ssize_t ft_write(int fd, const void *buf, size_t count);
```

```text
rdi = fd
rsi = buf
rdx = count
```

Pour les nombres flottants, les arguments utilisent principalement les registres
`xmm0` à `xmm7`. Ce n'est normalement pas nécessaire pour la partie obligatoire de
libasm.

## 6. Valeur de retour

Une fonction retourne généralement :

- un entier ou un pointeur dans `rax` ;
- un flottant dans `xmm0` ;
- aucune valeur particulière pour une fonction `void`.

Exemples :

```nasm
mov rax, 42         ; return 42
ret
```

Pour `ft_strlen`, `rax` contient donc la longueur finale.

## 7. Rôle habituel des registres

| Registre | Rôle courant |
|---|---|
| `rax` | valeur de retour, accumulateur, numéro de syscall |
| `rbx` | registre général à préserver |
| `rcx` | 4e argument C, compteur possible, détruit par `syscall` |
| `rdx` | 3e argument C, partie haute pour certaines multiplications/divisions |
| `rsi` | 2e argument C, source pour certaines instructions de chaîne |
| `rdi` | 1er argument C, destination pour certaines instructions de chaîne |
| `rsp` | pointeur du sommet de la pile |
| `rbp` | registre général préservé, souvent utilisé comme base de frame |
| `r8` à `r9` | 5e et 6e arguments C |
| `r10` | 4e argument d'un syscall Linux |
| `r11` | temporaire, détruit par `syscall` |
| `r12` à `r15` | registres généraux à préserver |

Ces rôles sont des conventions, pas des limitations matérielles. Par exemple, `rdi`
peut être utilisé comme registre temporaire dès que son argument n'est plus nécessaire.

## 8. Registres à préserver

Une fonction doit rendre certains registres avec leur valeur d'origine.

### La fonction appelée doit les préserver

```text
rbx, rbp, r12, r13, r14, r15, rsp
```

Si ta fonction les modifie, elle doit les sauvegarder puis les restaurer :

```nasm
push rbx
mov rbx, rdi
; utilisation de rbx
pop rbx
ret
```

### La fonction appelée peut les écraser

```text
rax, rcx, rdx, rsi, rdi, r8, r9, r10, r11
```

Si une valeur contenue dans l'un de ces registres doit survivre à un `call`, sauvegarde-la
avant l'appel.

Les registres SIMD `xmm0` à `xmm15` peuvent aussi être écrasés par une fonction appelée
dans la convention System V.

## 9. La pile

`rsp` pointe vers le sommet de la pile. La pile grandit vers les adresses basses.

```nasm
push rax            ; rsp -= 8, puis stocke rax sur la pile
pop rax             ; charge la valeur, puis rsp += 8
```

`call fonction` empile l'adresse de retour puis saute dans `fonction`. `ret` récupère cette
adresse et y retourne.

Avant d'exécuter un `call`, la pile doit être alignée sur 16 octets. À l'entrée d'une
fonction normale, `rsp` est donc généralement décalé de 8 octets à cause de l'adresse de
retour déjà empilée.

Exemple simple d'une fonction qui en appelle une autre :

```nasm
my_function:
    push rbp            ; rétablit ici un alignement multiple de 16
    mov rbp, rsp

    call malloc

    pop rbp
    ret
```

Chaque `push` change l'alignement de 8 octets. Il faut le recalculer avant chaque `call`.

## 10. Adresse ou contenu de la mémoire

Sans crochets, on manipule une valeur ou une adresse. Avec des crochets, on accède au
contenu de la mémoire à cette adresse.

```nasm
mov rax, rdi            ; copie l'adresse contenue dans rdi
mov al, [rdi]           ; lit un octet à l'adresse rdi
mov al, [rdi + 1]       ; lit l'octet suivant
mov byte [rdi], 'A'     ; écrit A à l'adresse rdi
```

Adressage courant :

```nasm
[base + index * taille + déplacement]
[rdi + rax]
[rdi + rcx * 8]
[rbp - 16]
```

Les facteurs autorisés pour l'index sont `1`, `2`, `4` et `8`.

## 11. Instructions courantes

### Copier et calculer

```nasm
mov rax, rdi        ; copie
lea rax, [rdi + 8]  ; calcule une adresse sans lire la mémoire
add rax, 1          ; addition
sub rax, 1          ; soustraction
inc rax             ; +1
dec rax             ; -1
imul rax, rsi       ; multiplication signée
xor rax, rax        ; met rax à zéro
```

`lea` signifie « load effective address ». Malgré son nom, il sert aussi à faire certains
calculs :

```nasm
lea rax, [rdi + rdi * 4]    ; rax = rdi * 5
```

### Comparer

`cmp a, b` calcule virtuellement `a - b` et modifie les drapeaux, sans conserver le
résultat.

```nasm
cmp rax, rbx
je .equal          ; égal, ZF = 1
jne .different     ; différent, ZF = 0
jg .greater        ; supérieur signé
jl .less           ; inférieur signé
ja .above          ; supérieur non signé
jb .below          ; inférieur non signé
jmp .loop          ; saut inconditionnel
```

Utilise les sauts signés (`jg`, `jl`, `jge`, `jle`) pour des valeurs signées et les sauts
non signés (`ja`, `jb`, `jae`, `jbe`) pour des tailles, adresses ou valeurs non signées.

`test` effectue un `AND` logique sans conserver le résultat :

```nasm
test rax, rax
jz .is_zero
jnz .not_zero
```

### Étendre une petite valeur

```nasm
movzx eax, byte [rdi]    ; étend un octet non signé avec des zéros
movsx eax, byte [rdi]    ; étend un octet signé en conservant son signe
```

Cette différence est importante pour reproduire précisément les comparaisons de
caractères.

## 12. Données et chaînes constantes

```nasm
section .rodata
message: db "Bonjour", 10, 0

section .data
counter: dq 0

section .bss
buffer: resb 1024
```

- `.rodata` : données constantes.
- `.data` : données initialisées et modifiables.
- `.bss` : espace non initialisé réservé au chargement.
- `db`, `dw`, `dd`, `dq` : définissent 1, 2, 4 ou 8 octets.
- `resb`, `resw`, `resd`, `resq` : réservent ces mêmes tailles.

Pour un code compatible PIE, préfère les adresses relatives à `rip` :

```nasm
default rel
lea rsi, [rel message]
```

## 13. Appeler une fonction externe

Déclare la fonction avec `extern`, place ses arguments, puis utilise `call` :

```nasm
extern malloc

section .text
global create_buffer

create_buffer:
    push rbp
    mov rbp, rsp

    mov rdi, 64         ; premier argument : taille demandée
    call malloc wrt ..plt

    pop rbp
    ret                 ; retourne le pointeur reçu dans rax
```

`wrt ..plt` permet un appel compatible avec un exécutable PIE lorsqu'on passe par la PLT.
Selon l'édition de liens et la configuration, `call malloc` peut également fonctionner,
mais la forme avec `wrt ..plt` est plus explicite pour une fonction externe.

Attention : `malloc` peut écraser tous les registres volatils. Sauvegarde les arguments
encore nécessaires dans des registres préservés ou sur la pile.

## 14. Syscalls Linux

Un syscall n'utilise pas exactement les mêmes registres qu'un appel C :

| Élément | Registre |
|---|---|
| Numéro du syscall | `rax` |
| Argument 1 | `rdi` |
| Argument 2 | `rsi` |
| Argument 3 | `rdx` |
| Argument 4 | `r10` |
| Argument 5 | `r8` |
| Argument 6 | `r9` |
| Retour | `rax` |

Sous Linux x86-64 :

```text
read  = 0
write = 1
```

Exemple minimal de `write` :

```nasm
mov rax, 1      ; numéro de SYS_write
; rdi contient déjà fd
; rsi contient déjà buf
; rdx contient déjà count
syscall
```

L'instruction `syscall` détruit `rcx` et `r11`.

En cas d'échec, le noyau renvoie une valeur négative comprise généralement entre `-1` et
`-4095`. La libc attend normalement `-1` et une valeur positive dans `errno`. Pour
`ft_read` et `ft_write`, il faut donc détecter l'erreur, transformer le résultat négatif en
numéro d'erreur positif, écrire ce numéro via `__errno_location`, puis retourner `-1`.

Schéma général :

```nasm
extern __errno_location

    syscall
    test rax, rax
    js .error
    ret

.error:
    neg rax             ; transforme -errno en errno
    push rax            ; sauvegarde errno et aligne la pile avant call
    call __errno_location wrt ..plt
    pop rdx
    mov [rax], edx      ; errno est un int de 32 bits
    mov rax, -1
    ret
```

Il faut vérifier l'alignement réel de la pile si d'autres `push` ou allocations locales ont
déjà été effectués.

## 15. Correspondance C et assembleur

### Lire un caractère

```c
c = str[i];
```

```nasm
mov al, [rdi + rcx]
```

### Écrire un caractère

```c
dst[i] = src[i];
```

```nasm
mov al, [rsi + rcx]
mov [rdi + rcx], al
```

### Boucle jusqu'au `\0`

```c
while (str[i] != '\0')
    i++;
```

```nasm
    xor rax, rax
.loop:
    cmp byte [rdi + rax], 0
    je .end
    inc rax
    jmp .loop
.end:
```

## 16. Déclarer les fonctions dans `libasm.h`

Les fonctions sont implémentées dans les `.s`, mais déclarées dans le `.h` pour que le C
connaisse leurs types :

```c
#ifndef LIBASM_H
# define LIBASM_H

# include <stddef.h>
# include <sys/types.h>

size_t  ft_strlen(const char *str);
char    *ft_strcpy(char *dst, const char *src);
int     ft_strcmp(const char *s1, const char *s2);
ssize_t ft_write(int fd, const void *buf, size_t count);
ssize_t ft_read(int fd, void *buf, size_t count);
char    *ft_strdup(const char *str);
void    *ft_calloc(size_t nmemb, size_t size);

#endif
```

Le fichier `.h` ne contient pas l'implémentation des fonctions.

## 17. Commandes de compilation utiles

Assembler un fichier :

```bash
nasm -f elf64 src/ft_strlen.s -o src/ft_strlen.o
```

Créer la bibliothèque statique :

```bash
ar rcs libasm.a src/ft_strlen.o
```

Compiler et lier un test :

```bash
cc -Wall -Wextra -Werror -Iincludes tests/main.c -L. -lasm -o test_libasm
```

Afficher les symboles de la bibliothèque :

```bash
nm libasm.a
```

Désassembler le code produit :

```bash
objdump -d -M intel libasm.a
```

Déboguer :

```bash
gdb ./test_libasm
```

Commandes GDB utiles :

```text
break ft_strlen
run
info registers
x/s $rdi
x/16bx $rdi
si
disassemble /r ft_strlen
```

## 18. Erreurs fréquentes

- Inverser la source et la destination : NASM écrit `destination, source`.
- Confondre `rdi` avec `[rdi]` : le premier est l'adresse, le second est son contenu.
- Oublier `global` pour une fonction appelée depuis le C.
- Oublier `extern` pour une fonction définie dans une autre bibliothèque.
- Oublier de préserver `rbx`, `rbp` ou `r12` à `r15`.
- Garder une valeur importante dans un registre volatil pendant un `call`.
- Désaligner la pile avant un `call`.
- Utiliser `%d` dans `printf` pour un `size_t` : utiliser `%zu`.
- Passer `&str` au lieu de `str` lorsque la fonction attend un `char *`.
- Comparer des valeurs non signées avec les sauts signés, ou inversement.
- Écrire seulement dans `al` puis supposer que le reste de `rax` vaut zéro.
- Pour un syscall, utiliser `rcx` comme quatrième argument au lieu de `r10`.
- Retourner directement `-errno` après un syscall au lieu de mettre à jour `errno`.
- Lire après le `\0` ou en dehors d'un buffer.

## 19. Résumé à mémoriser

```text
Arguments C : rdi, rsi, rdx, rcx, r8, r9
Retour       : rax
À préserver : rbx, rbp, r12, r13, r14, r15, rsp
Volatils     : rax, rcx, rdx, rsi, rdi, r8, r9, r10, r11
Syscall      : rax=numéro, puis rdi, rsi, rdx, r10, r8, r9
NASM Intel   : instruction destination, source
Mémoire      : [adresse]
Pile         : alignée sur 16 octets avant un call
```
