//
//  WMWebView.m
//  App Performance Library
//
//  Created by Alasdair Allan on 05/11/2010.
//  Copyright 2010 Babilim Light Industries. All rights reserved.
//

#import "WMPerfLib.h"


@implementation WMWebView

#pragma mark Accessor Wrappers

- (void)setDelegate:(id <WMWebViewDelegate>)delegate {
	[super setDelegate: self];
	[delegate retain];
	[_myDelegate release];
	_myDelegate = delegate;
}

#pragma mark -
#pragma mark Delegate Wrappers

- (void)webViewDidStartLoad:(WMWebView *)wv {
	NSLog(@"Black magic starts");
	
	analytics.didReceiveResponse = CFAbsoluteTimeGetCurrent(); 
	
	if( [_myDelegate respondsToSelector:@selector(webViewDidStartLoad:)] ) {
		[_myDelegate webViewDidStartLoad:wv];
	} 
}


- (void)webViewDidFinishLoad:(WMWebView *)wv {
    if (wv.loading)
		return;

	analytics.didFinishLoading = CFAbsoluteTimeGetCurrent(); 
	analytics.bytesReceived = [[wv stringByEvaluatingJavaScriptFromString:@"document.body.outerHTML"] length];
    NSLog(@"document.body.outerHTML length = %d", analytics.bytesReceived);
	
	NSLog(@"Black magic ends");
	if( [_myDelegate respondsToSelector:@selector(webViewDidStartLoad:)] ) {
		[_myDelegate webViewDidFinishLoad:wv];
	} 
	
	WMPerfLib *singleton = [WMPerfLib sharedWMPerfLib];
	[singleton.queue addResponse:analytics];
}


- (BOOL)webView:(WMWebView *)wv shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	
	NSLog(@"Black magic happening");
	BOOL returned = YES;
	
	analytics = [[WMResponse alloc] init];
	analytics.initRequest = CFAbsoluteTimeGetCurrent(); 
	analytics.url = request.URL;
	NSLog(@"url = %@", request.URL);
		
	if ( [_myDelegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
		returned = [_myDelegate webView:wv shouldStartLoadWithRequest:request navigationType:navigationType];
	}
	return returned;

}

- (void)webView:(WMWebView *)webView didFailLoadWithError:(NSError *)error {
	
	NSLog(@"Black magic happened by an error occured");
	
	analytics.didFinishLoading = CFAbsoluteTimeGetCurrent(); 
	analytics.error = YES;
	analytics.errorCode = error.code;
	analytics.errorString = error.localizedDescription;
	
	if( [_myDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)] ) {
		[_myDelegate webView:webView didFailLoadWithError:error];
	}
}

@end
