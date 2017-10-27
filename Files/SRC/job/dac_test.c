#include <bcm2835.h>
#include <stdio.h>

int main(int argc, char **argv)
{
	if (argc < 2) {
		printf("argc < 2\n");
		return -1;
	}

	bcm2835_init();

	if (bcm2835_i2c_begin() != 1) {
		printf("Error in i2c begin\n");
		return -1;
	}

	bcm2835_i2c_setSlaveAddress(0x60);

	int volt = atoi(argv[1]);
	unsigned char buf[2];
	buf[0] = volt >> 8;
	buf[1] = volt;

	bcm2835_i2c_write(buf, 2);

	bcm2835_i2c_end();

	return 0;
}
