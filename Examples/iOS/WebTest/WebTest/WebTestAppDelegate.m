//
//  WebTestAppDelegate.m
//  WebTest
//
//  Created by Alasdair Allan on 23/05/2011.
//  Copyright 2011 University of Exeter. All rights reserved.
//

#import "WebTestAppDelegate.h"
#import "WebTestViewController.h"

@implementation WebTestAppDelegate

@synthesize window=_window;

@synthesize viewController=_viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	WMAppPL *performanceLibrary = [WMAppPL sharedWMAppPL];
	performanceLibrary.libraryDebug = YES;
	performanceLibrary.libraryOff = NO;
	performanceLibrary.waitForWiFi = YES;
	[performanceLibrary status];
    [[WMAppPL sharedWMAppPL] restoreQueue];
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /* Sent when the application is about to move from active to inactive state. */
    NSLog(@"TrendsDelegate: applicationWillResignActive:");
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /* Use this method to release shared resources */
    NSLog(@"TrendsDelegate: applicationDidEnterBackground:");
    [[WMAppPL sharedWMAppPL] archiveQueue];
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /* Called as part of  transition from the background to the inactive state */
    NSLog(@"TrendsDelegate: applicationWillEnterForeground:");
    [[WMAppPL sharedWMAppPL] restoreQueue];
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /* Restart any tasks that were paused (or not yet started) while the application was inactive. */
    NSLog(@"TrendsDelegate: applicationDidBecomeActive:");
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /* Called when the application is about to terminate. */
    NSLog(@"TrendsDelegate: applicationWillTerminate:");
    [[WMAppPL sharedWMAppPL] archiveQueue];
}



- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

@end
