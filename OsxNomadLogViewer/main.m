//
//  main.m
//  OsxNomadLogViewer
//
//  Created by Doug Stone on 5/27/19.
//  Copyright © 2019 Doug Stone. All rights reserved.
//
// Build:
// gcc -framework Foundation main.m -o test1

#import <Foundation/Foundation.h>
#import "receivethread.h"
#import "transmitthread.h"


const char * ipAddress;
NSThread* receiveThreadNs;

void parseCmdLine(int argc, const char * argv[]);

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        parseCmdLine(argc, argv);
        [receiveThread start];
        [transmitThread start];
        
        [transmitThread send:0 :"192.168.1.4"];
        
        [transmitThread stop];
        [transmitThread stop];
    }
    return 0;
}

void parseCmdLine(int argc, const char * argv[]) {
    for (int x=0; x<argc; x++) {
        NSLog(@"Arg %d %s\n", x, argv[x]);
        
        const char * str = argv[x];
        
        switch(str[0]) {
            case '-':
                if (strlen(str) >= 2) {
                    switch (str[1]) {
                        case 'a':
                            x++;
                            if (x < argc) {
                                ipAddress = argv[x];
                                NSLog(@"ipaddress = %s\n", ipAddress);
                            }
                            break;
                    };
                }
                break;
        };
    }
}



