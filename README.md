# ft_libasm

**42 School · Libasm**

*Rebuilding familiar C library functions in x86-64 assembly.*

![Assembly](https://img.shields.io/badge/Language-x86--64%20Assembly-4B5563?style=flat-square)
![NASM](https://img.shields.io/badge/Assembler-NASM-2563EB?style=flat-square)
![42 School](https://img.shields.io/badge/Project-42%20School-111827?style=flat-square)

---

## 📖 About

**Libasm** is a 42 School project that introduces low-level programming through the reimplementation of standard C library functions in **64-bit assembly**, using **NASM** and **Intel syntax**.

The project focuses on registers, memory operations, calling conventions, system calls, error handling, and linking assembly code with C. The resulting static library is named **`libasm.a`**.

## 🧩 Mandatory functions

| Function | Purpose |
| --- | --- |
| `ft_strlen` | Calculate the length of a string. |
| `ft_strcpy` | Copy a null-terminated string. |
| `ft_strcmp` | Compare two strings. |
| `ft_write` | Write data to a file descriptor. |
| `ft_read` | Read data from a file descriptor. |
| `ft_strdup` | Duplicate a string using dynamically allocated memory. |
| `ft_calloc` | Allocate zero-initialized memory, detecting `nmemb * size` overflow. |

`ft_read` and `ft_write` must handle system-call failures correctly, including setting **`errno`** when required.

## ✨ Bonus functions

The bonus part is optional and is evaluated **only if the mandatory part is perfect**.

| Function | Purpose |
| --- | --- |
| `ft_atoi_base` | Convert a string to an integer using a validated base. |
| `ft_list_push_front` | Insert an element at the beginning of a linked list. |
| `ft_list_size` | Count the elements in a linked list. |
| `ft_list_sort` | Sort a linked list using a comparison function. |
| `ft_list_remove_if` | Remove matching list elements and free their memory. |
| `ft_simd_memchr` | Find a byte using parallel byte comparisons (SIMD or SWAR). |

Bonus assembly sources use the required **`_bonus.s`** suffix. The `ft_simd_memchr` implementation must not read beyond safe memory boundaries.

## 🛠️ Requirements

- An **x86-64** environment with a compatible calling convention.
- **NASM** (Netwide Assembler).
- **Make**, a C compiler, and a static archive tool such as `ar`.

The project uses standalone **`.s`** files, not inline assembly. The **`-no-pie`** compilation flag is forbidden by the subject.

## 🚀 Build

```bash
# Build libasm.a
make

# Build the bonus part (if implemented)
make bonus

# Remove object files
make clean

# Remove object files and libasm.a
make fclean

# Rebuild from scratch
make re
```

The Makefile provides the required targets: `$(NAME)`, `all`, `clean`, `fclean`, and `re`. It should rebuild only what has changed.

## 📁 Project structure

```text
ft_libasm/
├── Makefile
├── README.md
├── .gitignore
├── includes/
│   └── libasm.h
├── srcs/
│   ├── ft_strlen.s
│   ├── ft_strcpy.s
│   ├── ft_strcmp.s
│   ├── ft_write.s
│   ├── ft_read.s
│   ├── ft_strdup.s
│   └── ft_calloc.s
├── bonus/
│   ├── ft_atoi_base_bonus.s
│   ├── ft_list_push_front_bonus.s
│   ├── ft_list_size_bonus.s
│   ├── ft_list_sort_bonus.s
│   ├── ft_list_remove_if_bonus.s
│   └── ft_simd_memchr_bonus.s
└── tests/
    ├── main.c
    ├── test_strings.c
    ├── test_io.c
    ├── test_memory.c
    └── test_bonus.c
```

## 🧪 Testing

The subject requires a **`main` function** that links against the library and demonstrates that the functions work.

For the structure above, a basic way to compile and run the test entry point is:

```bash
make
cc -Wall -Wextra -Werror -Iincludes tests/main.c -L. -lasm -o libasm_test
./libasm_test
```

Test the functions against their standard C counterparts where appropriate, and include edge cases such as empty strings, read/write failures, allocation failures, and `ft_calloc` overflow. Bonus tests should also cover linked-list edge cases and safe buffer boundaries.

## 📌 Project rules

- Use **64-bit assembly** and the appropriate calling convention.
- Assemble with **NASM**, using **Intel syntax**.
- Write assembly in separate **`.s`** source files.
- Handle system-call errors and **`errno`** correctly.
- Keep bonus functions in separate **`_bonus.s`** files.
- Do not use **`-no-pie`**.
- Submit the source code and a working **`main`** test program to the assigned Git repository.

---

**42 School — Libasm (subject v6.0)**

*Assembly yourself!*
