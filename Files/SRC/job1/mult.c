#include <stdio.h>
#include <stdlib.h>
#include <bcm2835.h>

int main(int argc, char *argv[])
{
	int r;
	unsigned char buf[1];

	r = bcm2835_init();
	if (r != 1 || argc < 2) {
		printf("Error in i2c init OR args\n");

		return 1;
	}

	r = bcm2835_i2c_begin();
	if (r != 1) {
		printf("Error in i2c begin\n");

		return 1;
	}

	bcm2835_i2c_setSlaveAddress(0x74);

	buf[0] = (int)strtol(argv[1], NULL, 2);
	r = bcm2835_i2c_write(buf, 1);

	if (r != BCM2835_I2C_REASON_OK) {
		printf("Error in write r=%d\n", r);

		return 2;
	}

	bcm2835_i2c_end();

	bcm2835_close();

	return 0;
}
