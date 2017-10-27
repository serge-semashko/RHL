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

	wr_buf[0] = 0b00000001;
	wr_buf[1] = 0b11000000;
	wr_buf[2] = 0b00000011;
	bcm2835_i2c_write(wr_buf, 3);

	wr_buf[0] = 0;
	bcm2835_i2c_write(wr_buf, 1);

	bcm2835_i2c_read(buf, 2);

	printf("%.4f V\n", 6.144*(256.0*buf[0]+buf[1])/32768.0 );
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
