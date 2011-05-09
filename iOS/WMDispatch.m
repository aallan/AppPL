//
//  WMDispatch.m
//  AppPerfLib
//
//  Created by Alasdair Allan on 09/12/2010.
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


#import "WMPerfLib.h"

#pragma mark -
#pragma mark Private Interface

@interface WMDispatch (PrivateMethods)

- (void)dispatchResponse:(NSString*)jsonDocument;

@end

#pragma mark -

@implementation WMDispatch

#pragma mark Dispatch Method


- (id)init {
	
	if( self = [super init] ) {
		responseData = [[NSMutableData data] retain];
	}
	return self;
}

- (void)dispatchResponse:(NSString *)jsonDocument {
   
	// the URL	
    NSString *url = @"http://rum-alpha.io.watchmouse.com/in/mobile/0.1/6/";
	theURL = [[NSURL URLWithString:url] retain];
	if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
		NSLog(@"WMDispatch: dispatchResponse: theURL = %@", theURL );
	}	
	
	// The JSON
	NSLog(@"WMDispatch: dispatchResponse: json = %@", jsonDocument );
	NSData *requestData = [NSData dataWithBytes:[jsonDocument UTF8String] length:[jsonDocument length]];
				  
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:theURL];

	[request setHTTPMethod: @"POST"];
	[request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"*/*" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/jsonrequest" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody: requestData];
	
	[[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];    
	
}

- (void)dispatchResponseQueue:(WMResponseQueue *)responseQueue {
	
	NSString *jsonResults = @"";
	
	NSString *batched;
	if ( [responseQueue sizeOfQueue] > 1 ) {
		batched = @"true";
	} else {
		batched = @"false";
	}
	
	if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
		NSLog(@"WMDispatch: dispatchResponseQueue: Items in queue = %d", [responseQueue sizeOfQueue] );
	}	
	
	// TO DO: Limit to ~< 1MB max size, batch in chunks of 100 responses?
	while ( [responseQueue sizeOfQueue] > 0 ) {
		
		WMResponse *response = [responseQueue popResponse];
		if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
			NSLog(@"WMDispatch: dispatchResponseQueue: Popped response from queue." );
		}
		
		
		NSNumber *result = [NSNumber numberWithInt:0];
		if ( response.errorCode ) {
			result = [NSNumber numberWithInt:response.errorCode];
		}
		NSString *error = @"";
		if ( response.errorString != nil ) {
			error = [response.errorString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
		}
		
		if ( response.mobileCountryCode == nil ) {
			response.mobileCountryCode = @"null";
		}
		if ( response.mobileNetworkCode == nil ) {
			response.mobileNetworkCode = @"null";
		}
		
		int t_connect = (int)(1000.0f*(response.didReceiveResponse - response.initRequest));
		NSString *t_connectString;
		if ( t_connect >= 0 ) {
			t_connectString = [NSString stringWithFormat:@"%d", t_connect];
		} else {
			t_connectString = @"null";
		}
		
		int t_firstbyte = (int)(1000.0f*(response.didReceiveFirstData - response.initRequest));
		NSString *t_firstbyteString;
		if ( t_firstbyte >= 0 ) {
			t_firstbyteString = [NSString stringWithFormat:@"%d", t_firstbyte];
		} else {
			t_firstbyteString = @"null";
		}
		
		int t_done = (int)(1000.0f*(response.didFinishLoading - response.initRequest));
		NSString *t_doneString;
		if ( t_done >= 0 ) {
			t_doneString = [NSString stringWithFormat:@"%d", t_done];
		} else {
			t_doneString = @"null";
		}
		
		NSString *thisResult = [NSString stringWithFormat:@"{ \"result\": %@, \"error\": \"%@\", \"when\": \"%@\", \"url\": \"%@\", \"mcc\": \"%@\", \"mnc\": \"%@\", \"c_type\": \"%@\", \"t_connect\": %@, \"t_firstbyte\": %@, \"t_done\": %@, \"size\": %d  }", 
					  result,
					  error,
					  [response.when stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
					  [[response.url absoluteString] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
					  [response.mobileCountryCode stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
					  [response.mobileNetworkCode stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
					  [response.connectionType stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
					  t_connectString,
					  t_firstbyteString,
					  t_doneString,
					  (int)response.bytesReceived];
		
		/*if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
			NSLog(@"WMDispatch: dispatchResponseQueue: thisResult = %@", thisResult );
		}*/		
		jsonResults = [jsonResults stringByAppendingString:thisResult];
		if ( [responseQueue sizeOfQueue] > 0 ) {
			jsonResults = [jsonResults stringByAppendingString:@", "];
		}
	}	
		
		
	NSString *json = [NSString stringWithFormat:@"{\"app\": \"%@\",\"appversion\": \"%@\", \"key\": \"%@\", \"batched\": %@, \"device\": \"%@\", \"os_version\": \"%@\", \"model\": \"%@\", \"measurements\": [ %@ ], \"hash\": \"%@\" }",
					  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"],
					  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"],
					  [[WMPerfLib sharedWMPerfLib] token],
					  batched,
					  [[UIDevice currentDevice].name stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
					  [[UIDevice currentDevice].systemVersion stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
					  [[UIDevice currentDevice].model stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
					  jsonResults,
					  @""
					  ];

	
	NSLog(@"WMDispatch: dispatchResponseQueue: Dispatching JSON", json );
	[self dispatchResponse:json];  
	
}


#pragma mark NSURLConnection Delegate Methods

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse {
	[theURL autorelease];
	theURL = [[request URL] retain];
	return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
	
	if ([response respondsToSelector:@selector(statusCode)]) {
		int statusCode = [((NSHTTPURLResponse *)response) statusCode];
		if (statusCode >= 400) {
			[connection cancel];  // stop connecting; no more delegate messages
			NSDictionary *errorInfo = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:
												  NSLocalizedString(@"Server returned status code %d",@""),
												  statusCode] forKey:NSLocalizedDescriptionKey];
			NSError *statusError = [NSError errorWithDomain:@"NSHTTPPropertyStatusCodeKey" code:statusCode userInfo:errorInfo];
			[self connection:connection didFailWithError:statusError];
		}
	}
	
	
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {	
	if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
		NSLog(@"WMDispatch: connection:didFailWithError: %@", error);
	}

	if ( [[WMPerfLib delegate] respondsToSelector:@selector(flushFailedWithError:)]) {	
		[[WMPerfLib delegate] flushFailedWithError:error];
		if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
			NSLog(@"WMDispatch: cdidFailWithError: Called flushFailedWithError: delegate method.");
		}
	} else {
		if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
			NSLog(@"WMDispatch: didFailWithError: No response to flushFailedWithError: method in delegate.");
		}		
	}
	
	// Re-add the response to the queue
	//WMPerfLib *singleton = [WMPerfLib sharedWMPerfLib];
	//[singleton.queue addResponse:analytics];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
		
 	NSString *content = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
		NSLog(@"WMDispatch: connectionDidFinishLoading: content[%d] = '%@'", [responseData length], content );
		NSLog(@"WMDispatch: connectionDidFinishLoading: Done");
	}

	if ( [[WMPerfLib delegate] respondsToSelector:@selector(flushedResponseQueue:)]) {	
		[[WMPerfLib delegate] flushedResponseQueue:content];
		if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
			NSLog(@"WMDispatch: connectionDidFinishLoading: Called flushedResponseQueue: delegate method.");
		}
	} else {
		if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
			NSLog(@"WMDispatch: connectionDidFinishLoading: No response to flushedResponseQueue: method in delegate.");
		}		
	}
}

- (void)dealloc {
    [super dealloc];

}



@end
