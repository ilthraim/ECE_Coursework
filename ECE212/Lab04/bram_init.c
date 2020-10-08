#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "char_map.h"

int main(int argc, const char* argv[]) {
	unsigned int mask;
	if (argc == 3)
		if (sscanf(argv[2], "%x", &mask) != 1)
			printf("INVALID COLOR MASK");
	else
		mask = 0x77777777;

	if (strlen(argv[1]) >= 198)
		printf("INVALID STRING LENGTH");
	else {
		unsigned int init_buf[8];
		int y = 0, x, z, col = 4;
		char c;
		for (x = 0; x < strlen(argv[1]); x++) {
			c = argv[1][x];
			for (z = 0; z < 6; z++) {
				init_buf[y] = (char_map[c][z] & mask);

				if (++y >= 8) {
					printf(".INIT_%02X (256\'h%08X_%08X_%08X_%08X_%08X_%08X_%08X_%08X),\n", col, init_buf[7], init_buf[6], init_buf[5], init_buf[4], init_buf[3], init_buf[2], init_buf[1], init_buf[0]);
					col++;
					y = 0;
				}
			}
		}

		if (y != 0) {
			while (y < 8) {
				init_buf[y] = 0x00000000;
				y++;
			}

			printf(".INIT_%02X (256\'h%08X_%08X_%08X_%08X_%08X_%08X_%08X_%08X),\n", col, init_buf[7], init_buf[6], init_buf[5], init_buf[4], init_buf[3], init_buf[2], init_buf[1], init_buf[0]);
		}

	}

	return 0;
}

