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

bool running = false;
+(void) start {
    NSLog(@"start entry");
    running =  false;
    rxThread = [[NSThread alloc] initWithTarget:self selector:@selector(rxThread:)  object:nil];
    [rxThread start];
    while (running == false) {
        sleep(1);
    }
    NSLog(@"start exit");
}

+(void) stop {
    
}

+(void) rxThread:(id) param {
    NSLog(@"rxThread entry");
    running = true;
}

@end
