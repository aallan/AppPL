//
//  TwitterTrendsAppDelegate.m
//  TwitterTrends
//
//  Created by Alasdair Allan on 07/09/2009.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "TrendsDelegate.h"
#import "RootController.h"

@implementation TrendsDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
	
	[WMPerfLib sharedWMPerfLib].libraryDebug = YES;
	[WMPerfLib sharedWMPerfLib].libraryOff = NO;
	[WMPerfLib sharedWMPerfLib].waitForWiFi = YES;
	[WMPerfLib sharedWMPerfLib].status;
	
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
