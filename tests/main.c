/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: zcadinot <zcadinot@student.42lehavre.      +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/10/14 17:02:03 by zcadinot          #+#    #+#             */
/*   Updated: 2026/10/15 12:33:13 by zcadinot         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <unistd.h>
#include <stdlib.h>
#include "libasm.h"

static void	test_strcmp(const char *s1, const char *s2)
{
	int	ft;
	int	libc;

	ft = ft_strcmp(s1, s2);
	libc = strcmp(s1, s2);
	printf("\"%s\" / \"%s\" : %s (ft=%d, libc=%d)\n", s1, s2,
		((ft > 0) - (ft < 0)) == ((libc > 0) - (libc < 0)) ? "OK" : "KO",
		ft, libc);
}

static void	test_write(void)
{
	const char	message[] = "message écrit avec ft_write\n";
	ssize_t		result;

	printf("\n=== FT_WRITE ===\n");
	fflush(stdout);
	result = ft_write(1, message, sizeof(message) - 1);
	printf("écriture : %s (retour=%zd)\n",
		result == (ssize_t)(sizeof(message) - 1) ? "OK" : "KO", result);
	errno = 0;
	result = ft_write(-1, message, sizeof(message) - 1);
	printf("erreur   : %s (retour=%zd, errno=%d)\n",
		result == -1 && errno == EBADF ? "OK" : "KO", result, errno);
}

static void	test_read(void)
{
	char	buffer[20] = {0};
	int		pipe_fd[2];
	ssize_t	result;

	printf("\n=== FT_READ ===\n");
	if (pipe(pipe_fd) == -1)
		return (perror("pipe"));
	write(pipe_fd[1], "bonjour", 7);
	close(pipe_fd[1]);
	errno = 0;
	result = ft_read(pipe_fd[0], buffer, sizeof(buffer) - 1);
	close(pipe_fd[0]);
	printf("lecture  : %s (retour=%zd, buffer=\"%s\")\n",
		result == 7 && strcmp(buffer, "bonjour") == 0 ? "OK" : "KO",
		result, buffer);
	errno = 0;
	result = ft_read(-1, buffer, sizeof(buffer));
	printf("erreur   : %s (retour=%zd, errno=%d)\n",
		result == -1 && errno == EBADF ? "OK" : "KO", result, errno);
}

static void	test_strdup(void)
{
	const char	*src;
	char		*copy;

	src = "bonjour";
	copy = ft_strdup(src);
	printf("\n=== FT_STRDUP ===\n");
	if (copy == NULL)
	{
		printf("allocation : KO\n");
		return ;
	}
	printf("source    : \"%s\"\n", src);
	printf("copie     : \"%s\"\n", copy);
	printf("contenu   : %s\n", strcmp(copy, src) == 0 ? "OK" : "KO");
	printf("nouvelle adresse : %s\n", copy != src ? "OK" : "KO");
	free(copy);
}

int	main(void)
{
	char	src[] = "bonjour";
	char	ft_dest[20] = "XXXXXXXX";
	char	libc_dest[20] = "XXXXXXXX";
	char	*result;

	printf("=== FT_STRLEN ===\n");
	printf("attendu : %zu\n", strlen(src));
	printf("obtenu  : %zu\n", ft_strlen(src));
	result = ft_strcpy(ft_dest, src);
	strcpy(libc_dest, src);
	printf("\n=== FT_STRCPY ===\n");
	printf("source  : \"%s\"\n", src);
	printf("attendu : \"%s\"\n", libc_dest);
	printf("obtenu  : \"%s\"\n", ft_dest);
	printf("contenu : %s\n", strcmp(ft_dest, libc_dest) == 0 ? "OK" : "KO");
	printf("retour  : %s\n", result == ft_dest ? "OK" : "KO");
	printf("\n=== FT_STRCMP ===\n");
	test_strcmp("abc", "abc");
	test_strcmp("abc", "abd");
	test_strcmp("abd", "abc");
	test_strcmp("", "abc");
	test_write();
	test_read();
	test_strdup();
	return (0);
}
