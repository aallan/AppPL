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
		NSLog(@"WMResponseQueue: addResponse: Flushing response to acceptor");
	}
	WMDispatch *dispatch = [[[WMDispatch alloc] init] autorelease];
	[dispatch dispatchResponse:self];
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



@end
