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

- (void)dispatchResponse:(WMResponseQueue *)responseQueue {

	responseData = [[NSMutableData data] retain];
	WMResponse *response = [responseQueue popResponse];
   
	// the URL
	
    NSString *url = @"http://rum-alpha.io.watchmouse.com/in/mobile/0.1/6/";
	theURL = [[NSURL URLWithString:url] retain];
	if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
		NSLog(@"WMDispatch: dispatchResponse: theURL = %@", theURL );
	}	
	
	/*  the JSON
	
	{"app": "HelloWorld",
		"appversion": "1.3",
		"key": "aghudHZndWlkZXIMCxIGTmdDaXR5GAUM",
		"batched": true,
		"device": "Al's phone", 
		"os_version": "iOS 4.4", 
		"model": "iPhone 4",
		"measurements": 
		[{"result": 0, 
			"error": "", 
			"when": "2011-02-17T11:07:01Z", 
			"url": "http:\/\/api.watchmouse.com\/1.6\/cp_list?callback=x", 
			"mcc": "310", 
			"mnc": "012", 
			"c_type": "3G", 
			"t_connect": 500, 
			"t_firstbyte": 3000, 
			"t_done": 5000, 
			"size": 10567}, 
		 {"result": 0, 
			 "error": "", 
			 "when": "2011-02-17T11:09:12Z", 
			 "url": "http:\/\/api.watchmouse.com\/1.6\/info_ip?callback=y", 
			 "c_type": "wwan", 
			 "ipaddr": "80.126.145.170",
			 "t_connect": 200, 
			 "t_firstbyte": 1000, 
			 "t_done": 2000, 
			 "size": 389}], 
		"hash": null
	}
	*/
	
	NSNumber *result = [NSNumber numberWithInt:0];
	if ( response.errorCode ) {
		result = [NSNumber numberWithInt:response.errorCode];
	}
	NSString *error = @"";
	if ( response.errorString != nil ) {
		error = [response.errorString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	}
	
	if ( response.mobileCountryCode == nil ) {
		response.mobileCountryCode = @"XXX";
	}
	if ( response.mobileNetworkCode == nil ) {
		response.mobileNetworkCode = @"XXX";
	}
	
	int t_connect = (int)(1000.0f*(response.didReceiveResponse - response.initRequest));
	int t_firstbyte = (int)(1000.0f*(response.didReceiveFirstData - response.initRequest));
	int t_done = (int)(1000.0f*(response.didFinishLoading - response.initRequest));
	
	NSString *json = [NSString stringWithFormat:@"{\"app\": \"%@\",\"appversion\": \"%@\", \"key\": \"%@\", \"batched\": false, \"device\": \"%@\", \"os_version\": \"%@\", \"model\": \"%@\", \"measurements\": [ { \"result\": %@, \"error\": \"%@\", \"when\": \"%@\", \"url\": \"%@\", \"mcc\": \"%@\", \"mnc\": \"%@\", \"c_type\": \"%@\", \"t_connect\": %d, \"t_firstbyte\": %d, \"t_done\": %d, \"size\": %d  }], \"hash\": \"%@\" }",
		[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"],
		[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"],
		@"aghudHZndWlkZXIMCxIGTmdDaXR5GAUM",
		[response.name stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
		[response.systemVersion stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
		[response.model stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
		result,
		error,
		[response.when stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
		[[response.url absoluteString] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
		[response.mobileCountryCode stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
		[response.mobileNetworkCode stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
		[response.connectionType stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
		t_connect,
		t_firstbyte,
		t_done,
		(int)response.bytesReceived,
		@""
		];
	
	[result release];
	
	NSLog(@"json = %@", json );
	NSData *requestData = [NSData dataWithBytes:[json UTF8String] length:[json length]];
				  
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:theURL];

	[request setHTTPMethod: @"POST"];
	[request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"*/*" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/jsonrequest" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody: requestData];
	
	[[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];    
	
}

#pragma mark -
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
	
	// Re-add the response to the queue
	//WMPerfLib *singleton = [WMPerfLib sharedWMPerfLib];
	//[singleton.queue addResponse:analytics];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
	NSLog(@"length of content = %d", [responseData length]);
	
 	NSString *content = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
		
	if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
		NSLog(@"WMDispatch: connectionDidFinishLoading: Done");
		NSLog(@"WMDispatch: connectionDidFinishLoading: content = '%@'", content );
	}
}

- (void)dealloc {
    [super dealloc];

}



@end
