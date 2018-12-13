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

#define GPIO12 RPI_BPLUS_GPIO_J8_32
#define GPIO21 RPI_BPLUS_GPIO_J8_40

const double VREFP = 5.0;
const double VREFN = 0.0;

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
void init_DAC()
{
    char mosi[3] = {0};

    //RESET
    mosi[0] = 0b01000000;
    mosi[1] = 0b00000000;
    mosi[2] = 0b00000100;
    bcm2835_gpio_write(GPIO12, HIGH);
    bcm2835_gpio_write(GPIO12, LOW);
    bcm2835_spi_transfern(mosi, 3);
    bcm2835_gpio_write(GPIO12, HIGH);

    usleep(1000);

    //write to control register
    mosi[0] = 0b00100000;
    mosi[1] = 0b00000000;
    mosi[2] = 0b00010010;
    bcm2835_gpio_write(GPIO12, HIGH);
    bcm2835_gpio_write(GPIO12, LOW);
    bcm2835_spi_transfern(mosi, 3);
    bcm2835_gpio_write(GPIO12, HIGH);
}
void set_V(char *msb)
{
    char mosi[3] = {0};

    mosi[0] = 0b00010000 | (msb[0] & 0b00001111);
    mosi[1] = msb[1];
    mosi[2] = msb[2];

    bcm2835_gpio_write(GPIO12, HIGH);
    bcm2835_gpio_write(GPIO12, LOW);
    bcm2835_spi_transfern(mosi, 3);
    bcm2835_gpio_write(GPIO12, HIGH);
}

void write_DAC8532(uint8_t channel, uint16_t Data) {
    bcm2835_gpio_write(SPI_CS, HIGH);
    bcm2835_gpio_write(SPI_CS, LOW);

    bcm2835_spi_transfer(channel);
    bcm2835_spi_transfer((Data >> 8));
    bcm2835_spi_transfer((Data & 0xff));
    printf("write dac8532  = %d ", Data>>8);
    printf("  %d \n", Data& 0xff8);

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
// Init DAC and SPI
    int ret = bcm2835_init();
    if (ret != 1) {
        fprintf(stderr, "Error in bcm2835_init()\n");
    

        return -1;
    }
    fprintf(stderr, "bcm2835_init()\n");

    ret = bcm2835_spi_begin();
    if (ret != 1) {
        fprintf(stderr, "Error in spi begin! ret code = %d\n", ret);

        return -1;
    }

    //setting SPI and CS
    bcm2835_spi_setBitOrder(BCM2835_SPI_BIT_ORDER_LSBFIRST);
    bcm2835_spi_setDataMode(BCM2835_SPI_MODE1);
    bcm2835_spi_setClockDivider(BCM2835_SPI_CLOCK_DIVIDER_1024);
    bcm2835_gpio_fsel(GPIO12, BCM2835_GPIO_FSEL_OUTP);
    bcm2835_gpio_write(GPIO12, HIGH);

    if ((argc >1) && (strncmp(argv[1], "init", 4) == 0)) {
        fprintf(stderr, "init 5790\n" );
        init_DAC();

    } else {
        fprintf(stderr, "start without init  5790\n" );

    }



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
	return 0;
    }
    double setval;
    uint16_t dsetval;

    listen(sock, 5);
    while (1) {
        client_fd = accept(sock, (struct sockaddr *) &cli_addr, &sin_len);

//           printf("got connection\n");

        if (client_fd == -1) {
//            perror("Can't accept");
            continue;
        }

        timer = time(NULL);
        u = localtime(&timer);
        f = settime(u);
        printf("\n####################################\n %s",  f);
        rdlen = read(client_fd, answer, 2000);
                printf(" request: %s \n", answer);
        strstart = 0;
        strpos = 0;
        /*    nword = "";
         */
        getword();
        strcpy(metod, nword);
        getword();
        strcpy(uri, nword);
        getword();
        strcpy(protocol, nword);
        printf("metod='%s' uri='%s' protocol='%s'\n", metod, uri, protocol);
        memset(resp1, 0, 1100);
        strcpy(resp1, response);
        if (strncmp(uri, "/get", 4) == 0) {
            val = 123.876;
            sprintf(nword, "%f}", val);
            strcat(resp1, nword);
            printf("get=%s\n", nword);
        }

        if (strncmp(uri, "/setabs=", 7) == 0) {
            memset(nword, 0, 100);
            strncpy(nword, uri + 8, 20);
            strcat(resp1, nword);
            printf("setabs=%s\n", nword);
            long int  dsetval;
            dsetval=0;
            sscanf(nword,"%d",&dsetval);
            printf("setabs u = %d \n", dsetval);

//            double Vout = atof(argv[1]) - 1e-6;
//            printf("1 u =  \n");
//            long int DAC_code = 1048576.0*(Vout + VREFN) / (VREFP - VREFN);
//            printf("2 u = %d \n", DAC_code);
            long int DAC_code = dsetval;
            printf("3 dac code = %d \n", DAC_code);
            char msb[3] = {0};
            printf("4 u = %d \n", DAC_code);
            msb[0] = DAC_code / (256*256);
            msb[1] = (DAC_code - 256*256*msb[0])/256;
            msb[2] = (DAC_code - 256*256*msb[0] - 256*msb[1]);
            printf("5 u = %d \n", DAC_code);

            printf("msb = {%d %d %d}\n", msb[0], msb[1], msb[2]);

            set_V(msb);
        }

        write(client_fd, resp1, sizeof (resp1) - 1); /*-1:'\0'*/
        close(client_fd);
    }
}


