//
//  WMAppPL.m
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

#import "WMAppPL.h"

@implementation WMAppPL

static __weak id<WMAppPLDelegate> _delegate;

@synthesize libraryDebug;
@synthesize libraryOff;
@synthesize waitForWiFi;

@synthesize queue;
@synthesize token;

WM_SYNTHESIZE_SINGLETON_FOR_CLASS(WMAppPL);

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
		NSLog( @"WMAppPL: status:");
        NSLog( @"  version = %@", WM_VERSION );
		NSLog( @"  on = %d", !self.libraryOff );
		NSLog( @"  debug = %d", self.libraryDebug );
		NSLog( @"  wait = %d", self.waitForWiFi );
		NSLog( @"  token = %@", self.token );
	}
	
}

// http://cocoadevcentral.com/articles/000084.php
- (void)archiveQueue {
	
	if ( self.libraryDebug ) {
		NSLog(@"WMAppPL: archiveQueue: Saving queue of %d items to Document Directory.", [self.queue sizeOfQueue]);

	}
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.queue];
    NSString *file = [[WMUtil documentsDirectoryPath] stringByAppendingPathComponent: @"queue.plist"]; 
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createFileAtPath:file contents:data attributes:nil];
	if ( self.libraryDebug ) {
		NSLog(@"WMAppPL: archiveQueue: file = %@", file);
        
	}
	
}

- (void)restoreQueue {
 	
	if ( self.libraryDebug ) {
		NSLog(@"WMAppPL: restoreQueue: Restoring queue from Document Directory.");
	}   
    
    NSString *file = [[WMUtil documentsDirectoryPath] stringByAppendingPathComponent: @"queue.plist"]; 
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *data = [fileManager contentsAtPath:file];
    if ( [data length] > 0 ) {
        self.queue = nil;
        self.queue = (WMResponseQueue *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ( self.libraryDebug ) {
            NSLog(@"WMAppPL: restoreQueue: Restored %d items to queue.", [self.queue sizeOfQueue]);
        } 
    } else {
        if ( self.libraryDebug ) {
            NSLog(@"WMAppPL: restoreQueue: No queue to restore.");
        }        
    }

    
}

- (void)flushQueue {
	if ( self.libraryDebug ) {
		NSLog(@"WMAppPL: flushQueue: Flushing response queue to acceptor");
	}
	WMDispatch *dispatch = [[[WMDispatch alloc] init] autorelease];
	[dispatch dispatchResponseQueue:self.queue];	
	
}

+ (id)delegate {
	
    return _delegate;
}

+ (void)setDelegate:(id)newDelegate {
	
    _delegate = newDelegate;	
}

@end
