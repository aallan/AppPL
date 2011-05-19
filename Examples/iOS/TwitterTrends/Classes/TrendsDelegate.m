//
//  TwitterTrendsAppDelegate.m
//  TwitterTrends
//
//  Created by Alasdair Allan on 07/09/2009.
//  Copyright (c) 2009, Babilim Light Industries. All rights reserved.
//  This code is released under the Modified BSD license.
//  
//  Redistribution and use in source and binary forms, with or without 
//  modification,  are permitted provided that the following conditions are met:
//  
//  Redistributions of source code must retain the above copyright notice, this 
//  list  of conditions and the following disclaimer. Redistributions in binary 
//  form must reproduce the above copyright notice, this list of conditions and 
//  the following disclaimer in the documentation and/or other materials provided
//  with the distribution.
//  
//  Neither the name of the Babilim Light Industries nor the names of its
//  contributors may be used to endorse or promote products derived from this
//  software without specific prior written permission.
//  
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE 
//  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "TrendsDelegate.h"
#import "RootController.h"

@implementation TrendsDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
	WMAppPL *performanceLibrary = [WMAppPL sharedWMAppPL];
	performanceLibrary.libraryDebug = YES;
	performanceLibrary.libraryOff = NO;
	performanceLibrary.waitForWiFi = YES;
	performanceLibrary.status;
    [[WMAppPL sharedWMAppPL] restoreQueue];
	
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
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




- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
