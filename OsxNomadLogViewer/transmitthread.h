//
//  transmitthread.h
//  OsxNomadLogViewer
//
//  Created by Doug Stone on 6/1/19.
//  Copyright © 2019 Doug Stone. All rights reserved.
//

#ifndef transmitthread_h
#define transmitthread_h

@interface transmitThread : NSObject {
}

+(void) start;
+(void) stop;
+(void) txThread :(id)param;
+(void) send :(int)cmd :(char *)addr :(int)port;
+(void) sendRequest: (char *)sendAddr;

@end

#endif /* transmitthread_h */
