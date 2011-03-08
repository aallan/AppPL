//
//  WMResponseQueue.m
//  App Performance Library
//
//  Created by Alasdair Allan on 06/12/2010.
//  Copyright 2010 Babilim Light Industries. All rights reserved.
//

#import "WMPerfLib.h"


@implementation WMResponseQueue

@synthesize queue;

- (id)init {
	
	if( self = [super init] ) {
		queue = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)dealloc {
    [super dealloc];
	[queue release];
}

- (void)addResponse:(WMResponse *)response {
	if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
		//NSLog(@"WMResponseQueue: addResponse: Adding response to queue: %@", response);
		NSLog(@"WMResponseQueue: addResponse: Adding response to queue");
	}
	[self.queue addObject:response];

	if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
		NSLog(@"WMResponseQueue: addResponse: Attempting to flush response to acceptor");
	}
	
	if ( [WMPerfLib sharedWMPerfLib].waitForWiFi ) {

		if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
			NSLog(@"WMResponseQueue: addResponse: waitForWiFi = %d", 
				  [WMPerfLib sharedWMPerfLib].waitForWiFi );
		}
		
		if ( [[WMUtil connectionType] isEqualToString:@"wifi"] ) {
			WMDispatch *dispatch = [[[WMDispatch alloc] init] autorelease];
			[dispatch dispatchResponseQueue:self];		
			if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
				NSLog(@"WMResponseQueue: addResponse: Flushed response to acceptor"); 
			}	  
		} else {
			if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
				NSLog(@"WMResponseQueue: addResponse: Queued response for future delivery"); 
			}	 			
		}
	} else {
		if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
			NSLog(@"WMResponseQueue: addResponse: waitForWiFi = %d, ctype = %@", 
				  [WMPerfLib sharedWMPerfLib].waitForWiFi,[WMUtil connectionType]);
		}	
		if ([[WMUtil connectionType] isEqualToString:@"wifi"] ||
			[[WMUtil connectionType] isEqualToString:@"wwan"] ) {
			WMDispatch *dispatch = [[[WMDispatch alloc] init] autorelease];
			[dispatch dispatchResponseQueue:self];			
			if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
				NSLog(@"WMResponseQueue: addResponse: Flushed response to acceptor"); 
			}	  
		} else {
			if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
				NSLog(@"WMResponseQueue: addResponse: No Internet connection. Queued."); 
			}	  
			
		}

	}
		
}

- (void)flushQueue {
	if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
		NSLog(@"WMResponseQueue: flushQueue: Flushing response queue to acceptor");
	}
	WMDispatch *dispatch = [[[WMDispatch alloc] init] autorelease];
	[dispatch dispatchResponseQueue:self];	
	
}

- (void)removeResponse:(WMResponse *)response {
	[self.queue removeObject:response];
}

- (WMResponse *)popResponse {
	
	WMResponse *response = nil;
	if( self.queue.count >= 1 ) {
		response = 	[self.queue objectAtIndex:0];
		[self.queue removeObjectAtIndex:0];
	}
    return response;
	
}

- (int)sizeOfQueue {
	return [self.queue count];
	
}

@end
