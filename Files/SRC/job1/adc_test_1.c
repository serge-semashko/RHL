#include <bcm2835.h>
#include <stdio.h>

int main(int argc, char **argv)
{
	int r = 0;
	bcm2835_init();

	if ((r=bcm2835_i2c_begin()) != 1) {
		printf("Error in i2c begin r = %d\n", r);
		return -1;
	}

	bcm2835_i2c_setSlaveAddress(0x48);

	char wr_buf[4] = {0};
	char buf[3] = {0};

	wr_buf[0] = 0b10010000;
	bcm2835_i2c_write(wr_buf, 1);

	wr_buf[0] = 0b00000001;
	bcm2835_i2c_write(wr_buf, 1);

	wr_buf[0] = 0b10000100;
	bcm2835_i2c_write(wr_buf, 1);

	wr_buf[0] = 0b10000011;
	bcm2835_i2c_write(wr_buf, 1);

	wr_buf[0] = 0b10010000;
	bcm2835_i2c_write(wr_buf, 1);

	wr_buf[1] = 0b00000000;
	bcm2835_i2c_write(wr_buf, 1);

	bcm2835_i2c_read(buf, 3);

	printf("%d %d %d\n", buf[0], buf[1], buf[2]);
/*
	wr_buf[0] = 0;
	bcm2835_i2c_write(wr_buf, 1);
	bcm2835_i2c_read(buf, 2);

	bcm2835_i2c_end();

	printf("%d %d\n", buf[0], buf[1]);
	int adc_out = 256*buf[0] + buf[1];
	printf("ADC out = %d\n", adc_out);
*/
	return 0;
}
