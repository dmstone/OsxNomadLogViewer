//
//  receivethread.m
//  OsxNomadLogViewer
//
//  Created by Doug Stone on 6/1/19.
//  Copyright © 2019 Doug Stone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "receivethread.h"

#include <netinet/in.h>
#include <sys/socket.h>
#include <unistd.h>
#include <arpa/inet.h>

@implementation receiveThread

// these are globals
bool receivethread_running = false;
bool receivethread_stopThread = false;
NSThread * receivethread_Thread;
char * receivethread_ipaddr;
int receivethread_port;

+(void) start :(char *)addr :(int)port {
    NSLog(@"start entry");
    receivethread_running =  false;
    receivethread_stopThread = false;
    receivethread_ipaddr = addr;
    receivethread_port =  port;
    
    receivethread_Thread = [[NSThread alloc] initWithTarget:self selector:@selector(rxThread:)  object:nil];
    [receivethread_Thread start];
    while (receivethread_running == false) {
        sleep(1);
    }
    NSLog(@"start exit");
}

+(void) stop {
    receivethread_stopThread = true;
}

+(void) rxThread:(id) param {
    NSLog(@"rxThread entry");
    receivethread_running = true;
    void * buffer;
    int length;
    
    while ( ! receivethread_stopThread) {
        [self receivePacket:receivethread_ipaddr :&buffer :&length];
        sleep(1);
    }
    NSLog(@"rxThread exit");
}

+(void) receivePacket :(char *) sendAddr :(void **) oBuffer :(int*) oLength {
    int sk = socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP);
    
    if (sk <= 0 ) {
        NSLog(@"receivePacket socket failed %s", strerror(errno));
        return;
    }
    
    // set timeout to 2 seconds.
    struct timeval timeV;
    timeV.tv_sec = 2;
    timeV.tv_usec = 0;
    
    if (setsockopt(sk, SOL_SOCKET, SO_RCVTIMEO, &timeV, sizeof(timeV)) == -1) {
        NSLog(@"Error: listenForPackets - setsockopt failed");
        close(sk);
        return;
    }
    
    // bind the port
    struct sockaddr_in sockaddr;
    memset(&sockaddr, 0, sizeof(sockaddr));
    
    sockaddr.sin_len = sizeof(sockaddr);
    sockaddr.sin_family = AF_INET;
    sockaddr.sin_port = htons(8087);
    inet_pton(AF_INET, sendAddr, &sockaddr.sin_addr);
    
    int status = bind(sk, (struct sockaddr *)&sockaddr, sizeof(sockaddr));
    if (status == -1) {
        close(sk);
        NSLog(@"Error: receivePacket - bind() failed. %s", strerror(errno));
        return;
    }
    
    // receive
    struct sockaddr_in receiveSockaddr;
    socklen_t receiveSockaddrLen = sizeof(receiveSockaddr);
    
    size_t bufSize = 9216;
    void *buf = malloc(bufSize);
    ssize_t result = recvfrom(sk, buf, bufSize, 0, (struct sockaddr *)&receiveSockaddr, &receiveSockaddrLen);

    if (result > 0) {
        NSLog(@"receivePacket received %zd bytes", result);
        *oBuffer = buf;
        *oLength = (int) result;
    } else {
        free(buf);
    }
    
    return;
}

@end
