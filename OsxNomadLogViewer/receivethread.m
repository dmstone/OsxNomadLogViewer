//
//  receivethread.m
//  OsxNomadLogViewer
//
//  Created by Doug Stone on 6/1/19.
//  Copyright © 2019 Doug Stone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "receivethread.h"

@implementation receiveThread

// these are globals
bool receivethread_running = false;
bool receivethread_stopThread = false;
NSThread * receivethread_Thread;

+(void) start {
    NSLog(@"start entry");
    receivethread_running =  false;
    receivethread_stopThread = false;
    
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
    
    while ( ! receivethread_stopThread) {
        sleep(1);
    }
    NSLog(@"rxThread exit");
}

@end
