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


-(id)init {
    self = [super init];
    return self;
}

-(void) start :(char *)addr :(int)port {
    NSLog(@"receiveThread start entry");
    running =  false;
    stopThread = false;
    ipaddr = addr;
    port =  port;
    
    thread = [[NSThread alloc] initWithTarget:self selector:@selector(rxThread:)  object:nil];
    [thread start];
    sleep(2);
    // wait for thread to complete
    while (running == true) {
        sleep(1);
    }
    NSLog(@"receiveThread start exit");
}

-(void) stop {
    stopThread = true;
}

-(void) rxThread:(id) param {
    NSLog(@"receiveThread rxThread entry");
    running = true;
    void * buffer;
    int length;
    
    //int sk = [self createSocket];
    int sk = [self sendRequest:ipaddr];
    [self setSocketTimeout:sk];
    
    if (sk >=0) {
    
        while ( ! stopThread) {
            [self receivePacket :sk :&buffer :&length];
            if (length > 0) {
                char * datastart = strstr(buffer, "<LogLine>");
                datastart += 9;
                char * dataend = strstr(buffer, "</LogLine>");
                *dataend = 0;
                NSLog(@"%s", datastart);
            }
        }
    
        close(sk);
    }
    
    running = false;
    NSLog(@"receiveThread rxThread exit");
}

-(void) setSocketTimeout:(int)sk {
    // set timeout to 2 seconds.
    struct timeval timeV;
    timeV.tv_sec = 2;
    timeV.tv_usec = 0;
    
    if (setsockopt(sk, SOL_SOCKET, SO_RCVTIMEO, &timeV, sizeof(timeV)) == -1) {
        NSLog(@"receiveThread createSocket - setsockopt failed %s", strerror(errno));
    }

}


-(void) receivePacket :(int)sk :(void **) oBuffer :(int*) oLength {
    
    // receive
    struct sockaddr_in receiveSockaddr;
    socklen_t receiveSockaddrLen = 0;
    memset(&receiveSockaddr, 0, sizeof(struct sockaddr_in));
    
    *oBuffer = nil;
    *oLength = 0;
    
    size_t bufSize = 1024*100;
    void *buf = malloc(bufSize);
    ssize_t result = recvfrom(sk, buf, bufSize, 0, (struct sockaddr *)&receiveSockaddr, &receiveSockaddrLen);

    if (result > 0) {
        *oBuffer = buf;
        *oLength = (int) result;
    } else {
        if (result < 0) {
            NSLog(@"receiveThread receivePacket recvfrom failed %d %s",errno, strerror(errno));
        }
        free(buf);
        stopThread = true;
    }
    
    return;
}

-(int) sendRequest :(char *) sendAddr {
    NSLog(@"receiveThread sendReqest entry");
    int sd = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
    if (sd <=0) {
        NSLog(@"sendReqest socket open error exit %s", strerror(errno));
        return -1;
    }
    
    struct sockaddr_in addr;
    memset(&addr, 0, sizeof addr);
    addr.sin_family = AF_INET;
    inet_pton(AF_INET, (char *) sendAddr, &addr.sin_addr);
    addr.sin_port = htons(8087);
    
    char * buffer = "<LogDebug    Version=\"1.0\"><LogType>system</LogType><LogMethod>start</LogMethod></LogDebug>";
    int ret = (int) sendto(sd, buffer, strlen(buffer), 0 , (struct sockaddr *) &addr, sizeof addr);
    if (ret <= 0) {
        NSLog(@"receiveThread sendReqest sendto error exit %s", strerror(errno));
    }
    
    return sd;
}

@end
