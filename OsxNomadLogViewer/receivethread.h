//
//  receivethread.h
//  OsxNomadLogViewer
//
//  Created by Doug Stone on 6/1/19.
//  Copyright © 2019 Doug Stone. All rights reserved.
//

#ifndef receivethread_h
#define receivethread_h


@interface receiveThread : NSObject {
    bool running;
    bool stopThread;
    NSThread * thread;
    char * ipaddr;
    int port;

}

-(void) start:(char *)addr :(int)port;
-(void) stop;
-(void) rxThread:(id)param;
-(void) receivePacket :(int)sk  :(void **) oBuffer :(int *) oLength;

@end

#endif /* receivethread_h */
