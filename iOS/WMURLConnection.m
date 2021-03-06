//
//  WMURLConnection.m
//  App Performance Library
//
//  Created by Alasdair Allan on 05/11/2010.
//  Copyright 2010 WatchMouse. All rights reserved.
//  This code is released under the MIT license.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "WMAppPL.h"

@implementation WMURLConnection

#pragma mark Initialisation Wrappers

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate {
	
	analytics = [[WMResponse alloc] init];
	analytics.initRequest = CFAbsoluteTimeGetCurrent(); 
	analytics.url = request.URL;

	responseData = [[NSMutableData data] retain];
	
	if( self = [super initWithRequest:request delegate:self] ) {
		if ( [WMAppPL sharedWMAppPL].libraryDebug ) {
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
 
 X – connection:canAuthenticateAgainstProtectionSpace:  
 X – connection:didCancelAuthenticationChallenge:  
 X – connection:didReceiveAuthenticationChallenge:  
 X – connectionShouldUseCredentialStorage:  

 X – connection:willCacheResponse:  
 X – connection:didReceiveResponse:  
 X – connection:didReceiveData:  
   – connection:didSendBodyData:totalBytesWritten:totalBytesExpectedToWrite:  
 X – connection:willSendRequest:redirectResponse:  

 X – connection:didFailWithError: 
 X – connectionDidFinishLoading:  
 */

- (void)connection:(WMURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
	
	/* Sent as the body (message data) of a request is transmitted (such as in an http POST request). This method provides an estimate of the progress of a URL upload. The value of totalBytesExpectedToWrite may change during the upload if the request needs to be retransmitted due to a lost connection or an authentication challenge from the server. */
	 
	if ( [WMAppPL sharedWMAppPL].libraryDebug ) {
		NSLog(@"WMURLConnection: connection:didSendBodyData:totalBytesWritten:totalBytesExpectedToWrite:");
	}	
	
	if ( [_myDelegate respondsToSelector:@selector(connection:didSendBodyData:totalBytesWritten:totalBytesExpectedToWrite:)]) {
		[_myDelegate connection:connection didSendBodyData:bytesWritten totalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
	} else {
		if ( [WMAppPL sharedWMAppPL].libraryDebug ) {
			NSLog(@"WMURLConnection: connection:didSendBodyData:totalBytesWritten:totalBytesExpectedToWrite: Assigned delegate doesn't respond to selector");
		}
		[super connection:connection didSendBodyData:bytesWritten totalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
	}
	

}

- (NSCachedURLResponse *)connection:(WMURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
	if ( [WMAppPL sharedWMAppPL].libraryDebug ) {
		NSLog(@"WMURLConnection: connection:willCacheResponse:");
	}	
	
	NSCachedURLResponse *returned;
	if ( [_myDelegate respondsToSelector:@selector(connection:willCacheResponse:)]) {
		returned = [_myDelegate connection:connection willCacheResponse:cachedResponse];
	} else {
		if ( [WMAppPL sharedWMAppPL].libraryDebug ) {
			NSLog(@"WMURLConnection: connection:willCacheResponse: Assigned delegate doesn't respond to selector");
		}
		//returned = [super connection:connection willCacheResponse:cachedResponse];
		returned = cachedResponse;

	}
	return returned;	
	
}


- (BOOL)connection:(WMURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
	if ( [WMAppPL sharedWMAppPL].libraryDebug ) {
		NSLog(@"WMURLConnection: connection:canAuthenticateAgainstProtectionSpace:");
	}	
	
	BOOL returned;
	if ( [_myDelegate respondsToSelector:@selector(connection:canAuthenticateAgainstProtectionSpace:)]) {
		returned = [_myDelegate connection:connection canAuthenticateAgainstProtectionSpace:protectionSpace];
	} else {
		if ( [WMAppPL sharedWMAppPL].libraryDebug ) {
			NSLog(@"WMURLConnection: connection:canAuthenticateAgainstProtectionSpace: Assigned delegate doesn't respond to selector");
		}
		if ([protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodClientCertificate] ||
			[protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust] ) {
			returned = NO;
		} else {
			returned = YES;
		}
	}
	return returned;
}

- (void)connection:(WMURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	if ( [WMAppPL sharedWMAppPL].libraryDebug ) {
		NSLog(@"WMURLConnection: connection:didCancelAuthenticationChallenge:");
	}	

	if ( [_myDelegate respondsToSelector:@selector(connection:didCancelAuthenticationChallenge:)]) {
		[_myDelegate connection:connection didCancelAuthenticationChallenge:challenge];
	} else {
		if ( [WMAppPL sharedWMAppPL].libraryDebug ) {
			NSLog(@"WMURLConnection: connection:didCancelAuthenticationChallenge: Assigned delegate doesn't respond to selector");
		}
		//[super connection:connection didCancelAuthenticationChallenge:challenge];
	}
	
}

- (void)connection:(WMURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	if ( [WMAppPL sharedWMAppPL].libraryDebug ) {
		NSLog(@"WMURLConnection: connection:didReceiveAuthenticationChallenge:");
	}	
	
	if ( [_myDelegate respondsToSelector:@selector(connection:didReceiveAuthenticationChallenge:)]) {
		[_myDelegate connection:connection didReceiveAuthenticationChallenge:challenge];
	} else {
		if ( [WMAppPL sharedWMAppPL].libraryDebug ) {
			NSLog(@"WMURLConnection: connection:didReceiveAuthenticationChallenge: Assigned delegate doesn't respond to selector");
		}
		[super connection:connection didReceiveAuthenticationChallenge:challenge];
	}	
}

- (BOOL)connectionShouldUseCredentialStorage:(WMURLConnection *)connection {
	if ( [WMAppPL sharedWMAppPL].libraryDebug ) {
		NSLog(@"WMURLConnection: connectionShouldUseCredentialStorage:");
	}	
	
	BOOL returned;
	if ( [_myDelegate respondsToSelector:@selector(connectionShouldUseCredentialStorage:)]) {
		returned = [_myDelegate connectionShouldUseCredentialStorage:connection];
	} else {
		if ( [WMAppPL sharedWMAppPL].libraryDebug ) {
			NSLog(@"WMURLConnection: connectionShouldUseCredentialStorage: Assigned delegate doesn't respond to selector");
		}
		//returned = [super connectionShouldUseCredentialStorage:connection];
		returned = YES;
	}
	return returned;	
}


- (NSURLRequest *)connection:(WMURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse {
	if ( [WMAppPL sharedWMAppPL].libraryDebug ) {
		NSLog(@"WMURLConnection: connection:willSendRequest:redirectResponse:");
	}
	
	NSURLRequest *returned;
	if ( [_myDelegate respondsToSelector:@selector(connection:willSendRequest:redirectResponse:)]) {
		returned = [_myDelegate connection:connection willSendRequest:request redirectResponse:redirectResponse];
	} else {
		if ( [WMAppPL sharedWMAppPL].libraryDebug ) {
			NSLog(@"WMURLConnection: connection:willSendRequest:redirectResponse: Assigned delegate doesn't respond to selector");
		}
		//returned = [super connection:connection willSendRequest:request redirectResponse:redirectResponse];
		returned = request;
	}
	return returned;
}


- (void)connection:(WMURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {

	analytics.didReceiveResponse = CFAbsoluteTimeGetCurrent(); 
	if ( [WMAppPL sharedWMAppPL].libraryDebug ) {
		NSLog(@"WMURLConnection: connecton:didReceiveResponse: didReceiveResponse at %f", analytics.didReceiveResponse);
	}
	
	if ( [_myDelegate respondsToSelector:@selector(connection:didReceiveResponse:)]) {
		[_myDelegate connection:connection didReceiveResponse:response];
 
	} else {
		if ( [WMAppPL sharedWMAppPL].libraryDebug ) {
			NSLog(@"WMURLConnection: connecton:didReceiveResponse: Assigned delegate doesn't respond to selector");	
		}
		//[super connection:connection didReceiveResponse:response];
		[responseData setLength:0];
	}
	
}

- (void)connection:(WMURLConnection *)connection didReceiveData:(NSData *)data {
	if ( [WMAppPL sharedWMAppPL].libraryDebug ) {
		NSLog(@"WMURLConnection: connection:didReceiveData:");
	}
	
	if ( firstData ) {
		analytics.didReceiveFirstData = CFAbsoluteTimeGetCurrent(); 
		firstData = NO;
		if ( [WMAppPL sharedWMAppPL].libraryDebug ) {
		    NSLog(@"WMURLConnection: connection:didReceiveData: firstData at %f", analytics.didReceiveFirstData);
		}	
	} 
	analytics.bytesReceived = analytics.bytesReceived + [data length];
	if ( [WMAppPL sharedWMAppPL].libraryDebug ) {
		NSLog(@"WMURLConnection: connection:didReceiveData: bytesReceived = %d", analytics.bytesReceived);
	}	
	
	if( [_myDelegate respondsToSelector:@selector(connection:didReceiveData:)] ) {
		[_myDelegate connection:connection didReceiveData:data];
	} else {
		if ( [WMAppPL sharedWMAppPL].libraryDebug ) {
			NSLog(@"WMURLConnection: connection:didReceiveData: Assigned delegate doesn't respond to selector");
		}
		//[super connection:connection didReceiveData:data];
		[responseData appendData:data];
	}
	
}

- (void)connection:(WMURLConnection *)connection didFailWithError:(NSError *)error {
	if ( [WMAppPL sharedWMAppPL].libraryDebug ) {		
		NSDictionary *userInfo = error.userInfo;
		NSArray *keys = userInfo.allKeys;
		NSArray *values = userInfo.allValues;		
		for( int i = 0; i < keys.count; i++ ) {
			NSLog( @"WMURLConnection: connection:didFailWithError: %@: %@",
				  (NSString *) [keys objectAtIndex:i], (NSString *) [values objectAtIndex:i] );
		} 		
	}
	
	analytics.didFinishLoading = CFAbsoluteTimeGetCurrent(); 
	analytics.error = YES;
	analytics.errorCode = error.code;
	analytics.errorString = error.localizedDescription;
	
	if( [_myDelegate respondsToSelector:@selector(connection:didFailWithError:)] ) {
		[_myDelegate connection:connection didFailWithError:error];		
	} else {
		if ( [WMAppPL sharedWMAppPL].libraryDebug ) {
			NSLog(@"WMURLConnection: connection:didFailWithError: Assigned delegate doesn't respond to selector");
		}
		//[super connection:connection didFailWithError:error];
	}
		
	WMAppPL *singleton = [WMAppPL sharedWMAppPL];
	if ( !singleton.libraryOff ) {
		if (singleton.libraryDebug ) {
			NSLog(@"WMURLConnection: connection:didFailWithError: Adding response to queue" );
		}
		[singleton.queue addResponse:analytics];
	} else {
		if (singleton.libraryDebug ) {
			NSLog(@"WMURLConnection: connection:didFailWithError: LIBRARY OFF - NO DISPATCH" );
		}
	}	
}

- (void)connectionDidFinishLoading:(WMURLConnection *)connection {

	analytics.didFinishLoading = CFAbsoluteTimeGetCurrent(); 
	if ( [WMAppPL sharedWMAppPL].libraryDebug ) {
		NSLog( @"WMURLConnection: connection:didFinishLoading: didFinishLoading at %f", analytics.didFinishLoading);
	}
		 	
	if( [_myDelegate respondsToSelector:@selector(connectionDidFinishLoading:)] ) {
		[_myDelegate connectionDidFinishLoading: connection];	
	} else {
		if ( [WMAppPL sharedWMAppPL].libraryDebug ) {
			NSLog(@"WMURLConnection: connection:didFinishLoading: Assigned delegate doesn't respond to selector");
			NSString *content = [[NSString alloc] initWithBytes:[responseData bytes] length:[responseData length] encoding:NSUTF8StringEncoding];
			NSLog(@"WMURLConnection: connection:didFinishLoading: content = %@", content);
			[content release];
		}
		//[super connectionDidFinishLoading: connection];	

	}
	
	WMAppPL *singleton = [WMAppPL sharedWMAppPL];
	if ( !singleton.libraryOff ) {
		if (singleton.libraryDebug ) {
			NSLog(@"WMURLConnection: connection:didFinishLoading: Adding response to queue" );
		}
		[singleton.queue addResponse:analytics];
	} else {
		if (singleton.libraryDebug ) {
			NSLog(@"WMURLConnection: connection:didFinishLoading: LIBRARY OFF - NO DISPATCH" );
		}
	}
	
}

#pragma mark -
#pragma mark Other Methods

-(void)dealloc {
	
	[responseData release];
    [super dealloc];
	
}

@end
