//
//  TwitterTrendsViewController.m
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
	[WMPerfLib setDelegate:self];
	
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

-(void)flushedResponseQueue:(NSString *)jsonString {
	
	NSLog(@"GOT DELEGATE CALL FROM WMPERFLIB");
	NSLog(@"JSON = %@", jsonString);
}

@end
