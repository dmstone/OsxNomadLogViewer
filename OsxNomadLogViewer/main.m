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

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        const char * ipAddress;
        
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
    return 0;
}
