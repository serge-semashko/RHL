
#include <unistd.h>
#include <stdio.h>
#include <bcm2835.h>

int main(int argc, char **argv)
{
	int ret = 0;
	char buf[3] = {0};
	char rbuf[3] = {-1};

	char mosi[3];
	char miso[3] = {111};

	ret = bcm2835_init();
	if (ret != 1) {
		fprintf(stderr, "Error in bcm2835_init()\n");

		return -1;
	}

	ret = bcm2835_spi_begin();
	if (ret != 1) {
		fprintf(stderr, "Error in spi begin! ret code = %d\n", ret);

		return -1;
	}

	bcm2835_spi_setBitOrder(BCM2835_SPI_BIT_ORDER_MSBFIRST);
	bcm2835_spi_setDataMode(BCM2835_SPI_MODE1);
	bcm2835_spi_setClockDivider(BCM2835_SPI_CLOCK_DIVIDER_128);
	bcm2835_spi_chipSelect(BCM2835_SPI_CS0);
	bcm2835_spi_setChipSelectPolarity(BCM2835_SPI_CS0, HIGH);

	mosi[0] = 0b00100000;
	mosi[1] = 0b00000000;
	mosi[2] = 0b00010010;
	bcm2835_spi_transfern(mosi, 3);

	mosi[0] = 0b10100000;
	mosi[1] = 0b00000000;
	mosi[2] = 0b00010010;
	bcm2835_spi_transfernb(mosi, miso, 3);

	printf("mosi = {%d %d %d}\nmiso = {%d %d %d}\n", mosi[0], mosi[1], mosi[2], miso[0], miso[1], miso[2]);


	mosi[0] = 0b00011000;
	mosi[1] = 0b11000000;
	mosi[2] = 0b10000000;
	bcm2835_spi_transfern(mosi, 3);
	usleep(1000);

/*
	while (1) {
		mosi[0] = 0b00010000;
		mosi[1] = 0b11111111;
		mosi[2] = 0b00000000;
		bcm2835_spi_transfernb(mosi, miso, 3);
		//printf("miso = %s\n", miso);
		printf("miso = {%d %d %d}\n", miso[0], miso[1], miso[2]);
		usleep(1000);
	}
*/
/*
	mosi[0] = 0b00100000;
	mosi[1] = 0b00000000;
	mosi[2] = 0b00010010;
	bcm2835_spi_transfern(mosi, 3);
	usleep(1000);
*/


/*
	mosi[0] = 0b00011111;
	mosi[1] = 0b00000000;
	mosi[2] = 0b00000000;
	bcm2835_spi_transfern(mosi, 3);


//	printf("miso = {%d %d %d}\n", miso[0], miso[1], miso[2]);
/*
	buf[0] = 0b00100000;
	buf[1] = 0b00000000;
	buf[2] = 0b00010010;
	bcm2835_spi_transfernb(buf, rbuf, 3);
	printf("after write rb = %d %d %d\n", rbuf[0], rbuf[1], rbuf[2]);

	buf[0] = 0b10110000;
	buf[1] = buf[2] = 0b00000000;
	bcm2835_spi_transfernb(buf, rbuf, 3);
	printf("after read rb = %d %d %d\n", rbuf[0], rbuf[1], rbuf[2]);

	buf[0] = 0b00010000;
	buf[1] = 0b00000000;
	buf[2] = 0b00000000;
	bcm2835_spi_transfernb(buf, rbuf, 3);
	printf("rb = %d %d %d\n", rbuf[0], rbuf[1], rbuf[2]);
*/
	bcm2835_spi_end();
	bcm2835_close();

	return 0;
}
