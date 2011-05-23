//
//  WMResponseQueue.m
//  App Performance Library
//
//  Created by Alasdair Allan on 06/12/2010.
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


@implementation WMResponseQueue

@synthesize queue;

- (id)init {
	
	if( (self = [super init]) ) {
		queue = [[NSMutableArray alloc] init];        
	}
	return self;
}

- (void)dealloc {
    [super dealloc];
	[queue release];
}

- (void)addResponse:(WMResponse *)response {

    if ( [WMAppPL sharedWMAppPL].libraryDebug ) {
		NSLog(@"WMResponseQueue: addResponse: Adding response to queue");
	}
    if ( response.waitForNextFlush == YES ) {
        response.waitForNextFlush = NO;
        
        // If we've just re-added a failed response to the queue, wait for next time
        // before attempting to flush it to the acceptor. Hopefully stop runaway loops.
        if ( [WMAppPL sharedWMAppPL].libraryDebug ) {
            NSLog(@"WMResponseQueue: addResponse: Queued response for future delivery");
            
        }
        
        // Add the passed response to the queue
        [self.queue addObject:response];
        if ( [WMAppPL sharedWMAppPL].libraryDebug ) {
            NSLog(@"WMResponseQueue: addResponse: Items in queue = %d", [self.queue count]);
            
        }
        return;
    }
    
    // Add the passed response to the queue
	[self.queue addObject:response];       
              
	if ( [WMAppPL sharedWMAppPL].libraryDebug ) {
		NSLog(@"WMResponseQueue: addResponse: Attempting to flush response to acceptor");
	}
	
	if ( [WMAppPL sharedWMAppPL].waitForWiFi ) {

		if ( [WMAppPL sharedWMAppPL].libraryDebug ) {
			NSLog(@"WMResponseQueue: addResponse: waitForWiFi = %d", 
				  [WMAppPL sharedWMAppPL].waitForWiFi );
		}
		
		if ( [[WMUtil connectionType] isEqualToString:@"wifi"] ) {
			WMDispatch *dispatch = [[[WMDispatch alloc] init] autorelease];
			[dispatch dispatchResponseQueue:self];		
			if ( [WMAppPL sharedWMAppPL].libraryDebug ) {
				NSLog(@"WMResponseQueue: addResponse: Flushed response to acceptor"); 
			}	  
		} else {
			if ( [WMAppPL sharedWMAppPL].libraryDebug ) {
				NSLog(@"WMResponseQueue: addResponse: Queued response for future delivery"); 
                NSLog(@"WMResponseQueue: addResponse: Items in queue = %d", [self.queue count]);
			}	 			
		}
	} else {
		if ( [WMAppPL sharedWMAppPL].libraryDebug ) {
			NSLog(@"WMResponseQueue: addResponse: waitForWiFi = %d, ctype = %@", 
				  [WMAppPL sharedWMAppPL].waitForWiFi,[WMUtil connectionType]);
		}	
		if ([[WMUtil connectionType] isEqualToString:@"wifi"] ||
			[[WMUtil connectionType] isEqualToString:@"wwan"] ) {
			WMDispatch *dispatch = [[[WMDispatch alloc] init] autorelease];
			[dispatch dispatchResponseQueue:self];			
			if ( [WMAppPL sharedWMAppPL].libraryDebug ) {
				NSLog(@"WMResponseQueue: addResponse: Flushed response to acceptor"); 
			}	  
		} else {
			if ( [WMAppPL sharedWMAppPL].libraryDebug ) {
				NSLog(@"WMResponseQueue: addResponse: No Internet connection. Queued."); 
			}	  
			
		}

	}
		
}

- (void)removeResponse:(WMResponse *)response {
	[self.queue removeObject:response];
}

// returns a retained object
- (WMResponse *)popResponse {
	
	WMResponse *response = nil;
	if( self.queue.count >= 1 ) {
		response = 	(WMResponse *)[self.queue objectAtIndex:0];
        [response retain];
		[self.queue removeObjectAtIndex:0];
	}
    return response;
	
}

- (int)sizeOfQueue {
	return [self.queue count];
	
}

#pragma mark NSCoding


- (id)initWithCoder:(NSCoder *)decoder {
	if ((self = [super init])) {
        self.queue = [decoder decodeObjectForKey:@"queue"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.queue forKey:@"queue"];   
}


@end
