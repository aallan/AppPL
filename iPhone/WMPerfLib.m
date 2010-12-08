//
//  WMPerfLib.m
//  App Performance Library
//
//  Created by Alasdair Allan on 01/12/2010.
//  Copyright 2010 Babilim Light Industries. All rights reserved.
//

#import "WMPerfLib.h"

@implementation WMPerfLib

@synthesize queue;
@synthesize token;

WM_SYNTHESIZE_SINGLETON_FOR_CLASS(WMPerfLib);

- (id)init {
	
	if( self = [super init] ) {
		queue = [[WMResponseQueue alloc] init];
	}
	return self;
}

- (void)dealloc {
    [super dealloc];
	[queue release];
	[token release];
	
}

@end
