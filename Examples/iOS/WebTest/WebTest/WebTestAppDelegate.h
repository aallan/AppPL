//
//  WebTestAppDelegate.h
//  WebTest
//
//  Created by Alasdair Allan on 23/05/2011.
//  Copyright 2011 University of Exeter. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WebTestViewController;

@interface WebTestAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet WebTestViewController *viewController;

@end
