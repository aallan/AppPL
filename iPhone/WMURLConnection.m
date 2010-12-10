//
//  WMURLConnection.m
//  App Performance Library
//
//  Created by Alasdair Allan on 05/11/2010.
//  Copyright 2010 Babilim Light Industries. All rights reserved.
//

#import "WMPerfLib.h"

@implementation WMURLConnection

#pragma mark Initialisation Wrappers

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate {
	
	analytics = [[WMResponse alloc] init];
	analytics.initRequest = CFAbsoluteTimeGetCurrent(); 
	analytics.url = request.URL;
	
	if( self = [super initWithRequest:request delegate:self] ) {
		NSLog(@"Starting magic");
		[delegate retain];
		[_myDelegate release];
		_myDelegate = delegate;	
		firstData = YES;
	}
	return self;
}

#pragma mark -
#pragma mark Delegate Wrappers

/*
 Implemented Methods
 
   – connection:canAuthenticateAgainstProtectionSpace:  
   – connection:didCancelAuthenticationChallenge:  
   – connection:didReceiveAuthenticationChallenge:  
   – connectionShouldUseCredentialStorage:  

   – connection:willCacheResponse:  
 X – connection:didReceiveResponse:  
 X – connection:didReceiveData:  
   – connection:didSendBodyData:totalBytesWritten:totalBytesExpectedToWrite:  
 X – connection:willSendRequest:redirectResponse:  

 X – connection:didFailWithError: 
 X – connectionDidFinishLoading:  
 */

- (NSURLRequest *)connection:(WMURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse {
	NSLog(@"magic 1");
	
	NSURLRequest *returned;
	if ( [_myDelegate respondsToSelector:@selector(connection:willSendRequest:redirectResponse:)]) {
		returned = [_myDelegate connection:connection willSendRequest:request redirectResponse:redirectResponse];
	} else {
		NSLog(@"Doesn't respond to selector");
		returned = [super connection:connection willSendRequest:request redirectResponse:redirectResponse];
	}
	return returned;
}


- (void)connection:(WMURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"magic 2");
	analytics.didReceiveResponse = CFAbsoluteTimeGetCurrent(); 
	
	if ( [_myDelegate respondsToSelector:@selector(connection:didReceiveResponse:)]) {
		[_myDelegate connection:connection didReceiveResponse:response];
 
	} else {
		NSLog(@"Doesn't respond to selector");		
		[super connection:connection didReceiveResponse:response];
	}
	
}

- (void)connection:(WMURLConnection *)connection didReceiveData:(NSData *)data {
	if ( firstData ) {
		analytics.didReceiveFirstData = CFAbsoluteTimeGetCurrent(); 
		firstData = NO;
	} 
	analytics.bytesReceived = analytics.bytesReceived + [data length];
	
	
	NSLog(@"magic 3");
	if( [_myDelegate respondsToSelector:@selector(connection:didReceiveData:)] ) {
		[_myDelegate connection:connection didReceiveData:data];
	} else {
		NSLog(@"Doesn't respond to selector");
		[super connection:connection didReceiveData:data];
	}
	
}

- (void)connection:(WMURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"magic failed");
	
	analytics.didFinishLoading = CFAbsoluteTimeGetCurrent(); 
	analytics.error = YES;
	analytics.errorCode = error.code;
	analytics.errorString = error.localizedDescription;
	
	if( [_myDelegate respondsToSelector:@selector(connection:didFailWithError:)] ) {
		[_myDelegate connection:connection didFailWithError:error];		
	} else {
		NSLog(@"Doesn't respond to selector");
		[super connection:connection didFailWithError:error];
	}
		
	WMPerfLib *singleton = [WMPerfLib sharedWMPerfLib];
	[singleton.queue addResponse:analytics];
	
}

- (void)connectionDidFinishLoading:(WMURLConnection *)connection {
	NSLog( @"Magic happens");
	analytics.didFinishLoading = CFAbsoluteTimeGetCurrent(); 
		 	
	if( [_myDelegate respondsToSelector:@selector(connectionDidFinishLoading:)] ) {
		[_myDelegate connectionDidFinishLoading: connection];	
	} else {
		NSLog(@"Doesn't respond to selector");
		[super connectionDidFinishLoading: connection];	

	}
	
	WMPerfLib *singleton = [WMPerfLib sharedWMPerfLib];
	[singleton.queue addResponse:analytics];
	
}

@end
