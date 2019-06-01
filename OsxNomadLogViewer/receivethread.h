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
}

+(void) start;
+(void) stop;
+(void) rxThread:(id)param;

@end

#endif /* receivethread_h */
