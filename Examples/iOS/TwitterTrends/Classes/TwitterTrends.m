//
//  TwitterTrends.m
//  Weather
//
//  Created by Alasdair Allan on 30/08/2009.
//  Copyright (c) 2009, Babilim Light Industries. All rights reserved.
//  
//  Redistribution and use in source and binary forms, with or without modification, 
//  are permitted provided that the following conditions are met:
//  
//  Redistributions of source code must retain the above copyright notice, this list 
//  of conditions and the following disclaimer. Redistributions in binary form must 
//  reproduce the above copyright notice, this list of conditions and the following 
//  disclaimer in the documentation and/or other materials provided with the distribution.
//  
//  Neither the name of the Babilim Light Industries nor the names of its contributors 
//  may be used to endorse or promote products derived from this software without specific 
//  prior written permission.
//  
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY 
//  EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
//  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT 
//  SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, 
//  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED 
//  TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; 
//  OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN 
//  ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH 
//  DAMAGE.


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
