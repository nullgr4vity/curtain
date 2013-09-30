//
//  main.m
//  curtain
//
//  Created by 0xc01df00d on 10-06-13.
//  Copyright NullGravity 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
    
	NSLog(@"application start");
	
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
    return retVal;
}
