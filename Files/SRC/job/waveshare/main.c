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

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <err.h>
int strstart = 0;
char answer[2048];
char *pansw;
char nword[100],metod[100],protocol[100],uri[100];
int strpos;
char resp1[2048];
char response[100] = "HTTP/1.1 200 OK\r\n"
        "Content-Type: text/html; charset=UTF-8\r\n\r\n"
        "{ADC:";
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
    printf("\n###pos startpos %d \n", strpos);
    while (*(answer + strpos) != ' ') {
        
        //             && ((answer + strpos) != "\r\n")
        printf("%c",*(answer+strpos));
        strpos++;
    };
    memset(nword,0,100);
    
    strncpy(nword, answer + strstart, strpos - strstart);
    printf("\n ###pos after %d \"%s\"\n", strpos,nword);
    strpos++;
    ;

}

int main(int argc, char** argv) {
    int one = 1, client_fd;
    int rdlen;
    struct sockaddr_in svr_addr, cli_addr;
    socklen_t sin_len = sizeof (cli_addr);

    int sock = socket(AF_INET, SOCK_STREAM, 0);
    if (sock < 0)
        err(1, "can't open socket");

    setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, &one, sizeof (int));

    int port = 8282;
    svr_addr.sin_family = AF_INET;
    svr_addr.sin_addr.s_addr = INADDR_ANY;
    svr_addr.sin_port = htons(port);

    if (bind(sock, (struct sockaddr *) &svr_addr, sizeof (svr_addr)) == -1) {
        close(sock);
        err(1, "Can't bind");
    }

    listen(sock, 5);
    while (1) {
        client_fd = accept(sock, (struct sockaddr *) &cli_addr, &sin_len);
        printf("got connection\n");

        if (client_fd == -1) {
            perror("Can't accept");
            continue;
        }

        printf("got connection\n");
        rdlen = read(client_fd, answer, 2000);
        printf("answer %s \n", answer);
        strstart = 0;
        strpos = 0;
        /*    nword = "";
         */
        getword();
        strcpy(metod,nword);
        getword();
        strcpy(uri,nword);
        getword();
        strcpy(protocol,nword);
        printf("metod=%s uri=%s protocol=%s",metod,uri,protocol);
        double val = 123.876;
        sprintf(nword,"%f}",val);
        strcat(response,nword);
        write(client_fd, response, sizeof (response) - 1); /*-1:'\0'*/
        close(client_fd);
    }
}


