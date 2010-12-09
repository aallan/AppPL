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
	
/* WatchMouse Acceptor
 
http://alpha.rum.watchmouse.com/in/mobile/0.1/6/?pr=http&ho=myhost.com&po=8080&pa=%2Fapicall.php&qs=query_string&ct=wifi&cn=myiphoneapp&cv=1.0&td=320&ds=2345

 X pr = protocol
 X ho = host
 X po = port
 X pa = path (urlencoded)
 X qs = query string (urlencoded)
 X ct = connection type (wifi or wan)
 X cn = application name
 X cv = application version
 td = total time of operation (in msec)
 ds = document size in bytes

 */
	NSString *pr = [analytics.url.scheme stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	NSString *ho = [analytics.url.host stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	NSString *po = [[analytics.url.port stringValue] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	NSString *pa = [analytics.url.path stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	NSString *qs = [analytics.url.query stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	NSString *ct = [[WMUtil connectionType] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	NSString *cn = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
	NSString *cv = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
	NSString *td = [[NSString stringWithFormat:@"%f", 1000.0f*(analytics.didFinishLoading - analytics.initRequest)] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	NSString *ds = [[NSString stringWithFormat:@"%d", analytics.bytesReceived] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];

#ifdef WM_DEBUG
	NSLog(@" pr = %@, ho = %@, po = %@, pa = %@, qs = %@, ct = %@, cn = %@, cv = %@, td = %@, ds = %@", pr, ho, po, pa, qs, ct, cn, cv, td, ds );
#endif
	
	NSString *url = [NSString stringWithFormat:@"http://alpha.rum.watchmouse.com/in/mobile/0.1/6/?pr=%@&ho=%@&po=%@&pa=%@&qs=%@&ct=%@&cn=%@&cv=%@&td=%@&ds=%@", pr, ho, po, pa, qs, ct, cn, cv, td, ds];
	theURL = [[NSURL URLWithString:url] retain];
	
#ifdef WM_DEBUG
	NSLog(@"theURL = %@", theURL );
#endif
	
	
	NSURLRequest *request = [NSURLRequest requestWithURL:theURL];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];    

	
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
