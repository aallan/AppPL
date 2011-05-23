//
//  WebTestAppDelegate.m
//  WebTest
//
//  Created by Alasdair Allan on 23/05/2011.
//  Copyright 2011 WatchMouse. All rights reserved.
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

#import "WebTestAppDelegate.h"
#import "WebTestViewController.h"

@implementation WebTestAppDelegate

@synthesize window=_window;
@synthesize viewController=_viewController;


+ (void)initialize{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObject:@"NO" forKey:@"disabled_preference"];
    [defaults registerDefaults:appDefaults];
    [defaults synchronize];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	WMAppPL *performanceLibrary = [WMAppPL sharedWMAppPL];
	performanceLibrary.libraryDebug = YES;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
    BOOL disabled = [defaults boolForKey:@"disabled_preference"]; 
    NSLog(@"WebTestDelegate: application:didFinishLaunchingWithOptions: AppPL disabled in preferences = %d", disabled);
	performanceLibrary.libraryOff = disabled;
    
	performanceLibrary.waitForWiFi = YES;
	[performanceLibrary status];
    [[WMAppPL sharedWMAppPL] restoreQueue];
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /* Sent when the application is about to move from active to inactive state. */
    NSLog(@"WebTestDelegate: applicationWillResignActive:");
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /* Use this method to release shared resources */
    NSLog(@"WebTestDelegate: applicationDidEnterBackground:");
    [[WMAppPL sharedWMAppPL] archiveQueue];
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /* Called as part of  transition from the background to the inactive state */
    NSLog(@"WebTestDelegate: applicationWillEnterForeground:");
    [[WMAppPL sharedWMAppPL] restoreQueue];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
    [defaults synchronize];
    BOOL disabled = [defaults boolForKey:@"disabled_preference"]; 
    NSLog(@"WebTestDelegate: applicationWillEnterForeground: AppPL disabled in preferences = %d", disabled);
	[WMAppPL sharedWMAppPL].libraryOff = disabled;
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /* Restart any tasks that were paused (or not yet started) while the application was inactive. */
    NSLog(@"WebTestDelegate: applicationDidBecomeActive:");
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /* Called when the application is about to terminate. */
    NSLog(@"WebTestDelegate: applicationWillTerminate:");
    [[WMAppPL sharedWMAppPL] archiveQueue];
}



- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

@end
