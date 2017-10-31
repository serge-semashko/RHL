#include <bcm2835.h>  
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <errno.h>

//CS      -----   SPICS  
//DIN     -----   MOSI
//DOUT  -----   MISO
//SCLK   -----   SCLK
//DRDY  -----   ctl_IO     data  starting
//RST     -----   ctl_IO     reset



#define	SPI_CS	RPI_GPIO_P1_16	//P4

#define CS_1() bcm2835_gpio_write(SPI_CS, HIGH)
#define CS_0() bcm2835_gpio_write(SPI_CS, LOW)


/* Unsigned integer types  */
#define uint8_t unsigned char
#define uint16_t unsigned short    

const double V_REF = 5.14; //V_POWER on RPi 3 

const unsigned int ch_A = 0x30;
const unsigned int ch_B = 0x34;

void bsp_DelayUS(uint64_t micros);
void write_DAC8532(uint8_t channel, uint16_t Data);
uint16_t V_convert(double Vref, double voltage);


void bsp_DelayUS(uint64_t micros)
{
	bcm2835_delayMicroseconds (micros);
}


void write_DAC8532(uint8_t channel, uint16_t Data)
{
	bcm2835_gpio_write(SPI_CS, HIGH);
	bcm2835_gpio_write(SPI_CS, LOW);
	
	bcm2835_spi_transfer(channel);
	bcm2835_spi_transfer((Data>>8));
	bcm2835_spi_transfer((Data&0xff));  
	
	bcm2835_gpio_write(SPI_CS, HIGH);
}

uint16_t V_convert(double Vref, double voltage)
{
	uint16_t res = (uint16_t)(65536 * voltage / Vref);

	return res;
}

int main(int argc, char **argv)
{   
	if (bcm2835_init() != 1) {
		fprintf(stderr, "Error in bcm2835_init()\n");
		return -1;
	}

    bcm2835_spi_begin();
    bcm2835_spi_setBitOrder(BCM2835_SPI_BIT_ORDER_LSBFIRST );      // The default
    bcm2835_spi_setDataMode(BCM2835_SPI_MODE1);                   // The default;
    bcm2835_spi_setClockDivider(BCM2835_SPI_CLOCK_DIVIDER_1024); // The default

    bcm2835_gpio_fsel(SPI_CS, BCM2835_GPIO_FSEL_OUTP);//
    bcm2835_gpio_write(SPI_CS, HIGH);

    if (argc == 2) {
        printf("argc = %d | argv[1] = %e\n", argc, (double)atof(argv[1]));
        write_DAC8532( ch_A, V_convert(V_REF, (double)atof(argv[1])) );
    }
    else {
        write_DAC8532(ch_A, V_convert(V_REF, 1.0));
    }

    bcm2835_spi_end();
    bcm2835_close();

    return 0;
}
