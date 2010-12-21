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
		if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
			NSLog(@"WMURLConnection: initWithRequest:delegate: initRequest at %f", analytics.initRequest);
		}
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
	if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
		NSLog(@"WMURLConnection: connection:willSendRequest:redirectResponse:");
	}
	
	NSURLRequest *returned;
	if ( [_myDelegate respondsToSelector:@selector(connection:willSendRequest:redirectResponse:)]) {
		returned = [_myDelegate connection:connection willSendRequest:request redirectResponse:redirectResponse];
	} else {
		if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
			NSLog(@"WMURLConnection: connection:willSendRequest:redirectResponse: Assigned delegate doesn't respond to selector");
		}
		returned = [super connection:connection willSendRequest:request redirectResponse:redirectResponse];
	}
	return returned;
}


- (void)connection:(WMURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {

	analytics.didReceiveResponse = CFAbsoluteTimeGetCurrent(); 
	if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
		NSLog(@"WMURLConnection: connecton:didReceiveResponse: didReceiveResponse at %f", analytics.didReceiveResponse);
	}
	
	if ( [_myDelegate respondsToSelector:@selector(connection:didReceiveResponse:)]) {
		[_myDelegate connection:connection didReceiveResponse:response];
 
	} else {
		if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
			NSLog(@"WMURLConnection: connecton:didReceiveResponse: Assigned delegate doesn't respond to selector");	
		}
		[super connection:connection didReceiveResponse:response];
	}
	
}

- (void)connection:(WMURLConnection *)connection didReceiveData:(NSData *)data {
	if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
		NSLog(@"WMURLConnection: connection:didReceiveData:");
	}
	
	if ( firstData ) {
		analytics.didReceiveFirstData = CFAbsoluteTimeGetCurrent(); 
		firstData = NO;
		if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
		    NSLog(@"WMURLConnection: connection:didReceiveData: firstData at %f", analytics.didReceiveFirstData);
		}	
	} 
	analytics.bytesReceived = analytics.bytesReceived + [data length];
	if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
		NSLog(@"WMURLConnection: connection:didReceiveData: bytesReceived = %d", analytics.bytesReceived);
	}	
	
	if( [_myDelegate respondsToSelector:@selector(connection:didReceiveData:)] ) {
		[_myDelegate connection:connection didReceiveData:data];
	} else {
		if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
			NSLog(@"WMURLConnection: connection:didReceiveData: Assigned delegate doesn't respond to selector");
		}
		[super connection:connection didReceiveData:data];
	}
	
}

- (void)connection:(WMURLConnection *)connection didFailWithError:(NSError *)error {
	if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
		NSLog(@"WMURLConnection: connection:didFailWithError: %@", error );
	}
	
	analytics.didFinishLoading = CFAbsoluteTimeGetCurrent(); 
	analytics.error = YES;
	analytics.errorCode = error.code;
	analytics.errorString = error.localizedDescription;
	
	if( [_myDelegate respondsToSelector:@selector(connection:didFailWithError:)] ) {
		[_myDelegate connection:connection didFailWithError:error];		
	} else {
		if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
			NSLog(@"WMURLConnection: connection:didFailWithError: Assigned delegate doesn't respond to selector");
		}
		[super connection:connection didFailWithError:error];
	}
		
	WMPerfLib *singleton = [WMPerfLib sharedWMPerfLib];
	[singleton.queue addResponse:analytics];
	
}

- (void)connectionDidFinishLoading:(WMURLConnection *)connection {

	analytics.didFinishLoading = CFAbsoluteTimeGetCurrent(); 
	if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
		NSLog( @"WMURLConnection: connection:didFinishLoading: didFinishLoading at %f", analytics.didFinishLoading);
	}
		 	
	if( [_myDelegate respondsToSelector:@selector(connectionDidFinishLoading:)] ) {
		[_myDelegate connectionDidFinishLoading: connection];	
	} else {
		if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
			NSLog(@"WMURLConnection: connection:didFinishLoading: Assigned delegate doesn't respond to selector");
		}
		[super connectionDidFinishLoading: connection];	

	}
	
	WMPerfLib *singleton = [WMPerfLib sharedWMPerfLib];
	[singleton.queue addResponse:analytics];
	
}

@end
