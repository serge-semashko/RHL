#include <unistd.h>
#include <stdio.h>
#include <bcm2835.h>

int main(int argc, char **argv)
{
	int ret = 0;

	char mosi[3] = {0};
	char miso[3] = {0};

	ret = bcm2835_init();
	if (ret != 1) {
		fprintf(stderr, "Error in bcm2835_init()\n");

		return -1;
	}

	ret = bcm2835_spi_begin();
	if (ret != 1) {
		fprintf(stderr, "Error in bcm2835_spi_begin()\n");

		return -1;
	}

	bcm2835_spi_setBitOrder(BCM2835_SPI_BIT_ORDER_MSBFIRST);
	bcm2835_spi_setDataMode(BCM2835_SPI_MODE1);
	bcm2835_spi_setClockDivider(BCM2835_SPI_CLOCK_DIVIDER_256);
	bcm2835_spi_chipSelect(BCM2835_SPI_CS0);
	bcm2835_spi_setChipSelectPolarity(BCM2835_SPI_CS0, LOW);

	mosi[0] = 0b11111111;
	mosi[1] = 0b00010000;
	mosi[2] = 0b00110000;

	while(1) {
		bcm2835_spi_transfernb(mosi, miso, 3);
		printf("mosi = {%d %d %d}\n", mosi[0], mosi[1], mosi[2]);
		printf("miso = {%d %d %d}\n", miso[0], miso[1], miso[2]);
		usleep(1000);
	}

	bcm2835_spi_end();
	bcm2835_close();

	return 0;
}
