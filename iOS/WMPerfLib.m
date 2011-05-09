//
//  WMPerfLib.m
//  App Performance Library
//
//  Created by Alasdair Allan on 01/12/2010.
//  Copyright 2010 Babilim Light Industries. All rights reserved.
//

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
	
	if( self = [super init] ) {
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

+ (id)delegate {
	
    return _delegate;
}

+ (void)setDelegate:(id)newDelegate {
	
    _delegate = newDelegate;	
}

@end
