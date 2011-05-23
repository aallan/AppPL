//
//  main.m
//  WebTest
//
//  Created by Alasdair Allan on 23/05/2011.
//  Copyright 2011 University of Exeter. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[])
{
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *log = [[paths objectAtIndex:0] stringByAppendingPathComponent: @"ns.log"];
	freopen([log fileSystemRepresentation], "a", stderr);
    
    int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
    return retVal;
}
