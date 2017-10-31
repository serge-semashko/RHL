/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   main.c
 * Author: serge
 *
 * Created on March 4, 2017, 5:21 PM
 */
#include "mydacadc.h"
#include "mybcm2835.h"
#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <err.h>
#include <string.h>
#define SPI_CS RPI_GPIO_P1_16 //P4

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

void bsp_DelayUS(uint64_t micros) {
    bcm2835_delayMicroseconds(micros);
}

void write_DAC8532(uint8_t channel, uint16_t Data) {
    bcm2835_gpio_write(SPI_CS, HIGH);
    bcm2835_gpio_write(SPI_CS, LOW);

    bcm2835_spi_transfer(channel);
    bcm2835_spi_transfer((Data >> 8));
    bcm2835_spi_transfer((Data & 0xff));

    bcm2835_gpio_write(SPI_CS, HIGH);
}

uint16_t V_convert(double Vref, double voltage) {
    uint16_t res = (uint16_t) (65536 * voltage / Vref);

    return res;
}


int port = 8282;
double val;
int strstart = 0;
char answer[2048];
char *pansw;
char nword[100], metod[100], protocol[100], uri[100];
int strpos;
char resp1[2048];
char response[100] = "HTTP/1.1 200 OK\r\n"
        "Content-Type: text/html; charset=UTF-8\r\n\r\n";
//        "{ret:";
//        "<!DOCTYPE html><html><head><title>Bye-bye baby bye-bye</title>"
//        "<style>body { background-color: #111 }"
//        "h1 { font-size:4cm; text-align: center; color: black;"
//        " text-shadow: 0 0 2mm red}</style></head>"
//        "<body><h1>Goodbye, world!</h1></body></html>\r\n";

/*
 * 
 */
void getword() {
    strstart = strpos;
    //    printf("pos startpos %d \n", strpos);
    while (
            (*(answer + strpos) == ' ')&&
            (*(answer + strpos) == "\n")&&
            (*(answer + strpos) == "\r")) {
        //        printf(";%c;", *(answer + strpos));
        strpos++;
    };

    while ((*(answer + strpos) != ' ')&&(*(answer + strpos) != "\r\n")) {
        //        printf("'%c'", *(answer + strpos));
        strpos++;
    };
    memset(nword, 0, 100);
    strncpy(nword, answer + strstart, strpos - strstart);
    //    printf("\n pos after %d '%s' \n", strpos, nword);
    strpos++;
}

char * settime(struct tm *u) {
    char s[40];
    char *tmp;
    for (int i = 0; i < 40; i++) s[i] = 0;
    int length = strftime(s, 40, "%d.%m.%Y %H:%M:%S, %A", u);
    tmp = (char*) malloc(sizeof (s));
    strcpy(tmp, s);
    return (tmp);
}

int main(int argc, char** argv) {
    int one = 1, client_fd;
    int rdlen;
    struct sockaddr_in svr_addr, cli_addr;
    socklen_t sin_len = sizeof (cli_addr);
    struct tm *u;
    char *f;
    time_t timer;
    int step=1;
    int sock = socket(AF_INET, SOCK_STREAM, 0);
    if (sock < 0)
        err(1, "can't open socket");

    setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, &one, sizeof (int));


    svr_addr.sin_family = AF_INET;
    svr_addr.sin_addr.s_addr = INADDR_ANY;
    svr_addr.sin_port = htons(port);

    if (bind(sock, (struct sockaddr *) &svr_addr, sizeof (svr_addr)) == -1) {
        close(sock);
        err(1, "Can't bind");
    }
            double setval;
            uint16_t dsetval;
	    dsetval=10001;
    listen(sock, 5);
  
    while (1==1) {

        if (step==0) {
		dsetval = 43501;
	};
        if (step==1) {
		dsetval = 43501;
	};
        if (step==2) {
		dsetval = 43500;
	};
        if (step==3) {
		dsetval = 43501;
	};

        if (step==4) {
		dsetval = 43501;
	};
        if (step==5) {
		dsetval = 43500;
	};
            if (bcm2835_init() != 1) {
                fprintf(stderr, "Error in bcm2835_init()\n");
                return -1;
            }
            step = ++step % 6;
            bcm2835_spi_begin();
            bcm2835_spi_setBitOrder(BCM2835_SPI_BIT_ORDER_LSBFIRST); // The default
            bcm2835_spi_setDataMode(BCM2835_SPI_MODE1); // The default;
            bcm2835_spi_setClockDivider(BCM2835_SPI_CLOCK_DIVIDER_1024); // The default

            bcm2835_gpio_fsel(SPI_CS, BCM2835_GPIO_FSEL_OUTP); //
            bcm2835_gpio_write(SPI_CS, HIGH);
            write_DAC8532(ch_A, dsetval);
            bcm2835_spi_end();
            bcm2835_close();
    }
}


