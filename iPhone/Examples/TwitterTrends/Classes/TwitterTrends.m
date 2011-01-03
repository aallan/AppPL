//
//  TwitterTrends.m
//  Weather
//
//  Created by Alasdair Allan on 30/08/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TwitterTrends.h"
#import "RootController.h"
#import "JSON/JSON.h"

@implementation TwitterTrends


- (void)queryServiceWithParent:(UIViewController *)controller {
	viewController = (RootController *)controller;
	responseData = [[NSMutableData data] retain];
	
	NSString *url = [NSString stringWithFormat:@"http://search.twitter.com/trends.json"];	
	theURL = [[NSURL URLWithString:url] retain];
	NSURLRequest *request = [NSURLRequest requestWithURL:theURL];
	[[WMURLConnection alloc] initWithRequest:request delegate:self];
	
}


- (NSURLRequest *)connection:(WMURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse {
	[theURL autorelease];
	theURL = [[request URL] retain];
	return request;
}

- (void)connection:(WMURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}
	 
- (void)connection:(WMURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}
	 
- (void)connection:(WMURLConnection *)connection didFailWithError:(NSError *)error {
	// Handle Error
}
	 
- (void)connectionDidFinishLoading:(WMURLConnection *)connection {
	
	NSString *content = [[NSString alloc] initWithBytes:[responseData bytes] length:[responseData length] encoding:NSUTF8StringEncoding];
	
	SBJSON *parser = [[SBJSON alloc] init];
	NSDictionary *json = [parser objectWithString:content];
	NSArray *trends = [json objectForKey:@"trends"];
	
	
	for (NSDictionary *trend in trends) {
		[viewController.names addObject:[trend objectForKey:@"name"]];
		[viewController.urls addObject:[trend objectForKey:@"url"]];
	}
	[parser release];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[viewController.serviceView reloadData];
	
}

-(void)dealloc {
	[viewController release];
	[responseData release];
	[theURL release];
	[super dealloc];
}

@end
