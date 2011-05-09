//
//  TwitterTrendsAppDelegate.h
//  TwitterTrends
//
//  Created by Alasdair Allan on 07/09/2009.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootController;

@interface TrendsDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    RootController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet RootController *viewController;

@end

