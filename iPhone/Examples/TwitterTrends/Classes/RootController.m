//
//  TwitterTrendsViewController.m
//  TwitterTrends
//
//  Created by Alasdair Allan on 07/09/2009.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "RootController.h"
#import "WebViewController.h"
#import "TwitterTrends.h"

@implementation RootController

@synthesize serviceView;

@synthesize names;
@synthesize urls;

- (void)viewDidLoad {
	names = [[NSMutableArray alloc] init];
	urls = [[NSMutableArray alloc] init];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	TwitterTrends *trends = [[TwitterTrends alloc] init];
	[trends queryServiceWithParent:self];
	
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; 
}


- (void)dealloc {
	[names dealloc];
	[urls dealloc];
    [super dealloc];
}

#pragma mark Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return names.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    
	cell.textLabel.text = [names objectAtIndex:indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {		
	NSString *title = [names objectAtIndex:indexPath.row];
	NSURL *url = [NSURL URLWithString:[urls objectAtIndex:indexPath.row]];
	WebViewController *webViewController = [[WebViewController alloc] initWithURL:url andTitle:title];
	[self presentModalViewController:webViewController animated:YES];
	[webViewController release]; 
	
	[tv deselectRowAtIndexPath:indexPath animated:YES];
	
}

@end
