//
//  transmitthread.m
//  OsxNomadLogViewer
//
//  Created by Doug Stone on 6/1/19.
//  Copyright © 2019 Doug Stone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "transmitthread.h"

#include <netinet/in.h>
#include <sys/socket.h>
#include <unistd.h>
#include <arpa/inet.h>

@implementation transmitThread

bool transmitthread_running = false;
bool transmitthread_stopThread = false;
int transmitthread_cmd = -1;;
char * transmitthread_ipaddr;
int transmitthread_port;

NSThread * transmitthread_Thread;

+(void) start {
    NSLog(@"start entry");
    transmitthread_running =  false;
    transmitthread_stopThread = false;
    transmitthread_Thread = [[NSThread alloc] initWithTarget:self selector:@selector(txThread:)  object:nil];
    [transmitthread_Thread start];
    while (transmitthread_running == false) {
        sleep(1);
    }
    NSLog(@"start exit");
}

+(void) stop {
    transmitthread_stopThread = true;
    while (transmitthread_running) {
        sleep(1);
    }
}

+(void) send :(int)cmd :(char *)addr :(int)port {
    transmitthread_ipaddr = addr;
    transmitthread_cmd = cmd;
    transmitthread_port=port;
    while (transmitthread_cmd != -1) {
        sleep(1);
    }
}

+(void) txThread :(id)param {
    NSLog(@"txThread entry");
    transmitthread_running = true;
    
    while ( ! transmitthread_stopThread) {
        sleep(1);
        
        switch(transmitthread_cmd) {
            case 0:
            [self sendRequest:transmitthread_ipaddr];
            transmitthread_cmd = -1;
            break;
                
            case 1:
            transmitthread_cmd = -1;
            break;
        }
        
    }
    transmitthread_running = false;
    NSLog(@"txThread exit");
}

+(void) sendRequest :(char *) sendAddr {
    NSLog(@"sendReqest entry");
    int sd = socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP);
    if (sd <=0) {
        NSLog(@"sendReqest socket open error exit %s", strerror(errno));
        return;
    }
    
    struct sockaddr_in addr;
    memset(&addr, 0, sizeof addr);
    inet_pton(AF_INET, (char *) sendAddr, &addr.sin_addr);
    addr.sin_port = htons(transmitthread_port);
    
    char * buffer = "crossmatc ";
    int ret = (int) sendto(sd, buffer, strlen(buffer), 0 , (struct sockaddr *) &addr, sizeof addr);
    if (ret <= 0) {
        NSLog(@"sendReqest sendto error exit %s", strerror(errno));
    }
    close(sd);
}
@end
