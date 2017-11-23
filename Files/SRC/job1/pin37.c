#include <stdio.h>
#include <bcm2835.h>

#define PIN37	RPI_BPLUS_GPIO_J8_37

int main(int argc, char **argv)
{
	if (bcm2835_init() == 0) {
		return 1;
	}
	
	bcm2835_gpio_fsel(PIN37, BCM2835_GPIO_FSEL_OUTP);
	bcm2835_gpio_write(PIN37, HIGH);
	
	bcm2835_close();
	
	return 0;
}
