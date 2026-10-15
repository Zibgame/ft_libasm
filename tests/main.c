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
#include "libasm.h"

int	main(void)
{
	char	str[] = "salut";
	char	src[] = "bonjour";
	char	ft_dest[100] = {0};
	char	libc_dest[100] = {0};
	char	*ft_return;
	char	*libc_return;

	printf("ft_strlen('%s') = %zu\n", str, ft_strlen(str));
	printf("strlen('%s') = %zu\n", str, strlen(str));
	ft_return = ft_strcpy(ft_dest, src);
	libc_return = strcpy(libc_dest, src);
	printf("ft_strcpy: '%s'\n", ft_dest);
	printf("strcpy:    '%s'\n", libc_dest);
	printf("contenu:   %s\n", strcmp(ft_dest, libc_dest) == 0 ? "OK" : "KO");
	printf("retour:    %s\n", ft_return == ft_dest
		&& libc_return == libc_dest ? "OK" : "KO");
    return (0);
}
