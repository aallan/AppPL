//
//  WMDispatch.m
//  AppPerfLib
//
//  Created by Alasdair Allan on 09/12/2010.
//  Copyright 2010 University of Exeter. All rights reserved.
//

#import "WMPerfLib.h"


@implementation WMDispatch

#pragma mark -
#pragma mark Dispatch Method

- (void)dispatchResponse:(WMResponse *)response {

#ifdef WM_DEBUG
	NSLog(@"WMDispatch: dispatchResponse()");
#endif
	analytics = response;

#ifdef WM_DEBUG	
	NSLog(@"Grabbed response object: %@", analytics);
#endif
	
	//NSString* escapedUrlString = [unescapedString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
}

#pragma mark -
#pragma mark NSURLConnection Delegate Methods

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
#ifdef WM_DEBUG
	NSLog(@"WMDispatch: Error");
#endif 
	
	// Re-add the response to the queue
	WMPerfLib *singleton = [WMPerfLib sharedWMPerfLib];
	[singleton.queue addResponse:analytics];
}

- (void)connectionDidFinishLoading:(WMURLConnection *)connection {
	
	//NSString *content = [[NSString alloc] initWithBytes:[responseData bytes] length:[responseData length] encoding:NSUTF8StringEncoding];
	
#ifdef WM_DEBUG
    NSLog(@"WMDispatch: Done");
#endif
}

- (void)dealloc {
    [super dealloc];
	[analytics release];
	[responseData release];
	[theURL release];
}



@end
