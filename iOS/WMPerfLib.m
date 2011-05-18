//
//  WMPerfLib.m
//  App Performance Library
//
//  Created by Alasdair Allan on 01/12/2010.
//  Copyright 2010 WatchMouse. All rights reserved.
//  This code is released under the MIT license.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "WMPerfLib.h"

@implementation WMPerfLib

static __weak id<WMPerfLibDelegate> _delegate;

@synthesize libraryDebug;
@synthesize libraryOff;
@synthesize waitForWiFi;

@synthesize queue;
@synthesize token;

WM_SYNTHESIZE_SINGLETON_FOR_CLASS(WMPerfLib);

- (id)init {
	
	if( (self = [super init]) ) {
		queue = [[WMResponseQueue alloc] init];
#ifdef WM_TOKEN
		self.token = WM_TOKEN;
#endif
	}
	return self;
}

- (void)dealloc {
    [super dealloc];
	[queue release];
	[token release];
	
}

- (void) status {
	
	if ( self.libraryDebug ) {
		NSLog( @"WMPerfLib Version %f", WM_VERSION );
		NSLog( @"  debug = %d, on = %d, wait = %d", 
			      self.libraryDebug, !self.libraryOff, self.waitForWiFi );
		NSLog( @"  developer token = %@", self.token );
	}
	
}

// http://cocoadevcentral.com/articles/000084.php
- (void)archiveQueue {
	
	if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
		NSLog(@"WMPerfLib: archiveQueue: Saving queue of %d items to Document Directory.", [self.queue sizeOfQueue]);

	}
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.queue];
    NSString *file = [[WMUtil documentsDirectoryPath] stringByAppendingPathComponent: @"queue.plist"]; 
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createFileAtPath:file contents:data attributes:nil];
	if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
		NSLog(@"WMPerfLib: archiveQueue: file = %@", file);
        
	}
	
}

- (void)restoreQueue {
 	
	if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
		NSLog(@"WMResponseQueue: restoreQueue: Restoring queue from Document Directory.");
	}   
    
    NSString *file = [[WMUtil documentsDirectoryPath] stringByAppendingPathComponent: @"queue.plist"]; 
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *data = [fileManager contentsAtPath:file];
    self.queue = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
		NSLog(@"WMResponseQueue: restoreQueue: Restored %d items to queue.", [self.queue sizeOfQueue]);
	} 
    
}



+ (id)delegate {
	
    return _delegate;
}

+ (void)setDelegate:(id)newDelegate {
	
    _delegate = newDelegate;	
}

@end
