//
//  TwitterTrendsViewController.h
//  TwitterTrends
//
//  Created by Alasdair Allan on 07/09/2009.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMPerfLib.h"

@interface RootController : UIViewController <UITableViewDataSource, UITableViewDelegate, WMPerfLibDelegate> {
	UITableView *serviceView;
	NSMutableArray *names;
	NSMutableArray *urls;
	
}

@property (nonatomic, retain) IBOutlet UITableView *serviceView;

@property (nonatomic, retain) NSMutableArray *names;
@property (nonatomic, retain) NSMutableArray *urls;

@end

