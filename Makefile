NAME		= libasm.a

NASM		= nasm
NASMFLAGS	= -f elf64
AR			= ar rcs
CC			= cc
CFLAGS			= -Wall -Wextra -Werror
CPPFLAGS		= -Iincludes

SRC			= src/ft_strlen.s \
			  src/ft_strcpy.s \
			  src/ft_strcmp.s \
			  src/ft_write.s \
			  src/ft_read.s \
			  src/ft_strdup.s \
			  src/ft_calloc.s
OBJ			= $(SRC:.s=.o)

TEST			= test_libasm
TEST_SRC		= tests/main.c
TEST_OBJ		= $(TEST_SRC:.c=.o)

.PHONY: all clean fclean re bonus test

all: $(NAME)

$(NAME): $(OBJ)
	$(AR) $@ $^
	rm -f $(OBJ)

%.o: %.s
	$(NASM) $(NASMFLAGS) $< -o $@

%.o: %.c
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

bonus: all

$(TEST): $(NAME) $(TEST_OBJ)
	$(CC) $(CFLAGS) $(TEST_OBJ) -L. -lasm -o $@

test: $(TEST)
	./$(TEST)

clean:
	rm -f $(OBJ) $(TEST_OBJ)

fclean: clean
	rm -f $(NAME) $(TEST)

re: fclean all
