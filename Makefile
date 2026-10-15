NAME		= libasm.a

NASM		= nasm
NASMFLAGS	= -f elf64
AR			= ar rcs
CC			= cc
CFLAGS			= -Wall -Wextra -Werror
CPPFLAGS		= -Iincludes
OBJ_DIR			= .obj

SRC			= src/ft_strlen.s \
			  src/ft_strcpy.s \
			  src/ft_strcmp.s \
			  src/ft_write.s \
			  src/ft_read.s \
			  src/ft_strdup.s \
			  src/ft_calloc.s
OBJ			= $(patsubst src/%.s,$(OBJ_DIR)/src/%.o,$(SRC))

TEST			= test_libasm
TEST_SRC		= tests/main.c
TEST_OBJ		= $(patsubst tests/%.c,$(OBJ_DIR)/tests/%.o,$(TEST_SRC))

.PHONY: all clean fclean re bonus test

all: $(NAME)

$(NAME): $(OBJ)
	$(AR) $@ $^

$(OBJ_DIR)/src/%.o: src/%.s
	mkdir -p $(dir $@)
	$(NASM) $(NASMFLAGS) $< -o $@

$(OBJ_DIR)/tests/%.o: tests/%.c includes/libasm.h
	mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

bonus: all

$(TEST): $(NAME) $(TEST_OBJ)
	$(CC) $(CFLAGS) $(TEST_OBJ) -L. -lasm -o $@

test: $(TEST)
	./$(TEST)

clean:
	rm -rf .obj

fclean: clean
	rm -f $(NAME) $(TEST)

re: fclean all
