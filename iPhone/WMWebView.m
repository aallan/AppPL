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
	if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
		NSLog(@"WMWebView: webViewDidStartLoad:");
	}
	
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
	if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
		NSLog(@"WMWebView: webViewDiDFinishLoad: didFinishLoading at %f", analytics.didFinishLoading);
		NSLog(@"WMWebView: webViewDiDFinishLoad: document.body.outerHTML length = %d", analytics.bytesReceived);
	}	
	if( [_myDelegate respondsToSelector:@selector(webViewDidStartLoad:)] ) {
		[_myDelegate webViewDidFinishLoad:wv];
	} 
	
	WMPerfLib *singleton = [WMPerfLib sharedWMPerfLib];
	if ( !singleton.libraryOff ) {
		if (singleton.libraryDebug ) {
			NSLog(@"WMURLConnection: webViewDiDFinishLoad: Adding response to queue" );
		}
		[singleton.queue addResponse:analytics];
	} else {
		if (singleton.libraryDebug ) {
			NSLog(@"WMURLConnection: webViewDiDFinishLoad: LIBRARY OFF - NO DISPATCH" );
		}
	}
}


- (BOOL)webView:(WMWebView *)wv shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

	BOOL returned = YES;
	
	analytics = [[WMResponse alloc] init];
	analytics.initRequest = CFAbsoluteTimeGetCurrent(); 
	analytics.url = request.URL;
	if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
		NSLog(@"WMWebView: webView:shouldStartLoadWithRequest: URL = %@", request.URL);
		NSLog(@"WMWebView: webView:shouldStartLoadWithRequest: initRequest at %d", analytics.initRequest);
	}
	
	if ( [_myDelegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
		returned = [_myDelegate webView:wv shouldStartLoadWithRequest:request navigationType:navigationType];
	}
	return returned;

}

- (void)webView:(WMWebView *)webView didFailLoadWithError:(NSError *)error {

	if ( [WMPerfLib sharedWMPerfLib].libraryDebug ) {
		NSLog(@"WMWebView: webView:didFailLoadWithError: %@", error);
	}
	
	analytics.didFinishLoading = CFAbsoluteTimeGetCurrent(); 
	analytics.error = YES;
	analytics.errorCode = error.code;
	analytics.errorString = error.localizedDescription;
	
	if( [_myDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)] ) {
		[_myDelegate webView:webView didFailLoadWithError:error];
	}
	
	WMPerfLib *singleton = [WMPerfLib sharedWMPerfLib];
	if ( !singleton.libraryOff ) {
		if (singleton.libraryDebug ) {
			NSLog(@"WMURLConnection: webView:didFailLoadWithError: Adding response to queue" );
		}
		[singleton.queue addResponse:analytics];
	} else {
		if (singleton.libraryDebug ) {
			NSLog(@"WMURLConnection: webView:didFailLoadWithError: LIBRARY OFF - NO DISPATCH" );
		}
	}
	
}

@end
