//
//  TwitterTrends.h
//  Weather
//
//  Created by Alasdair Allan on 30/08/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RootController;

@interface TwitterTrends : NSObject {

	// Parent View Controller
	RootController *viewController;
	
	// Twitter Trends
	NSMutableData *responseData;
	NSURL *theURL;
	
	
}

- (void)queryServiceWithParent:(UIViewController *)controller;

@end
